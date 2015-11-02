//
//  StrategyDetailViewController.m
//  礼物说
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "StrategyDetailViewController.h"
#import "SelectionModel.h"

@interface StrategyDetailViewController () <UIWebViewDelegate>
{
    UIScrollView   *_scrollView;
    UIImageView    *_imageView;
    UILabel        *_titleLabel;
    UIWebView      *_webView;
}
@end

@implementation StrategyDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [MLTool showHUDWithText:@"正在加载..." toView:self.view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"攻略详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScrollView];
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH)];
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenW * 0.62)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover_image_url]];
    [_scrollView addSubview:_imageView];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:_imageView.frame];
    bgView.image = [Viewer createGradualWithFrame:_imageView.frame];
    [_imageView addSubview:bgView];
    
    _titleLabel = [Viewer createLabelWithFrame:CGRectMake(20, _imageView.maxY - 80, MLScreenW - 40, _imageView.height / 3) title:_model.SelectTitle font:MLFont(25.0)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.textColor = [UIColor whiteColor];
    [_imageView addSubview:_titleLabel];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MLScreenW * 0.62, MLScreenW, MLScreenH - 40)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.content_url]]];
    _webView.delegate = self;
    [_scrollView addSubview:_webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MLTool hideHUDFromView:self.view];
    MLLog(@"22");
    NSString *fitHeight = [_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    _webView.height = [fitHeight floatValue];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_webView.frame) + 1);
}

@end
