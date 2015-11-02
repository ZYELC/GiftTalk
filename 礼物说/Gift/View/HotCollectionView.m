//
//  ColectionView.m
//  礼物说
//
//  Created by qianfeng on 14/10/11.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "HotCollectionView.h"
#import "HotCell.h"
#import "HotModel.h"

@interface HotCollectionView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray  *_dataArr;
    NSInteger        _pageNumber;
}
@end
@implementation HotCollectionView

+ (instancetype)hotCollectionViewWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((MLScreenW - 21) / 2, (MLScreenW - 15) * 0.7);
    flowLayout.minimumInteritemSpacing = 7;
    flowLayout.minimumLineSpacing = 7;
    HotCollectionView *collectionView = [[HotCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.backgroundColor = MLBackColor;
    [collectionView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellWithReuseIdentifier:[HotCell identifier]];
    [collectionView initData];
    [collectionView loadDataWithPageNumber:@"0" isRemoveAll:NO];
    
    [collectionView addRefresh];
    
    return collectionView;
}

- (void)addRefresh
{
    self.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _pageNumber = 0;
        [self loadDataWithPageNumber:@"0" isRemoveAll:YES];
    }];
    
    self.footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        _pageNumber += 20;
        _pageNumber += 20;
        [self loadDataWithPageNumber:[NSString stringWithFormat:@"%ld",_pageNumber] isRemoveAll:NO];
    }];
}

- (void)initData
{
    _dataArr = [NSMutableArray array];
    _pageNumber = 0;
}

#pragma mark 加载item数据
- (void)loadDataWithPageNumber:(NSString *)page isRemoveAll:(BOOL)isRemoveAll
{
    // limit=20&offset=0
    NSDictionary *dict;
    dict = @{ @"limit" : @"20",
              @"offset" : page
              };
    
    [MLTool sendGetWithUrl:HOTURL parameters:dict success:^(id data) {
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
        id backData = MLJsonParserWithData(data);
        NSArray *items = backData[@"data"][@"items"];
        
        if (isRemoveAll) {
            [_dataArr removeAllObjects];
        }
        
        for (NSDictionary *dict in items) {
            HotModel *model = [[HotModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.Hotname = dict[@"name"];
            [_dataArr addObject:model];
        }
        [self reloadData];
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HotCell identifier] forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.item];
    return cell;
}

#pragma mark 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate1 conformsToProtocol:@protocol(HotCollectionViewDelegate)]) {
        if ([_delegate1 respondsToSelector:@selector(didSelectedAtModel:)]) {
            [_delegate1 didSelectedAtModel:_dataArr[indexPath.item]];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark 每一项的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7, 7, 0, 7);
}

@end
