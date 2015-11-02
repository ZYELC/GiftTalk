//
//  stragyCell.h
//  礼物说
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectionModel;
@interface strategyCell : UITableViewCell

@property (nonatomic, strong) SelectionModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
