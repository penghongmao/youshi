//
//  MMManage.m
//  MyFMDB
//
//  Created by 毛宏鹏 on 2018/1/16.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "MMManage.h"
#import <objc/runtime.h>
#import "CacheBox.h"
@implementation MMManage

//全局变量
static id _instance = nil;
//单例方法
+(instancetype)sharedLH{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}
#pragma mark--创建表格
//只需要传表的名字和model类名即可
- (void)creatDatabaseTableWithTableName:(NSString *)tableName forClass:(Class)modleClass
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *comStr = [NSString stringWithFormat:@"%@.db",tableName];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:comStr];
    NSLog(@"dbPath==%@",dbPath);
    
    _dbQueue= [FMDatabaseQueue databaseQueueWithPath:dbPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![self isTableExist:tableName]){
        
        if ([db open])
        {
            //遍历模型属性
            NSArray * arrayPro =  [self allPropertyNamesWithClass:[self getModelName:modleClass]];
            
            NSMutableString * operate = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",tableName]];
            for (int i = 0; i<arrayPro.count; i++) {
                NSString * strPro = arrayPro[i];
                NSString * type = @"text";
                if ([strPro isEqualToString:@"headpath"])
                {
                    type = @"blob";
                }else{
                    type = @"text";
                }
                if (i==arrayPro.count-1) {
                    [operate appendString:[NSString stringWithFormat:@",%@ %@);",strPro,type]];
                    
                }else{
                    [operate appendString:[NSString stringWithFormat:@",%@ %@",strPro,type]];
                }
            }
            
            //            NSString*operate=[NSString stringWithFormat:@"create table %@ (id integer primary key autoincrement,contentName text,fileName text,version text);",tableName];
            BOOL result = [db executeStatements:operate];
            if (result) {
                NSLog(@"创表成功");
            }else{
                NSLog(@"创表失败");
                
            }
        }
        [db close];
        
    }else{
        NSLog(@"表已存在");
//        [CacheBox saveCacheValue:@[@""] forKey:TABLEVERDION_DIARY];
        NSNumber *historyNum = [CacheBox getCacheWithKey:TABLEVERSION_DIARY];
        NSNumber *currentNum = @1;
        if (historyNum<currentNum) {
            [CacheBox saveCacheValue:currentNum forKey:TABLEVERSION_DIARY];
            //遍历模型属性
            NSArray * arrayPro =  [self allPropertyNamesWithClass:[self getModelName:modleClass]];
            for (id objecs in arrayPro) {
                [self addParameterWithName:objecs withTableName:tableName];
            }
        }
    }
    
}

#pragma mark--批量插入数据
- (BOOL)insertContentList:(NSMutableArray *)data WithTableName:(NSString *)tableName forClass:(Class)modleClass
{

    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            //先删除再添加，如果不需要删除的就去掉这一句
//            [db executeUpdate:[NSString stringWithFormat:@"delete from contactlist_tb"]];
        }
    }];
    if (data==nil || data.count<=0) {
        return NO;
    }
    
    //遍历模型属性
    NSArray * arrayPro =  [self allPropertyNamesWithClass:[self getModelName:modleClass]];
    NSMutableString * operate1 = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"insert into %@ ",tableName]];
    NSMutableString * operate2 = [[NSMutableString alloc]initWithString:@" values "];
    for (int i = 0; i<arrayPro.count; i++) {
        NSString * strPro = arrayPro[i];
        if (i==arrayPro.count-1) {
            [operate1 appendString:[NSString stringWithFormat:@",%@)",strPro]];
            [operate2 appendString:@",?)"];

        }
        else if (i==0){
            [operate1 appendString:[NSString stringWithFormat:@"(%@ ",strPro]];
            [operate2 appendString:@"(?"];
            
        }
        else{
            [operate1 appendString:[NSString stringWithFormat:@",%@ ",strPro]];
            [operate2 appendString:@",?"];
        }
    }
    
    [operate1 appendString:operate2];
    
//    NSString*insertContentSql = [NSString stringWithFormat:@"insert into %@(contentName ,fileName ,version) values (?,?,?)",tableName];
   __block BOOL success = NO;

    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
//            db.beginTransaction;
            
            for (int i=0; i<data.count; i++)
            {
                NSDictionary* contentData=[data objectAtIndex:i];
                NSMutableArray *contentValues = [NSMutableArray array];
                for (NSString * key in arrayPro)
                {
                    if ([contentData.allKeys containsObject:key]) {
                        NSString *value=(NSString *)[contentData objectForKey:[NSString stringWithFormat:@"%@",key]];
                        [contentValues addObject:value];
                    }

                }
                
                success = [db executeUpdate:operate1 withArgumentsInArray:contentValues];
            }
            NSLog(@"是否成功==%d",success);

        }else{
            NSLog(@"数据库打开失败了");
            success = NO;
        }
//        db.commit;
    }];
    
    return success;
}

