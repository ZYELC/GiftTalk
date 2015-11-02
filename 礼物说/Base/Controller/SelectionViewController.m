//
//  SubjectDetailViewController.m
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelectionModel.h"
#import "SelectionCell.h"
#import "StrategyDetailViewController.h"

@interface SelectionViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView         *_tableView;
    NSMutableArray      *_dataArr;
    NSInteger            _pageNumber;
}
@end

@implementation SelectionViewController
//-(void)dealloc {
//    [_footerView free];
//    [_headerView free];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self createTableView];
    
    [self loadDataWithPageNumber:@"0" ID:_collectionID isRemoveAll:NO isColletion:_isCollection];
}

- (void)initData
{
    self.title = _titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNumber = 0;
}
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MLScreenW, MLScreenH - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    if (!_isCollection) {
        // 下拉刷新
        _tableView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
            _pageNumber = 0;
            [self loadDataWithPageNumber:@"0" ID:_collectionID isRemoveAll:YES isColletion:NO];
        }];
        
        // 上拉加载
        _tableView.footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
            _pageNumber += 20;
            [self loadDataWithPageNumber:[NSString stringWithFormat:@"%ld",_pageNumber] ID:_collectionID isRemoveAll:NO isColletion:NO];
        }];
    }
}

#pragma mark 加载数据
- (void)loadDataWithPageNumber:(NSString *)page ID:(NSString *)ID isRemoveAll:(BOOL)isRemoveAll isColletion:(BOOL)isCollection
{
    NSString *url;
    if (isCollection) {
         url= [NSString stringWithFormat:SPECIALDETAIURL,ID,page];
    } else {
        url = [NSString stringWithFormat:CHANNELDETAILURL,ID,page];
    }
    
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        
        id backData = MLJsonParserWithData(data);
        NSArray *arr;
        if (isCollection) {
            arr = backData[@"data"][@"posts"];
        } else {
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
            arr = backData[@"data"][@"items"];
        }
        
        if (isRemoveAll) {
            [_dataArr removeAllObjects];
        }
        
        for (NSDictionary *dict in arr) {
            SelectionModel *model = [[SelectionModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.ID = dict[@"id"];
            model.SelectTitle = dict[@"title"];
            [_dataArr addObject:model];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
        if (!_isCollection) {
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionCell *cell = [SelectionCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectionCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StrategyDetailViewController *strategyVc = [[StrategyDetailViewController alloc] init];
    strategyVc.model = _dataArr[indexPath.row];
    strategyVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:strategyVc animated:YES];
}

@end
