//
//  AllNewsViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface AllNewsViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>

{
    UIScrollView *mainScrollView;
    
    UIButton *specialBackView;
    UITableView *newNewsTableView;
    UILabel *newNewsCountLabel;
    
    UIButton *complaintBackView;
    UITableView *contactsTableView;
    
    BOOL isHaveChat;
    id saveSelf;
    NSMutableArray *newNewsArray;
    NSMutableArray *contactsArray;
}

@end
