//
//  DetailHeaderView.m
//  礼物说
//
//  Created by qianfeng on 14/10/16.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "DetailHeaderView.h"
#import "DetailModel.h"
#import "CustomView.h"

@interface DetailHeaderView () <UIScrollViewDelegate>
{
    NSInteger      _index;
    NSInteger      _imgCount;
    UIPageControl *_pageControl;
    UIScrollView  *_scrollView;
    CGFloat        _detailViewHeight;
}
@end
@implementation DetailHeaderView

+ (instancetype)detailHeaderViewWithFrame:(CGRect)frame model:(DetailModel *)model
{
    DetailHeaderView *detailView = [[DetailHeaderView alloc] initWithFrame:frame];
    detailView.backgroundColor = MLBackColor;
    [detailView addSubviews:model];
    return detailView;
}

- (void)addSubviews:(DetailModel *)model
{
    _index = 1;
    _imgCount = model.image_urls.count;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenW)];
    scrollView.contentSize = CGSizeMake(MLScreenW * (_imgCount + 2), MLScreenW);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    NSMutableArray *photoMArr = [NSMutableArray arrayWithArray:model.image_urls];
    [photoMArr addObject:model.image_urls[0]];
    [photoMArr insertObject:model.image_urls[_imgCount - 1] atIndex:0];
    for (int i = 0; i < _imgCount + 2; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * MLScreenW, 0, MLScreenW, MLScreenW)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoMArr[i]]];
        [scrollView addSubview:imageView];
    }
    scrollView.contentOffset = CGPointMake(MLScreenW, 0);
    _scrollView = scrollView;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MLScreenW - 70, MLScreenW, 70)];
    bgView.image = [Viewer createGradualWithFrame:CGRectMake(0, 0, MLScreenW, 70)];
    [self addSubview:bgView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.width = 100;
    pageControl.height = 20;
    pageControl.centerX = MLScreenW / 2;
    pageControl.centerY = scrollView.maxY - 20;
    pageControl.numberOfPages = _imgCount;
    pageControl.currentPage = _index - 1;
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    UILabel *titleLabel = [Viewer createLabelWithFrame:CGRectMake(15, _scrollView.maxY + 15, MLScreenW - 30, 20) title:model.name font:MLFont(21.0)];
    [self addSubview:titleLabel];
    UILabel *priceLabel = [Viewer createLabelWithFrame:CGRectMake(15, titleLabel.maxY + 10, MLScreenW - 30, 20) title:[NSString stringWithFormat:@"￥%@",model.price] font:MLFont(17.0)];
    priceLabel.textColor = [UIColor redColor];
    [self addSubview:priceLabel];
    CGFloat descriptionH = [Helper heightOfString:model.descriptionText font:MLFont(15.0) width:MLScreenW - 30];
    UILabel *descriptionLabel = [Viewer createLabelWithFrame:CGRectMake(15, priceLabel.maxY + 5, MLScreenW - 30, descriptionH) title:model.descriptionText font:MLFont(15.0)];
    descriptionLabel.numberOfLines = 0;
    [self addSubview:descriptionLabel];
    _detailViewHeight = descriptionLabel.maxY + 20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, _detailViewHeight - 15)];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 0.5;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [self sendSubviewToBack:view];
}

- (CGFloat)detailHeaderViewHeight
{
    return _detailViewHeight;
}

#pragma mark 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint pt = scrollView.contentOffset;
    _index = pt.x / MLScreenW;
    if (_index == _imgCount + 1) {
        scrollView.contentOffset = CGPointMake(MLScreenW, 0);
        _index = 1;
    } else if (_index == 0) {
        scrollView.contentOffset = CGPointMake(_imgCount * MLScreenW, 0);
        _index = _imgCount;
    }
    _pageControl.currentPage = _index - 1;
}

@end
