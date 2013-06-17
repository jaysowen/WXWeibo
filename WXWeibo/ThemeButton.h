//
//  ThemeButton.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//Normal状态下的图片名称
@property(nonatomic,copy)NSString *imageName;
//高亮状态下的图片名称
@property(nonatomic,copy)NSString *highligtImageName;

//Normal状态下的背景图片名称
@property(nonatomic,copy)NSString *backgroundImageName;
//高亮状态下的背景图片名称
@property(nonatomic,copy)NSString *backgroundHighligtImageName;

//位置图片控件的位置
@property(nonatomic,assign)int leftCapWidth; //横向离原点的位置
@property(nonatomic,assign)int topCapWidth;  //纵向离原点的位置

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highligtImageName;

- (id)initWithBackground:(NSString *)backgroundImageName
   highlightedBackground:(NSString *)backgroundHighligtImageName;

@end
