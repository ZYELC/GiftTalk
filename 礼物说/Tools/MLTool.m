//
//  MLTool.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "MLTool.h"

@implementation MLTool

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setBool:(BOOL)b forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForkey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)boolForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (UIImage *)resizeImage:(UIImage *)image
{
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    return [image stretchableImageWithLeftCapWidth:w / 2 topCapHeight:h / 2];
}

+ (void)sendGetWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successblock fail:(FailBlock)failblock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successblock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failblock(error);
    }];
}

+ (NSString *)getCacheSize
{
    // 获取图片缓存大小 单位:B
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    
    NSString *sizeStr;
    
    if (size < 1024) {
        sizeStr = [NSString stringWithFormat:@"%lu B", size];
    } else if (size >= 1024 && size < 1024 * 1024) {
        sizeStr = [NSString stringWithFormat:@"%.2f KB", size / 1024.0];
    } else if (size >= 1024 * 1024 && size < 1024 * 1024 * 1024) {
        sizeStr = [NSString stringWithFormat:@"%.2f MB", size / (1024 * 1024.0)];
    } else {
        sizeStr = [NSString stringWithFormat:@"%.2f GB", size / (1024 * 1024 * 1024.0)];
    }
    
    return sizeStr;
}

+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view
{
    // 创建缓冲视图
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
}

+ (void)hideHUDFromView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
