//
//  SettingButton.m
//  1512LimitFree
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PromotionButton.h"

@implementation PromotionButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat contentW = contentRect.size.width;
    return CGRectMake(contentW / 4, 10, contentW / 2, contentW / 2);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat contentW = contentRect.size.width;
    CGFloat contentH = contentRect.size.height;
    return CGRectMake(0, contentW / 2 + 10, contentW, contentH - contentW / 2 - 10);
}

@end
