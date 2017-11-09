//
//  OrderFrame.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"
@interface OrderFrame : NSObject
@property (nonatomic,strong) OrderItem *orderInfo;
@property (nonatomic, assign) CGFloat cellHeight;
@end
