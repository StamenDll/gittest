//
//  FileUpAndDown.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FileUpAndDown.h"
#import "SVProgressHUD.h"
@implementation FileUpAndDown
#pragma mark 文件上传

- (void)uploadFile:(NSString*)urlString andData:(id)fildData andFileName:(id)fileName andController:(UIViewController*)controller{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setRingThickness:5];
    [SVProgressHUD setForegroundColor:GREENCOLOR];
    [SVProgressHUD setBackgroundColor:MAINWHITECOLOR];
    [SVProgressHUD show];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if ([fildData isKindOfClass:[NSArray class]]) {
            NSMutableArray *dataArray=fildData;
            for (int i=0;i<dataArray.count;i++) {
                [formData appendPartWithFileData:fildData[i] name:[NSString stringWithFormat:@"FileUpload[%d]",i] fileName:fileName[i] mimeType:@"image/jpg/png/jpeg"];
                NSLog(@"=====%@==========%@",fileName[i],formData);
            }
        }else{
            [formData appendPartWithFileData:fildData name:@"file" fileName:fileName mimeType:@"application/x-www-form-urlencoded"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        如果需要进度条   在此添加
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"======%@",task);
        [SVProgressHUD dismiss];
        
        if ([self.delegate respondsToSelector:@selector(uploadDataSuccess:)]) {
            [self.delegate uploadDataSuccess:fileName];
        }
        return;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error======%@",error);
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(uploadDataFail:)]) {
            [self.delegate uploadDataFail:fileName];
        }
        return;
    }];
}

- (void)download:(NSString*)urlString{
    //远程地址
    NSURL *URL = [NSURL URLWithString:urlString];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error&&[self.delegate respondsToSelector:@selector(dowloadDataFail)]) {
            [self.delegate dowloadDataFail];
        }else if ([self.delegate respondsToSelector:@selector(dowloadDataSuccess:)]) {
            [self.delegate dowloadDataSuccess:filePath];
        }
        
    }];
    [self.downloadTask resume];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
