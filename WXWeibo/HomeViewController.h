//
//  HomeViewController.h
//  WXWeibo
//  首页控制器

//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "ThemeImageView.h"

typedef enum {
    GET_ALL_WEIBO,
    GET_LATEST_WEIBO
} WeiboFetchType;

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate, UITableviewEventDelegate>

@property (retain, nonatomic) WeiboTableView *tableView;
@property (nonatomic, copy) NSString *topWeiboId;
@property (nonatomic, assign) WeiboFetchType weiboFetchType;
@property (nonatomic, retain) ThemeImageView *barView;
@end
