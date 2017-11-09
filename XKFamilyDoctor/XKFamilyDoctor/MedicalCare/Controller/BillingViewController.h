//
//  BillingViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "DrugInfoItem.h"
@interface BillingViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *mainTableView;
    UIScrollView *mainBGScrollView;
    UITextField *nameTextField;
    UITextField *phoneTextField;
    
    UIButton *addDrugButton;
    UIView *drugView;
    
    UIView *sureOrderView;
    UIButton *sureOrderButton;
    
    NSMutableArray *choiceDrugArray;
    NSMutableArray *orderGoods;
    
    UIButton *distributionButton;
    UIButton *getBySelfButton;
    NSString *getWay;
    
}
@property(nonatomic,strong)NSString *oederID;
@property(nonatomic,strong)NSString *userCode;
@property(nonatomic,strong)DrugInfoItem *choiceDrugItem;
@end
