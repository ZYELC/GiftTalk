//
//  CollectionCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  专题cell

#import <UIKit/UIKit.h>

@protocol CollectionCellDelegate <NSObject>

- (void)collectionCellViewClicked:(NSString *)collectionID title:(NSString *)title;
- (void)collectionCellBtnClicked;

@end
@interface CollectionCell : UITableViewCell

@property (nonatomic, weak) id<CollectionCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView modelArr:(NSArray *)modelArr;

@end
