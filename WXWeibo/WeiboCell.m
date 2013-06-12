//
//  WeiboCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-23.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "RegexKitLite.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //用户头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;  //圆弧半径
    _userImage.layer.borderWidth = .5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    
    //转发数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //回复数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:12.0];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    
    //微博来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    
    //微博内容
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    
    //设置cell的选中背景
    // 选中的背景视图，不必设置frame，会自适应
    UIView *selectedbackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    selectedbackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator"]];
    self.selectedBackgroundView = selectedbackgroundView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //-----------用户头像视图_userImage--------
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //昵称_nickLabel
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    
    //发布时间
    //源日期:       Tue May 23 17:46:32 +800 2011
    //源日期格式:    E M d HH:mm:ss Z yyyy
    //目标日期:     01-23 14:52
    NSString *createDate = _weiboModel.createDate;
    if (createDate == nil) {
        _createLabel.hidden = YES;
    } else {
        _createLabel.hidden = NO;
        NSString *dateString = [UIUtils fomateString:createDate];
        _createLabel.text = dateString;
        _createLabel.frame = CGRectMake(50, self.height-20, 100, 20);
        [_createLabel sizeToFit];        
    }
    
    //微博来源
    //source: "<a href="http://weibo.com" rel="nofollow">新浪微博</a>"
    if (_weiboModel.source == nil) {
        _sourceLabel.hidden = YES;
    } else {
        _sourceLabel.hidden = NO;
        NSString *parsedSource = [self getParsedSource:_weiboModel.source];
        _sourceLabel.text = [NSString stringWithFormat:@"来自%@", parsedSource];
        _sourceLabel.frame = CGRectMake(_createLabel.right+20, self.height-20, 100, 20);
        [_sourceLabel sizeToFit];
    }

    //微博视图_weiboView
    _weiboView.weiboModel = _weiboModel;
    //获取微博视图的高度
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeibo_Width_List, h);
    // For iOS 5.x, you will need to call the weiboView's layoutSubviews method,
    // as the weiboView's layoutSubviews method gets called only once
    // or the layout will be messed up
    [_weiboView setNeedsLayout];
}

- (NSString *)getParsedSource:(NSString *)source {
    NSString *parsedSource;
    NSArray *matches = [source componentsMatchedByRegex:@">\\w+<"];
    if (matches.count > 0) {
        NSString *rawSource = matches[0];
        parsedSource = [rawSource substringWithRange:NSMakeRange(1, rawSource.length-2)];
    } else {
        parsedSource = nil;
    }
    
    return parsedSource;
}

@end
