//
//  MainNavigationController.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条标题文字属性
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : MLFont(21.0f)
        }];
    
    // 导航栏背景色
    self.navigationBar.barTintColor = [UIColor orangeColor];
    // 导航元素项的颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

@end
