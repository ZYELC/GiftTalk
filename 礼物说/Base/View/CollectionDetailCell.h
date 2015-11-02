//
//  CollectionDetailCell.h
//  礼物说
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//  全部专题

#import <UIKit/UIKit.h>

@class CollectionModel;
@interface CollectionDetailCell : UITableViewCell

@property (nonatomic, strong) CollectionModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
