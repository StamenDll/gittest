//
//  AddArchivesViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/3/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddArchivesViewController.h"
#import "ArchiveInputViewController.h"
#import "CustomProgressView.h"
#import "ArchiveClass.h"
@interface AddArchivesViewController ()

@end

@implementation AddArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"建档"];
    [self addLeftButtonItem];
    areaArray=[NSMutableArray new];
    streetArray=[NSMutableArray new];
    NCArray=[NSMutableArray new];
    villageArray=[NSMutableArray new];
    floorArray=[NSMutableArray new];
    householdArray=[NSMutableArray new];
    [self creatUI];
}

- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    [cProgressView creatUI:@[@"住户信息",@"完成建档"] andCount:0];
    [self.view addSubview:cProgressView];
    
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,144, SCREENWIDTH, SCREENHEIGHT-144)];
    [self.view addSubview:BGScrollView];
    
    choiceAreaButton=[self addButton:CGRectMake(15,10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceArea)];
    [BGScrollView addSubview:choiceAreaButton];
    
    UILabel *areaLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择所属区域" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceAreaButton addSubview:areaLabel];
    
    choiceStreetButton=[self addButton:CGRectMake(15,choiceAreaButton.frame.origin.y+choiceAreaButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceStreet)];
    [BGScrollView addSubview:choiceStreetButton];
    
    UILabel *streetLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择所属街道办事处" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceStreetButton addSubview:streetLabel];
    
    choiceNCButton=[self addButton:CGRectMake(15,choiceStreetButton.frame.origin.y+choiceStreetButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceNC)];
    [BGScrollView addSubview:choiceNCButton];
    
    UILabel *NCLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择所属居委会" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceNCButton addSubview:NCLabel];
    
    choiceVillageButton=[self addButton:CGRectMake(15,choiceNCButton.frame.origin.y+choiceNCButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceVillage)];
    [BGScrollView addSubview:choiceVillageButton];
    
    UILabel *villageLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择所属小区" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceVillageButton addSubview:villageLabel];
    
    choiceFloorButton=[self addButton:CGRectMake(15,choiceVillageButton.frame.origin.y+choiceVillageButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceFloor)];
    [BGScrollView addSubview:choiceFloorButton];
    
    UILabel *floorLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择小区楼栋" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceFloorButton addSubview:floorLabel];
    
    choiceHouseholdButton=[self addButton:CGRectMake(15,choiceFloorButton.frame.origin.y+choiceFloorButton.frame.size.height+10, SCREENWIDTH-30, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceHousehold)];
    [BGScrollView addSubview:choiceHouseholdButton];
    
    UILabel *householdLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:@"请选择住户" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [choiceHouseholdButton addSubview:householdLabel];
    
    nextButton=[self addCurrencyButton:CGRectMake(40, choiceHouseholdButton.frame.origin.y+choiceHouseholdButton.frame.size.height+40, SCREENWIDTH-80, 40) andText:@"下一步" andSEL:@selector(sureNext)];
    [BGScrollView addSubview:nextButton];
    
    
}

