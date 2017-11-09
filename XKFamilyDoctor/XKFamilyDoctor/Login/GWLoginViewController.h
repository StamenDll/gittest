//
//  GWLoginViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface GWLoginViewController : RootViewController<UITextFieldDelegate>
{
    UIScrollView *BGScrollView;
    UITextField *accountsTextField;
    UITextField *passwordTextField;
    UIButton *loginButton;
    
}
@property(nonatomic,copy)NSString *whoPush;
@end
