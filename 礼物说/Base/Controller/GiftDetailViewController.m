//
//  GiftDetailViewController.m
//  礼物说
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "GiftDetailViewController.h"
#import "DetailModel.h"
#import "CommentModel.h"
#import "DetailCell.h"
#import "DetailHeaderView.h"
#import "PaserHTML.h"
#import "HotModel.h"
#import "CustomView.h"
#import "CommentCell.h"
#import "BuyGoodsViewController.h"
#import "DBManager.h"


@interface GiftDetailViewController () <UITableViewDataSource,UITableViewDelegate,CustomViewDelegate>
{
    NSMutableArray   *_commentDataArr;
    UITableView      *_tbView;
    NSInteger         _index;
    DetailModel      *_detailModel;
    NSInteger         _pageNumber;
}
@end

@implementation GiftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self creacteTableView];
    [self loadDetialData];
    [self loadCommentDataPageNumber:@"0"];
    [self createCustomBar];
}

#pragma mark 初始化数据
- (void)initData
{
    self.title = @"礼品详情";
    self.view.backgroundColor = MLBackColor;
    _index = 0;
    _commentDataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNumber = 0;
}

- (void)creacteTableView
{
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenH - 40) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tbView setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
    [self.view addSubview:_tbView];
}

- (void)createCustomBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, MLScreenH - 40, MLScreenW, 40)];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    CGFloat likesW = MLScreenW / 3 - 20;
    UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, likesW, 30)];
    likeBtn.layer.borderColor = [UIColor redColor].CGColor;
    likeBtn.layer.borderWidth = 1;
    [likeBtn setImage:MLImage(@"ic_action_compact_favourite_normal") forState:UIControlStateNormal];
    [likeBtn setImage:MLImage(@"ic_action_compact_favourite_selected") forState:UIControlStateSelected];
    BOOL isExists = [[DBManager shareManager] selectOneDataWithGiftID:_model.ID];
    if (isExists) {
        likeBtn.selected = YES;
    } else {
        likeBtn.selected = NO;
    }
    [likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    likeBtn.imageEdgeInsets = UIEdgeInsetsMake(7.5, 15, 7.5, 52);
    likeBtn.titleEdgeInsets = UIEdgeInsetsMake(7.5, -30, 7.5, 0);
    [likeBtn addTarget:self action:@selector(likeBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:likeBtn];
    
    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(likesW + 40, 5, 2 * likesW, 30)];
    [goBtn setTitle:@"立即前往购买" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
    goBtn.backgroundColor = [UIColor redColor];
    [view addSubview:goBtn];
}

- (void)likeBtnCliked:(UIButton *)sender
{
    BOOL isExists = [[DBManager shareManager] selectOneDataWithGiftID:_model.ID];
    if (!isExists) {
        // 收藏: 插入数据
        [[DBManager shareManager] insertDataWithHotModel:_model];
        
        sender.selected = YES;
    } else {
        [[DBManager shareManager] deleteDataWithGiftID:_model.ID];
        sender.selected = NO;
    }
    
}

- (void)goBuy
{
    BuyGoodsViewController *buyGoods = [[BuyGoodsViewController alloc] init];
    buyGoods.model = _detailModel;
    [self.navigationController pushViewController:buyGoods animated:YES];
}
#pragma mark 下载细节数据
- (void)loadDetialData
{
    NSString *url = [NSString stringWithFormat:DETAILURL,_model.ID];
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        id backData = MLJsonParserWithData(data);
        NSDictionary *datas = backData[@"data"];
        DetailModel *model = [[DetailModel alloc] init];
        [model setValuesForKeysWithDictionary:datas];
        model.descriptionText = datas[@"description"];
        _detailModel = model;
        
        DetailHeaderView *headerV = [DetailHeaderView detailHeaderViewWithFrame:CGRectMake(0, 0, MLScreenW, MLScreenW) model:_detailModel];
        headerV.height = headerV.detailHeaderViewHeight;
        _tbView.tableHeaderView = headerV;
        
        [_tbView reloadData];
    } fail:^(NSError *error) {
        MLLog(@"error:%@",error);
    }];
}

#pragma mark 下载评论数据
- (void)loadCommentDataPageNumber:(NSString *)page
{
    NSString *url = [NSString stringWithFormat:COMMENTURL,_model.ID,page];
    [MLTool sendGetWithUrl:url parameters:nil success:^(id data) {
        id backData = MLJsonParserWithData(data);
        NSArray *comments = backData[@"data"][@"comments"];
        for (NSDictionary *dict in comments) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_commentDataArr addObject:model];
        }
        NSInteger count;
        if (_detailModel) {
            count = [_detailModel.comments_count integerValue];
        } else {
            count = 0;
        }
        if (_pageNumber + 20 > count) {
            [_tbView.footer removeFromSuperview];
        } else {
            [_tbView.footer endRefreshing];
        }
        [_tbView reloadData];
    } fail:^(NSError *error) {
        if (_pageNumber > 0) {
            [_tbView.footer endRefreshing];
        }
        MLLog(@"error:%@",error);
    }];
}
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index == 0) {
        return 1;
    } else {
        return _commentDataArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        DetailCell *cell = [DetailCell cellWithTableView:tableView photos:[PaserHTML paserWithString:_detailModel.detail_html]];
        return cell;
    } else {
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
        cell.model = _commentDataArr[indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger count;
    if (_detailModel) {
        count = [_detailModel.comments_count integerValue];
    } else {
        count = 0;
    }
    NSArray *titles = @[@"图文详情",[NSString stringWithFormat:@"评论(%ld)",count]];
    CustomView *customView = [CustomView customViewWithTitles:titles];
    [customView changeColorWithNight:[MLTool boolForKey:ShowNight] ];
    customView.delegate = self;
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        DetailCell *cell = [DetailCell cellWithTableView:tableView photos:[PaserHTML paserWithString:_detailModel.detail_html]];
        return cell.cellHeight;
    } else {
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
        cell.model = _commentDataArr[indexPath.row];
        return cell.cellHeight;
    }
}
#pragma mark CustomViewDelegate
- (void)customViewBtnClikced:(NSInteger)index
{
    _index = index;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tbView reloadData];
    if(0 == _commentDataArr.count) return;
    [_tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSInteger count;
    if (_detailModel) {
        count = [_detailModel.comments_count integerValue];
    } else {
        count = 0;
    }
    if (count > 20) {
        if (index == 1) {
            _tbView.footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
                _pageNumber += 20;
                [self loadCommentDataPageNumber:[NSString stringWithFormat:@"%ld",_pageNumber]];
            }];
        } else {
            [_tbView.footer removeFromSuperview];
        }

    }
}
@end
