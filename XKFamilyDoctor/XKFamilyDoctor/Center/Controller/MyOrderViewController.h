//
//  MyOrderViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface MyOrderViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *waitPayOrderArray;
    NSMutableArray *paySuccessOrderArray;
    
    UITableView *mainTableView;
    UILabel *scrollLineLabel;
    UIButton *lastButton;
}

@property(nonatomic,copy)NSString *isPaySuccess;
@property(nonatomic,copy)NSString *isChoiceWho;
@property(nonatomic,copy)NSMutableArray *dataArray;

@end
