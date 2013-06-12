//
//  RectButton.h
//  WXWeibo
//
//  Created by wilson on 6/11/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton {
    UILabel *_tLabel;
    UILabel *_subLabel;
}
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *subtitle;
@end
