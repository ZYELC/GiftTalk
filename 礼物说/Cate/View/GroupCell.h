//
//  ChannalCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  分类各种cell

#import <UIKit/UIKit.h>

@class GroupModel;
@protocol GroupCellDelegate <NSObject>

- (void)groupCellViewClicked:(NSString *)groupID title:(NSString *)title;

@end
@interface GroupCell : UITableViewCell

@property (nonatomic, strong) GroupModel *model;
@property (nonatomic, weak) id<GroupCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
