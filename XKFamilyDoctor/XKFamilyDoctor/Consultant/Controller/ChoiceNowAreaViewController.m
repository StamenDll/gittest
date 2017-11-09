//
//  ChoiceNowAreaViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoiceNowAreaViewController.h"
#import "AddArchivesViewController.h"
#import "ArchiveInputViewController.h"
#import "NewFileViewController.h"
#import "ChoiceHouseholdViewController.h"
#import "NearAreaItem.h"
#import "VillageItem.h"
#import "CustomProgressView.h"
@interface ChoiceNowAreaViewController ()

@end

@implementation ChoiceNowAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"住户信息"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    areaArray=[NSMutableArray new];
    floorArray=[NSMutableArray new];
    householdArray=[NSMutableArray new];
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.choiceHouseholdItem) {
        UILabel *label=[choiceHouseholdButton subviews].lastObject;
        label.text=self.choiceHouseholdItem.sCellName;
    }
}


- (void)addRightButtonItem{
    UIButton *rButton=[self addSimpleButton:CGRectMake(0, 0, 80, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(goChoiceBySelf) andText:@"选择其他" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:2];
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)goChoiceBySelf{
    AddArchivesViewController *ovc=[AddArchivesViewController new];
    ovc.peopleOnlyID=self.peopleOnlyID;
    [self.myTabBarController hidesTabBar];
    ovc.whoPush=self.whoPush;
    ovc.userItem=self.userItem;
    [self.navigationController pushViewController:ovc animated:YES];
}

- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    [cProgressView creatUI:@[@"选择小区",@"住户信息",@"完成建档"] andCount:1];
    [self.view addSubview:cProgressView];
    
    addressDetailbLabel=[self addLabel:CGRectMake(15,160, SCREENWIDTH-30,0) andText:self.choiceVillageItem.sDistrictAddress andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    addressDetailbLabel.numberOfLines=0;
    [addressDetailbLabel sizeToFit];
    addressDetailbLabel.frame=CGRectMake(15,144+(130-64-addressDetailbLabel.frame.size.height)/2, SCREENWIDTH-30, addressDetailbLabel.frame.size.height);
    [self.view addSubview:addressDetailbLabel];
    
    choiceVillageButton=[self addButton:CGRectMake(15,210, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:nil];
    [self.view addSubview:choiceVillageButton];
    
    NSString *villageString=self.choiceVillageItem.sName;
    if ([self.choiceVillageItem.place isEqualToString:@"已设定"]) {
        villageString=[NSString stringWithFormat:@"%@(位置已上传)",villageString];
    }
    UILabel *villageLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:villageString andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceVillageButton addSubview:villageLabel];
    
    choiceFloorButton=[self addButton:CGRectMake(15,choiceVillageButton.frame.origin.y+choiceVillageButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceFloor)];
    [self.view addSubview:choiceFloorButton];
    
    UILabel *floorLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择小区楼栋" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceFloorButton addSubview:floorLabel];
    
    choiceHouseholdButton=[self addButton:CGRectMake(15,choiceFloorButton.frame.origin.y+choiceFloorButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceHousehold)];
    [self.view addSubview:choiceHouseholdButton];
    
    UILabel *householdLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择住户" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceHouseholdButton addSubview:householdLabel];
    
    nextButton=[self addCurrencyButton:CGRectMake(40, choiceHouseholdButton.frame.origin.y+choiceHouseholdButton.frame.size.height+40, SCREENWIDTH-80, 40) andText:@"下一步" andSEL:@selector(sureNext)];
    [self.view addSubview:nextButton];
    
}

- (void)sureNext{
    if (!self.choiceVillageItem) {
        [self showSimplePromptBox:self andMesage:@"请选择小区！"];
    }else if (!choiceFloorItem) {
        [self showSimplePromptBox:self andMesage:@"请选择楼栋！"];
    }else if (!self.choiceHouseholdItem){
        [self showSimplePromptBox:self andMesage:@"请选择住户！"];
    }else if (nextButton.selected==NO) {
        nextButton.selected=YES;
        [self sendRequest:@"NearAreaNC" andPath:queryURL andSqlParameter:self.choiceVillageItem.sDistrictId and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"SearchNearArea"]) {
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    NearAreaItem *item=[RMMapper objectWithClass:[NearAreaItem class] fromDictionary:dic];
                    [areaArray addObject:item];
                }
                NearAreaItem *item=[areaArray objectAtIndex:0];
                UILabel *villageLabel=[[choiceVillageButton subviews] lastObject];
                villageLabel.text=item.sName;
                self.choiceVillageItem=item;
                addressDetailbLabel.text=item.sDistrictAddress;
                addressDetailbLabel.numberOfLines=0;
                [addressDetailbLabel sizeToFit];
                addressDetailbLabel.frame=CGRectMake(15, 64+(130-64-addressDetailbLabel.frame.size.height)/2, SCREENWIDTH-30, addressDetailbLabel.frame.size.height);
            }
        }else if ([type isEqualToString:@"SearchFloor"]) {
            if (data.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in data) {
                    FloorItem *item=[RMMapper objectWithClass:[FloorItem class] fromDictionary:dic];
                    [floorArray addObject:item];
                    [nameArray addObject:[NSString stringWithFormat:@"%@%@",item.sUnitName,item.sUnit]];
                }
                self.choiceWho=@"Floor";
                [self addChoiceView:nameArray];
            }
        }else if ([type isEqualToString:@"SearchHousehold"]) {
            if (data.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in data) {
                    HouseholdItem *item=[RMMapper objectWithClass:[HouseholdItem class] fromDictionary:dic];
                    [householdArray addObject:item];
                    [nameArray addObject:item.sCellName];
                }
                self.choiceWho=@"Household";
                [self addChoiceView:nameArray];
            }
        }else if ([type isEqualToString:@"NearAreaNC"]){
            if (data.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                RegionItem *item=[RMMapper objectWithClass:[RegionItem class] fromDictionary:dic];
//                ArchiveInputViewController *avc=[ArchiveInputViewController new];
//                avc.areaItem=self.choiceVillageItem;
//                avc.choiceFloorItem=choiceFloorItem;
//                avc.NCItem=item;
//                avc.whoPush=self.whoPush;
//                avc.userItem=self.userItem;
//                avc.choiceHouseholdItem=self.choiceHouseholdItem;
//                [self.navigationController pushViewController:avc animated:YES];


                NewFileViewController *nvc=[NewFileViewController new];
                nvc.userItem=self.userItem;
                nvc.NCItem=item;
                nvc.choiceHouseholdItem=self.choiceHouseholdItem;
                [self.navigationController pushViewController:nvc animated:YES];

                
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
    if ([type isEqualToString:@"SearchFloor"]) {
        choiceFloorButton.selected=NO;
    }else if ([type isEqualToString:@"SearchHousehold"]){
        choiceHouseholdButton.selected=NO;
    }else if ([type isEqualToString:@"NearAreaNC"]){
        nextButton.selected=NO;
    }
}



- (void)requestFail:(NSString *)type{
    if ([type isEqualToString:@"SearchFloor"]) {
        choiceFloorButton.selected=NO;
    }else if ([type isEqualToString:@"SearchHousehold"]){
        choiceHouseholdButton.selected=NO;
    }else if ([type isEqualToString:@"NearAreaNC"]){
        nextButton.selected=NO;
    }
}

- (void)choiceFloor{
    if (!self.choiceVillageItem) {
        [self showSimplePromptBox:self andMesage:@"请先选择小区！"];
    }else if (choiceFloorButton.selected==NO) {
        if (floorArray.count==0) {
            choiceFloorButton.selected=YES;
            [self sendRequest:@"SearchFloor" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%d",self.choiceVillageItem.OrgID],[NSString stringWithFormat:@"%d",self.choiceVillageItem.AreaId]] and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (FloorItem *item in floorArray) {
                [nameArray addObject:[NSString stringWithFormat:@"%@%@",item.sUnitName,item.sUnit]];
            }
            self.choiceWho=@"Floor";
            [self addChoiceView:nameArray];
        }
    }
}

- (void)choiceHousehold{
    if (!choiceFloorItem) {
        [self showSimplePromptBox:self andMesage:@"请先选择楼栋！"];
    }else if (choiceHouseholdButton.selected==NO) {
//        if (householdArray.count==0) {
//            choiceHouseholdButton.selected=YES;
//            [self sendRequest:@"SearchHousehold" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%d",self.choiceVillageItem.OrgID],[NSString stringWithFormat:@"%d",self.choiceVillageItem.AreaId],[NSString stringWithFormat:@"%d",choiceFloorItem.UnitID]] and:self];
//        }else{
//            NSMutableArray *nameArray=[NSMutableArray new];
//            for (HouseholdItem *item in householdArray) {
//                [nameArray addObject:item.sCellName];
//            }
//            self.choiceWho=@"Household";
//            [self addChoiceView:nameArray];
//        }
        
        ChoiceHouseholdViewController *cvc=[ChoiceHouseholdViewController new];
        cvc.orgid=[NSString stringWithFormat:@"%d",self.choiceVillageItem.OrgID];
        cvc.AreaID=[NSString stringWithFormat:@"%d",self.choiceVillageItem.AreaId];
        cvc.UnitID=[NSString stringWithFormat:@"%d",choiceFloorItem.UnitID];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

- (void)addChoiceView:(NSMutableArray*)array{
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200, SCREENWIDTH, 200)];
    [menuChoiceView initMenuChoiceView:array andFirst:[array objectAtIndex:0]];
    menuChoiceView.delegate=self;
    [self.view addSubview:menuChoiceView];
}

- (void)sureChoiceMenu:(NSString *)menuString{
    if ([self.choiceWho isEqualToString:@"Floor"]){
        UILabel *label=[choiceFloorButton subviews].lastObject;
        label.text=menuString;
        for (FloorItem *item in floorArray) {
            if ([[NSString stringWithFormat:@"%@%@",item.sUnitName,item.sUnit] isEqualToString:menuString]) {
                choiceFloorItem=item;
                [householdArray removeAllObjects];
                self.choiceHouseholdItem=nil;
            }
        }
    }else if ([self.choiceWho isEqualToString:@"Household"]){
        UILabel *label=[choiceHouseholdButton subviews].lastObject;
        label.text=menuString;
        for (HouseholdItem *item in householdArray) {
            if ([item.sCellName isEqualToString:menuString]) {
                self.choiceHouseholdItem=item;
            }
        }
    }
}

- (void)cancelChoiceMenu{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
