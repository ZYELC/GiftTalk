//
//  DBManager.m
//  1512LimitFree
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

#import "HotModel.h"

@interface DBManager ()
{
    FMDatabase *_fmdb; // 数据库对象
    NSLock     *_lock; // 锁
}
@end

static DBManager *_db;
@implementation DBManager

// 单例模式
+ (instancetype)shareManager {
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _db = [[DBManager alloc] init];
    });
    
    return _db;
}

- (instancetype)init {
    if (self = [super init]) {
        // 初始化锁
        _lock = [[NSLock alloc] init];
        
        // 创建数据库
        NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/app.db"];
        NSLog(@"沙盒路径:%@", dbPath);
        _fmdb = [FMDatabase databaseWithPath:dbPath];
        
        // 打开数据库
        BOOL isOpen = [_fmdb open];
        
        if (isOpen) {
            // 创建表: 创建了app表，里面有三个字段,第一个:应用ID；第二个:应用名称;第三个:应用图标路径.
            NSString *sql = @"create table if not exists app (giftIcon varchar(1024),giftName varchar(100),giftID varchar(100))";
            
            // 执行sql语句
            BOOL isSuccess = [_fmdb executeUpdate:sql];
            if (isSuccess) {
                MLLog(@"建表成功");
            } else {
                MLLog(@"建表失败");
            }
            
            
        } else {
            MLLog(@"数据库打开失败");
        }
        
    }
    
    return self;
}

// 插入数据
- (BOOL)insertDataWithHotModel:(HotModel *)model
{
    // 加锁 : 为了防止多条线程同时去访问插入数据的代码导致数据紊乱.所以加锁保证在插入数据的时间内只有一条线程访问.
    [_lock lock];
    
    // 1. sql语句
    // ?是sql语句里面的占位符
    NSString *sql = @"insert into app values(?, ?, ?)";
    
    // 2. 执行sql语句
    BOOL isSuccess =[_fmdb executeUpdate:sql, model.cover_image_url,model.Hotname,model.ID];
    
    // 3. 是否成功
    NSLog(isSuccess ? @"插入成功" : @"插入失败");
    
    // 解锁
    [_lock unlock];
    
    return isSuccess;
}

// 删除数据
- (BOOL)deleteDataWithGiftID:(NSString *)giftID {
    [_lock lock];
    
    NSString *sql = @"delete from app where giftID = ?";
    
    BOOL isSuccess = [_fmdb executeUpdate:sql, giftID];
    
    NSLog(isSuccess ? @"删除成功" : @"删除失败");
    
    [_lock unlock];
    
    return isSuccess;
}

// 根据giftID查询单条数据
- (BOOL)selectOneDataWithGiftID:(NSString *)giftID {
    
    NSString *sql = @"select * from app where giftID = ?";
    
    // 查询方法:返回一个 查询结果集
    FMResultSet *set = [_fmdb executeQuery:sql, giftID];
    
    // 结果 集有值，next返回Yes,否则返回No。
    return [set next];
}

// 查询所有数据
- (NSArray *)selectAllData {
    NSString *sql = @"select * from app";
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    // 遍历结果集
    while ([set next]) {
        HotModel *model = [[HotModel alloc] init];
        // 将结果里面的字段值转换为模型的属性
        model.ID = [set stringForColumn:@"giftID"];
        
        model.Hotname = [set stringForColumn:@"giftName"];

        model.cover_image_url = [set stringForColumn:@"giftIcon"];
        
        [arr addObject:model];
    }
    
    return arr;
}

@end
