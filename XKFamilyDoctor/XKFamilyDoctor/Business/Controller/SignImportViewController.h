//
//  SignImportViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PMenuChoiceView.h"
#import "DateChoiceView.h"
#import "TeamItem.h"
#import "PrintView.h"
#import "CheckboxView.h"
#import "MyUserItem.h"
#import "SignTaskItem.h"

@interface SignImportViewController : RootViewController<UITextFieldDelegate,MenuChoiceDelegate,DateChoiceDelegate,PrintViewDelegate,CheckboxViewDelegate>
{
    UIScrollView *BGScrollView;
    UITextField *IDCardTextField;
    UITextField *phoneNumTextField;
    UITextField *userNameTextField;
    UITextField *addressTextField;
    UITextField *currentAddressField;
    UITextField *medicalInsTextField;
    
    UILabel *birDateLabel;
    UILabel *sexNumLabel;
    UIButton *nationButton;
    UILabel *nationNumLabel;
    UILabel *teamNameLabel;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
    
    UIButton *uploadButton;
    
    UIButton *districtButton;
    UILabel *districtLabel;
    NSMutableArray *districtArray;
    
    UIButton *diseaseButton;
    UILabel *diseaseCLabel;
    UIButton *marriageButton;
    UILabel *marriageCLabel;
    UIButton *personnelTypeButton;
    UILabel *personnelTypeCLabel;
    
    UIButton *lastChoiceButton;
    
    BOOL isSign;
    
    PrintView *printView;
    
    CheckboxView *checkboxView;

}

@property(nonatomic,copy)NSString *bindID;
@property(nonatomic,copy)NSString *fileNOString;
@property(nonatomic,copy)NSString *districtString;
@property(nonatomic,copy)NSString *lOnlyString;
@property(nonatomic,copy)NSString *memberID;
@property(nonatomic,strong)TeamItem *teamItem;
@property(nonatomic,strong)MyUserItem *userItem;
@property(nonatomic,strong)SignTaskItem *taskItem;

@property(nonatomic,copy)NSString *whoPush;

@end
