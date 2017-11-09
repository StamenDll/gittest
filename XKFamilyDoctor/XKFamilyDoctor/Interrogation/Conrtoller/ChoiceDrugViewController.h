//
//  ChoiceDrugViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChoiceDrugViewController : RootViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *searchField;
    UIView *historyView;
    UITableView *mainTableView;
}

@end
