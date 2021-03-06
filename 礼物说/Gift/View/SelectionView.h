//
//  SelectionView.h
//  礼物说
//
//  Created by qianfeng on 14/10/11.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  精选攻略

#import <UIKit/UIKit.h>

@class SelectionModel;
@protocol SelectionViewDelegate <NSObject>

- (void)didSelectedWithModel:(SelectionModel *)model;
- (void)btnClicked:(NSInteger)index;

@end
@interface SelectionView : UITableView

@property (nonatomic, weak) id<SelectionViewDelegate> delegate1;

+ (instancetype)selectionViewWithFrame:(CGRect)frame;

@end
