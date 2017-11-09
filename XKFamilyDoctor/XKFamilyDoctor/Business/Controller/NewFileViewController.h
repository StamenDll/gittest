//
//  NewFileViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/10/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "MyUserItem.h"
#import "RegionItem.h"
#import "DateChoiceView.h"
#import "PMenuChoiceView.h"
#import "HouseholdItem.h"
#import "UserFileInfoItem.h"

@interface NewFileViewController : RootViewController<UITextFieldDelegate,DateChoiceDelegate,MenuChoiceDelegate,UITextViewDelegate>
{
    UIScrollView *nowBGView;
    UIScrollView *faceBGView;
    UIScrollView *familyBGView;
    UIScrollView *pastBGView;
    UIButton *lastMenuButton;

    UILabel *moveLine;
    
    UIScrollView *otherBGView;
    
    NSMutableArray *mainArray;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
    
    UIButton *lastTimeButton;
    //疾病数组
    NSMutableArray *diseaseArray;
    NSMutableArray *paymentArray;
    NSMutableArray *allergicArray;
    NSMutableArray *exposeArray;
    NSMutableArray *familyFArray;
    NSMutableArray *disabilityArray;
    
    NSArray *archiveArray;
    NSArray *basicInfoArray;
    
    BOOL isCheckIDCard;
    
    UIView *diseaseBGView;
    UIScrollView *addDisView;
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
    
    NSInteger opsCount;
    NSInteger traumaCount;
    NSInteger bloodCount;

    
    UIButton *uploadButton;
}
///用户信息
@property(nonatomic,strong)MyUserItem *userItem;
///网格信息
@property (nonatomic,strong) RegionItem *NCItem;

@property(nonatomic,copy)NSString* fileNo;
@property(nonatomic,copy)NSString *DistrictNumber;

@property(nonatomic,copy)NSString *memberID;

///用户档案
@property(nonatomic,strong)UserFileInfoItem *userFileItem;

@property(nonatomic,copy)NSString* titleString;
@property (nonatomic,strong) HouseholdItem *choiceHouseholdItem;
@property(nonatomic,assign)BOOL isCA;

@property(nonatomic,copy)NSString *personalUUID;


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
@end
