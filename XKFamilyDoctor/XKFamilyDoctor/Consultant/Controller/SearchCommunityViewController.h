//
//  SearchCommunityViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface SearchCommunityViewController : RootViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,selfRequestDelegate>
{
    UITextField *searchField;
    UIView *historyView;
    UITableView *mainTableView;
    
    UIButton *lastDelSButton;
    NSMutableArray *dataArray;
    
    int nowCount;

}
@property(nonatomic,copy)NSString *whoPush;
@end
