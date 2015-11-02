//
//  Viewer.m
//  礼物说
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "Viewer.h"

@implementation Viewer

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font
{
    UILabel *label =[[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    return label;
}

+ (UIImage *)createGradualWithFrame:(CGRect)frame {
    UIGraphicsBeginImageContext(CGSizeMake(frame.size.width, frame.size.height));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.09].CGColor;
    CGColorRef lightGrayColor = [UIColor darkGrayColor].CGColor;
    CGRect paperRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    drawLinearGradient(context, paperRect, whiteColor,lightGrayColor);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

void drawLinearGradient(CGContextRef context,
                        CGRect rect,
                        CGColorRef startColor,
                        CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0,1.0}; //颜色所在位置
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor,(__bridge id) endColor, nil];//渐变颜色数组
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);//构造渐变
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);//保存状态，主要是因为下面用到裁剪。用完以后恢复状态。不影响以后的绘图
    CGContextAddRect(context, rect);//设置绘图的范围
    CGContextClip(context);//裁剪
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);//绘制渐变效果图
    CGContextRestoreGState(context);//恢复状态
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
