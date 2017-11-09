//
//  ReferralOutCViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ReferralOutCViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *referralOutArray;
    UITableView *referralOutTableView;
}
@property(nonatomic,copy)NSString *tableName;
@property(nonatomic,copy)NSString *tableAliasName;
@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *peopleMemberID;
@property(nonatomic,copy)NSString *isChange;
@end
