//
//  ArchiveInputViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/3/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "RegionItem.h"
#import "NearAreaItem.h"
#import "FloorItem.h"
#import "HouseholdItem.h"
#import "DateChoiceView.h"
#import "PMenuChoiceView.h"
#import "IDCardInfoItem.h"
#import "MyUserItem.h"
@interface ArchiveInputViewController : RootViewController<DateChoiceDelegate,MenuChoiceDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView *BGScrollView;
    UIView *pastBGView;
    UIView *downBGView;
    
    NSMutableArray *mainArray;
    
    NSMutableArray *paymentArray;
    NSMutableArray *allergicArray;
    NSMutableArray *exposeArray;
    NSMutableArray *familyFArray;
    NSMutableArray *diseaseArray;
    NSMutableArray *disabilityArray;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
    
    UIButton *uploadButton;
    UIButton *lastTimeButton;
    UIButton *lastMenuButton;
    
    UIButton *lastLiveTypeButton;
    UIButton *lastBloodTypeButton;
    UIButton *lastRHButton;
    UIButton *lastEducationTypeButton;
    UIButton *lastJobTypeButton;
    UIButton *lastMaritalButton;
    UIButton *lastFarmOrTownButton;
    UIButton *lastMaternalButton;
    UIButton *lastGeneticButton;
    UIButton *lastKitchenButton;
    UIButton *lastFuelButton;
    UIButton *lastDrinkingButton;
    UIButton *lastToiletButton;
    UIButton *lastLivestockButton;
    
    NSArray *archiveArray;
    NSArray *basicInfoArray;
    
    UIView *diseaseBGView;
    UIButton *addDiseaseButton;
    
    UIView *opsBGView;
    UIButton *addOpsButton;
    UIView *traumaBGView;
    UIButton *addTraumaButton;
    UIView *bloodBGView;
    UIButton *addBloodButton;
    
    NSInteger diseaseCount;
    NSMutableArray *diseaseButtonArray;
    UIButton *lastDiseasButton;
    NSMutableDictionary *lastDisDic;
    
    NSInteger opsCount;
    NSInteger traumaCount;
    NSInteger bloodCount;
    BOOL isCheckIDCard;
    


//    UIButton *lastAllergicButton;
//    UIButton *lastExposeButton;
//    UIButton *lastFamilyFButton;
//    UIButton *lastFamilyMButton;
//    UIButton *lastFamilyBButton;
//    UIButton *lastFamilyDButton;
//    UIButton *lastDisabilityButton;
    
}
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,assign)BOOL isCA;

@property(nonatomic,strong)MyUserItem *userItem;

@property (nonatomic,strong) NearAreaItem *areaItem;
@property (nonatomic,strong) FloorItem *choiceFloorItem;
@property (nonatomic,strong) RegionItem *NCItem;
@property (nonatomic,strong) HouseholdItem *choiceHouseholdItem;

@property (nonatomic,strong) IDCardInfoItem *oldIDCardInfo;


@property(nonatomic,copy)NSString *FileNo;
@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *liveType;
@property(nonatomic,copy)NSString *bloodType;
@property(nonatomic,copy)NSString *RH;
@property(nonatomic,copy)NSString *education;
@property(nonatomic,copy)NSString *job;
@property(nonatomic,copy)NSString *marital;
@property(nonatomic,copy)NSString *farmOrTown;
@property(nonatomic,copy)NSString *maternal;
@property(nonatomic,copy)NSString *genetic;
@property(nonatomic,copy)NSString *kitchen;
@property(nonatomic,copy)NSString *fuel;
@property(nonatomic,copy)NSString *drinking;
@property(nonatomic,copy)NSString *toilet;
@property(nonatomic,copy)NSString *livestock;

@property(nonatomic,copy)NSString *UUID;

@property(nonatomic,strong)NSMutableArray *paymentArray;
@property(nonatomic,strong)NSMutableArray *allergicArray;
@property(nonatomic,strong)NSMutableArray *exposeArray;
@property(nonatomic,strong)NSMutableArray *familyFArray;
@property(nonatomic,strong)NSMutableArray *familyMArray;
@property(nonatomic,strong)NSMutableArray *familyBArray;
@property(nonatomic,strong)NSMutableArray *familyDArray;
@property(nonatomic,strong)NSMutableArray *disabilityArray;

@property(nonatomic,strong)NSMutableArray *diseaseArray;
@property(nonatomic,strong)NSMutableArray *opsArray;
@property(nonatomic,strong)NSMutableArray *traumaArray;
@property(nonatomic,strong)NSMutableArray *bloodArray;

@property(nonatomic,copy)NSString *DistrictNumber;
@property(nonatomic,copy)NSString *delFielNO;

@end