#pragma mark--给表添加新的字段
- (void)addParameterWithName:(NSString *)name withTableName:(NSString *)tableName
{
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    [queue inDatabase:^(FMDatabase *db) {
        //打开数据库
        if ([db open]) {
           //首先判断添加的字段是否存在，如果不存在就添加
            if (![db columnExists:name inTableWithName:tableName])
            {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",tableName,name];
                BOOL worked = [db executeUpdate:alertStr];
                if(worked){
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
                
            }
        }
    }];
    
    
}
#pragma mark--删除一条数据 2
- (BOOL )deleteContentMessageWithID2:(NSString *)idStr withTableName:(NSString *)tableName
{
    //操作收藏数据库，删除
    __block BOOL success = NO;
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];

    [queue inDatabase:^(FMDatabase *db) {
        //打开数据库
        if ([db open]) {
            
          success = [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where id='%@'",tableName,idStr]];
        }else{
            NSLog(@"数据库打开失败了");
            success = NO;
        }
        
    }];
    
    return success;
}
#pragma mark--删除一条数据 此方法success的逻辑不可修改，否则导致删除失败导致回滚
- (BOOL)deleteContentMessageWithID:(NSString *)idStr withTableName:(NSString *)tableName {
    
    __block BOOL success = YES;//isRollBack
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        [db beginTransaction];//开启事物保证数据完整性(有/无)
        
        @try {
            
            [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where id='%@'",tableName,idStr]];
        }
        
        @catch (NSException *exception)
        {
            success = NO;
            [db rollback];
        }
        
        @finally
        {
            if (success)
            {
                [db commit];
            }
            
        }
        
    }];
    return success;

}
//示例
- (void)upgradeDBwithTableName:(NSString *)tableName {
    
    
    
    __block BOOL isRollBack = NO;
    
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        [db beginTransaction];
        
        @try {
            
            [db executeUpdate:@"CREATE TEMPORARY TABLE comicRead_backup(comicId INTEGER, chapterId INTEGER, pageIndex INTEGER, updateTime INTEGER)"];
            
            [db executeUpdate:@"INSERT INTO comicRead_backup SELECT comicId,chapterId,pageIndex,updateTime FROM comicRead"];
            
            [db executeUpdate:@"DROP TABLE comicRead"];
            
            
            
            //浏览记录,却掉之前的comicId的unique约束
            NSString *comicReaderSql;
//            NSString *comicReaderSql = @"CREATE TABLE IF NOT EXISTS comicRead (\
//
//            comicId  INTEGER DEFAULT 0,\
//
//            chapterId  INTEGER DEFAULT 0,\
//
//            pageIndex  INTEGER DEFAULT 0,\
//
//            updateTime  INTEGER DEFAULT 0)";
            
            [db executeUpdate:comicReaderSql];
            
            
            
            [db executeUpdate:@"INSERT INTO comicRead SELECT comicId,chapterId,pageIndex,updateTime FROM comicRead_backup"];
            
            [db executeUpdate:@"DROP TABLE comicRead_backup"];
            
            
            
            [db executeUpdate:@"ALTER TABLE comicRead ADD COLUMN cover TEXT"];
            
            [db executeUpdate:@"ALTER TABLE comicRead ADD COLUMN comic_name TEXT"];
            
            [db executeUpdate:@"ALTER TABLE comicRead ADD COLUMN chapter_name TEXT"];
            
            [db executeUpdate:@"ALTER TABLE comicRead ADD COLUMN isLocal INTEGER default 0"];
            
            [db executeStatements:@"CREATE UNIQUE INDEX IF NOT EXISTS comicReadUniqueIndex ON comicRead(comicId,isLocal)"];
            
            
            
            [db executeUpdate:@"UPDATE comicRead SET isLocal=1"];
            
        }
        
        @catch (NSException *exception) {
            
            isRollBack = YES;
            
            [db rollback];
            
        }
        
        @finally {
            
            if (!isRollBack) {
                
                [db commit];
                
                [self upgradeDBwithTableName:tableName];
                
            }
            
        }
        
    }];
    
}
#pragma mark-- 删除数据库对应的表
- (BOOL)deleteDatabseWithTableName:(NSString *)tableName
{
    __block BOOL success = NO;
    
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    
    if ([self isTableExist:tableName])
    
    {
        FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
        [queue inDatabase:^(FMDatabase *db) {
            //打开数据库
            if ([db open]) {
                
                
                success = [db executeUpdate:sqlstr];
                
            }else{
                NSLog(@"数据库打开失败了");
                success = NO;
            }
        }];
    }
    NSLog(@"是否删除成功==%d",success);
    
    return success;
}
#pragma mark--更新一条数据
- (BOOL )updateContentMessageWithID:(NSString *)idStr withContentDic:(NSDictionary *)data withTableName:(NSString *)tableName forClass:(Class)modleClass
{
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    __block BOOL success = NO;

    [queue inDatabase:^(FMDatabase *db) {
        //打开数据库
        if ([db open]) {
            
            //遍历模型属性
//            NSArray * arrayPro =  [self allPropertyNamesWithClass:[self getModelName:modleClass]];
            NSArray * arrayPro =  [data allKeys];

            NSMutableString * operate1 = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"UPDATE %@ SET ",tableName]];
            NSMutableString * operate2 = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"WHERE id = %@",idStr]];
            for (int i = 0; i<arrayPro.count; i++)
            {
                NSString * key = arrayPro[i];
                NSString * value = [data objectForKey:key];
                if (i==arrayPro.count-1) {
                    [operate1 appendString:[NSString stringWithFormat:@"%@ = '%@' ",key,value]];

                }else{
                    [operate1 appendString:[NSString stringWithFormat:@"%@ = '%@', ",key,value]];
                }

            }
            
            [operate1 appendString:operate2];
            
