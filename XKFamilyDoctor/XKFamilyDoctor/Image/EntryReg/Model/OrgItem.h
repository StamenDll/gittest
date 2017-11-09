//
//  OrgItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrgItem : NSObject
@property(nonatomic,strong)id id;
@property(nonatomic,strong)id orgkey;
@property(nonatomic,strong)id orgname;
@property(nonatomic,strong)id orgcode;
@property(nonatomic,strong)id parentid;
@property(nonatomic,strong)id sta;
@property(nonatomic,strong)id parentname;
@property(nonatomic,strong)id districtid;
@property(nonatomic,strong)id districtname;
@property(nonatomic,strong)id orgfullname;
@property(nonatomic,strong)id address;
@property(nonatomic,strong)id area;
@property(nonatomic,strong)id orgtype;
@property(nonatomic,strong)id tel;
@end
