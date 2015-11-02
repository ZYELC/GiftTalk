//
//  stragyCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/21.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectionModel;
@interface strategyCell : UITableViewCell

@property (nonatomic, strong) SelectionModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
