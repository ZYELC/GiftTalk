//
//  HotCell.m
//  礼物说
//
//  Created by qianfeng on 14/10/11.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "HotCell.h"
#import "HotModel.h"

@interface HotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;

@end
@implementation HotCell

- (void)awakeFromNib {
    _nameLabel.numberOfLines = 2;
    self.layer.cornerRadius = 3;
}

+ (NSString *)identifier
{
    return @"hotCell";
}

- (void)setModel:(HotModel *)model
{
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:MLImage(@"ig_holder_image")];
    _nameLabel.text = model.Hotname;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    [_likesBtn setTitle:[NSString stringWithFormat:@"%@",model.likes_count] forState:UIControlStateNormal];
}

// 改变cell的frame的时候就会调用。
- (void)layoutSubviews
{
    // 改变图片的frame
    _imageView.width = self.bounds.size.width;
    _imageView.height = self.bounds.size.width * 0.94;
    
    _nameLabel.y = _imageView.maxY + 5;
    CGFloat oldNameW = _nameLabel.width;
    _nameLabel.width = _imageView.width - 16;
    _nameLabel.height = _nameLabel.width / oldNameW * _nameLabel.height;
    
    _priceLabel.y = _nameLabel.maxY + 5;
    _priceLabel.width = self.bounds.size.width  - _likesBtn.width + 20;
    _likesBtn.x = _priceLabel.maxX;
    _likesBtn.y = _nameLabel.maxY + 5;
    
}


@end
