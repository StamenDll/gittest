//
//  FDItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDItem : NSObject
@property(nonatomic,copy)NSString *sID;
@property(nonatomic,assign)int iOrgId;
@property(nonatomic,copy)NSString *sName;
@property(nonatomic,copy)NSString *sContent;
@property(nonatomic,copy)NSString *dBeginTime;
@property(nonatomic,copy)NSString *dEndTime;
@property(nonatomic,copy)NSString *dTime;
@property(nonatomic,copy)NSString *state;
@end
