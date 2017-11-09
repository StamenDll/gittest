//
//  ChoicePlatetViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChoicePlatetViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainDataArray;
    NSMutableArray *nextDataArray;
    

}

@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *parentID;
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,copy)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *isNext;

@end
