//
//  ChoiceDocTeamViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChoiceDocTeamViewController : RootViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *searchField;
    UITableView *mainTableView;
    NSMutableArray *mainDataArray;
}
@property(nonatomic,copy)NSString *whoPush;
@end
