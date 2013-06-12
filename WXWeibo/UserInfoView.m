//
//  UserInfoView.m
//  WXWeibo
//
//  Created by wilson on 6/11/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        [self addSubview:userInfoView];
        self.size = userInfoView.size;
    }
    return self;
}

- (void)dealloc {
    [_userImage release];
    [_nameLabel release];
    [_addressLabel release];
    [_infoLabel release];
    [_countLabel release];
    [_attButton release];
    [_fansButton release];
    [super dealloc];
}

/*
 * layoutSubviews is used to layout the components and populate the data
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 头像图片
    NSString *urlstring = self.user.avatar_large;
    [self.userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    
    // 昵称
    self.nameLabel.text = self.user.screen_name;
    
    // 性别
    NSString *genderMark = self.user.gender;
    NSString *gender = @"未知";
    if ([genderMark isEqualToString:@"m"]) {
        gender = @"男";
    } else if ([genderMark isEqualToString:@"f"]) {
        gender = @"女";
    }

    // 地址
    NSString *location = self.user.location;
    if (location == nil) {
        location = @"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@", gender, location];
    
    // 简介
    NSString *description = self.user.description;
    if (description == nil) {
        description = @"";
    }
    self.infoLabel.text = description;
    
    // 微博数量
    NSString *count = self.user.statuses_count.stringValue;
    self.countLabel.text = [NSString stringWithFormat:@"共有%@条微博", count];
    
    // 关注数
    self.attButton.title = self.user.friends_count.stringValue;
    self.attButton.subtitle = @"关注";
    
    // 粉丝数
    long fansL = self.user.followers_count.longValue;
    NSString *fans;
    if (fansL > 10000) {
        fans = [NSString stringWithFormat:@"%ld万", (fansL/10000)];
    } else {
        fans = [NSString stringWithFormat:@"%ld", fansL];
    }
    self.fansButton.title = fans;
    self.fansButton.subtitle = @"粉丝";
}
@end















