//
//  LoginViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PrintView.h"
@interface LoginViewController : RootViewController<UITextFieldDelegate,PrintViewDelegate>
{
    UIScrollView *BGScrollView;
    UITextField *accountsTextField;
    UITextField *passwordTextField;
    UIButton *loginButton;
    UIButton *choiceURLButton;
    
    PrintView *printView;
    NSString *plistUrl;

    
}
@property(nonatomic,copy)NSString *isChangeSuccess;
@property(nonatomic,copy)NSString *whopresent;
@end
