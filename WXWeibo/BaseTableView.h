//
//  BaseTableView.h
//  WXWeibo
//
//  Created by wilson on 5/26/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;
@protocol UITableviewEventDelegate <NSObject>
@optional
//下拉
- (void)pullDown:(BaseTableView *)tableView;
//上拉
- (void)pullUp:(BaseTableView *)tableView;
// 选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIButton *_moreButton;
}

@property(nonatomic,assign, setter = setRefreshNeeded:) BOOL isRefreshNeeded;   //是否需要下拉
@property(nonatomic,retain) NSArray *data;           //为tableview提供数据
@property(nonatomic,assign) id<UITableviewEventDelegate> eventDelegate;
@property(nonatomic,assign) BOOL isMore;    // 是否还有更多微博可加载
@property(nonatomic,assign) int moreDataCount;  // 更多的数据条数

- (void)doneLoadingTableViewData;
- (void)refreshData;
@end
