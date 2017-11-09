//
//  DrugInfoViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface DrugInfoViewController : RootViewController
{
    UIScrollView *mainScrollView;
    UIButton *lastGGButton;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *isChoiceDrug;
@end
