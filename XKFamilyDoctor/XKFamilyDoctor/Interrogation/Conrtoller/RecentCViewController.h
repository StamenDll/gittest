//
//  RecentCViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface RecentCViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *mainArray;
    UITableView *mainTableView;
    int nowCount;
}
@end
