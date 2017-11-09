//
//  VillageItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/3/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VillageItem : NSObject
@property(nonatomic,copy)NSString *sName;
@property(nonatomic,copy)NSString *sUnit;
@property (nonatomic,assign)int OrgID;
@property (nonatomic,assign)int iUnit;
@property (nonatomic,assign)int AreaId;
@property (nonatomic,assign)int iTotalCell;
@end
