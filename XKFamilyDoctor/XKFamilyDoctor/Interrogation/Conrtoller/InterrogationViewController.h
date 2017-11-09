//
//  InterrogationViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface InterrogationViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
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
@property(nonatomic,strong)UILabel *newsCountLabel;
- (void)changeView;
@end
