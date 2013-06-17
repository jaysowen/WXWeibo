//
//  DetailViewController.m
//  WXWeibo
//
//  Created by wilson on 5/30/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "CommentModel.h"
#import "UserViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initView];
    [self loadData];
}

- (void)_initView {
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageUrl]];
    self.nickLabel.text = _weiboModel.user.screen_name;
    self.userBarView.userInteractionEnabled = YES;
    
    [tableHeaderView addSubview:self.userBarView];
    tableHeaderView.height += self.userBarView.height;
    // 添加透明按钮，使userBarView响应点击事件
//    UIButton *transparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    transparentButton.backgroundColor = [UIColor clearColor];
//    transparentButton.frame = self.userBarView.frame;
//    [transparentButton addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
//    [tableHeaderView addSubview:transparentButton];
    
    //---------------------创建微博效果-----------------------
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)] autorelease];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h+10);
    
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.eventDelegate = self;
}

- (void)loadData {
    NSString *weiboId = _weiboModel.weiboId.stringValue;
    if (weiboId.length < 1) {
        return;
    }
    self.commentFetchType = GET_ALL_COMMENTS;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboId, @"id", @"20", @"count", nil];
    [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_userImageView release];
    [_nickLabel release];
    [_userBarView release];
    [super dealloc];
}

//上拉加载更多微博数据
- (void)pullUpData {
    NSString *weiboId = _weiboModel.weiboId.stringValue;
    NSString *lastCommentId = self.lastCommentId;
    if (weiboId.length < 1 || lastCommentId.length < 1) {
        return;
    }
    self.commentFetchType = GET_MORE_COMMENTS;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboId, @"id", lastCommentId, @"max_id", @"21", @"count", nil];
    [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
}

#pragma mark 
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    if (self.commentFetchType == GET_ALL_COMMENTS) {
        [self request:request didFinishLoadingCurrentWithResult:result];
    } else if (self.commentFetchType == GET_MORE_COMMENTS) {
        [self request:request didFinishLoadingMoreWithResult:result];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingCurrentWithResult:(id)result {
    NSArray *array = [((NSDictionary *)result) objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        CommentModel *commentModel = [[[CommentModel alloc] initWithDataDic:dict] autorelease];
        [comments addObject:commentModel];
    }
    
    // 获得最后一个评论的id
    CommentModel *lastComment = [comments lastObject];
    self.lastCommentId = lastComment.idstr;
    self.tableView.moreDataCount = comments.count;
    
    // 将整个结果字典传过去
    self.tableView.commentDic = result;
    // 将评论数组传过去
    self.tableView.data = comments;
    [self.tableView reloadData];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingMoreWithResult:(id)result {
    NSArray *array = [((NSDictionary *)result) objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count+self.tableView.data.count];
    
    // 将已有的数据加至数组
    for(CommentModel *comment in self.tableView.data) {
        [comments addObject:comment];
    }
    
    // 将新数据加至数组，忽略第1条重复的
    for (int i=1; i<array.count; i++) {
        NSDictionary *dict = array[i];
        CommentModel *commentModel = [[[CommentModel alloc] initWithDataDic:dict] autorelease];
        [comments addObject:commentModel];
    }
    
    // 将整个结果字典传过去
    self.tableView.commentDic = result;
    // 将评论数组传过去
    self.tableView.data = comments;
    self.tableView.moreDataCount = array.count-1;
    
    // 获得最后一个评论的id
    CommentModel *lastComment = [comments lastObject];
    self.lastCommentId = lastComment.idstr;
    
    [self.tableView reloadData];
}


#pragma mark - UITableviewEventDelegate
- (void)pullUp:(BaseTableView *)tableView {
    [self pullUpData];
}

- (void)userAction {
    UserViewController *userVC = [[UserViewController alloc] init];
    userVC.userName = self.weiboModel.user.screen_name;
    [self.navigationController pushViewController:userVC animated:YES];
}

@end











