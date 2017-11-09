//
//  NearAreaItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearAreaItem : NSObject
@property(nonatomic,copy)NSString *sName;
@property(nonatomic,copy)NSString *sUnit;
@property(nonatomic,copy)NSString *place;
@property(nonatomic,copy)NSString *sDistrictId;
@property(nonatomic,copy)NSString *sDistrictAddress;
@property (nonatomic,assign)int OrgID;
@property (nonatomic,assign)int iUnit;
@property (nonatomic,assign)int AreaId;
@property (nonatomic,assign)int iTotalCell;
@property (nonatomic,assign)float Distance;


@end
