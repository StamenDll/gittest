//
//  UncaughtExceptionHandler.m
//  Game
//
//  Created by WangYue on 13-7-17.
//  Copyright (c) 2013年 ntstudio.imzone.in. All rights reserved.
//


#import "MyUncaughtExceptionHandler.h"
#import "AppDelegate.h"

NSString * applicationDocumentsDirectory()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException * exception)
{
    NSLog(@"==================2222222===============");
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
	NSString *urlStr = [NSString stringWithFormat:@"mailto:178646465@qq.com?subject=客户端bug报告&body=很抱歉应用出现故障,感谢您的配合!发送这封邮件可协助我们改善此应用<br>"
						"错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
						name,reason,[arr componentsJoinedByString:@"<br>"]];
	
	NSURL *url2 = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
	[[UIApplication sharedApplication] openURL:url2];
}

@implementation MyUncaughtExceptionHandler

-(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    NSLog(@"===============11111111==================");
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception
{
    NSLog(@"===============3333==================");
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

    NSLog(@"%s:%d %@", __FUNCTION__, __LINE__, url);
}

@end

