//
//  ChoiceHouseholdViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/8/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "HouseholdItem.h"
@interface ChoiceHouseholdViewController : RootViewController
{
    UIScrollView *BGScrollView;
    NSMutableArray *mainDataArray;
    NSMutableArray *unitArray;
    NSMutableArray *nowUnitArray;
    
    UILabel *unitNameLabel;
    
    UIButton *lastButton;
}

@property(nonatomic,copy)NSString *orgid;
@property(nonatomic,copy)NSString *AreaID;
@property(nonatomic,copy)NSString *UnitID;
@property(nonatomic,strong)HouseholdItem *choiceHousehold;
@end
