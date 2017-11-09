//
//  AddOrderUserViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PMenuChoiceView.h"
#import "DateChoiceView.h"
#import "FDItem.h"
#import "VisitItem.h"
#import "MyUserItem.h"
@interface AddOrderUserViewController : RootViewController<UITextFieldDelegate,MenuChoiceDelegate,DateChoiceDelegate>
{
    UIScrollView *mainBGVSrollView;
    UITextField *phoneTextField;
    UITextField *vCodeTextField;
    UITextField *nameTextField;
    UITextField *addressTextField;
    UITextField *cAddressTextField;
    UITextField *IDCardTextField;
    UITextField *unitTextField;
    UITextField *validTimeTextField;
    UITextView *remarkTextView;

    
    UIButton *getCodeButton;
    NSTimer *timer;
    NSInteger maCount;
    
    UILabel *birDateLabel;
    UILabel *sexNumLabel;
    
    UIButton *nationButton;
    UILabel *nationNumLabel;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
    
    UIButton *districtButton;
    UILabel *districtLabel;
    NSMutableArray *districtArray;
    
    UIButton *lastChoiceButton;

    UIButton *uploadButton;
    
    UIView *adviceView;
    UILabel *upAdviceLabel;
    
}
@property(nonatomic,copy)NSString *whopush;
@property(nonatomic,copy)NSString *isMU;

@property(nonatomic,copy)NSString *phoneString;
@property(nonatomic,copy)NSString *codeString;
@property(nonatomic,copy)NSString *districtString;
@property(nonatomic,copy)NSString *fileNOString;
@property(nonatomic,copy)NSString *lOnlyString;
@property(nonatomic,copy)NSString *memberID;
@property(nonatomic,strong)FDItem *fdItem;
@property(nonatomic,strong)VisitItem *visitItem;
@property(nonatomic,strong)MyUserItem *userItem;


@end