//            [db executeUpdate:@"UPDATE contactlist_tb SET phone = ? WHERE id = ?",@"110",idStr];
            success = [db executeUpdate:operate1];
            NSLog(@"operate1=======%@",operate1);
        }else{
            NSLog(@"数据库打开失败了");

            success = NO;

        }
    }];
    return success;
}

#pragma mark--更新图片 key = headpath
- (BOOL )updateContentImageWithID:(NSString *)idStr withImageData:(NSData *)data  withTableName:(NSString *)tableName forKey:(NSString *)key
{
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    __block BOOL success = NO;
    
    [queue inDatabase:^(FMDatabase *db) {
        //打开数据库
        if ([db open]) {
            
            NSString *muStr1 = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE id = %@",tableName,key,idStr];

             success = [db executeUpdate:muStr1,data];

//            NSLog(@"UPDATE ===%@",muStr1);
        }else{
            success = NO;
            
        }
    }];
    return success;
}
#pragma mark--查询单条数据或者查询某一类数据（条件查询）
- (NSMutableArray *)selectFromTableWithFileValue:(NSString *)filevalue fileKey:(NSString *)filekey withTableName:(NSString *)tableName
{
    //
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];

    NSMutableArray *arguments = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ where %@='%@'",tableName,filekey,filevalue]];
            while ([rs next]) {

                [arguments addObject:[rs resultDictionary]];
                
            }
            [rs close];
            
        }
    }];
    return arguments;

}
#pragma mark--查询 多 条数据
- (NSMutableArray *)selectFromTableFromValue:(NSString *)offset limitValue:(NSString *)limit fileKey:(NSString *)filekey withTableName:(NSString *)tableName
{
    //
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    
    NSMutableArray *arguments = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *queryStr = [NSString stringWithFormat:@"select * from %@ order by %@ desc limit %@ offset %@",tableName,filekey,limit,offset];
//            FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ where %@='%@'",tableName,filekey,filevalue]];
            FMResultSet *rs = [db executeQuery:queryStr];

            while ([rs next]) {
                
                [arguments addObject:[rs resultDictionary]];
                
            }
            [rs close];
            
        }
    }];
    return arguments;
    
}
#pragma mark--查询 整张表
- (NSMutableArray *)selectFromTableWithTableName:(NSString *)tableName
{
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];

    NSMutableArray *arguments = [NSMutableArray array];

    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM %@ order by id desc",tableName];
            FMResultSet *rs = [db executeQuery:queryStr];

            while ([rs next]) {

                [arguments addObject: [rs resultDictionary]];
//                NSLog(@"查询到几条数据");
            }
            [rs close];
            
        }
    }];
//    NSLog(@"arguments=%@",arguments);

    return arguments;
}

//--====
/**
 对象转对象名字符串
 */
- (NSString*)getModelName:(id)model{
    NSString * tableName = NSStringFromClass([model class]);
    return tableName;
}
///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *) allPropertyNamesWithClass:(NSString*)class{
    //字符串转类🌟🌟🌟🌟🌟
    Class someClass = NSClassFromString(class);
    id obj = [[someClass alloc] init];
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    ///存储属性的个数
    unsigned int propertyCount = 0;
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([obj class], &propertyCount);
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    ///释放
    free(propertys);
    return allNames;
}

- (FMDatabaseQueue* )getCurrentQueueWithTableName:(NSString *)tableName
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *comStr = [NSString stringWithFormat:@"%@.db",tableName];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:comStr];
//    NSLog(@"dbPath==%@",dbPath);
    FMDatabaseQueue *queue= [FMDatabaseQueue databaseQueueWithPath:dbPath];
    return queue;
}

- (BOOL)isTableExist:(NSString *)tableName
{
    __block BOOL exist  = NO;
    FMDatabaseQueue *queue = [self getCurrentQueueWithTableName:tableName];
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?",tableName];
         while([rs next])
         {
             NSInteger count = [rs intForColumn:@"count"];
             
             if(count==0)
             {
                 exist=NO;
             }else{
                 exist=YES;
             }
         }
     }];
    return exist;
    
}

@end
