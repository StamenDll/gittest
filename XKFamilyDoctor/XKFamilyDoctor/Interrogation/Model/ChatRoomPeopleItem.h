//
//  ChatRoomPeopleItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRoomPeopleItem : NSObject
@property(nonatomic,copy)NSString *LName;
@property(nonatomic,assign)int LForbiddenTalkTimeLength;
@property(nonatomic,copy)NSString *LForbiddenTalkStartTime;
@property(nonatomic,assign)int LostTime;
@property(nonatomic,copy)NSString *LHeadPic;
@property(nonatomic,copy)NSString *LWTime;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,assign)int p_t_c_n;
@property(nonatomic,assign)int rowid;
@end
