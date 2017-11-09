//
//  SelfRequestClass.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@protocol selfRequestDelegate <NSObject>
//请求成功回调方法
-(void)requestSuccess:(id)message andType:(NSString *)type;
//请求失败回调方法
-(void)requestFail:(NSString*)type;
@end

@interface SelfRequestClass : NSObject
{
    AFHTTPSessionManager *manager;
}
//请求地址
@property(nonatomic,copy)NSString *path;
@property(nonatomic,copy)NSString *type;
//post请求参数字典
@property(nonatomic,copy)NSDictionary *dic;

@property(nonatomic,assign)id<selfRequestDelegate>delegate;

-(void)startGetRequestInfo;

-(void)startPostRequestInfo;

-(void)startPostNoHeaderInfo;

- (void)cancelRequest;
@end
