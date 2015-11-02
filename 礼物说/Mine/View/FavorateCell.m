
//
//  FavorateCell.m
//  礼物说
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "FavorateCell.h"
#import "HotModel.h"

@interface FavorateCell ()
{
    UIImageView *_imageView;
    UILabel     *_label;
}
@end
@implementation FavorateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellID";
    FavorateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FavorateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 32, 32)];
    [self.contentView addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(55, 4, MLScreenW - 55, 32)];
    _label.font = [UIFont systemFontOfSize:16.0];
    _label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_label];
}

- (void)setModel:(HotModel *)model
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:MLImage(@"ig_holder_image")];
    _label.text = model.Hotname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
