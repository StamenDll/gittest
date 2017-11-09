//
//  SignViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "MemberInfoItem.h"
#import "MQTTKit.h"
@interface SignViewController : RootViewController
{
    UIScrollView *mainScrollView;
    UIButton *infoButton;
    UIButton *sHistoryButton;
    UIButton *fHistoryButton;
    
    MemberInfoItem *memberItem;
    
    UITextView *reasonTextView;
    MQTTClient *client;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *lChatID;
@property(nonatomic,copy)NSString *LDoctorName;
@property(nonatomic,copy)NSMutableArray *doctorArray;
@end
