//
//  HotCell.h
//  礼物说
//
//  Created by qianfeng on 15/10/11.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotModel;
@interface HotCell : UICollectionViewCell

@property (nonatomic, strong) HotModel *model;

+ (NSString *)identifier;

@end
