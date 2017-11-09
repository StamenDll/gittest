//
//  ChangePWViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChangePWViewController : RootViewController<UITextFieldDelegate>
{
    UIScrollView *BGScrollView;
    UITextField *oldPWTextField;
    UITextField *newPWTextField;
    UITextField *sureNewPWTextField;
    
    UIButton *overButton;
}
@end
