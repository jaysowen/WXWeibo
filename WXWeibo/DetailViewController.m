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
    
    [tableHeaderView addSubview:self.userBarView];
    tableHeaderView.height += self.userBarView.height;
    
    //---------------------创建微博效果-----------------------
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)] autorelease];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h+10);
    
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)loadData {
    NSString *weiboId = _weiboModel.weiboId.stringValue;
    if (weiboId.length < 1) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
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

#pragma mark 
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    NSArray *array = [((NSDictionary *)result) objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        CommentModel *commentModel = [[[CommentModel alloc] initWithDataDic:dict] autorelease];
        [comments addObject:commentModel];
    }
    // 将整个结果字典传过去
    self.tableView.commentDic = result;
    // 将评论数组传过去
    self.tableView.data = comments;
    [self.tableView reloadData];
}
@end











