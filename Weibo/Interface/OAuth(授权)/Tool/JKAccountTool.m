//
//  AccountTool.m
//  Weibo
//
//  Created by HiJack on 16/1/11.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#define cJKAccountPath [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"account.archive" ]

#import "JKAccountTool.h"

@implementation JKAccountTool


/**
 *  存储本地账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccout:(JKAccount *)account
{
    
    /* 存储账号的沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
     */
    // 将模型模型编码存入沙盒
    [NSKeyedArchiver archiveRootObject:account toFile:cJKAccountPath];
}



/**
 *  读取本地账号信息
 *
 *  @return 账号模型(如果账号过期,返回nil)
 */
+ (JKAccount *)account
{
    /* 账号文件的沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
     */
    // 账号文件解码
    JKAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:cJKAccountPath];
    
    // 验证账号是否过期
    // - 过期秒数
    long long expires_in = [account.expires_in longLongValue];
    // - 过期日期
    NSDate *expiresDate =  [account.access_Token_create_date dateByAddingTimeInterval:expires_in];
    //NSLog(@"过期日期%@",expiresDate);

    // - 当前时间
    NSDate *nowDate = [NSDate date] ;
   // NSLog(@"现在日期%@",nowDate);
    // - 比较日期
//    NSOrderedAscending = -1, 升序: 左边<右边
//    NSOrderedSame,           相同
//    NSOrderedDescending      降序: 左边>右边
    if ([expiresDate compare:nowDate] <= 0 ) {
        return nil;
    };
    return account;  
}

@end
