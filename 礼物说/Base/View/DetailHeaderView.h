//
//  DetailHeaderView.h
//  礼物说
//
//  Created by qianfeng on 14/10/16.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  礼物详情头部滚动视图

#import <UIKit/UIKit.h>

@class DetailModel;
@interface DetailHeaderView : UIView

+ (instancetype)detailHeaderViewWithFrame:(CGRect)frame model:(DetailModel *)model;

- (CGFloat)detailHeaderViewHeight;
@end
