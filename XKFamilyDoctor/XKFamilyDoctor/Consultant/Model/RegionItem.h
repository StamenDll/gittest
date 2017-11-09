//
//  RegionItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/3/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionItem : NSObject
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * Name;
@property (nonatomic , copy) NSString              * ParentName;
@property (nonatomic , copy) NSString              * Name_Png;
@property (nonatomic , assign) NSInteger              OrgID;
@property (nonatomic , assign) NSInteger              Level;
@property (nonatomic , assign) BOOL                 IsDetail;
@property (nonatomic , copy) NSString              *Description;
@property (nonatomic , copy) NSString              *ParentID;

@end
