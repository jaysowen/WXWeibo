//
//  RectButton.m
//  WXWeibo
//
//  Created by wilson on 6/11/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (void)awakeFromNib {
    if (_tLabel == nil) {
        _tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 20)];
        _tLabel.font = [UIFont boldSystemFontOfSize:19];
        _tLabel.textColor = [UIColor blueColor];
        _tLabel.textAlignment = NSTextAlignmentCenter;
        _tLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_tLabel];
        [_tLabel release];
    }
    
    if (_subLabel == nil) {
        _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.width, 20)];
        _subLabel.font = [UIFont systemFontOfSize:19];
        _subLabel.textAlignment = NSTextAlignmentCenter;
        _subLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_subLabel];
        [_subLabel release];
    }
    
    _tLabel.text = self.title;
    _subLabel.text = self.subtitle;
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateHighlighted];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self awakeFromNib];
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    [self awakeFromNib];
}

@end
