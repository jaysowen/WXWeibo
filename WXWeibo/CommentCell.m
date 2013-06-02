//
//  CommentCell.m
//  WXWeibo
//
//  Created by wilson on 6/1/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentCell.h"
#import "UIUtils.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    _userImage = [(UIImageView *)[self viewWithTag:100] retain];
    _nickLabel = [(UILabel *)[self viewWithTag:101] retain];
    _timeLabel = [(UILabel *)[self viewWithTag:102] retain];
    
    _contentLabel = [[[RTLabel alloc] initWithFrame:CGRectZero] autorelease];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.delegate =self;
    //设置链接的颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置链接高亮的颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *urlString = self.commentModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:urlString]];
    _nickLabel.text = self.commentModel.user.screen_name;
    _timeLabel.text =  [UIUtils fomateString:self.commentModel.created_at];;
    NSString *commentText = self.commentModel.text;
    // 解析替换超链接
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.text = commentText;
    _contentLabel.frame = CGRectMake(_userImage.right+10, _nickLabel.bottom+5, 240, 0);
    _contentLabel.height = _contentLabel.optimumSize.height;
}

+ (float)getCommentHeight:(CommentModel *)commentModel {
    RTLabel *rt = [[[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)] autorelease];
    rt.text = commentModel.text;
    rt.font = [UIFont systemFontOfSize:14];
    return rt.optimumSize.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    
}

@end
