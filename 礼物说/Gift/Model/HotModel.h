//
//  HotModel.h
//  礼物说
//
//  Created by qianfeng on 15/10/11.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//  热门礼物下得item

#import <Foundation/Foundation.h>

@interface HotModel : NSObject

@property (nonatomic, strong) NSString *cover_image_url;
@property (nonatomic, strong) NSString *Hotname;
@property (nonatomic, strong) NSNumber *likes_count;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *ID;

@end
