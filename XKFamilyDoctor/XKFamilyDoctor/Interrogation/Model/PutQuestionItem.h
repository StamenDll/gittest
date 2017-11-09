//
//  PutQuestionItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PutQuestionItem : NSObject
@property(nonatomic,copy)NSString *LPic1;
@property(nonatomic,copy)NSString *LPic2;
@property(nonatomic,copy)NSString *LSenderName;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *LWTime;
@property(nonatomic,copy)NSString *LSenderCode;
@property(nonatomic,copy)NSString *LTitle;
@property(nonatomic,copy)NSString *LDetail;
@property(nonatomic,copy)NSString *LHeadPic;
@property(nonatomic,assign)int LStoreNum;
@property(nonatomic,assign)int LAnswerNum;
@property(nonatomic,strong)id StoreTime;
@end
