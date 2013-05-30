//
//  BaseViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,retain)MBProgressHUD *hud;

- (SinaWeibo *)sinaweibo;
- (void)showHUD:(NSString *)title showDim:(BOOL)isDim;
- (void)showHUDComplete:(NSString *)title;
- (void)hideHUD;

@end
