//
//  OrderRegisterViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface OrderRegisterViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainArray;
}
@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *isChange;
@end
