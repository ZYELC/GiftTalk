//
//  AllSubjectsViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/13.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "AllCollectionsViewController.h"
#import "CollectionModel.h"
#import "CollectionDetailCell.h"
#import "SelectionViewController.h"

@interface AllCollectionsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray   *_dataArr;
    UITableView      *_tableView;
    NSInteger         _pageNumber;
}
@end

@implementation AllCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self createTableView];
    
    [self loadDataWithPageNumber:@"0" isRemove:NO];
}

- (void)initData
{
    self.title = @"全部专题";
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNumber = 0;
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addRefresh];
    [self.view addSubview:_tableView];
}

- (void)addRefresh
{
    _tableView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _pageNumber = 0;
        [self loadDataWithPageNumber:@"0" isRemove:YES];
    }];
    
    _tableView.footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        _pageNumber += 20;
        [self loadDataWithPageNumber:[NSString stringWithFormat:@"%ld",_pageNumber] isRemove:NO];
    }];
    
}

- (void)loadDataWithPageNumber:(NSString *)page isRemove:(BOOL)isRemove
{
    NSString *url = [NSString stringWithFormat:SPECIALURL,@"20",page];
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        MLLog(@"1");
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        id backData = MLJsonParserWithData(data);
        NSArray *collections = backData[@"data"][@"collections"];
        
        for (NSDictionary *dict in collections) {
            CollectionModel *model = [[CollectionModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.titleName = dict[@"title"];
            [_dataArr addObject:model];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionDetailCell *cell = [CollectionDetailCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CollectionDetailCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionViewController *collectionVC = [[SelectionViewController alloc] init];
    collectionVC.collectionID = [_dataArr[indexPath.row] ID];
    collectionVC.titleName = [_dataArr[indexPath.row] titleName];
    collectionVC.isCollection = YES;
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
}
@end
