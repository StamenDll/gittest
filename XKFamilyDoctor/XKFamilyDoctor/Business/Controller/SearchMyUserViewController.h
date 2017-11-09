//
//  SearchMyUserViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/8/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface SearchMyUserViewController : RootViewController<UITextFieldDelegate>
{
    UIScrollView *BGScrollView;
    NSMutableArray *mainArray;
    UITextField *searchField;
    
    UIView *tagBGView;
}
@end
