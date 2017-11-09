//
//  ConsultantViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ConsultantViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    UIButton *userButton;
}
@property(nonatomic,copy)NSString *isAdd;
@end
