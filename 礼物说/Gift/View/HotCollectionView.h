//
//  ColectionView.h
//  礼物说
//
//  Created by qianfeng on 14/10/11.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  热门礼物

#import <UIKit/UIKit.h>

@class HotModel;
@protocol HotCollectionViewDelegate <NSObject>

- (void)didSelectedAtModel:(HotModel *)model;

@end
@interface HotCollectionView : UICollectionView

@property (nonatomic, weak) id<HotCollectionViewDelegate> delegate1;

+ (instancetype)hotCollectionViewWithFrame:(CGRect)frame;

@end
