//
//  AccountTool.h
//  Weibo
//
//  Created by HiJack on 16/1/11.
//  Copyright © 2016年 HiJack. All rights reserved.
//  处理账号相关的操作:储存账号/取出账号/验证账号

#import <Foundation/Foundation.h>
#import "JKAccount.h"
@interface JKAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccout:(JKAccount *)account;


/**
 *  返回账号信息
 *
 *  @return 账号模型(如果账号过期,返回nil)
 */
+ (JKAccount *)account;

@end
