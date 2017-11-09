//
//  MyQuestionViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface MyQuestionViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    NSInteger delIndex;
    
    int nowCount;
}

@end
