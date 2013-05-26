//
//  BaseTableView.h
//  WXWeibo
//
//  Created by wilson on 5/26/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property(nonatomic,assign, setter = setRefreshNeeded:) BOOL isRefreshNeeded;   //是否需要下拉
@property(nonatomic,retain) NSArray *data;           //为tableview提供数据

@end
