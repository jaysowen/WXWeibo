//
//  RightViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)senderAction:(UIButton *)sender {
    if (sender.tag == 100) {
        SendViewController *sendVC = [[SendViewController alloc] init];
        BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:sendVC];
        [self.appDelegate.menuCtrl presentViewController:baseNav animated:YES completion:NULL];
    }
}
@end












