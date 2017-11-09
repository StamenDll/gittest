//
//  VisitViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface VisitViewController : RootViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *searchField;
    UITableView *mainTableView;
    
    NSMutableArray *mainDataArray;
}
@end
