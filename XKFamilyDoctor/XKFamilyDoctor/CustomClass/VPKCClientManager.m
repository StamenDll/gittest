//
//  VPKCClientManager.m
//  VideoTest
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VPKCClientManager.h"
#import "AppDelegate.h"

static VPKCClientManager *instance = nil;
@implementation VPKCClientManager
{
    MQTTClient *client;
    NSString *kTopic;
}
+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *clientId = [NSString stringWithFormat:@"MQTTKitTests-%@", [[NSUUID UUID] UUIDString]];
        client = [[MQTTClient alloc] initWithClientId:clientId];
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
       client.host = appDelegate.MQTT_HOST;
        client.port = appDelegate.MQTT_PORT;
    }
    return self;
}

- (void)subscribeMessageWithMessageHandler:(void(^)(id dict))messageHandler
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [client connectToHost:appDelegate.MQTT_HOST
        completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            NSLog(@"连接成功...........");
            [client subscribe:CHATCODE withCompletionHandler:nil];
            
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            NSString *LHeadPic=nil;
            if ([usd objectForKey:@"LHeadPic"]==nil) {
                LHeadPic=@"";
            }else{
                LHeadPic=[usd objectForKey:@"LHeadPic"];
            }
            NSDictionary *dict=dict =@{@"face":LHeadPic, @"genre":@"user",@"name":[usd objectForKey:@"truename"], @"type" : @"conn", @"who" :CHATCODE};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
            
            NSString *text =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [client publishString:text
                          toTopic:@"com.dav.icdp.message"
                          withQos:AtMostOnce
                           retain:NO
                completionHandler:^(int mid) {
                    
                }];
            
        }else{
            NSLog(@"连接失败...........");
        }
        
    }];
    [client setMessageHandler:^(MQTTMessage *message){
        NSLog(@"============%@",message.payload);
        NSString *result = [[NSString alloc] initWithData:message.payload  encoding:NSUTF8StringEncoding];
        NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)result, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        NSData* xmlData = [decodedString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingAllowFragments error:nil];
        messageHandler(json);
    }];
}




- (void)disconectClient{
    if (client.connected) {
        dispatch_semaphore_t disconnected = dispatch_semaphore_create(0);
        [client disconnectWithCompletionHandler:^(NSUInteger code) {
            dispatch_semaphore_signal(disconnected);
        }];
    }
}

@end
