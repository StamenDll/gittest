//
//  WriteRecipeViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface WriteRecipeViewController : RootViewController<UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView *mainScrollView;
    UITextField *sicknessField;
    UILabel *timeNLabel;
    UITextView *introduceTextView;
    UIButton *addDrugButton;
}
@property(nonatomic,copy)NSString *isAddDrug;
@end
