//
//  MainViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "HomeViewController.h"

@interface MainViewController : UITabBarController<SinaWeiboDelegate, SinaWeiboRequestDelegate, UINavigationControllerDelegate> {
    UIView *_tabbarView;
    UIImageView *_sliderView;
    UIImageView *_badgeView;
    HomeViewController *_home;
}

- (void)showBadge:(BOOL)shouldShow;
- (void)showTabbar:(BOOL)shouldShow;
@end
