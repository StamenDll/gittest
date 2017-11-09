//
//  ApplyListItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyListItem : NSObject
@property(nonatomic,copy)NSString *LName;
@property(nonatomic,copy)NSString *LCode;
@property(nonatomic,copy)NSString *Lid;
@property(nonatomic,copy)NSString *LMobile;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *LDeviceType;
@property(nonatomic,copy)NSString *LBindTime;
@property(nonatomic,copy)NSString *LMsgOnlineID;
@property(nonatomic,copy)NSString *LHeadPic;
@property(nonatomic,copy)NSString *LDoctorName;
@property(nonatomic,copy)NSString *iAge;
@property(nonatomic,assign)int member_sex;
@end
