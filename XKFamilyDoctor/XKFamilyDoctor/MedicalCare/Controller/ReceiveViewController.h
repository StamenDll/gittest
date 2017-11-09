//
//  ReceiveViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "ReferraItem.h"
#import "DateChoiceView.h"
#import "CommunityItem.h"
@interface ReceiveViewController : RootViewController<UITextFieldDelegate,DateChoiceDelegate>
{
    UIScrollView *mainScrollView;
    UIButton *choiceCommunityButton;
    UITextField *docNameField;
    UITextField *docPhoneField;
    UITextField *userNameField;
    UITextField *userPhoneField;
    UIButton *choiceDateButton;
    UITextView *detailTextView;
    
    UIButton *sureReseiveButton;
}
@property(nonatomic,strong)ReferraItem *Item;
@property(nonatomic,strong)CommunityItem *communityItem;
@end
