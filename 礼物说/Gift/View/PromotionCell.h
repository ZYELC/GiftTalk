//
//  TitleCell.h
//  礼物说
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//  美好小物

#import <UIKit/UIKit.h>

@protocol PromotionCellDelegate <NSObject>

- (void)btnClicked:(NSInteger)index;

@end
@interface PromotionCell : UITableViewCell

@property (nonatomic, weak)id<PromotionCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView modelArr:(NSArray *)modelArr;

+ (CGFloat)cellHeight;

@end
