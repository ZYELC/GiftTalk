//
//  Viewer.h
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Viewer : NSObject

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;

// 渐变图
+ (UIImage *)createGradualWithFrame:(CGRect)frame;
@end
