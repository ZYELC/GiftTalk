//
//  DBManager2.m
//  礼物说
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import "DBManager2.h"
#import "FMDatabase.h"
#import "SelectionModel.h"

@interface DBManager2 ()
{
    FMDatabase *_fmdb; // 数据库对象
    NSLock     *_lock; // 锁
}
@end

static DBManager2 *_db;
@implementation DBManager2

// 单例模式
+ (instancetype)shareManager {
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _db = [[DBManager2 alloc] init];
    });
    
    return _db;
}

- (instancetype)init {
    if (self = [super init]) {
        // 初始化锁
        _lock = [[NSLock alloc] init];
        
        // 创建数据库
        NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/selection.db"];
        NSLog(@"沙盒路径:%@", dbPath);
        _fmdb = [FMDatabase databaseWithPath:dbPath];
        
        // 打开数据库
        BOOL isOpen = [_fmdb open];
        
        if (isOpen) {
            // 创建表: 创建了app表，里面有三个字段,第一个:应用ID；第二个:应用名称;第三个:应用图标路径.
            NSString *sql = @"create table if not exists selection (selectionIcon varchar(1024),selectionName varchar(100),selectionID varchar(100))";
            
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
- (BOOL)insertDataWithSelectionModel:(SelectionModel *)model
{
    // 加锁 : 为了防止多条线程同时去访问插入数据的代码导致数据紊乱.所以加锁保证在插入数据的时间内只有一条线程访问.
    [_lock lock];
    
    // 1. sql语句
    // ?是sql语句里面的占位符
    NSString *sql = @"insert into selection values(?, ?, ?)";
    
    // 2. 执行sql语句
    BOOL isSuccess =[_fmdb executeUpdate:sql, model.cover_image_url,model.SelectTitle,model.ID];
    
    // 3. 是否成功
    NSLog(isSuccess ? @"插入成功" : @"插入失败");
    
    // 解锁
    [_lock unlock];
    
    return isSuccess;
}

// 删除数据
- (BOOL)deleteDataWithSelectionID:(NSString *)selectionID {
    [_lock lock];
    
    NSString *sql = @"delete from selection where selectionID = ?";
    
    BOOL isSuccess = [_fmdb executeUpdate:sql, selectionID];
    
    NSLog(isSuccess ? @"删除成功" : @"删除失败");
    
    [_lock unlock];
    
    return isSuccess;
}

// 根据giftID查询单条数据
- (BOOL)selectOneDataWithSelectionID:(NSString *)selectionID {
    
    NSString *sql = @"select * from selection where selectionID = ?";
    
    // 查询方法:返回一个 查询结果集
    FMResultSet *set = [_fmdb executeQuery:sql, selectionID];
    
    // 结果 集有值，next返回Yes,否则返回No。
    return [set next];
}

// 查询所有数据
- (NSArray *)selectAllData {
    NSString *sql = @"select * from selection";
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    // 遍历结果集
    while ([set next]) {
        SelectionModel *model = [[SelectionModel alloc] init];
        // 将结果里面的字段值转换为模型的属性
        model.ID = [set stringForColumn:@"selectionID"];
        
        model.SelectTitle = [set stringForColumn:@"selectionName"];
        
        model.cover_image_url = [set stringForColumn:@"selectionIcon"];
        
        [arr addObject:model];
    }
    
    return arr;
}

@end
