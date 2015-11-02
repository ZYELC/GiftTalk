//
//  ChannalCell.m
//  礼物说
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "GroupCell.h"
#import "GroupModel.h"
#import "GroupButton.h"

@interface GroupCell ()
{
    UILabel      *_titleLabel;
    UIScrollView *_scrollView;
    NSArray      *_dataArr;
}
@end
@implementation GroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellID";
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    _titleLabel = [Viewer createLabelWithFrame:CGRectMake(15, 10, 50, 25) title:@"品种" font:MLFont(17.0)];
    [self.contentView addSubview:_titleLabel];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _titleLabel.maxY + 5, MLScreenW, MLScreenW / 4 + 25)];
    _scrollView.showsHorizontalScrollIndicator = NO;

    [self.contentView addSubview:_scrollView];
}

- (void)setModel:(GroupModel *)model
{
    _dataArr = model.channels;
    _titleLabel.text = model.name;
    CGFloat imageWH = MLScreenW / 4 - 7;
    NSInteger imgCount = model.channels.count;
    for (int i = 0; i < imgCount; i ++) {
        GroupButton *btn = [[GroupButton alloc] initWithFrame:CGRectMake(15 + i * (imageWH + 21), 0, imageWH, imageWH + 25)];
        [btn sd_setImageWithURL:[NSURL URLWithString:[model.channels[i] icon_url]] forState:UIControlStateNormal placeholderImage:MLImage(@"ig_holder_image")];
        [btn setTitle:[model.channels[i] name] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_scrollView addSubview:btn];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i * (imageWH + 21), 0, imageWH, imageWH)];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[model.channels[i] icon_url]] placeholderImage:MLImage(@"ig_holder_image")] ;
//        imageView.layer.cornerRadius = 10;
//        imageView.clipsToBounds = YES;
//        [_scrollView addSubview:imageView];
//        
//        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
//        name.centerX = imageView.centerX;
//        name.y = imageView.maxY + 5;
//        name.font = MLFont(13.0);
//        name.text = [model.channels[i] name];
//        name.textAlignment = NSTextAlignmentCenter;
//        [_scrollView addSubview:name];
    }
    _scrollView.contentSize = CGSizeMake(imgCount * (imageWH + 21) + 9, imageWH + 25);
}

- (void)btnClicked:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(GroupCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(groupCellViewClicked:title:)]) {
            [_delegate groupCellViewClicked:[_dataArr[sender.tag] ID] title:[_dataArr[sender.tag] name]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}
@end
