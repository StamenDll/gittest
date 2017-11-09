//
//  ChatRoomItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRoomItem : NSObject
@property(nonatomic,copy)NSString *LRoomName;
@property(nonatomic,assign)int LUserTotal;
@property(nonatomic,copy)NSString *LMainDoctorName;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *LMainDoctorCode;
@property(nonatomic,copy)NSString *LRoomDetail;
@property(nonatomic,copy)NSString *LSpeakRange;
@property(nonatomic,assign)int LSortId;
@property(nonatomic,copy)NSString *LWTime;
@property(nonatomic,copy)NSString *LPic;
@property(nonatomic,copy)NSString *LItemBigPic;

@property(nonatomic,copy)NSString *LHeadTitle;
@property(nonatomic,copy)NSString *LHeadUrl;
@property(nonatomic,copy)NSString *LHeadPic;
@end
