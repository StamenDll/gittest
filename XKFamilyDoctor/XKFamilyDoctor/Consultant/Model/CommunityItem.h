//
//  CommunityItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityItem : NSObject
@property(nonatomic,copy)NSString *LAddr;
@property(nonatomic,copy)NSString *LongName;
@property(nonatomic,copy)NSString *LName;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *Distance;
@property(nonatomic,copy)NSString *LPic;
@property(nonatomic,copy)NSString *LDetail;
@property(nonatomic,copy)NSString *LTel;
@property(nonatomic,copy)NSString *LOrgId;
@property(nonatomic,assign)int id;
@end
