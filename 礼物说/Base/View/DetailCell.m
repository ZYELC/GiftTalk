//
//  DetailCell.m
//  礼物说
//
//  Created by qianfeng on 14/10/17.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "DetailCell.h"

@interface DetailCell ()
@property (nonatomic, assign) CGFloat bottomY;
@end
@implementation DetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView photos:(NSArray *)photos
{
    static NSString *ID = @"cellid";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews:photos];
        cell.cellHeight = cell.bottomY;
    }
    return cell;
}

- (void)addSubviews:(NSArray *)photos
{
    _bottomY = 0;
    for (int i = 0; i < photos.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bottomY, MLScreenW, MLScreenW)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photos[i]]];
        [self.contentView addSubview:imageView];
        _bottomY += MLScreenW;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
