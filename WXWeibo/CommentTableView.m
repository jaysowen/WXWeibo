//
//  CommentTableView.m
//  WXWeibo
//
//  Created by wilson on 6/1/13.
//  Copyright (c) 2013 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "CommentModel.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CommentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // 从nib中取得cell，注意在nib中也要设置identifier
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    CGFloat height = [CommentCell getCommentHeight:commentModel];
    return (height+40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // header的高度还须在heightForHeaderInSection方法中设置
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *commentCount = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)] autorelease];
    commentCount.backgroundColor = [UIColor clearColor];
    commentCount.font = [UIFont boldSystemFontOfSize:16];
    commentCount.textColor = [UIColor blueColor];
    [view addSubview:commentCount];

    UIImageView *seperatorView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 39, tableView.width, 1)] autorelease];
    seperatorView.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    [view addSubview:seperatorView];
    
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    commentCount.text = [NSString stringWithFormat:@"评论: %@", total];
    
    return [view autorelease];
}

// 设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

@end








