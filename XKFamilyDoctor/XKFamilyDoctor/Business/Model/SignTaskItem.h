//
//  SignTaskItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignTaskItem : NSObject
@property(nonatomic,copy)NSDictionary *address;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *name;

@end
