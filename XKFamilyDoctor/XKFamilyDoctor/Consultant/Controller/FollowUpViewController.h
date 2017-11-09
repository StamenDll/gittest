//
//  FollowUpViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface FollowUpViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainArray;
    
    UIScrollView *BGScrollView;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *tableName;
@property(nonatomic,copy)NSString *tableAliasName;
@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *isChange;
@end
 
