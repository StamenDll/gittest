//
//  AuditViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface AuditViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
}
@end
