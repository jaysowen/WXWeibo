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
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
        // 注册系统声音
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        AudioServicesCreateSystemSoundID((CFURLRef)url, &_soundId);
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

//上拉加载更多微博数据
- (void)pullUpData {
    if (self.lastWeiboId.length<1) {
        NSLog(@"微博id为空");
        return;
    }
    self.weiboFetchType = GET_MORE_WEIBO;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"21", @"count", self.lastWeiboId, @"max_id", nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

#pragma mark - load Data
- (void)loadWeiboData {
    // 显示Loading画面
    [super showHUD:@"正在加载..." showDim:NO];
    
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
    NSLog(@"网络加载失败:%@", error);
    [super hideHUD]; // 隐藏Loading画面
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    if (self.weiboFetchType == GET_ALL_WEIBO) {
        [self didFinishLoadingAllWeiboWithResult:result];
    } else if (self.weiboFetchType == GET_LATEST_WEIBO) {
        [self didFinishLoadingLatestWeiboWithResult:result];
    } else if (self.weiboFetchType == GET_MORE_WEIBO) {
        [self didFinishLoadingMoreWeiboWithResult:result];
    }
    
   [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
    //[super hideHUD];
    [super performSelector:@selector(showHUDComplete:) withObject:@"加载成功" afterDelay:0.5];
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
    self.weibos = weibos;
    self.tableView.moreDataCount = weibos.count;
    
    if (weibos.count > 0) {
        WeiboModel *weibo = weibos[0];
        self.topWeiboId = weibo.weiboId.stringValue;
        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeiboId = lastWeibo.weiboId.stringValue;
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
    int updatedCount = weibos.count;
    //self.tableView.moreDataCount = updatedCount;
    NSLog(@"最新的微博条数: %d", updatedCount);
    
    // 将已有的微博加入
    for(WeiboModel *model in self.tableView.data) {
        [weibos addObject:model];
    }
    
    self.tableView.data = weibos;
    self.weibos = weibos;
    
    if (weibos.count > 0) {
        WeiboModel *weibo = weibos[0];
        self.topWeiboId = weibo.weiboId.stringValue;
        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeiboId = lastWeibo.weiboId.stringValue;
    }
    
    //刷新tableView
    [self.tableView reloadData];
    [self showNewWeiboCount:updatedCount];
}

- (void)didFinishLoadingMoreWeiboWithResult:(id)result {
    NSLog(@"%@", result);
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:(statues.count+self.tableView.data.count)];
    
    // 将已有的微博加入
    for(WeiboModel *model in self.tableView.data) {
        [weibos addObject:model];
    }
    
    // 加入更多的微博，跳过第1条，因为与之前的最后一条重复
    for (int i=1; i<statues.count; i++) {
        NSDictionary *statuesDic = statues[i];
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    int updatedCount = statues.count;
    self.tableView.moreDataCount = updatedCount-1;
    NSLog(@"更多的微博条数: %d", (updatedCount-1));
    
    self.tableView.data = weibos;
    self.weibos = weibos;
    
    if (weibos.count > 0) {
        WeiboModel *weibo = weibos[0];
        self.topWeiboId = weibo.weiboId.stringValue;
        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeiboId = lastWeibo.weiboId.stringValue;
    }
    
    //刷新tableView
    [self.tableView reloadData];
}

#pragma mark UI
- (void)showNewWeiboCount:(int)count {
    if (self.barView == nil) {
        self.barView = [UIFactory createImageView:@"timeline_new_status_background.png"];
        UIImage *image = [self.barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.barView.image = image;
        self.barView.leftCapWidth = 5;
        self.barView.topCapHeight = 5;
        self.barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40); // 隐藏视图
        [self.view addSubview:self.barView];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.tag = 2013;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self.barView addSubview:label];
    }
    
    if (count > 0) {
        UILabel *label = (UILabel *)[self.view viewWithTag:2013];
        label.text = [NSString stringWithFormat:@"%d条新微博", count];
        [label sizeToFit];
        label.origin = CGPointMake((ScreenWidth-label.width)/2, (self.barView.height-label.height)/2);
        
        // 有新微博时出现一条消息提示。通过下移动画停止一秒后开始上移动画
        [UIView animateWithDuration:0.6 animations:^{
            self.barView.top = 5;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                self.barView.top = -40;
                [UIView commitAnimations];
            }
        }];
        
        // 播放系统声音
        AudioServicesPlaySystemSound(self.soundId);
    }
    
    // 隐藏badgeView
    MainViewController *mainVC = (MainViewController *)self.tabBarController;
    [mainVC showBadge:NO];
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
//    NSLog(@"上拉");
    [self pullUpData];
}

// 选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中cell");
    
    WeiboModel *weibo = [self.weibos objectAtIndex:indexPath.row];
    DetailViewController *detailVC = [[[DetailViewController alloc] init] autorelease];
    detailVC.weiboModel = weibo;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshWeibo {
    // 使UI显示下拉
    [self.tableView refreshData];
    // 取数据
    [self pullDownData];
}

@end










