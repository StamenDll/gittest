//
//  ChoicePostViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChoicePostViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    NSMutableArray *mainDataArray;
    NSMutableArray *searchDataArray;
    
    UITextField *searchField;
    BOOL isSearch;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *whoPush;
@end
