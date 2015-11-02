//
//  DetailModel.h
//  礼物说
//
//  Created by qianfeng on 14/10/16.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property (nonatomic, strong) NSArray *image_urls;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *detail_html;
@property (nonatomic, strong) NSNumber *comments_count;
@property (nonatomic, strong) NSString *purchase_url;
@end
