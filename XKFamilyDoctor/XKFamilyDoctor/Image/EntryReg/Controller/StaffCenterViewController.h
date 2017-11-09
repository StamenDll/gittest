//
//  StaffCenterViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface StaffCenterViewController : RootViewController
{
    UIScrollView *mainBGVSrollView;
    UITextField *phoneTextField;
    UITextField *codeTextField;
    
    UIButton *getCodeButton;
    NSTimer *timer;
    NSInteger maCount;
}
@end
