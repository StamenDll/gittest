//
//  BuyDrugViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface BuyDrugViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainArray;
    int nowCount;
}
@property(nonatomic,copy)NSString *rwloadString;
@end
