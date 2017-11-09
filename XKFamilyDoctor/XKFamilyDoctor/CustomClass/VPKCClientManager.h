//
//  VPKCClientManager.h
//  VideoTest
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTKit.h"
@interface VPKCClientManager : NSObject
+ (instancetype)sharedClient;
- (void)subscribeMessageWithMessageHandler:(void(^)(id dict))messageHandler;
- (void)disconectClient;
@end
