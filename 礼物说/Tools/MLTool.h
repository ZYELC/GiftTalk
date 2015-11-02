//
//  MLTool.h
//  礼物说
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSError *error);

@interface MLTool : NSObject

// 存值
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (void)setBool:(BOOL)b forKey:(NSString *)key;

// 取值
+ (id)objectForkey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

// 设置图片拉伸点
+ (UIImage *)resizeImage:(UIImage *)image;

// 封装网络请求
+ (void)sendGetWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successblock fail:(FailBlock)failblock;

// 计算缓存大小
+ (NSString *)getCacheSize;

// 显示缓冲视图
+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view;

// 隐藏缓冲视图
+ (void)hideHUDFromView:(UIView *)view;
@end
