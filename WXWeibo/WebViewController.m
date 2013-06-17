//
//  WebViewController.m
//  WXWeibo
//
//  Created by wilson on 6/16/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goBackAction:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (IBAction)goForwardAction:(id)sender {
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (IBAction)reloadAction:(id)sender {
    [_webView reload];
}

- (id)initWithURL:(NSString *)urlString {
    self = [super init];
    if (self != nil) {
        _urlString = urlString;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    self.title = @"载入中...";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_goBackButton release];
    [_goForwardButton release];
    [_reloadButton release];
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setGoBackButton:nil];
    [self setGoForwardButton:nil];
    [self setReloadButton:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // 执行javascript代码
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"%@", error);
}
@end








