//
//  MedicalCareViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface MedicalCareViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *mainScrollView;
    UITableView *mainTableView;
    
    UIView *applyBackView;
    
    NSMutableArray *applyArray;
    NSMutableArray *doctorArray;
    UIButton *lastButton;
}
@property(nonatomic,copy)NSString *applyIsChange;
@property(nonatomic,copy)NSString *returnOrAgree;
@end
