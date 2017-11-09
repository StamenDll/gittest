//
//  FileUpAndDown.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@protocol FileUpAndDownDelegate <NSObject>
//下载成功之后的回调方法
-(void)dowloadDataSuccess:(id)message;
//下载失败之后的回调方法
-(void)dowloadDataFail;
//上传成功之后的回调方法
-(void)uploadDataSuccess:(id)message;
//上传失败之后的回调方法
-(void)uploadDataFail:(id)message;
@end

@interface FileUpAndDown : NSObject
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,assign)id<FileUpAndDownDelegate>delegate;

//文件上传
- (void)uploadFile:(NSString*)urlString andData:(id)fildData andFileName:(id)fileName andController:(UIViewController*)controller;
//文件下载
- (void)download:(NSString*)urlString;

@end
