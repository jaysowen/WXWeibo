//
//  BrowseModeController.m
//  WXWeibo
//
//  Created by wilson on 6/10/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BrowseModeController.h"
#import "CONSTS.h"
#import "Reachability.h"


@interface BrowseModeController ()

@end

@implementation BrowseModeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.title = @"图片浏览模式";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大图";
        cell.detailTextLabel.text = @"所有网络加载大图";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"小图";
        cell.detailTextLabel.text = @"所有网络加载小图";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"自动";
        cell.detailTextLabel.text = @"根据网络情况选择";
    }
    
    return [cell autorelease];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int mode = -1;
    if (indexPath.row == 0) {
        mode = LargeBrowseMode;   // 大图
    } else if (indexPath.row == 1) {
        mode = SmallBrowseMode;   // 小图
    } else if (indexPath.row == 2) { // 自动
        // 根据网络类型设置加载图片的尺寸
        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
        switch (r.currentReachabilityStatus) {
            case NotReachable:
                break;
            case ReachableViaWiFi:
                mode = LargeBrowseMode;
                break;
            case ReachableViaWWAN:
                mode = SmallBrowseMode;
                break;
            default:
                break;
        }
    }
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowseMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
