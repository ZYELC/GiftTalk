//
//  TypeModel.m
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "GroupModel.h"


@implementation GroupModel

// 重写channels的getter方法.
- (NSArray *)channels
{
    NSMutableArray *channelArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _channels.count; i ++) {
        NSDictionary *dict = _channels[i];
        GroupDetailModel *model = [[GroupDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        model.ID = dict[@"id"];
        [channelArr addObject:model];
    }
    return channelArr;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
