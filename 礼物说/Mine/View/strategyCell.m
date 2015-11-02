//
//  stragyCell.m
//  礼物说
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "strategyCell.h"
#import "SelectionModel.h"

@interface strategyCell ()
{
    UIImageView *_imageView;
    UILabel     *_label;
}
@end
@implementation strategyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellid";
    strategyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[strategyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
    [self.contentView addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, MLScreenW - 140, 60)];
    _label.font = [UIFont systemFontOfSize:18.0];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.numberOfLines = 0;
    [self.contentView addSubview:_label];
}

- (void)setModel:(SelectionModel *)model
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:MLImage(@"ig_holder_image")];
    _label.text = model.SelectTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
