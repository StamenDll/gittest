//
//  BPSListViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "BPSListItem.h"
@interface BPSListViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainDataArray;
    int pageCount;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,copy)NSString *LOnlyCode;
@property(nonatomic,copy)NSString *memberID;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,strong)BPSListItem *BPSItem;
@end
