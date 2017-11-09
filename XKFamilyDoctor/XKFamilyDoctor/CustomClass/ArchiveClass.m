//
//  ArchiveClass.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ArchiveClass.h"
#import "ChatItem.h"
@implementation ArchiveClass
#pragma mark 读取本地缓存
- (NSMutableArray*)getLocalNews{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",CHATCODE]];
    NSMutableArray *newPersonsArr = [NSKeyedUnarchiver unarchiveObjectWithFile:personsArrPath];
    NSMutableArray *array=[NSMutableArray new];
    if (newPersonsArr) {
        return newPersonsArr;
    }
    return array;
}

#pragma mark 将未读新消息缓存到本地
- (void)saveNewsToLocal:(NSMutableArray*)newNewsArray{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",CHATCODE]];
    //    NSLog(@"=保存地址＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",)
    [NSKeyedArchiver archiveRootObject:newNewsArray toFile:personsArrPath];
}

- (BOOL)contrastNews:(NSString*)chatTo andChatType:(NSString*)type{
    NSMutableArray *newsArray=[self getLocalNews];
    BOOL isHave=NO;
    NSInteger index=0;
    if ([type isEqualToString:@"chat"]) {
        for (ChatItem *item in newsArray) {
            if ([item.from isEqualToString:chatTo]) {
                isHave=YES;
                index=[newsArray indexOfObject:item];
            }
        }
    }else{
        for (ChatItem *item in newsArray) {
            if ([item.to isEqualToString:chatTo]) {
                isHave=YES;
                index=[newsArray indexOfObject:item];
            }
        }
    }
    if (isHave==YES) {
        [newsArray removeObjectAtIndex:index];
    }
    return isHave;
}

#pragma mark 读取本地缓存
- (NSMutableArray*)getLocalArea{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@_area.plist",CHATCODE]];
    NSMutableArray *newPersonsArr = [NSKeyedUnarchiver unarchiveObjectWithFile:personsArrPath];
    NSMutableArray *array=[NSMutableArray new];
    if (newPersonsArr) {
        return newPersonsArr;
    }
    return array;
}

#pragma mark 将未读新消息缓存到本地
- (void)saveAreaToLocal:(NSMutableArray *)areaArray{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@_area.plist",CHATCODE]];
    //    NSLog(@"=保存地址＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",)
    [NSKeyedArchiver archiveRootObject:areaArray toFile:personsArrPath];
}

#pragma mark 读取本地缓存服务器地址
- (NSDictionary*)getLocalUrl{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:@"/url.plist"];
    NSDictionary *urlDic = [NSKeyedUnarchiver unarchiveObjectWithFile:personsArrPath];
    if (urlDic) {
        return urlDic;
    }
    NSDictionary *newUrlDic=[NSDictionary new];
    return newUrlDic;
}

#pragma mark 将服务器地址缓存到本地
- (void)saveUrlToLocal:(NSDictionary *)urlDic{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:@"/url.plist"];
    //    NSLog(@"=保存地址＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",)
    [NSKeyedArchiver archiveRootObject:urlDic toFile:personsArrPath];
}

#pragma mark 读取本地缓存服务器地址
- (NSString*)getLocalDeviceUUID:(NSString*)type{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@_%@.plist",EMPKEY,type]];
    NSString *deviceUUID = [NSKeyedUnarchiver unarchiveObjectWithFile:personsArrPath];
    if (deviceUUID) {
        return deviceUUID;
    }
    return @"";
}

#pragma mark 将服务器地址缓存到本地
- (void)saveDeviceUUIDToLocal:(NSString *)deviceUUID andType:(NSString*)type{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@_%@.plist",EMPKEY,type]];
    //    NSLog(@"=保存地址＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",)
    [NSKeyedArchiver archiveRootObject:deviceUUID toFile:personsArrPath];
}

@end
