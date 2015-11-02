//
//  ItemCell.h
//  礼物说
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//  首页3

#import <UIKit/UIKit.h>

@class SelectionModel;
@interface SelectionCell : UITableViewCell

@property (nonatomic, strong) SelectionModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;

@end
