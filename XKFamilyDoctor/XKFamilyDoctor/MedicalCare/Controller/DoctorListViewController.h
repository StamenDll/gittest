//
//  DoctorListViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface DoctorListViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
}
@property(nonatomic,copy)NSMutableArray *mainArray;
@end
