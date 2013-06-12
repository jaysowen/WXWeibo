//
//  UserViewController.h
//  WXWeibo
//
//  Created by wilson on 6/11/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "UserInfoView.h"

@interface UserViewController : BaseViewController <SinaWeiboRequestDelegate>

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;
@property (retain, nonatomic) UserInfoView *userInfoView;
@property (copy, nonatomic) NSString *userName;
@end
