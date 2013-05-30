//
//  WeiboView.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-23.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeImageView.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"

#define LIST_FONT   14.0f           //列表中文本字体
#define LIST_REPOST_FONT  13.0f;    //列表中转发的文本字体
#define DETAIL_FONT  18.0f          //详情的文本字体
#define DETAIL_REPOST_FONT 17.0f    //详情中转发的文本字体

@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parsedText = [[NSMutableString alloc] init];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //微博内容
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    //十进制RGB值：r:69 g:149 b:203
    //十六进制RGB值：4595CB
    //设置链接的颜色
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置链接高亮的颜色
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    //微博图片
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.backgroundColor = [UIColor clearColor];
    _image.image = [UIImage imageNamed:@"page_image_loading.png"];
    //设置图片的内容显示模式：等比例缩/放（不会被拉伸或压缩）
    _image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_image];
    
    //转发微博视图的背景
    _repostBackgroudView = [UIFactory createImageView:@"timeline_retweet_background.png"];
    UIImage *image = [_repostBackgroudView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBackgroudView.image = image;
    _repostBackgroudView.leftCapWidth = 25;
    _repostBackgroudView.topCapHeight = 10;
    _repostBackgroudView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackgroudView atIndex:0];
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    //创建转发微博视图
    if (_repostView == nil) {
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        _repostView.isRepost = YES;
        [self addSubview:_repostView];        
    }
    
    [self parseLink];
}

- (void)parseLink {
    // 重置string
    _parsedText.string = @"";
    
    NSString *text = self.weiboModel.text;
    
    //判断当前微博是否为转发微博，若是，则将微博作者链接加上
    if (self.isRepost) {
        NSString *nickName= self.weiboModel.user.screen_name;
        [_parsedText appendFormat:@"<a href='user://%@'>%@</a>: ", [nickName URLEncodedString], nickName];
    }
    
    /*
     * 微博中有三种文本需要超链接：
     * 1. @麻子
     * 2. #话题#
     * 3. http://www.baidu.com
     */
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://(\\w|.)+)";
    //NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([a-zA-Z0-9._-]|/|\\?|=|&)+)";
    NSArray *array = [text componentsMatchedByRegex:regex];
    for (NSString *str in array) {
        /*
         * 集中文本的超链接跳转：
         * @麻子:     <a href='user://@用户'></a>
         * #话题#:    <a href='topic://#话题#'></a>
         * http://www.baidu.com: <a href='http://www.baidu.com'></a>
         */
        
        NSString *replacement;
        if ([str hasPrefix:@"@"]) {
             // 中文需要编码后才能被识别为url
            replacement = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>", [str URLEncodedString], str];
        } else if ([str hasPrefix:@"#"]) {
             // 中文需要编码后才能被识别为url
            replacement = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>", [str URLEncodedString], str];
        } else if ([str hasPrefix:@"http://"]) {
            replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>", str, str];
        } else {
            replacement = nil;
        }
       
        //text = [text stringByReplacingOccurrencesOfRegex:str withString:replacement];
        text = [text stringByReplacingOccurrencesOfString:str withString:replacement];
    }
    
    [_parsedText appendString:text];
}

//layoutSubviews 展示数据、子视图布局
//此方法有可能会被调用多次
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //---------------微博内容_textLabel子视图------------------
    //获取字体大小
    float fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.frame = CGRectMake(0, 0, self.width, 20);
    //判断当前视图是否为转发视图
    if (self.isRepost) {
        _textLabel.frame = CGRectMake(10, 10, self.width-20, 0);
    }
    //_textLabel.text = _weiboModel.text;
    _textLabel.text = _parsedText;
    //文本内容尺寸
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
    
    
    //---------------转发的微博视图_repostView------------------
    //转发的微博model
    WeiboModel *repostWeibo = _weiboModel.relWeibo;
    if (repostWeibo != nil) {
        _repostView.hidden = NO;
        _repostView.weiboModel = repostWeibo;
        
        //计算转发微博视图的高度
        float height = [WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        _repostView.frame = CGRectMake(0, _textLabel.bottom, self.width, height);
    } else {
        _repostView.hidden = YES;
    }
    
    
    //---------------微博图片视图_image------------------
    if (self.isDetail) {
        // 中等图
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        if (bmiddleImage != nil && !([@"" isEqualToString:bmiddleImage])) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, 280, 200);
            [_image setImageWithURL:[NSURL URLWithString:bmiddleImage]];
        } else {
            _image.hidden = YES;
        }
    } else {
        // 缩略图
        NSString *thumbnailImage = _weiboModel.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, 70, 80);
            
            //加载网络图片数据
            [_image setImageWithURL:[NSURL URLWithString:thumbnailImage]];
        } else {
            _image.hidden = YES;
        }
    }
    
    //----------------转发的微博视图背景_repostBackgroudView---------------
    if (self.isRepost) {
        _repostBackgroudView.frame = self.bounds;
        _repostBackgroudView.hidden = NO;
    } else {
        _repostBackgroudView.hidden = YES;
    }
    
}

#pragma mark - 计算
//获取字体大小
+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost {
    float fontSize = 14.0f;
    
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }
    else if(!isDetail && isRepost) {
        return LIST_REPOST_FONT;
    }
    else if(isDetail && !isRepost) {
        return DETAIL_FONT;
    }
    else if(isDetail && isRepost) {
        return DETAIL_REPOST_FONT;
    }
    
    return fontSize;
}

//计数微博视图的高度
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isRepost:(BOOL)isRepost
                     isDetail:(BOOL)isDetail {
    /**
     *   实现思路：计算每个子视图的高度，然后相加。
     **/
    float height = 0;
    
    //--------------------计算微博内容text的高度------------------------
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    float fontsize = [WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontsize];
    //判断此微博是否显示在详情页面
    if (isDetail) {
        textLabel.width = kWeibo_Width_Detail;
    } else {
        textLabel.width = kWeibo_Width_List;
    }
    if (isRepost) {
        textLabel.width -= 20;
    }
    
    textLabel.text = weiboModel.text;
    
    height += textLabel.optimumSize.height;
    
    //--------------------计算微博图片的高度------------------------
    if (isDetail) {
        NSString *bmiddleImage = weiboModel.bmiddleImage;
        if (bmiddleImage != nil && !([@"" isEqualToString:bmiddleImage])) {
            height += (200+10);
        }
    } else {
        NSString *thumbnailImage = weiboModel.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            height += (80+10);
        }
    }
    
    //--------------------计算转发微博视图的高度------------------------
    //转发的微博
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if (relWeibo != nil) {
        //转发微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += (repostHeight);
    }
    
    if (isRepost == YES) {
        height += 30;
    }
    
    return height;
}


#pragma mark - RTLabel delegate
// rtlabel超链接的点击事件
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    //NSString *urlString = [url absoluteString];
    NSString *hostString = [url host];
    hostString = [hostString URLDecodedString];
    NSLog(@"%@", hostString);
}

@end













