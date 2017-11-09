//
//  AddUserViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "DateChoiceView.h"
#import "PMenuChoiceView.h"
#import "CommunityItem.h"

@interface AddUserViewController : RootViewController<UITextFieldDelegate,DateChoiceDelegate,MenuChoiceDelegate>
{
    UIScrollView *mainScrollView;
    NSMutableArray *mainArray;
    
    UITextField *memberNumberField;
    UITextField *codeField;
    
    NSString *phoneText;
    NSMutableDictionary *localCodeDic;
    
    UIButton *lastTimeButton;
    UIButton *lastSexButton;
    
    
    NSInteger maCount;
    NSTimer *timer;
    
    NSMutableArray *overArray;
}
@property(nonatomic,strong)UITextField *memberTextField;
@property(nonatomic,strong)UILabel *communityLabel;
@property(nonatomic,strong)UIButton *getCodeButton;
@property(nonatomic,copy)NSString *writeType;
@property(nonatomic,copy)NSString *tableName;
@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,strong)CommunityItem *communityItem;
@end
