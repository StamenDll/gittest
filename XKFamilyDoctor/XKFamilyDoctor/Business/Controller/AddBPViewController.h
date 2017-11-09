//
//  AddBPViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "DateChoiceView.h"
#import "PMenuChoiceView.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface AddBPViewController : RootViewController<UITextFieldDelegate,DateChoiceDelegate,MenuChoiceDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    UIScrollView *mainScrollView;
    UITextField *hBPTextField;
    UITextField *lBPTextField;
    UITextField *hrTextField;
    UILabel *dateLabel;
    UILabel *timeLabel;
    
    UILabel *timeIntLabel;
    UITextField *bsTextField;
    
    UIButton *saveButton;

    UILabel *deviceStateLabel;

    DateChoiceView *dateChoiceView;
    PMenuChoiceView *menuChoiceView;
    UIButton *lastButton;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *whoPush;

@property(nonatomic,copy)NSString *dataSource;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *memberID;

@property(nonatomic,copy)NSString *choiceDevice;
/* 中心管理者 */
@property (nonatomic, strong) CBCentralManager *cMgr;

/* 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;
@end
