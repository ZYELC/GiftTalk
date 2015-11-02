//
//  CollectionCell.m
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "CollectionCell.h"
#import "CollectionModel.h"

@interface CollectionCell ()
{
    NSArray  *_dataArr;
}
@end
@implementation CollectionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView modelArr:(NSArray *)modelArr
{
    static NSString *ID = @"cellid";
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews:modelArr];
    }
    return cell;
}

- (void)addSubviews:(NSArray *)modelArr
{
    _dataArr = modelArr;
    UILabel *titleLabel = [Viewer createLabelWithFrame:CGRectMake(15, 10, 50, 25) title:@"专题" font:MLFont(17.0)];
    [self.contentView addSubview:titleLabel];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(MLScreenW - 80, 10, 80, 25)];
    [moreBtn setTitle:@"查看全部>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = MLFont(13.0);
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLabel.maxY + 5, MLScreenW, MLScreenW / 4)];
    scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat imageW = MLScreenW / 2 - 15;
    NSInteger imgCount = modelArr.count;
    for (int i = 0; i < imgCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i * (imageW + 20), 0, imageW, MLScreenW / 4)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[modelArr[i] banner_image_url]] placeholderImage:MLImage(@"ig_holder_image")] ;
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
        [imageView addGestureRecognizer:tap];
        
        [scrollView addSubview:imageView];
    }
    scrollView.contentSize = CGSizeMake(imgCount * (imageW + 20) + 10, MLScreenW / 4);
    [self.contentView addSubview:scrollView];
}

#pragma mark 全部专题按钮
- (void)btnClick
{
    if ([_delegate conformsToProtocol:@protocol(CollectionCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionCellBtnClicked)]) {
            [_delegate collectionCellBtnClicked];
        }
    }

}

- (void)viewClicked:(UITapGestureRecognizer *)sender
{
    if ([_delegate conformsToProtocol:@protocol(CollectionCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionCellViewClicked:title:)]) {
            [_delegate collectionCellViewClicked:[_dataArr[sender.view.tag] ID] title:[_dataArr[sender.view.tag] titleName]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}
@end
