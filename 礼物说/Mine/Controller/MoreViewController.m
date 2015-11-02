//
//  MoreViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/13.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "MoreViewController.h"
#import "CustomButton.h"

@interface MoreViewController () <UIAlertViewDelegate>
{
    UILabel  *_labelStr;
    UISwitch *_mySwitch;
}
@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    self.view.backgroundColor = MLBackColor;
    
    [self createBarButtonItem];
    [self createUI];
    BOOL isOn = [MLTool boolForKey:ShowNight];
    if (isOn) {
        _mySwitch.on = YES;
    } else {
        _mySwitch.on = NO;
    }
}

- (void)createBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)createUI
{
    NSArray *imgs = @[@"向好友推荐礼物说",@"给我们评分吧",@"意见反馈"];
    NSArray *titles = @[@"向好友推荐礼物说~",@"给我们评分吧",@"意见反馈"];
    for (int i = 0; i < 3; i++) {
        CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 84 + i * 44.5, MLScreenW, 45)];
        [btn setImage:[MLImage(imgs[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        btn.tintColor = [UIColor darkGrayColor];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        if (i == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MLScreenW - 35, 0, 35, 45)];
            label.text = @"☺️";
            [btn addSubview:label];
        } else if (i == 2) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(MLScreenW - 25, 17.5, 10, 10)];
            iv.image = MLImage(@"ic_chevron");
            [btn addSubview:iv];
        }
        [self.view addSubview:btn];
        if (i > 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 84.25 + i * 44.25, 40, 0.5)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
        }
    }

    
    NSArray *images = @[@"接收消息提醒",@"深夜显示",@"清理缓存"];
    NSArray *titles2 = @[@"接收消息提醒",@"深夜显示夜间模式开关",@"清理缓存"];
    for (int i = 0; i < 3; i++) {
        CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 240 + i * 44.5, MLScreenW, 45)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[MLImage(images[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        btn.tintColor = [UIColor darkGrayColor];
        [btn setTitle:titles2[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        if (i == 0 || i == 1) {
            UISwitch *mySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(MLScreenW - 65, 7.5, 70, 25)];
            [btn addSubview:mySwitch];
            _mySwitch = mySwitch;
            //设置状态（开、关）
            mySwitch.on=NO;
            mySwitch.tag = i + 1;
            [mySwitch addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
        } else {
            _labelStr = [[UILabel alloc]initWithFrame:CGRectMake(MLScreenW - 120, 0, 120, 45)];
            _labelStr.textAlignment = NSTextAlignmentRight;
            _labelStr.text = [MLTool getCacheSize];
            _labelStr.textColor = [UIColor darkGrayColor];
            [btn addSubview:_labelStr];
        }
        [self.view addSubview:btn];
        if (i > 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 240.25 + i * 44.25, 40, 0.5)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
        }
    }

}

- (void)btnClicked:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"清理缓存"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否清除缓存?" message:[MLTool getCacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) { // 点击了确定按钮
        [[SDImageCache sharedImageCache] clearDisk];
        MLLog(@"清除成功:%@", [MLTool getCacheSize]);
        _labelStr.text = [MLTool getCacheSize];
    }
}

- (void)changeState:(UISwitch *)sender
{
    if (sender.tag == 2 && sender.isOn) {
        MLLog(@"显示夜间模式");
        [MLTool setBool:YES forKey:ShowNight];
    } else if (sender.tag == 2 && !sender.isOn) {
        [MLTool setBool:NO forKey:ShowNight];
    }
}

- (void)doneClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
