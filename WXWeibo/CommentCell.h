//
//  CommentCell.h
//  WXWeibo
//
//  Created by wilson on 6/1/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell <RTLabelDelegate> {
    UIImageView *_userImage;
    UILabel *_nickLabel;
    UILabel *_timeLabel;
    RTLabel *_contentLabel;
}

@property(nonatomic,retain)CommentModel *commentModel;

+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
