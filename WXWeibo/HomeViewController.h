//
//  HomeViewController.h
//  WXWeibo
//  首页控制器

//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SinaWeiboRequestDelegate>


@property(nonatomic,retain)NSArray *data;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
