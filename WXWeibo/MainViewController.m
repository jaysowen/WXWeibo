//
//  MainViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initViewController];
    [self _initTabbarView];
    
    //每60秒请求未读数接口
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
//初始化子控制器
- (void)_initViewController {
    _home = [[HomeViewController alloc] init];
    MessageViewController *message = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *profile = [[[ProfileViewController alloc] init] autorelease];
    DiscoverViewController *discover = [[[DiscoverViewController alloc] init] autorelease];
    MoreViewController *more = [[[MoreViewController alloc] init] autorelease];
    
    NSArray *views = @[_home,message,profile,discover,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        nav.delegate = self;
        [viewControllers addObject:nav];
        [nav release];
    }
    
    self.viewControllers = viewControllers;
}

//创建自定义tabBar
- (void)_initTabbarView {
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, ScreenWidth, 49)];
//    _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [self.view addSubview:_tabbarView];
    
    UIImageView *tabbarGroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    tabbarGroundImage.frame = _tabbarView.bounds;
    [_tabbarView addSubview:tabbarGroundImage];
    
    NSArray *backgroud = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        
//        ThemeButton *button = [[ThemeButton alloc] initWithImage:backImage highlighted:heightImage];
        UIButton *button = [UIFactory createButton:backImage highlighted:heightImage];
        button.showsTouchWhenHighlighted = YES; // 按钮点击高亮显示
        button.frame = CGRectMake((64-30)/2+(i*64), (49-30)/2, 30, 30);
        button.tag = i;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
    
    _sliderView = [[UIFactory createImageView:@"tabbar_slider.png"] retain];
    _sliderView.backgroundColor = [UIColor clearColor];
    _sliderView.frame = CGRectMake((64-15)/2, 5, 15, 44);
    [_tabbarView addSubview:_sliderView];
}

#pragma mark - actions
//tab 按钮的点击事件
- (void)selectedTab:(UIButton *)button {
    float x = button.left + (button.width-_sliderView.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x;
    }];
    
    // 判断是否为重复点击home按钮，如是，则刷新微博
    if (button.tag == self.selectedIndex && (button.tag == 0)) {
        [_home refreshWeibo];
    }
    
    self.selectedIndex = button.tag;
}

#pragma mark - SinaWeibo delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    //保存认证的数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_home loadWeiboData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    //移除认证的数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    //记得同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    //登陆页面
    _home.tableView.hidden = YES;
    [_home.sinaweibo logIn];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboLogInDidCancel");    
}

#pragma mark - data
- (void)timeAction:(NSTimer *)timer {
    [self loadUnreadData];
}

- (void)loadUnreadData {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaweibo;
    [sinaWeibo requestWithURL:@"remind/unread_count.json" params:nil httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"unread_count request faild: %@", error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    [self refreshUnreadView:result];
}

- (void)refreshUnreadView:(NSDictionary *)result {
    // 新微博未读数
    NSNumber *status = [result objectForKey:@"status"];
    if (_badgeView == nil) {
        _badgeView = [UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake(64-20, 5, 20, 20);
        [_tabbarView addSubview:_badgeView];
        
        UILabel *badgeLabel = [[[UILabel alloc] initWithFrame:_badgeView.bounds] autorelease];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont systemFontOfSize:13];
        badgeLabel.textColor = [UIColor purpleColor];
        badgeLabel.tag = 100;
        [_badgeView addSubview:badgeLabel];
    }
    
    int n = status.intValue;
    UILabel *badgeLabel = (UILabel *)[_tabbarView viewWithTag:100];
    if (n > 0) {
        if (n > 99) { // 最多只显示99
            n = 99;
        }
        badgeLabel.text = [NSString stringWithFormat:@"%d", n];
        _badgeView.hidden = NO;
    } else {
        _badgeView.hidden = YES;
    }
}

- (void)showBadge:(BOOL)shouldShow {
    _badgeView.hidden = !shouldShow;
}

- (void)showTabbar:(BOOL)shouldShow {
    [UIView animateWithDuration:0.35 animations:^{
        if (shouldShow) {
            _tabbarView.left = 0;
        } else {
            _tabbarView.left = -ScreenWidth;
        }
    }];
    
    [self _resizeView:shouldShow];
}

- (void)_resizeView:(BOOL)shouldShowTabbar {
    for (UIView *subView in self.view.subviews) {
        //NSLog(@"%@", subView);
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (shouldShowTabbar) {
                subView.height = ScreenHeight - 49 - 20;
            } else {
                // 减去的20是为平衡DDMenu
                subView.height = ScreenHeight - 20;
            }
        }
    }
}

# pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 导航控制器的子控制器的个数
    int count = navigationController.viewControllers.count;
    BOOL shouldShowTabbar = (count != 2);
    [self showTabbar:shouldShowTabbar];
}

@end























