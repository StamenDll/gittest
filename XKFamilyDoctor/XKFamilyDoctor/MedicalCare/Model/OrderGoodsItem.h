//
//  OrderGoodsItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoodsItem : NSObject
@property(nonatomic,copy)NSString *LRemark;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *LUnit;
@property(nonatomic,copy)NSString *LGoodsName;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *LWTime;
@property(nonatomic,copy)NSString *LGoodsID;
@property(nonatomic,copy)NSString *LBillId;
@property(nonatomic,assign)int LNumber;
@property(nonatomic,assign)CGFloat LMoney;
@end
