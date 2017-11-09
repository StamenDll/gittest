//
//  ChoiceFamilyViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/11/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChoiceFamilyViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainDataArray;
}
@end
