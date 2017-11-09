//
//  FreeDiagnoseViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface FreeDiagnoseViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
    UIScrollView *BGScrollView;
}
@property(nonatomic,copy)NSString *whoPush;
@end
