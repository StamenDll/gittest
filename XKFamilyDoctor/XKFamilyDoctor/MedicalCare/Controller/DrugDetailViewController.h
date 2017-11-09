//
//  DrugDetailViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "DrugInfoItem.h"
@interface DrugDetailViewController : RootViewController
{
    UIScrollView *BGScrollView;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,strong)DrugInfoItem *drugInfoItem;
@end