- (void)sureNext{
    if (!choiceAreaItem) {
        [self showSimplePromptBox:self andMesage:@"请选择所属区域！"];
    }else if (!choiceStreetItem){
        [self showSimplePromptBox:self andMesage:@"请选择街道办事处！"];
    }else if (!choiceNCItem) {
        [self showSimplePromptBox:self andMesage:@"请选择居委会！"];
    }else if (!choiceVillageItem) {
        [self showSimplePromptBox:self andMesage:@"请选择小区！"];
    }else if (!choiceFloorItem) {
        [self showSimplePromptBox:self andMesage:@"请选择楼栋！"];
    }else   if (!choiceHouseholdItem) {
        [self showSimplePromptBox:self andMesage:@"请选择住户！"];
    }else{
        NSMutableArray *hAreaArray=[[ArchiveClass new] getLocalArea];
        BOOL isHave=NO;
        for (NearAreaItem *hItem in hAreaArray) {
            if (hItem.AreaId==choiceVillageItem.AreaId) {
                isHave=YES;
            }
        }
        if (isHave==NO) {
            if (hAreaArray.count>2) {
                [hAreaArray removeObjectAtIndex:0];
            }
            [hAreaArray addObject:choiceVillageItem];
        }
        [[ArchiveClass new] saveAreaToLocal:hAreaArray];
        
        ArchiveInputViewController *avc=[ArchiveInputViewController new];
        avc.NCItem=choiceNCItem;
        avc.areaItem=choiceVillageItem;
        avc.choiceFloorItem=choiceFloorItem;
        avc.choiceHouseholdItem=choiceHouseholdItem;
        avc.isCA=YES;
        avc.whoPush=self.whoPush;
        avc.userItem=self.userItem;
        [self.navigationController pushViewController:avc animated:YES];
    }
}

