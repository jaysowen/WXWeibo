//
//  DetailViewController.h
//  WXWeibo
//
//  Created by wilson on 5/30/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentTableView.h"

typedef enum {
    GET_ALL_COMMENTS,
    GET_MORE_COMMENTS
} FetchType;

@interface DetailViewController : BaseViewController <SinaWeiboRequestDelegate, UITableviewEventDelegate> {
    WeiboView *_weiboView;
}

@property(nonatomic,retain)WeiboModel *weiboModel;
@property (retain, nonatomic) IBOutlet CommentTableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (assign, nonatomic) FetchType commentFetchType;
@property (copy, nonatomic) NSString *lastCommentId;

@end
