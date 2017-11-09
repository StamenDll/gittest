//
//  ChangeInfoViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PMenuChoiceView.h"
#import "DateChoiceView.h"
@interface ChangeInfoViewController : RootViewController<MenuChoiceDelegate,DateChoiceDelegate>
{
    UIScrollView *mainBGVSrollView;
    
    UITextField *nameTextField;
    UITextField *nationTextField;
    UITextField *addressTextField;
    UITextField *IDCardTextField;
    
    UILabel *birDateLabel;
    
    UIButton *sexButton;
    UILabel *sexNumLabel;
    
    UIButton *uploadButton;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
}
@end
