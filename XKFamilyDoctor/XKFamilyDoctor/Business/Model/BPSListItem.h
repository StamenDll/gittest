//
//  BPSListItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPSListItem : NSObject
@property(nonatomic,copy)NSString *DataSource;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *adddate;
@property(nonatomic,copy)NSString *checkdate;
@property(nonatomic,copy)NSString *checkType;
@property(nonatomic,copy)NSString *checkvalue;
@property(nonatomic,copy)NSString *feel;
@property(nonatomic,copy)NSString *fileno;
@property(nonatomic,assign)int highpressure;
@property(nonatomic,copy)NSString *iid;
@property(nonatomic,copy)NSString *imei;
@property(nonatomic,assign)int lowpressure;
@property(nonatomic,assign)int isabnormal;
@property(nonatomic,assign)int ischeck;
@property(nonatomic,copy)NSString *member_id;
@property(nonatomic,assign)int pulse;
@property(nonatomic,copy)NSString *sn;
@property(nonatomic,assign)int tempcolumn;
@property(nonatomic,assign)int temprownumber;
@property(nonatomic,copy)NSString *username;

@end
