//
//  ItemsModel.h
//  礼物说
//
//  Created by qianfeng on 14/10/10.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  精选攻略下得cell

#import <Foundation/Foundation.h>

@interface SelectionModel : NSObject

@property (nonatomic, strong) NSString *content_url;
@property (nonatomic, strong) NSString *cover_image_url;
@property (nonatomic, strong) NSString *SelectTitle;
@property (nonatomic, strong) NSNumber *likes_count;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *updated_at;

@end
