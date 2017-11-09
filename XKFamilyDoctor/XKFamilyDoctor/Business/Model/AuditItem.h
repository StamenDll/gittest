//
//  AuditItem.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuditItem : NSObject
@property(nonatomic,copy)NSString *departmentname;
@property(nonatomic,assign)int empkey;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *idno;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *optdate;
@property(nonatomic,copy)NSString *orgname;
@property(nonatomic,copy)NSString *platename;
@property(nonatomic,copy)id postname;
@property(nonatomic,assign)int rownum;
@property(nonatomic,copy)NSString *truename;

@end
