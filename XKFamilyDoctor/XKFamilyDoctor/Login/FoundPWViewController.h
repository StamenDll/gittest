//
//  FoundPWViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface FoundPWViewController : RootViewController<UITextFieldDelegate>
{
    UIScrollView *BGScrollView;
    UITextField *phoneField;
    UITextField *codeField;
    UITextField *newPWField;
    UITextField *surePWField;
    
    UIButton *codeButton;
    NSTimer *timer;
    NSInteger maCount;
    UIButton *sureButton;
}

@property(nonatomic,copy)NSString *codeString;
@property(nonatomic,copy)NSString *phoneString;

@end
