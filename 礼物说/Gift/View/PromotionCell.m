//
//  TitleCell.m
//  礼物说
//
//  Created by qianfeng on 14/10/9.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "PromotionCell.h"
#import "PromotionModel.h"
#import "PromotionButton.h"
#import "HexColors.h"

@interface PromotionCell ()

@end
@implementation PromotionCell

#pragma mark 创建类方法
+ (instancetype)cellWithTableView:(UITableView *)tableView modelArr:(NSArray *)modelArr
{
    static NSString *ID = @"cellID";
    PromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell addSubviews:modelArr];
    return cell;
}

#pragma mark 添加子视图
- (void)addSubviews:(NSArray *)modelArr
{
    for (int i = 0; i < 4; i ++) {
        PromotionButton *btn = [[PromotionButton alloc] initWithFrame:CGRectMake(i * MLScreenW / 4, 0, MLScreenW / 4, self.height)];
        if (modelArr.count) {
            [btn sd_setImageWithURL:[NSURL URLWithString:[modelArr[i] icon_url]] forState:UIControlStateNormal];
            [btn setTitle:[modelArr[i] title] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[UIColor colorWithHexString:[modelArr[i] col]] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}

- (void)btnClicked:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(PromotionCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(btnClicked:)]) {
            [_delegate btnClicked:sender.tag];
        }
    }
}
+ (CGFloat)cellHeight
{
    return MLScreenH / 8 + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
