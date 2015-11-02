//
//  CustomView.m
//  礼物说
//
//  Created by qianfeng on 14/10/13.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()
{
    UIView *_lineView;
}
@end
@implementation CustomView

+ (instancetype)customViewWithTitles:(NSArray *)titles
{
    CustomView *view = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, 50)];
    [view addSubviews:titles];
    return view;
}

- (void)addSubviews:(NSArray *)titles
{
    for (int i = 0; i < titles.count; i ++) {
        MLButton *button = [MLButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(i * (MLScreenW / 2 - 1), 0, MLScreenW / 2 + i, 50);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = MLFont(17.0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5;
        
        button.tag = i + 100;
        [button addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, MLScreenW / 2, 2)];
    _lineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_lineView];
}

- (void)changeColorWithNight:(BOOL)isNight
{
    if (isNight) {
        MLButton *btn = (MLButton *)[self viewWithTag:100];
        btn.backgroundColor = [UIColor darkGrayColor];
        UIButton *btn1 = (UIButton *)[self viewWithTag:101];
        btn1.backgroundColor = [UIColor darkGrayColor];
    } else {
        MLButton *btn = (MLButton *)[self viewWithTag:100];
        btn.backgroundColor = [UIColor whiteColor];
        UIButton *btn1 = (UIButton *)[self viewWithTag:101];
        btn1.backgroundColor = [UIColor whiteColor];
    }
}

- (void)btnChange:(UIButton *)sender
{
    NSLog(@"%li",  sender.tag);
    [UIView animateWithDuration:kDURATION animations:^{
        _lineView.x = (sender.tag - 100) * MLScreenW / 2;
        NSLog(@"%f",_lineView.x);
    }];
    if ([_delegate conformsToProtocol:@protocol(CustomViewDelegate)]) {
        if ([_delegate respondsToSelector:@selector(customViewBtnClikced:)]) {
            [_delegate customViewBtnClikced:sender.tag];
        }
    }
}
@end
