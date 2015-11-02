//
//  CustomView.h
//  礼物说
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomViewDelegate <NSObject>

- (void)customViewBtnClikced:(NSInteger)index;

@end
@interface CustomView : UIView

@property (nonatomic, weak) id<CustomViewDelegate> delegate;

+ (instancetype)customViewWithTitles:(NSArray *)titles;

- (void)changeColorWithNight:(BOOL)isNight;

@end
