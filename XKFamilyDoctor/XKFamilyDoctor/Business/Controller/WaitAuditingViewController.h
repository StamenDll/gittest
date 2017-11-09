//
//  WaitAuditingViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface WaitAuditingViewController : RootViewController
{
    UIScrollView *BGSrollView;
    NSMutableArray *dataArray;
    
    UIView *setAllMenuBGView;
    
    UIButton *lastChoiceButton;
    NSMutableArray *choiceButtonArray;
    NSMutableArray *idsArray;
}
@property(nonatomic,copy)NSString *isAgree;
@end
