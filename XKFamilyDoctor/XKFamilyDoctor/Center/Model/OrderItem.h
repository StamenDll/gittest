//
//  OrderItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *LGoodsName;
@property(nonatomic,copy)NSString *LGoodsID;
@property(nonatomic,copy)id LMoney;
@property(nonatomic,copy)NSString *LOrderTime;
@property(nonatomic,copy)NSString *LPayTime;
@property(nonatomic,copy)NSString *LRemark;
@property(nonatomic,copy)NSString *LUserName;
@property(nonatomic,copy)NSString *LMobile;
///未付，已付，支付失败
@property(nonatomic,copy)NSString *LState;
@property(nonatomic,copy)NSString *LSendSta;
@property(nonatomic,copy)NSString *LWTime;
@end
