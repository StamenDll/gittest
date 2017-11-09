//
//  SearchViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface SearchViewController : RootViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *searchField;
    UIView *historyView;
    UITableView *mainTableView;
    
    UIButton *lastDelSButton;
}
@end
