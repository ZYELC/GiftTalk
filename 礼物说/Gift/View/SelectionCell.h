//
//  ItemCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/10.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  首页3

#import <UIKit/UIKit.h>

@class SelectionModel;
@interface SelectionCell : UITableViewCell

@property (nonatomic, strong) SelectionModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;

@end
