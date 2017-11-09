//
//  ChoiceDepViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "FDItem.h"
#import "FDDoctorItem.h"
#import "OrgDoctorItem.h"
#import "MQTTKit.h"
#import "MyUserItem.h"
@interface ChoiceDepViewController : RootViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIScrollView *BGScrollView;
    NSMutableArray *allDataArray;
    NSMutableArray *subDataArray;
    NSMutableArray *choiceArray;
    NSMutableArray *newsDicArray;
    
    UIButton *lastButton;
    UIView *choiceView;
    
    NSMutableArray *sureArray;
    
    UIButton *uploadButton;
    BOOL isSign;
    MQTTClient *client;
}
@property(nonatomic,copy)NSString *whopush;
@property(nonatomic,copy)NSString *isMU;

@property(nonatomic,strong)FDItem *fdItem;
@property(nonatomic,strong)FDDoctorItem *fdDocItem;
@property(nonatomic,strong)OrgDoctorItem *orgDocItem;
@property(nonatomic,strong)MyUserItem *userItem;
@property(nonatomic,copy)NSString *nameString;
@property(nonatomic,copy)NSString *phoneString;
@property(nonatomic,copy)NSString *IDCardString;
@property(nonatomic,copy)NSString *sexString;
@property(nonatomic,copy)NSString *addressString;
@property(nonatomic,copy)NSString *birString;
@property(nonatomic,copy)NSString *nationString;
@property(nonatomic,copy)NSString *unitString;
@property(nonatomic,copy)NSString *validtimeString;
@property(nonatomic,copy)NSString *memberidString;
@property(nonatomic,copy)NSString *onlycodeString;
@property(nonatomic,copy)NSString *print;

@end
