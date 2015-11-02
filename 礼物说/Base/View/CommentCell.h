//
//  CommentCell.h
//  礼物说
//
//  Created by qianfeng on 14/10/17.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;
@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentModel *model;
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype) cellWithTableView:(UITableView *)tableView;

@end
