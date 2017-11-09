//
//  AddArchivesViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/3/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PMenuChoiceView.h"
#import "RegionItem.h"
#import "NearAreaItem.h"
#import "FloorItem.h"
#import "HouseholdItem.h"
#import "MyUserItem.h"
@interface AddArchivesViewController : RootViewController<MenuChoiceDelegate>
{
    UIScrollView *BGScrollView;
    UIButton *choiceAreaButton;
    UIButton *choiceStreetButton;
    UIButton *choiceNCButton;
    UIButton *choiceVillageButton;
    UIButton *choiceFloorButton;
    UIButton *choiceHouseholdButton;
    UIButton *nextButton;
    
    NSMutableArray *areaArray;
    NSMutableArray *streetArray;
    NSMutableArray *NCArray;
    NSMutableArray *villageArray;
    NSMutableArray *floorArray;
    NSMutableArray *householdArray;
    
    PMenuChoiceView *menuChoiceView;
    RegionItem *choiceAreaItem;
    RegionItem *choiceStreetItem;
    RegionItem *choiceNCItem;
    NearAreaItem *choiceVillageItem;
    FloorItem *choiceFloorItem;
    HouseholdItem *choiceHouseholdItem;
    
}
@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *choiceWho;
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,strong)MyUserItem *userItem;
@end
