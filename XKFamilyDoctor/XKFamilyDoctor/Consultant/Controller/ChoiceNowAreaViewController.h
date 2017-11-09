//
//  ChoiceNowAreaViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "PMenuChoiceView.h"
#import "NearAreaItem.h"
#import "FloorItem.h"
#import "HouseholdItem.h"
#import "MyUserItem.h"
@interface ChoiceNowAreaViewController : RootViewController<BMKLocationServiceDelegate,MenuChoiceDelegate>
{
    NSMutableArray *areaArray;
    UILabel *addressDetailbLabel;
    UIButton *choiceVillageButton;
    UIButton *choiceFloorButton;
    UIButton *choiceHouseholdButton;
    UIButton *nextButton;
    BMKLocationService *locationService;
    PMenuChoiceView *menuChoiceView;
    
    NSMutableArray *floorArray;
    NSMutableArray *householdArray;

    FloorItem *choiceFloorItem;
}
@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *choiceWho;
@property(nonatomic,strong)NearAreaItem *choiceVillageItem;
@property(nonatomic,strong)HouseholdItem *choiceHouseholdItem;

@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,strong)MyUserItem *userItem;

@end
