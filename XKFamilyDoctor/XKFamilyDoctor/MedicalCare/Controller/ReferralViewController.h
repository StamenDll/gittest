//
//  ReferralViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ReferralViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIScrollView *mainScrollView;
    NSMutableArray *referralOutArray;
    NSMutableArray *referralOutCopyArray;
    NSMutableArray *referralInArray;
    NSMutableArray *referralInCopyArray;
    
    UITableView *referralOutTableView;
    UITableView *referralInTableView;
    UIButton *applyButton;
    NSArray *pickerArray;
}
@property(nonatomic,copy)NSString *stateString;
@property(nonatomic,copy)NSString *isChange;
@end
