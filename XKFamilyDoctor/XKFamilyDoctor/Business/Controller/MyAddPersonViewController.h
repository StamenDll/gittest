//
//  MyAddPersonViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "MQTTKit.h"

@interface MyAddPersonViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    NSMutableArray *mainDataArray;
    NSMutableArray *searchDataArray;
    
    
    UILabel *countLabel;
    UILabel *totalCountLabel;
    
    UITextField *searchField;
    BOOL isSearch;

    MQTTClient *client;
    long count;
    int nowCount;
}
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,copy)NSString *fdSid;
@end
