//
//  MyCollectionViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface MyCollectionViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    NSInteger delIndex;
    
    int nowCount;
}

@end
