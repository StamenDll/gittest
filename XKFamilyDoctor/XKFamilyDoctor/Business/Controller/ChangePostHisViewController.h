//
//  ChangePostHisViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChangePostHisViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    NSMutableArray *mainDataArray;
}

@end
