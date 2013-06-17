//
//  UserViewController.m
//  WXWeibo
//
//  Created by wilson on 6/11/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserViewController.h"
#import "WeiboModel.h"
#import "DetailViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    // put the delegate code in viewDidLoad instead of init method to ensure that the tableView is not null and available
    self.tableView.eventDelegate = self;
    [self loadUserData];
    //[self loadWeiboData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_userInfoView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - data
// 加载用户资料
- (void)loadUserData {
    if (self.userName.length < 1) {
        NSLog(@"error:用户为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    _queryType = GET_USER;
    [self.sinaweibo requestWithURL:@"users/show.json" params:params httpMethod:@"GET" delegate:self];
}

// 获取用户最新发布的微博列表
- (void)loadWeiboData {
    if (self.userName.length < 1) {
        NSLog(@"error: 用户为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    _queryType = GET_WEIBO;
    [self.sinaweibo requestWithURL:@"statuses/user_timeline.json" params:params httpMethod:@"GET" delegate:self];
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    if (_queryType == GET_USER) {
        UserModel *userModel = [[UserModel alloc] initWithDataDic:result];
        self.userInfoView.user = userModel;
        self.tableView.tableHeaderView = [_userInfoView autorelease];
        [self loadWeiboData];
    } else if (_queryType == GET_WEIBO) {
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses) {
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
            [weibos addObject:weiboModel];
            [weiboModel release];
        }
        
        self.tableView.data = weibos;
        self.tableView.isMore = (weibos.count >= 20);
        [self.tableView reloadData];
    }
}

// 选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中cell");
    
    WeiboModel *weibo = [self.tableView.data objectAtIndex:indexPath.row];
    DetailViewController *detailVC = [[[DetailViewController alloc] init] autorelease];
    detailVC.weiboModel = weibo;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end












