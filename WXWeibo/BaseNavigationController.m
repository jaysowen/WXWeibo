//
//  BaseNavigationController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofication object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadThemeImage];
    
    UISwipeGestureRecognizer *swipeGr = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)] autorelease];
    swipeGr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGr];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipeGr {
    // 返回
    if (self.viewControllers.count > 1) {
        if (swipeGr.direction == UISwipeGestureRecognizerDirectionRight) {
            [self popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification actions
- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

- (void)loadThemeImage {
    float version = WXHLOSVersion();
    if (version >= 5.0) {
        UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"navigationbar_background.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        //调用setNeedsDisplay方法会让绚烂引擎异步调用drawRect方法
        [self.navigationBar setNeedsDisplay];
    }
}

@end
