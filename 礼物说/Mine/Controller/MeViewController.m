//
//  MeViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "MeViewController.h"
#import "MyButton.h"
#import "CustomView.h"
#import "MoreViewController.h"
#import "MainNavigationController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "DBManager.h"
#import "DBManager2.h"
#import "HotModel.h"
#import "FavorateCell.h"
#import "strategyCell.h"
#import "GiftDetailViewController.h"
#import "StrategyDetailViewController.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate,CustomViewDelegate>
{
//    UIScrollView *_scrollView;
    CGFloat       _bottomY;
    UIView       *_lineView;
    UITableView  *_tbView;
    NSArray      *_dataArr;
    NSInteger     _index;
    NSArray      *_selectionArr;
    CustomView   *_customView;
}
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createScrollView];
    
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [_customView changeColorWithNight:[MLTool boolForKey:ShowNight] ];

    [_tbView reloadData];
}

- (void)createUI
{
    self.navigationItem.title = @"我";
    self.view.backgroundColor = MLBackColor;
    _index = 0;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)moreClick
{
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    moreVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    MainNavigationController *moreNav = [[MainNavigationController alloc] initWithRootViewController:moreVC];
    [self presentViewController:moreNav animated:YES completion:nil];
}

- (void)createScrollView
{
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MLScreenW, MLScreenW / 2 - 10)];
    bgIV.image = MLImage(@"Me_ProfileBackground@2x.jpg");
    [self.view addSubview:bgIV];
    
    CGFloat iconWH = bgIV.size.height / 2;
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, iconWH, iconWH)];
    iconIV.layer.cornerRadius = iconWH / 2;
    iconIV.clipsToBounds = YES;
    iconIV.centerX = MLScreenW / 2;
    iconIV.image = MLImage(@"ig_profile_photo_default");
    [bgIV addSubview:iconIV];
    
    UILabel *nameL = [Viewer createLabelWithFrame:CGRectMake(0, iconIV.maxY + 10, MLScreenW, 30) title:@"登陆" font:MLFont(17.0)];
    nameL.textAlignment = NSTextAlignmentCenter;
    
    nameL.textColor = [UIColor whiteColor];
    [bgIV addSubview:nameL];
    
    NSArray *titles = @[@"我的消息",@"送礼提醒"];
    NSArray *imgs = @[@"message",@"time"];
    for (int i = 0; i < titles.count; i ++) {
        MyButton *btn = [[MyButton alloc] initWithFrame:CGRectMake(0, bgIV.maxY + i * 45, MLScreenW, 45)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:MLImage(imgs[i]) forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(MLScreenW - 25, 17.5, 10, 10)];
        iv.image = MLImage(@"ic_chevron");
        [btn addSubview:iv];
        
        [self.view addSubview:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, bgIV.maxY + 45, MLScreenW - 40, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    _bottomY = line.y + 57;
}

- (void)createTableView
{
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, _bottomY, MLScreenW, MLScreenH - _bottomY - 44)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbView];
    
    NSArray *titleArr = @[@"喜欢的礼品",@"喜欢的攻略"];
    CustomView *customView = [CustomView customViewWithTitles:titleArr];
    _customView = customView;
    customView.delegate = self;
    _tbView.tableHeaderView = customView;
}

#pragma mark CustomViewDelegate
- (void)customViewBtnClikced:(NSInteger)index
{
    _index = index;
    [_tbView reloadData];
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index == 0) {
        _dataArr = [[DBManager shareManager] selectAllData];
        return _dataArr.count;
    } else {
        _selectionArr = [[DBManager2 shareManager] selectAllData];
        return _selectionArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        FavorateCell *cell = [FavorateCell cellWithTableView:tableView];
        cell.model = _dataArr[indexPath.row];
        return cell;
    } else {
        strategyCell *cell = [strategyCell cellWithTableView:tableView];
        cell.model = _selectionArr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 44;
    } else {
        _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 80;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_index == 0) {
            [[DBManager shareManager] deleteDataWithGiftID:[_dataArr[indexPath.row] ID]];
        } else {
            [[DBManager2 shareManager] deleteDataWithSelectionID:[_selectionArr[indexPath.row] ID]];
        }
        NSArray *array = @[indexPath];
        [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        GiftDetailViewController *giftDetailVC = [[GiftDetailViewController alloc] init];
        giftDetailVC.model = _dataArr[indexPath.row];
        giftDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:giftDetailVC animated:YES];
    } else {
        StrategyDetailViewController *strategyVc = [[StrategyDetailViewController alloc] init];
        strategyVc.model = _selectionArr[indexPath.row];
        strategyVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:strategyVc animated:YES];
    }
}
@end
