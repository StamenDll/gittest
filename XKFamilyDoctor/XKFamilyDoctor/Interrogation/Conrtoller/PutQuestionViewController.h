//
//  PutQuestionViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface PutQuestionViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
    UITableView *mainTableView;
    int nowCount;
}
@property(nonatomic,copy)NSString *isChange;
@end
