//
//  DetailCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/17.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;
+ (instancetype) cellWithTableView:(UITableView *)tableView photos:(NSArray *)photos;
@end
