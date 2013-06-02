//
//  UIUtils.m
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (NSString *)parseLink:(NSString *)text {
    /*
     * 微博中有三种文本需要超链接：
     * 1. @麻子
     * 2. #话题#
     * 3. http://www.baidu.com
     */
    //NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://(\\w|.)+)";
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([a-zA-Z0-9._-]|/|\\?|=|&)+)";
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
    return text;
}

@end
