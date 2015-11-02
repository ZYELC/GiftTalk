//
//  GiftViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "GiftViewController.h"
#import "SelectionView.h"
#import "HotCollectionView.h"
#import "StrategyDetailViewController.h"
#import "GiftDetailViewController.h"
#import "PaserHTML.h"
#import "AllCollectionsViewController.h"
#import "SelectionViewController.h"
#import "SearchViewController.h"

@interface GiftViewController () <UIScrollViewDelegate,SelectionViewDelegate,HotCollectionViewDelegate>
{
    UIView              *_lineView;
    UIScrollView        *_scrollView;
    SelectionView       *_selectionView;
    HotCollectionView   *_collectionView;
    MLButton            *_button;
}
@end

@implementation GiftViewController

- (void)viewWillAppear:(BOOL)animated
{
    if ([MLTool boolForKey:ShowNight]) {
        self.view.backgroundColor = [UIColor darkGrayColor];
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        btn.backgroundColor = [UIColor darkGrayColor];
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
        btn1.backgroundColor = [UIColor darkGrayColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        btn.backgroundColor = [UIColor whiteColor];
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
        btn1.backgroundColor = [UIColor whiteColor];

    }
    [_selectionView reloadData];
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"礼品购";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:MLImage(@"search") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:MLImage(@"sweep") forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    // 创建按钮
    [self createUI];
}

- (void)rightBtnClicked
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -- 创建按钮
- (void)createUI
{
    NSArray *titleArr = @[@"精选攻略",@"热门礼品"];
    for (int i = 0; i < titleArr.count; i ++) {
        MLButton *button = [MLButton buttonWithType:UIButtonTypeRoundedRect];
        _button = button;
        button.frame = CGRectMake(i * MLScreenW / 2, 64, MLScreenW / 2, 40);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = MLFont(17.0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 102, MLScreenW / 2, 2)];
    _lineView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_lineView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, MLScreenW, MLScreenH - 104 - 49)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(2 * MLScreenW, _scrollView.height);
    
    SelectionView *selectionView = [SelectionView selectionViewWithFrame:CGRectMake(0, 0, MLScreenW, _scrollView.height)];
    selectionView.delegate1 = self;
    _selectionView = selectionView;
    [_scrollView addSubview:selectionView];
    
    HotCollectionView *collectionView = [HotCollectionView hotCollectionViewWithFrame:CGRectMake(MLScreenW, 0, MLScreenW, _scrollView.height)];
    collectionView.delegate1 = self;
    _collectionView = collectionView;
    [_scrollView addSubview:collectionView];

    [self.view addSubview:_scrollView];
}

#pragma mark 按钮改变
- (void)btnChange:(MLButton *)sender
{
    if (sender.tag == 100) {
        [UIView animateWithDuration:kDURATION animations:^{
            _lineView.x = 0;
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        } completion:^(BOOL finished) {
            MLLog(@"按钮1");
            
        }];
        
    } else {
        [UIView animateWithDuration:kDURATION animations:^{
            _lineView.x = MLScreenW / 2;
            [_scrollView setContentOffset:CGPointMake(MLScreenW, 0) animated:YES];
        } completion:^(BOOL finished) {
            MLLog(@"按钮2");
            
        }];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:kDURATION animations:^{
        _lineView.x = scrollView.contentOffset.x / 2;
    }];
}

#pragma mark - SelectionViewDelegate
- (void)didSelectedWithModel:(SelectionModel *)model
{
    StrategyDetailViewController *strategyVc = [[StrategyDetailViewController alloc] init];
    strategyVc.model = model;
    strategyVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:strategyVc animated:YES];
}

- (void)btnClicked:(NSInteger)index
{
    if (index == 1) {
        AllCollectionsViewController *allVC = [[AllCollectionsViewController alloc] init];
        allVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:allVC animated:YES];
    } else if (index == 0) {
        SelectionViewController *collectionVC = [[SelectionViewController alloc] init];
        collectionVC.collectionID = @"22";
        collectionVC.titleName = @"美好小物";
        collectionVC.isCollection = YES;
        collectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
}

#pragma mark - HotCollectionViewDelegate
- (void)didSelectedAtModel:(HotModel *)model
{
    GiftDetailViewController *giftDetailVC = [[GiftDetailViewController alloc] init];
    giftDetailVC.model = model;
    giftDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:giftDetailVC animated:YES];
    
}


@end