- (void)choiceArea{
    if (choiceAreaButton.selected==NO) {
        if (areaArray.count==0) {
            choiceAreaButton.selected=YES;
            [self sendRequest:@"SearchRegion_area" andPath:queryURL andSqlParameter:@"530100" and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (RegionItem *item in areaArray) {
                [nameArray addObject:item.Name];
            }
            self.choiceWho=@"Area";
            [self addChoiceView:nameArray];
        }
    }
}

- (void)choiceStreet{
    if (!choiceAreaItem) {
        [self showSimplePromptBox:self andMesage:@"请先选择所属区域！"];
    }else if (choiceStreetButton.selected==NO) {
        if (streetArray.count==0) {
            choiceStreetButton.selected=YES;
            [self sendRequest:@"SearchRegion_street" andPath:queryURL andSqlParameter:choiceAreaItem.ID and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (RegionItem *item in streetArray) {
                [nameArray addObject:item.Name];
            }
            self.choiceWho=@"Street";
            [self addChoiceView:nameArray];
        }
    }
    
}

- (void)choiceNC{
    if (!choiceStreetItem){
        [self showSimplePromptBox:self andMesage:@"请先选择街道办事处！"];
    }else if (choiceNCButton.selected==NO) {
        if (NCArray.count==0) {
            choiceNCButton.selected=YES;
            [self sendRequest:@"SearchRegion_NC" andPath:queryURL andSqlParameter:choiceStreetItem.ID and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (RegionItem *item in NCArray) {
                [nameArray addObject:item.Name];
            }
            self.choiceWho=@"NC";
            [self addChoiceView:nameArray];
        }
    }
}

- (void)choiceVillage{
    if (!choiceNCItem) {
        [self showSimplePromptBox:self andMesage:@"请先选择居委会！"];
    }else if (choiceVillageButton.selected==NO) {
        if (villageArray.count==0) {
            choiceVillageButton.selected=YES;
            [self sendRequest:@"SearchVillage" andPath:queryURL andSqlParameter:choiceNCItem.ID and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (NearAreaItem *item in villageArray) {
                [nameArray addObject:item.sName];
            }
            self.choiceWho=@"Village";
            [self addChoiceView:nameArray];
        }
    }
}

- (void)choiceFloor{
    if (!choiceVillageItem) {
        [self showSimplePromptBox:self andMesage:@"请先选择小区！"];
    }else if (choiceFloorButton.selected==NO) {
        if (floorArray.count==0) {
            choiceFloorButton.selected=YES;
            [self sendRequest:@"SearchFloor" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%d",choiceVillageItem.OrgID],[NSString stringWithFormat:@"%d",choiceVillageItem.AreaId]] and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (FloorItem *item in floorArray) {
                [nameArray addObject:item.sUnitName];
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
        if (householdArray.count==0) {
            choiceHouseholdButton.selected=YES;
            [self sendRequest:@"SearchHousehold" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%d",choiceVillageItem.OrgID],[NSString stringWithFormat:@"%d",choiceVillageItem.AreaId],[NSString stringWithFormat:@"%d",choiceFloorItem.UnitID]] and:self];
        }else{
            NSMutableArray *nameArray=[NSMutableArray new];
            for (HouseholdItem *item in householdArray) {
                [nameArray addObject:item.sCellName];
            }
            self.choiceWho=@"Household";
            [self addChoiceView:nameArray];
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if ([type isEqualToString:@"SearchRegion_area"]) {
            NSMutableArray *nameArray=[NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                RegionItem *item=[RMMapper objectWithClass:[RegionItem class] fromDictionary:dic];
                [areaArray addObject:item];
                [nameArray addObject:item.Name];
            }
            self.choiceWho=@"Area";
            [self addChoiceView:nameArray];
        }else if ([type isEqualToString:@"SearchRegion_street"]) {
            if (dataArray.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in dataArray) {
                    RegionItem *item=[RMMapper objectWithClass:[RegionItem class] fromDictionary:dic];
                    [streetArray addObject:item];
                    [nameArray addObject:item.Name];
                }
                self.choiceWho=@"Street";
                [self addChoiceView:nameArray];
            }else{
                [self showSimplePromptBox:self andMesage:@"该区域暂无对应的街道办事处信息！"];
            }
        }else if ([type isEqualToString:@"SearchRegion_NC"]) {
            if (dataArray.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in dataArray) {
                    RegionItem *item=[RMMapper objectWithClass:[RegionItem class] fromDictionary:dic];
                    [NCArray addObject:item];
                    [nameArray addObject:item.Name];
                }
                self.choiceWho=@"NC";
                [self addChoiceView:nameArray];
            }else{
                [self showSimplePromptBox:self andMesage:@"该区域暂无对应的居委会信息！"];
            }
        }else if ([type isEqualToString:@"SearchVillage"]) {
            if (dataArray.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in dataArray) {
                    NearAreaItem *item=[RMMapper objectWithClass:[NearAreaItem class] fromDictionary:dic];
                    [villageArray addObject:item];
                    [nameArray addObject:item.sName];
                }
                self.choiceWho=@"Village";
                [self addChoiceView:nameArray];
            }else{
                [self showSimplePromptBox:self andMesage:@"暂无该居委会对应的小区信息！"];
            }
        }else if ([type isEqualToString:@"SearchFloor"]) {
            if (dataArray.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in dataArray) {
                    FloorItem *item=[RMMapper objectWithClass:[FloorItem class] fromDictionary:dic];
                    [floorArray addObject:item];
                    [nameArray addObject:item.sUnitName];
                }
                self.choiceWho=@"Floor";
                [self addChoiceView:nameArray];
            }else{
                [self showSimplePromptBox:self andMesage:@"暂无该小区对应的楼栋信息！"];
            }
        }else if ([type isEqualToString:@"SearchHousehold"]) {
            if (dataArray.count>0) {
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in dataArray) {
                    HouseholdItem *item=[RMMapper objectWithClass:[HouseholdItem class] fromDictionary:dic];
                    [householdArray addObject:item];
                    [nameArray addObject:item.sCellName];
                }
                self.choiceWho=@"Household";
                [self addChoiceView:nameArray];
            }else{
                [self showSimplePromptBox:self andMesage:@"暂无该楼栋对应的住户信息！"];
            }
        }else if([type isEqualToString:@"GenerateFileNO"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                ArchiveInputViewController *avc=[ArchiveInputViewController new];
                avc.FileNo=[dic objectForKey:@"FileNo"];
                avc.areaItem=choiceVillageItem;
                avc.choiceFloorItem=choiceFloorItem;
                avc.NCItem=choiceNCItem;
                avc.whoPush=self.whoPush;
                avc.userItem=self.userItem;
                [self.navigationController pushViewController:avc animated:YES];
            }else{
                [self showSimplePromptBox:self andMesage:@"生成档案号失败，请重试！"];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
    [self changeBtnState:type];
}

- (void)requestFail:(NSString *)type{
    [self changeBtnState:type];
    
}

- (void)changeBtnState:(NSString *)type{
    if ([type isEqualToString:@"SearchRegion_area"]) {
        choiceAreaButton.selected=NO;
    }else if ([type isEqualToString:@"SearchRegion_street"]){
        choiceStreetButton.selected=NO;
    }else if ([type isEqualToString:@"SearchRegion_NC"]){
        choiceNCButton.selected=NO;
    }else if ([type isEqualToString:@"SearchVillage"]){
        choiceVillageButton.selected=NO;
    }else if ([type isEqualToString:@"SearchFloor"]){
        choiceFloorButton.selected=NO;
    }else if ([type isEqualToString:@"SearchHousehold"]){
        choiceHouseholdButton.selected=NO;
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
    if ([self.choiceWho isEqualToString:@"Area"]) {
        UILabel *label=[choiceAreaButton subviews].lastObject;
        label.text=menuString;
        for (RegionItem *item in areaArray) {
            if ([item.Name isEqualToString:menuString]) {
                choiceAreaItem=item;
            }
        }
        [streetArray removeAllObjects];
        [NCArray removeAllObjects];
        [villageArray removeAllObjects];
        [floorArray removeAllObjects];
        [householdArray removeAllObjects];
        choiceNCItem=nil;
        choiceStreetItem=nil;
        choiceVillageItem=nil;
        choiceFloorItem=nil;
        choiceHouseholdItem=nil;
    }else if ([self.choiceWho isEqualToString:@"Street"]){
        UILabel *label=[choiceStreetButton subviews].lastObject;
        label.text=menuString;
        for (RegionItem *item in streetArray) {
            if ([item.Name isEqualToString:menuString]) {
                choiceStreetItem=item;
            }
        }
        [NCArray removeAllObjects];
        [floorArray removeAllObjects];
        [householdArray removeAllObjects];
        [villageArray removeAllObjects];
        choiceVillageItem=nil;
        choiceFloorItem=nil;
        choiceHouseholdItem=nil;
        choiceNCItem=nil;
    }else if ([self.choiceWho isEqualToString:@"NC"]){
        UILabel *label=[choiceNCButton subviews].lastObject;
        label.text=menuString;
        for (RegionItem *item in NCArray) {
            if ([item.Name isEqualToString:menuString]) {
                choiceNCItem=item;
            }
        }
        [floorArray removeAllObjects];
        [householdArray removeAllObjects];
        [villageArray removeAllObjects];
        choiceVillageItem=nil;
        choiceFloorItem=nil;
        choiceHouseholdItem=nil;
    }else if ([self.choiceWho isEqualToString:@"Village"]){
        UILabel *label=[choiceVillageButton subviews].lastObject;
        label.text=menuString;
        for (NearAreaItem *item in villageArray) {
            if ([item.sName isEqualToString:menuString]) {
                choiceVillageItem=item;
            }
        }
        [floorArray removeAllObjects];
        [householdArray removeAllObjects];
        choiceFloorItem=nil;
        choiceHouseholdItem=nil;
    }else if ([self.choiceWho isEqualToString:@"Floor"]){
        UILabel *label=[choiceFloorButton subviews].lastObject;
        label.text=menuString;
        for (FloorItem *item in floorArray) {
            if ([item.sUnitName isEqualToString:menuString]) {
                choiceFloorItem=item;
            }
        }
        [householdArray removeAllObjects];
        choiceHouseholdItem=nil;
    }else if ([self.choiceWho isEqualToString:@"Household"]){
        UILabel *label=[choiceHouseholdButton subviews].lastObject;
        label.text=menuString;
        for (HouseholdItem *item in householdArray) {
            if ([item.sCellName isEqualToString:menuString]) {
                choiceHouseholdItem=item;
            }
        }
    }
}

- (void)cancelChoiceMenu{
    [menuChoiceView removeFromSuperview];
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
