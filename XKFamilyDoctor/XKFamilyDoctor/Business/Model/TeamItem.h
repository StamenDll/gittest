//
//  TeamItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamItem : NSObject
@property(nonatomic,copy)NSString *LName;
@property(nonatomic,copy)NSString *LRemark;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,assign)int LOrgId;
@property(nonatomic,copy)NSString *LTime;

@end
