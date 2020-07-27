//
//  MMManage.h
//  MyFMDB
//
//  Created by 毛宏鹏 on 2018/1/16.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"FMDatabase.h"
#import"FMDatabaseQueue.h"
#import"FMDatabaseAdditions.h"
#define CONTACT_TABLE   @"contactlist_tb"//联系人 表名字
#define DIARY_TABLE     @"diary_tb"//日记（事件） 表名字
#define DIARYSERVER_TABLE     @"diaryserver_tb"//模拟服务端 日记（事件） 表名字

@interface MMManage : NSObject

@property(nonatomic,retain)FMDatabaseQueue*dbQueue;

/**
 单例方法
 */
+(instancetype)sharedLH;

#pragma mark--创建表格
- (void)creatDatabaseTableWithTableName:(NSString *)tableName forClass:(Class)modleClass;

#pragma mark--批量插入数据
- (BOOL)insertContentList:(NSMutableArray *)data WithTableName:(NSString *)tableName forClass:(Class)modleClass;
#pragma mark--给表添加新的字段
- (void)addParameterWithName:(NSString *)name withTableName:(NSString *)tableName;
#pragma mark--删除一条数据 返回YES代表成功
- (BOOL)deleteContentMessageWithID:(NSString *)idStr withTableName:(NSString *)tableName;
- (BOOL )deleteContentMessageWithID2:(NSString *)idStr withTableName:(NSString *)tableName;
#pragma mark-- 删除整个表数据
- (BOOL)deleteDatabseWithTableName:(NSString *)tableName;
#pragma mark--更新一条数据
- (BOOL )updateContentMessageWithID:(NSString *)idStr withContentDic:(NSDictionary *)data withTableName:(NSString *)tableName forClass:(Class)modleClass;
#pragma mark--更新图片
- (BOOL )updateContentImageWithID:(NSString *)idStr withImageData:(NSData *)data  withTableName:(NSString *)tableName forKey:(NSString *)key;
#pragma mark--查询数据
- (NSMutableArray *)selectFromTableWithFileValue:(NSString *)filevalue fileKey:(NSString *)filekey withTableName:(NSString *)tableName;
#pragma mark--查询 多 条数据
- (NSMutableArray *)selectFromTableFromValue:(NSString *)offset limitValue:(NSString *)limit fileKey:(NSString *)filekey withTableName:(NSString *)tableName;
#pragma mark--查询整个表的数据
- (NSMutableArray *)selectFromTableWithTableName:(NSString *)tableName;

@end
