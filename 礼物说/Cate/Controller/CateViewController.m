//
//  CateViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "CateViewController.h"
#import "CollectionModel.h"
#import "CollectionCell.h"
#import "GroupModel.h"
#import "GroupCell.h"
#import "SelectionViewController.h"
#import "AllCollectionsViewController.h"

@interface CateViewController () <UITableViewDataSource,UITableViewDelegate,CollectionCellDelegate,GroupCellDelegate>
{
    UITableView    *_tableView;
    NSMutableArray *_specialDataArr;
    NSMutableArray *_groupDataArr;
}
@end

@implementation CateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self initData];
}

#pragma mark 初始化数据
- (void)initData
{
    _specialDataArr = [NSMutableArray arrayWithCapacity:0];
    _groupDataArr = [NSMutableArray arrayWithCapacity:0];
    
    dispatch_queue_t _mainQueue = dispatch_get_main_queue();
    dispatch_async(_mainQueue, ^{
        [self loadDataWithLimitNumber:@"6" offset:@"0"];
    });
    dispatch_async(_mainQueue, ^{
        [self loadData];
    });
}

#pragma mark 加载专题数据
- (void)loadDataWithLimitNumber:(NSString *)lNumber offset:(NSString *)oNumber
{
    NSString *url = [NSString stringWithFormat:SPECIALURL,lNumber,oNumber];
    
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        id backData = MLJsonParserWithData(data);
        NSArray *collections = backData[@"data"][@"collections"];
        
        for (NSDictionary *dict in collections) {
            CollectionModel *model = [[CollectionModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.titleName = dict[@"title"];
            [_specialDataArr addObject:model];
        }
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
    }];
}

#pragma mark 加载group数据
- (void)loadData
{
    [MLTool sendGetWithUrl:CHANNELURL parameters:nil success:^(id data) {
        id backData = MLJsonParserWithData(data);
        NSArray *groups = backData[@"data"][@"channel_groups"];
        
        for (NSDictionary *dict in groups) {
            GroupModel *model = [[GroupModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_groupDataArr addObject:model];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
    }];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_groupDataArr.count) {
        return _groupDataArr.count + 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [CollectionCell cellWithTableView:tableView modelArr:_specialDataArr];
        [(CollectionCell *)cell setDelegate:self];
    } else {
        cell = [GroupCell cellWithTableView:tableView];
        [(GroupCell *)cell setModel:_groupDataArr[indexPath.row - 1]];
        [(GroupCell *)cell setDelegate:self];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return MLScreenW / 4 + 55;
    } else {
        return MLScreenW / 4 + 68;
    }
    
}

#pragma mark - CollectionCellDelegate
- (void)collectionCellViewClicked:(NSString *)collectionID title:(NSString *)title
{
    SelectionViewController *collectionVC = [[SelectionViewController alloc] init];
    collectionVC.collectionID = collectionID;
    collectionVC.titleName = title;
    collectionVC.isCollection = YES;
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
}

- (void)collectionCellBtnClicked
{
    AllCollectionsViewController *allVC = [[AllCollectionsViewController alloc] init];
    allVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allVC animated:YES];
}

#pragma mark - GroupCellDelegate
- (void)groupCellViewClicked:(NSString *)groupID title:(NSString *)title
{
    SelectionViewController *collectionVC = [[SelectionViewController alloc] init];
    collectionVC.collectionID = groupID;
    collectionVC.titleName = title;
    collectionVC.isCollection = NO;
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
}

@end
