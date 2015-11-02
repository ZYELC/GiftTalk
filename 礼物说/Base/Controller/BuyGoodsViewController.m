
//
//  BuyGoodsViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/19.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "BuyGoodsViewController.h"
#import "DetailModel.h"

@interface BuyGoodsViewController ()

@end

@implementation BuyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
}

- (void)createWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.purchase_url]]];
    [self.view addSubview:webView];
}
@end
