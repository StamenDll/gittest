//
//  SelfRequestClass.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SelfRequestClass.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
@implementation SelfRequestClass
//Get请求
-(void)startGetRequestInfo{
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    NSLog(@"startget URL:%@", _path);
    [manager GET:_path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(requestSuccess:andType:)]&&self.delegate!=nil) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [self.delegate requestSuccess:string andType:_type];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code==-1009) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查您的网络后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }else if ([self.delegate respondsToSelector:@selector(requestFail:)]&&self.delegate!=nil) {
            [self.delegate requestFail:_type];
        }
    }];
}

-(void)startPostRequestInfo{
    
    if (![_type isEqualToString:@"AddHealTitleCount"]&&![self.type isEqualToString:@"AddHealTitleCount"]&&![self.type isEqualToString:@"SignState"]&&![self.type isEqualToString:GETSIGNTYPE]) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setRingThickness:5];
        [SVProgressHUD setForegroundColor:GREENCOLOR];
        [SVProgressHUD setBackgroundColor:MAINWHITECOLOR];
        [SVProgressHUD show];
    }
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =10;
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",nil];
    
    if ([self.type isEqualToString:GETSIGNTYPE]||[self.type isEqualToString:CHANGESIGNTYPE]||[self.type isEqualToString:SETUSERFILETYPE]) {
        NSLog(@"设置成功");
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        if (![self.type isEqualToString:SETUSERFILEURL]) {
        [manager.requestSerializer setValue:@"DEF4C7B-9BED-4585-A3F7-EA1C7143A03B" forHTTPHeaderField:@"Authorization"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }else{
        [manager.requestSerializer setValue:@"raw" forHTTPHeaderField:@"Content-Type"];
        }
    }
    else{
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    NSLog(@"startPost URL:%@", _path);
    NSLog(@"startPost dic:%@", _dic);
    if ([self.type isEqualToString:@"GetSureOrderCode"]||[self.type isEqualToString:@"GetCode"]||[self.type isEqualToString:@"SendMessage"]) {
        self.path=@"http://116.52.164.59:7702/home_doctor_main/sql/excute";
    }
    
    [manager POST:_path parameters:_dic progress:^(NSProgress * _Nonnull uploadProgress) {}
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![self.type isEqualToString:@"OnOrOffLine"]) {
            if ([self.delegate respondsToSelector:@selector(requestSuccess:andType:)]&&self.delegate!=nil) {
                NSLog(@"==11111111=%@",responseObject);
                [SVProgressHUD dismiss];
                if ([responseObject objectForKey:@"code"]||[responseObject objectForKey:@"success"]||[responseObject objectForKey:@"succeed"]) {
                    int code=[[responseObject objectForKey:@"code"] intValue];
                    int success=[[responseObject objectForKey:@"success"] intValue];
                    int succeed=[[responseObject objectForKey:@"succeed"] intValue];
                    if (code==1||success==1||succeed==1) {
                        id data=[responseObject objectForKey:@"data"];
                        if (data) {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                [self.delegate requestSuccess:data andType:_type];
                            }else if ([data isKindOfClass:[NSArray class]]) {
                                [self.delegate requestSuccess:data andType:_type];
                            }else{
                                [self.delegate requestSuccess:@[] andType:_type];
                            }
                        }
                        else{
                            [self.delegate requestSuccess:responseObject andType:_type];
                        }
                    }else{
                        if ([responseObject objectForKey:@"reason"]) {
                            [self.delegate requestSuccess:[responseObject objectForKey:@"reason"] andType:_type];
                            
                        }else{
                            [self.delegate requestSuccess:[responseObject objectForKey:@"msg"] andType:_type];
                        }
                    }
                }
                else if([responseObject objectForKey:@"result"]){
                    int result=[[responseObject objectForKey:@"result"] intValue];
                    if (result==0) {
                        id data=[responseObject objectForKey:@"data"];
                        [self.delegate requestSuccess:data andType:_type];
                    }else{
                        [self.delegate requestSuccess:[responseObject objectForKey:@"msg"] andType:_type];
                    }

                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"===================%@",error);
        [SVProgressHUD dismiss];
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"网络错误，请检查您的网络后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        if ([self.delegate respondsToSelector:@selector(requestFail:)]&&self.delegate!=nil) {
            [self.delegate requestFail:_type];
        }
    }];
}

- (void) startPostNoHeaderInfo {
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSLog(@"startNoHeaderPost URL:%@", _path);
    NSLog(@"startNoHeaderPost dic:%@", _dic);
    [manager POST:_path parameters:_dic progress:^(NSProgress * _Nonnull uploadProgress) {
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(requestSuccess:andType:)]&&self.delegate!=nil) {
            [self.delegate requestSuccess:responseObject andType:_type];
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(requestFail:)]&&self.delegate!=nil
            ) {
            [self.delegate requestFail:_type];
        }
    }];
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

- (void)cancelRequest{
    [SVProgressHUD dismiss];
    for (NSURLSessionDataTask *task in manager.tasks) {
        [task cancel];
    }
}
@end
