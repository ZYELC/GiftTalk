//
//  MainTabbarController.m
//  礼物说
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "MainTabbarController.h"
#import "MainNavigationController.h"
#import "GiftViewController.h"
#import "CateViewController.h"
#import "MeViewController.h"

@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建子控制器
    [self createSubControllers];
    
    // 设置TabbarItem
    [self setTabBarItems];
}

- (void)createSubControllers
{
    GiftViewController *giftVc = [[GiftViewController alloc] init];
    MainNavigationController *giftNav = [[MainNavigationController alloc] initWithRootViewController:giftVc];
    
    CateViewController *cateVc = [[CateViewController alloc] init];
    MainNavigationController *cateNav = [[MainNavigationController alloc] initWithRootViewController:cateVc];
    
    MeViewController *meVc = [[MeViewController alloc] init];
    MainNavigationController *meNav = [[MainNavigationController alloc] initWithRootViewController:meVc];
    
    self.viewControllers = @[giftNav,cateNav,meNav];
}

- (void)setTabBarItems
{
    NSArray *titleArr =  @[@"礼品购", @"分类", @"我"];
    
    NSArray *normalImgArr = @[@"tabbar_gift", @"tabbar_cate", @"tabbar_me"];
    
    for (int i = 0; i < titleArr.count; i ++) {
        UIViewController *vc = self.viewControllers[i];
        
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArr[i] image:MLImage(normalImgArr[i]) selectedImage:[MLImage(normalImgArr[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        self.tabBar.tintColor = [UIColor orangeColor];
    }
  
//    // 设置tabbarItem的文字
//    // appearance 获取UITabBarItem的最高权限,对它的操作可以影响整个工程的UITabBarItem.
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : MLColor(242, 133, 136)} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : MLFont(12.0)} forState:UIControlStateNormal];
}
@end
