//
//  ResidentItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResidentItem : NSObject
@property(nonatomic,copy)NSString *LGroupID;
@property(nonatomic,copy)NSString *LName;
@property(nonatomic,copy)NSString *LActiveTime;
@property(nonatomic,copy)NSString *LDoctorTeamId;
@property(nonatomic,copy)NSString *LCode;
@property(nonatomic,copy)NSString *LMobile;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *LBindTime;
@property(nonatomic,copy)NSString *LDeviceOs;
@property(nonatomic,assign)int LOrgid;
@property(nonatomic,assign)int p_t_c_n;
@property(nonatomic,assign)int rowid;
@end
