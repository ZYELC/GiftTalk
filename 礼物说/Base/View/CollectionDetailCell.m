//
//  CollectionDetailCell.m
//  礼物说
//
//  Created by qianfeng on 14/10/13.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "CollectionDetailCell.h"
#import "CollectionModel.h"

@interface CollectionDetailCell ()
{
    UIImageView  *_picIV;
    UILabel      *_titleLabel;
    UILabel      *_subTitleLabel;
}
@end
@implementation CollectionDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellid";
    CollectionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CollectionDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = MLBackColor;
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, MLScreenW - 10, MLScreenH / 4 + 10)];
    _picIV.layer.cornerRadius = 5;
    _picIV.clipsToBounds = YES;
    [self.contentView addSubview:_picIV];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:_picIV.frame];
    bgView.image = [Viewer createGradualWithFrame:_picIV.frame];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    [self.contentView addSubview:bgView];
    
    _titleLabel = [Viewer createLabelWithFrame:CGRectMake(20, (MLScreenH / 4 + 10) / 2 - 40, MLScreenW - 50, 40) title:@"实用小家电" font:MLFont(23.0)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_titleLabel];
    
    for (int i = 0; i < 2; i ++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20 + i *((MLScreenW - 60) / 2 + 10), _titleLabel.maxY, (MLScreenW - 60) / 2, 0.8)];
        line.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:line];
    }
    UILabel *label = [Viewer createLabelWithFrame:CGRectMake(MLScreenW / 2 - 10, (MLScreenH / 4 + 10) / 2 - 9, 10, 10) title:@"。" font:MLFont(20.0)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label];
    
    _subTitleLabel = [Viewer createLabelWithFrame:CGRectMake(20, _titleLabel.maxY + 5, MLScreenW - 50, 25) title:@"租房二三事还是小家电神马的最方便了" font:MLFont(17.0)];
    _subTitleLabel.textColor = [UIColor whiteColor];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:_subTitleLabel];
    
}

- (void)setModel:(CollectionModel *)model
{
    [_picIV sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    _titleLabel.text = model.titleName;
    _subTitleLabel.text = model.subtitle;
}

+ (CGFloat)cellHeight
{
    return MLScreenH / 4 + 17;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
