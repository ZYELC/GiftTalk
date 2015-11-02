//
//  CommentCell.m
//  礼物说
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

@interface CommentCell ()
{
    UIImageView   *_iconIV;
    UILabel       *_nameLabel;
    UILabel       *_contentLabel;
    UILabel       *_timeLabel;
}
@end
@implementation CommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellID";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self.contentView addSubview:_iconIV];
    _iconIV.layer.cornerRadius = 15;
    _iconIV.clipsToBounds = YES;
    
    _nameLabel = [Viewer createLabelWithFrame:CGRectMake(50, 10, 200, 20) title:@"始末" font:MLFont(13.0)];
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [Viewer createLabelWithFrame:CGRectMake(50, 30, MLScreenW - 80, 40) title:@"喜欢" font:MLFont(16.0)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [Viewer createLabelWithFrame:CGRectMake(MLScreenW - 80, 10, 80, 20) title:@"2015-10-23" font:MLFont(11.0)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
}

- (void)setModel:(CommentModel *)model
{
    if (![model.user[@"avatar_url"] isKindOfClass:[NSNull class]]) {
        [_iconIV sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar_url"]] placeholderImage:MLImage(@"ig_profile_photo_default")];
    } else {
        _iconIV.image = MLImage(@"ig_profile_photo_default");
    }
    _nameLabel.text = model.user[@"nickname"];
    CGFloat contenH = [Helper heightOfString:model.content font:MLFont(16.0) width:MLScreenW - 80];
    _contentLabel.height = contenH;
    _contentLabel.text = model.content;
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[model.created_at floatValue]];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MM-dd hh:mm"];
    NSString *sdate=[format stringFromDate:date2];
    _timeLabel.text = [NSString stringWithFormat:@"%@",sdate];
    
    _cellHeight = _contentLabel.maxY + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
