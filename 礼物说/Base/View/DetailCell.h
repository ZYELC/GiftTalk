//
//  DetailCell.h
//  礼物说
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;
+ (instancetype) cellWithTableView:(UITableView *)tableView photos:(NSArray *)photos;
@end
