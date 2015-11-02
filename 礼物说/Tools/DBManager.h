//
//  DBManager.h
//  1512LimitFree
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HotModel;

@interface DBManager : NSObject

// 单例模式
+ (instancetype)shareManager;

// 删除数据
- (BOOL)deleteDataWithGiftID:(NSString *)giftID;

// 插入数据
- (BOOL)insertDataWithHotModel:(HotModel *)model;

// 根据giftID查询单条数据
- (BOOL)selectOneDataWithGiftID:(NSString *)giftID;

// 查询所有数据
- (NSArray *)selectAllData;


@end
