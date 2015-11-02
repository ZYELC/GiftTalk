//
//  SelectionView.m
//  礼物说
//
//  Created by qianfeng on 14/10/11.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "SelectionView.h"
#import "BannerModel.h"
#import "PromotionModel.h"
#import "SelectionModel.h"
#import "BannerView.h"
#import "PromotionCell.h"
#import "SelectionCell.h"

@interface SelectionView () <UITableViewDataSource,UITableViewDelegate,PromotionCellDelegate>
{
    NSMutableArray      *_bannerDataArr;
    NSMutableArray      *_proDataArr;
    NSMutableArray      *_itemDataArr;
    NSInteger            _pageNumber;
}

@end
@implementation SelectionView

+ (instancetype)selectionViewWithFrame:(CGRect)frame
{
    SelectionView *selectionView = [[SelectionView alloc] initWithFrame:frame];
    selectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectionView.delegate = selectionView;
    selectionView.dataSource = selectionView;
    
    // 初始化数据
    [selectionView initData];
    
    // 请求数据
    [selectionView loadBannerData];
    [selectionView loadPromotionData];
    [selectionView loadItemDataWithPageNumber:@"0" isRemoveAll:NO];
    
    [selectionView addRefresh];

    return selectionView;
}

- (void)addRefresh
{
    self.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _pageNumber = 0;
        [self loadBannerData];
        [self loadPromotionData];
        [self loadItemDataWithPageNumber:@"0" isRemoveAll:YES];
    }];
    
    self.footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        _pageNumber += 20;
        [self loadItemDataWithPageNumber:[NSString stringWithFormat:@"%ld",_pageNumber] isRemoveAll:NO];
    }];
    
}

#pragma mark -- 数据初始化
- (void)initData
{
    
    _bannerDataArr = [NSMutableArray arrayWithCapacity:0];
    _proDataArr = [NSMutableArray arrayWithCapacity:0];
    _itemDataArr = [NSMutableArray arrayWithCapacity:0];
    
    _pageNumber = 0;
}


#pragma mark 加载banner数据
- (void)loadBannerData
{
    [MLTool sendGetWithUrl:BANNERURL parameters:nil success:^(id data) {
        id backData = MLJsonParserWithData(data);
        NSArray *banners = backData[@"data"][@"banners"];
        for (NSDictionary *dict in banners) {
            BannerModel *model = [[BannerModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_bannerDataArr addObject:model];
        }
        BannerView *bannerView = [BannerView bannerViewWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH / 4 - 10) bannerDataArr:_bannerDataArr];
        self.tableHeaderView = bannerView;
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
    }];
}

#pragma mark 加载promotion数据
- (void)loadPromotionData
{
    [MLTool sendGetWithUrl:PROMOTIONURL parameters:nil success:^(id data) {
        id backData = MLJsonParserWithData(data);
        NSArray *promotions = backData[@"data"][@"promotions"];
        for (NSDictionary *dict in promotions) {
            PromotionModel *model = [[PromotionModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.col = dict[@"color"];
            [_proDataArr addObject:model];
        }
        [self reloadData];
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
    }];
}

#pragma mark 加载item数据
- (void)loadItemDataWithPageNumber:(NSString *)page isRemoveAll:(BOOL)isRemoveAll
{
    // limit=20&offset=0
    NSDictionary *dict;
    dict = @{ @"limit" : @"20",
              @"offset" : page
              };
    
    [MLTool sendGetWithUrl:ITEMSURL parameters:dict success:^(id data) {
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
        id backData = MLJsonParserWithData(data);
        NSArray *items = backData[@"data"][@"items"];
        
        if (isRemoveAll) {
            [_itemDataArr removeAllObjects];
        }
        
        for (NSDictionary *dict in items) {
            SelectionModel *model = [[SelectionModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.SelectTitle = dict[@"title"];
            [_itemDataArr addObject:model];
        }
        [self reloadData];
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
#pragma mark -- UITableViewDataSource & UITableViewDelegate
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemDataArr.count + 1;
}

#pragma mark 填充cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [PromotionCell cellWithTableView:tableView modelArr:_proDataArr];
        [(PromotionCell *)cell setDelegate:self];
    } else {
    cell = [SelectionCell cellWithTableView:tableView];
    [(SelectionCell *)cell setModel:_itemDataArr[indexPath.row - 1]];
    }
    return cell;
}

#pragma mark 返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0) {
            return [PromotionCell cellHeight];
        } else {
            return [SelectionCell cellHeight];
        }
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        if ([_delegate1 conformsToProtocol:@protocol(SelectionViewDelegate)]) {
            if ([_delegate1 respondsToSelector:@selector(didSelectedWithModel:)]) {
                [_delegate1 didSelectedWithModel:_itemDataArr[indexPath.row - 1]];
            }
        }
    }
}

#pragma mark - PromotionCellDelegate
- (void)btnClicked:(NSInteger)index
{
    if ([_delegate1 conformsToProtocol:@protocol(SelectionViewDelegate)]) {
        if ([_delegate1 respondsToSelector:@selector(btnClicked:)]) {
            [_delegate1 btnClicked:index];
        }
    }
}
@end
