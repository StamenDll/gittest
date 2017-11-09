//
//  FollowUpItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowUpItem : NSObject
@property(nonatomic,copy)NSString *LContent;
@property(nonatomic,assign)float LMoney;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *LPeopleOnlyCode;
@property(nonatomic,copy)NSString *LAiderOnlyCode;
@property(nonatomic,copy)NSString *LTime;
@property(nonatomic,copy)NSString *LIsMedical;
@end
