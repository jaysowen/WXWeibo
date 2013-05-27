//
//  HomeViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = [bindItem autorelease];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    
    //WeiboTableView
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.eventDelegate = self;
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表数据
        [self loadWeiboData];
    }
}

//下拉加载最新微博数据
- (void)pullDownData {
    if (self.topWeiboId.length<1) {
        NSLog(@"微博id为空");
        return;
    }
    self.weiboFetchType = GET_LATEST_WEIBO;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20", @"count", self.topWeiboId, @"since_id", nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

#pragma mark - load Data
- (void)loadWeiboData {
    self.weiboFetchType = GET_ALL_WEIBO;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

#pragma mark - SinaWeiboRequest delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    if (self.weiboFetchType == GET_ALL_WEIBO) {
        [self didFinishLoadingAllWeiboWithResult:result];
    } else if (self.weiboFetchType == GET_LATEST_WEIBO) {
        [self didFinishLoadingLatestWeiboWithResult:result];
    }
    
   [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}

- (void)didFinishLoadingAllWeiboWithResult:(id)result {
    NSLog(@"%@", result);
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.tableView.data = weibos;
    
    if (weibos.count > 0) {
        WeiboModel *weibo = weibos[0];
        self.topWeiboId = weibo.weiboId.stringValue;
    }
    
    //刷新tableView
    [self.tableView reloadData];
}

- (void)didFinishLoadingLatestWeiboWithResult:(id)result {
    NSLog(@"%@", result);
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    NSLog(@"最新的微博条数: %d", weibos.count);
    
    // 将已有的微博加入
    for(WeiboModel *model in self.tableView.data) {
        [weibos addObject:model];
    }
    
    self.tableView.data = weibos;
    
    if (weibos.count > 0) {
        WeiboModel *weibo = weibos[0];
        self.topWeiboId = weibo.weiboId.stringValue;
    }
    
    //刷新tableView
    [self.tableView reloadData];
}

#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
}

#pragma mark - Memery Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    
}

#pragma mark UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView {
//    NSLog(@"请求网络数据");
//    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    [self pullDownData];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView {
}

// 选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中cell");
}

@end










