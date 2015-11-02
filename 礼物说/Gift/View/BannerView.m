//
//  BannerView.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  无缝滚动

#import "BannerView.h"
#import "BannerModel.h"

@interface BannerView () <UIScrollViewDelegate>
{
    NSInteger       _index;
    NSInteger       _imgCount;
    UIScrollView   *_scrollView;
    UIPageControl  *_pageControl;
    NSTimer        *_timer;
}
@end
@implementation BannerView

#pragma mark 创建类方法
+ (instancetype)bannerViewWithFrame:(CGRect)frame bannerDataArr:(NSArray *)bannerDataArr
{
    BannerView *bannerView = [[BannerView alloc] initWithFrame:frame];
    [bannerView addSubviews:bannerDataArr];
    
    return bannerView;
}

#pragma mark -- 添加banner视图
- (void)addSubviews:(NSArray *)bannerDataArr
{
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
    _index = 1;
    for (int i = 0; i < bannerDataArr.count; i ++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1) * MLScreenW, 0, MLScreenW, self.height)];
        [iv sd_setImageWithURL:[NSURL URLWithString:[bannerDataArr[i] image_url]]];
        [imgArr addObject:iv];
    }
    // 多添加一张图到第一个位置
    UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, self.height)];
    [iv1 sd_setImageWithURL:[NSURL URLWithString:[bannerDataArr[bannerDataArr.count - 1] image_url]]];
    [imgArr insertObject:iv1 atIndex:0];
    
    // 多添加一张图到最后一个位置
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake((bannerDataArr.count + 1) * MLScreenW, 0, MLScreenW, self.height)];
    [iv2 sd_setImageWithURL:[NSURL URLWithString:[bannerDataArr[0] image_url]]];
    [imgArr addObject:iv2];
    
    _imgCount = imgArr.count;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, self.height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(_imgCount * MLScreenW, self.height);
    scrollView.contentOffset = CGPointMake(_index * MLScreenW, 0);
    for (int i = 0; i < _imgCount; i ++) {
        [scrollView addSubview:imgArr[i]];
    }
    
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.width = 100;
    pageControl.height = 20;
    pageControl.centerX = MLScreenW / 2;
    pageControl.centerY = scrollView.maxY - 10;
    pageControl.numberOfPages = bannerDataArr.count;
    pageControl.currentPage = _index - 1;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    [self addTimer];
}

- (void)changePage:(UIPageControl *)sender
{
    NSInteger index=sender.currentPage;
    [_scrollView setContentOffset:CGPointMake((index + 1) * MLScreenW, 0) animated:YES];
}

#pragma mark -- 添加定时器
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateBanner) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark -- 移除定时器
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)updateBanner
{
    NSInteger index = _pageControl.currentPage;
    
    if (index == _pageControl.numberOfPages - 1) {
        _pageControl.currentPage = 0;
        [_scrollView setContentOffset:CGPointMake((index + 2) * MLScreenW, 0) animated:YES];
        _scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        [_scrollView setContentOffset:CGPointMake((index + 2) * MLScreenW, 0) animated:YES];
        _pageControl.currentPage ++;
    }
}

#pragma mark 开始拖曳
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

#pragma mark 停止拖曳
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}


#pragma mark 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint pt = scrollView.contentOffset;
    _index = pt.x / MLScreenW;
    if (_index == _imgCount - 1) {
        scrollView.contentOffset = CGPointMake(MLScreenW, 0);
        _index = 1;
    } else if (_index == 0) {
        scrollView.contentOffset = CGPointMake((_imgCount - 2) * MLScreenW, 0);
        _index = _imgCount - 2;
    }
    _pageControl.currentPage = _index - 1;
}

@end
