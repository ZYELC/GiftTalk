//
//  GroupButton.m
//  礼物说
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "GroupButton.h"

@implementation GroupButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat contentW = contentRect.size.width;
    return CGRectMake(0, 0, contentW, contentW);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat contentW = contentRect.size.width;
    CGFloat contentH = contentRect.size.height;
    return CGRectMake(0, contentW + 5, contentW, contentH - contentW - 5);
}
@end
