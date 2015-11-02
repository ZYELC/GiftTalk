//
//  SearchViewController.m
//  礼物说
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "SearchViewController.h"
#import "StrategyDetailViewController.h"
#import "GiftDetailViewController.h"
#import "SelectionViewController.h"
#import "HotCell.h"
#import "SelectionCell.h"
#import "SelectionModel.h"
#import "HotModel.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>
{
    UIView              *_lineView;
    UIScrollView        *_scrollView;
    UITableView         *_tbView;
    UICollectionView    *_collectionView;
    NSInteger            _index;
    UISearchBar         *_searchBar;
    NSMutableArray      *_selectionDataArr;
    NSMutableArray      *_hotDataArr;
}
@end

@implementation SearchViewController

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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _index = 0;
    _selectionDataArr = [NSMutableArray arrayWithCapacity:0];
    _hotDataArr = [NSMutableArray arrayWithCapacity:0];
    // 创建按钮
    [self createUI];
}

#pragma mark -- 创建按钮
- (void)createUI
{
    // 创建搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MLScreenW - 150, 40)];
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    NSArray *titleArr = @[@"精选攻略",@"热门礼品"];
    for (int i = 0; i < titleArr.count; i ++) {
        MLButton *button = [MLButton buttonWithType:UIButtonTypeRoundedRect];
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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, MLScreenW, MLScreenH - 104)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(2 * MLScreenW, _scrollView.height);
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH - 114)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tbView];
    

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((MLScreenW - 21) / 2, (MLScreenW - 15) * 0.7);
    flowLayout.minimumInteritemSpacing = 7;
    flowLayout.minimumLineSpacing = 7;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(MLScreenW, 0, MLScreenW, MLScreenH - 114) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = MLBackColor;
    [_collectionView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellWithReuseIdentifier:[HotCell identifier]];
    [_scrollView addSubview:_collectionView];

    [self.view addSubview:_scrollView];
}

- (void)btnChange:(UIButton *)sender
{
    _index = sender.tag - 100;
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.x = _index * MLScreenW / 2;
        [_scrollView setContentOffset:CGPointMake(MLScreenW * _index, 0) animated:YES];
    }];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _index = scrollView.contentOffset.x / MLScreenW;
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.x = scrollView.contentOffset.x / 2;
    }];
}

- (void)loadData {
    // 拼接参数
    NSString *url = [[NSString stringWithFormat:SEARCHURL,_searchBar.text,@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        id backData =MLJsonParserWithData(data);
        
        //        MLLog(@"正在搜索：%@",backData);
        for (NSDictionary *dict in backData[@"data"][@"posts"]) {
            SelectionModel *model = [[SelectionModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.SelectTitle = dict[@"title"];
            [_selectionDataArr addObject:model];
        }
        
        [_tbView reloadData];
    } fail:^(NSError *error) {
        MLLog(@"error:%@",error);
    }];
}

- (void)loadDataGift {
    // 拼接参数
    NSString *url = [[NSString stringWithFormat:GIFTSEARCHURL,_searchBar.text,@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        id backData =MLJsonParserWithData(data);
        
        //        MLLog(@"正在搜索：%@",backData);
        for (NSDictionary *dict in backData[@"data"][@"items"]) {
            HotModel *model = [[HotModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.Hotname = dict[@"name"];
            [_hotDataArr addObject:model];
        }
        
        [_collectionView reloadData];
    } fail:^(NSError *error) {
        MLLog(@"error:%@",error);
    }];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _selectionDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectionCell *cell = [SelectionCell cellWithTableView:tableView];
    cell.model = _selectionDataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StrategyDetailViewController *strategyVc = [[StrategyDetailViewController alloc] init];
    strategyVc.model = _selectionDataArr[indexPath.row];
    strategyVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:strategyVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectionCell cellHeight];
}


#pragma mark -  UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HotCell identifier] forIndexPath:indexPath];
    cell.model = _hotDataArr[indexPath.item];
    return cell;
}

#pragma mark 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftDetailViewController *giftDetailVC = [[GiftDetailViewController alloc] init];
    giftDetailVC.model = _hotDataArr[indexPath.item];
    giftDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:giftDetailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark 每一项的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7, 7, 0, 7);
}

#pragma mark -- UISearchBarDelegate
#pragma mark 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark 点击搜索按钮的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (0 == searchBar.text.length) return;
    [searchBar resignFirstResponder];
    [self loadData];
    [self loadDataGift];
}
@end
