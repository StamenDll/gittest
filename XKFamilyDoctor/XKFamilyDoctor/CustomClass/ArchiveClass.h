//
//  ArchiveClass.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveClass : NSObject

/**
 获取本地缓存数据

 @return 返回消息数据
 */
- (NSMutableArray*)getLocalNews;

/**
 将新消息缓存到本地

 @param newNewsArray 新消息数组
 */
- (void)saveNewsToLocal:(NSMutableArray*)newNewsArray;


/**
 修改本地消息缓存

 @param chatTo 聊天对象
 @param type 聊天方式
 @return 对比结果
 */
- (BOOL)contrastNews:(NSString*)chatTo andChatType:(NSString*)type;

/**
 获取本地缓存小区数据
 
 @return 返回小区数据
 */
- (NSMutableArray*)getLocalArea;

/**
 将历史小区缓存到本地
 
 @param newNewsArray 新消息数组
 */
- (void)saveAreaToLocal:(NSMutableArray*)areaArray;


/**
 获取本地服务器地址缓存

 @return 本地服务器地址字典
 */
- (NSDictionary*)getLocalUrl;


/**
 将服务器地址缓存到本地

 @param urlDic 服务器地址字典
 */
- (void)saveUrlToLocal:(NSDictionary *)urlDic;



/**
 保存我的设备

 @param deviceUUID 设备UUID
 @param type 设备类型
 */
- (void)saveDeviceUUIDToLocal:(NSString *)deviceUUID andType:(NSString*)type;


/**
 获取我的设备

 @param type 设备类型
 @return 设备UUID
 */
- (NSString*)getLocalDeviceUUID:(NSString*)type;

@end
