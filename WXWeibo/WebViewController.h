//
//  WebViewController.h
//  WXWeibo
//
//  Created by wilson on 6/16/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate> {
    NSString *_urlString;
}
@property (retain, nonatomic) IBOutlet UIButton *goBackButton;
@property (retain, nonatomic) IBOutlet UIButton *goForwardButton;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)goBackAction:(id)sender;
- (IBAction)goForwardAction:(id)sender;
- (IBAction)reloadAction:(id)sender;

- (id)initWithURL:(NSString *)urlString;

@end
