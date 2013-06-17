//
//  WXImageView.m
//  WXWeibo
//
//  Created by wilson on 6/16/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXImageView.h"

@implementation WXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initGesture];
    }
    return self;
}

- (void)awakeFromNib {
    if (_gr == nil) {
        [self _initGesture];
    }
}

- (void)_initGesture {
    self.userInteractionEnabled = YES;
    _gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:[_gr autorelease]];
}

- (void)tapAction {
    if (self.touchBlock) {
        self.touchBlock();
    }
}

- (void)dealloc {
    Block_release(self.touchBlock);
    [_gr release];
    [super dealloc];
};

@end
