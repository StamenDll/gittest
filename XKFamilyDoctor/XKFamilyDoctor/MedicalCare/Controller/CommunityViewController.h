//
//  CommunityViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "CommunityItem.h"
@interface CommunityViewController : RootViewController
{
    UIScrollView *BGScrollView;
    UIView *introduceBGView;
    UIView *addressBGView;
    UIView *departmentBGView;
    UIView *teamBGView;
    CommunityItem *communityItem;
    NSMutableArray *doctorArray;
}
@end
