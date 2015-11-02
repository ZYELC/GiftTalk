//
//  AppDelegate.m
//  礼物说
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarController.h"

@interface AppDelegate ()
{
    UIScrollView *_scrollView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 设置window的根控制器
    /** 判断应用是否是新版本的第一次进入,如果是第一次进入,需要展示新特征介绍页面,否则直接进入主页面.
     
     实现思路:获取应用的版本号,获取沙盒存储的版本号,如果沙盒存储的版本号与当前应用版本号一致,说明不是第一次进入新版本;不一致,说明是第一次进入新版本.
     */
    
    // 获取应用的版本号 1,@"CFBundleVersion" 2,(NSString *)kCFBundleVersionKey
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
    MLLog(@"%@:currentVersion", currentVersion);
    
    // 获取沙盒存储的应用版本号
    NSString *saveVersion = [MLTool objectForkey:MLSaveVersion];
    
    if ([currentVersion isEqualToString:saveVersion]) {
        // 进入主界面
        [self gotoMainTabbarControll];
    } else {
        // 进入新特征界面
        [self gotoScrollView];
        
        // 存储新的版本号
        [MLTool setObject:currentVersion forKey:MLSaveVersion];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark 主界面
- (void)gotoMainTabbarControll {
    MLLog(@"进入主界面");
    
    [UIView animateWithDuration:1.0f animations:^{
        _scrollView.transform = CGAffineTransformMakeScale(2, 2);
        _scrollView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        self.window.rootViewController = [[MainTabbarController alloc] init];
    }];
}

#pragma mark 新特征界面
- (void)gotoScrollView {
    MLLog(@"进入新特征界面");
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    int imgCount = 4;
    scrollView.contentSize = CGSizeMake(imgCount * MLScreenW, 0);
    
    for (int i = 0; i < imgCount; i ++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * MLScreenW, 0, MLScreenW, MLScreenH)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"walkthrough_%i.jpg", i + 1]];
        [scrollView addSubview:iv];
        
        if (imgCount - 1 == i) {
            iv.userInteractionEnabled = YES;
            // 最后一张图片需要添加一个进入应用的按钮
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [btn setBackgroundImage:MLImage(@"btn_begin") forState:UIControlStateNormal];
            btn.center = CGPointMake(MLScreenW / 2, MLScreenH - 90);
            [btn addTarget:self action:@selector(gotoMainTabbarControll) forControlEvents:UIControlEventTouchUpInside];
            [iv addSubview:btn];
        }
    }
    
    [self.window addSubview:scrollView];
    _scrollView = scrollView;
}

@end
