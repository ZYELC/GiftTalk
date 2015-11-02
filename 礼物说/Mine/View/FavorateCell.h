//
//  FavorateCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/21.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotModel;
@interface FavorateCell : UITableViewCell

@property (nonatomic, strong) HotModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
