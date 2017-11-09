//
//  SAMemberInfoViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PMenuChoiceView.h"
#import "DateChoiceView.h"
#import "TeamItem.h"
#import "CheckboxView.h"
#import "MyUserItem.h"
#import "SignTaskItem.h"
@interface SAMemberInfoViewController : RootViewController<UITextFieldDelegate,MenuChoiceDelegate,DateChoiceDelegate,CheckboxViewDelegate>
{
    UIScrollView *BGScrollView;
    UITextField *nickNameTextField;
    UITextField *nameTextField;
    UITextField *nationTextField;
    UITextField *addressTextField;
    UITextField *IDCardTextField;
    
    UILabel *birDateLabel;
    UILabel *sexNumLabel;
    UILabel *teamNameLabel;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
    
    UIButton *diseaseButton;
    UILabel *diseaseCLabel;
    UIButton *marriageButton;
    UILabel *marriageCLabel;
    UIButton *personnelTypeButton;
    UILabel *personnelTypeCLabel;
    UIButton *lastChoiceButton;
    UIButton *signButton;
    
    CheckboxView *checkboxView;
    
}
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,copy)NSString *isMU;

@property(nonatomic,strong)TeamItem *teamItem;
@property(nonatomic,strong)MyUserItem *userItem;
@property(nonatomic,strong)SignTaskItem *taskItem;

@property(nonatomic,copy)NSString *bindID;
@property(nonatomic,copy)NSString *nameString;
@property(nonatomic,copy)NSString *IDCardString;
@property(nonatomic,copy)NSString *phoneString;
@property(nonatomic,copy)NSString *sexString;
@property(nonatomic,copy)NSString *addressString;
@property(nonatomic,copy)NSString *birString;
@property(nonatomic,copy)NSString *nationString;
@property(nonatomic,copy)NSString *onlycodeString;
@end
