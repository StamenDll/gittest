//
//  ChatItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ChatItem : NSObject<NSCoding>
@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *fromName;
@property(nonatomic,copy)NSString *fromFace;
@property(nonatomic,copy)NSString *channel;
@property(nonatomic,copy)NSString *timestamp;
@property(nonatomic,copy)NSString *to;
@property(nonatomic,copy)NSString *toName;
@property(nonatomic,copy)NSString *toFace;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *contentType;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)int yyLength;
@property(nonatomic,assign)int unsend;

@end
