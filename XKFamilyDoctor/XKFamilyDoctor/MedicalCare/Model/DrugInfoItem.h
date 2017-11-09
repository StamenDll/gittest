//
//  DrugInfoItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugInfoItem : NSObject
@property(nonatomic,copy)NSString *LSerial;
@property(nonatomic,copy)NSString *LMainFun;
@property(nonatomic,copy)NSString *LName;
@property(nonatomic,copy)NSString *LInstructions;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *LUsage;
@property(nonatomic,copy)NSString *LFlag;
@property(nonatomic,copy)NSString *LQualityTime;
@property(nonatomic,assign)int rowid;
@property(nonatomic,copy)NSString *LTime;
@property(nonatomic,copy)NSString *LKind;
@property(nonatomic,copy)NSString *LTaboo;
@property(nonatomic,copy)NSString *LFromAddr;
@property(nonatomic,copy)NSString *LDetail;
@property(nonatomic,copy)NSString *LCode;
@property(nonatomic,copy)NSString *LStoreType;
@property(nonatomic,assign)CGFloat LNewPrice;
@property(nonatomic,copy)NSString *LModel;
@property(nonatomic,assign)int p_t_c_n;
@property(nonatomic,copy)NSString *LPic;
@property(nonatomic,copy)NSString *LState;
@property(nonatomic,assign)CGFloat LOldPrice;
@property(nonatomic,copy)NSString *LExist;
@end
