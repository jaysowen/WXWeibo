//
//  WXImageView.h
//  WXWeibo
//
//  Created by wilson on 6/16/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface WXImageView : UIImageView {
    UITapGestureRecognizer *_gr;
}

@property(nonatomic,copy)ImageBlock touchBlock;

@end
