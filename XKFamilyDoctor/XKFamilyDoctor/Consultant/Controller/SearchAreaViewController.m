//
//  SearchAreaViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SearchAreaViewController.h"
#import "ChoiceNowAreaViewController.h"
#import "AddArchivesViewController.h"
#import "SearchAreaTableViewCell.h"
#import "ArchiveClass.h"
#import "CustomProgressView.h"
@interface SearchAreaViewController ()

@end

@implementation SearchAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择小区"];
    [self addLeftButtonItem];
    areaArray=[NSMutableArray new];
    searchAreaArray=[NSMutableArray new];
    locationService=[[BMKLocationService alloc]init];
    locationService.delegate=self;
    [locationService startUserLocationService];
    
    [self creatUI];
}
- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    [cProgressView creatUI:@[@"选择小区",@"住户信息",@"完成建档"] andCount:0];
    [self.view addSubview:cProgressView];
    
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,160, SCREENWIDTH-100,30) andColor:MAINWHITECOLOR];
    [searchBGView.layer setCornerRadius:15];
    [self.view addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 20)];
    searchField.placeholder=@"搜索";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchBGView addSubview:searchField];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-90,160,80, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceBySelf) andText:@"手动选择" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
    [self.view addSubview:cancelButton];
    
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,200, SCREENWIDTH, SCREENHEIGHT-200) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.hidden=YES;
    [self.view addSubview:mainTableView];
    
    nearBGView=[self addSimpleBackView:CGRectMake(0, 200, SCREENWIDTH, SCREENHEIGHT-120) andColor:MAINWHITECOLOR];
    [self.view addSubview:nearBGView];
    
    UILabel *nowLocationAreaLbael=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"当前定位小区:" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
    [nearBGView addSubview:nowLocationAreaLbael];
    
    nowAreaButton=[self addButton:CGRectMake(10, 40,SCREENWIDTH-20, 40) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(sureChoice:)];
    [nearBGView addSubview:nowAreaButton];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(0, 10, SCREENWIDTH-80, 20) andText:@"未定位到" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [nowAreaButton addSubview:nameLabel];
    
    UILabel *dicetanseLabel=[self addLabel:CGRectMake(SCREENWIDTH-70, 10,50, 20) andText:@"" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:2];
    [nowAreaButton addSubview:dicetanseLabel];
    
    [self addLineLabel:CGRectMake(0, 40,SCREENWIDTH-20, 0.5) andColor:LINECOLOR andBackView:nowAreaButton];
    
    hAreaBGView=[self addSimpleBackView:CGRectMake(0, 190, SCREENWIDTH, 0) andColor:CLEARCOLOR];
    [self.view addSubview:hAreaBGView];
    
    NSMutableArray *hAreaArray=[[ArchiveClass new]getLocalArea];
    if (hAreaArray.count>0) {
        UILabel *titleLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"最近选择的小区:" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
        [hAreaBGView addSubview:titleLabel];
        
        NSMutableArray *btnArray=[NSMutableArray new];
        for (int i=0; i<hAreaArray.count; i++) {
            NearAreaItem *item=[hAreaArray objectAtIndex:i];
            UIButton *hBtn=[self addButton:CGRectMake(10, 40, 0, 30) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(sureChoiceh:)];
            [hAreaBGView addSubview:hBtn];
            
            UILabel *hNameLable=[self addLabel:CGRectMake(0, 5,0,20) andText:item.sName andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
            [hNameLable sizeToFit];
            hNameLable.frame=CGRectMake(10, 5, hNameLable.frame.size.width, 20);
            hBtn.frame=CGRectMake(10, 40, hNameLable.frame.size.width+20, 30);
            hBtn.layer.borderWidth=0.5;
            hBtn.layer.borderColor=LINECOLOR.CGColor;
            [hBtn addSubview:hNameLable];
            
            if (btnArray.count>0) {
                UIButton *upButton=[btnArray objectAtIndex:i-1];
                
                hBtn.frame=CGRectMake(upButton.frame.origin.x+upButton.frame.size.width+10,40, hBtn.frame.size.width, 30);
                if (hBtn.frame.origin.x+hBtn.frame.size.width>SCREENWIDTH-10) {
                    hBtn.frame=CGRectMake(10,upButton.frame.origin.y+40, hBtn.frame.size.width, 30);
                }
            }
            [btnArray addObject:hBtn];
            hAreaBGView.frame=CGRectMake(0, 190, SCREENWIDTH,hBtn.frame.origin.y+hBtn.frame.size.height+10);
            
        }
        mainTableView.frame=CGRectMake(0, hAreaBGView.frame.origin.y+hAreaBGView.frame.size.height, SCREENWIDTH, SCREENHEIGHT-( hAreaBGView.frame.origin.y+hAreaBGView.frame.size.height));
        nearBGView.frame=CGRectMake(0, hAreaBGView.frame.origin.y+hAreaBGView.frame.size.height, SCREENWIDTH, SCREENHEIGHT-( hAreaBGView.frame.origin.y+hAreaBGView.frame.size.height));
    }
}

- (void)sureChoiceh:(UIButton*)button{
    
    NSMutableArray *hAreaArray=[[ArchiveClass new] getLocalArea];
    NearAreaItem *item=[hAreaArray objectAtIndex:button.tag-101];
    ChoiceNowAreaViewController *cvc=[ChoiceNowAreaViewController new];
    cvc.choiceVillageItem=item;
    cvc.whoPush=self.whoPush;
    cvc.userItem=self.userItem;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)choiceBySelf{
    AddArchivesViewController *avc=[AddArchivesViewController new];
    [self.navigationController pushViewController:avc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchAreaArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchAreaTableViewCell";
    SearchAreaTableViewCell *cell = (SearchAreaTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[SearchAreaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NearAreaItem *item=[searchAreaArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=[NSString stringWithFormat:@"%@%@",item.sDistrictAddress,item.sName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NearAreaItem *item=[searchAreaArray objectAtIndex:indexPath.row];
    NSMutableArray *hAreaArray=[[ArchiveClass new] getLocalArea];
    BOOL isHave=NO;
    for (NearAreaItem *hItem in hAreaArray) {
        if (hItem.AreaId==item.AreaId) {
            isHave=YES;
        }
    }
    if (isHave==NO) {
        if (hAreaArray.count>2) {
            [hAreaArray removeObjectAtIndex:0];
        }
        [hAreaArray addObject:item];
    }
    [[ArchiveClass new] saveAreaToLocal:hAreaArray];
    
    ChoiceNowAreaViewController *cvc=[ChoiceNowAreaViewController new];
    cvc.choiceVillageItem=item;
    cvc.whoPush=self.whoPush;
    cvc.userItem=self.userItem;
    [self.navigationController pushViewController:cvc animated:YES];
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (self.latitude==0) {
        self.longitude=userLocation.location.coordinate.longitude;
        self.latitude=userLocation.location.coordinate.latitude;
        [self sendRequest:@"SearchNearArea" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%f",self.latitude],[NSString stringWithFormat:@"%f",self.longitude],@"",[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"workorgkey"] intValue]]] and:self];
        [locationService stopUserLocationService];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        UIAlertController *av=[UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL success) {}];
            }else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }];
        [av addAction:sureAC];
        
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        [av addAction:cancelAC];
        [self presentViewController:av animated:YES completion:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        
        [self sendRequest:@"SearchNearArea_S" andPath:queryURL andSqlParameter:@[@"0",@"0",textField.text,[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"workorgkey"] intValue]]] and:self];
    }
    return YES;
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
                UILabel *nameLabel=[[nowAreaButton subviews] firstObject];
                nameLabel.text=[NSString stringWithFormat:@"%@%@",item.sDistrictAddress,item.sName];
                nameLabel.numberOfLines=0;
                [nameLabel sizeToFit];
                nameLabel.frame=CGRectMake(0,(40-nameLabel.frame.size.height)/2, SCREENWIDTH-110, nameLabel.frame.size.height);
                
                UILabel *distanceLabel=[[nowAreaButton subviews] objectAtIndex:1];
                distanceLabel.text=[NSString stringWithFormat:@"%.f米",item.Distance*1000];
                [self addNearAreaButton];
            }else{
//                [self showSimplePromptBox:self andMesage:@"您附近暂未定位到小区信息，您可以尝试手动选择！"];
            }
        }else if ([type isEqualToString:@"SearchNearArea_S"]){
            if (data.count>0) {
                [searchAreaArray removeAllObjects];
                for (NSDictionary *dic in data) {
                    NearAreaItem *item=[RMMapper objectWithClass:[NearAreaItem class] fromDictionary:dic];
                    [searchAreaArray addObject:item];
                }
                [searchField resignFirstResponder];
                nearBGView.hidden=YES;
                mainTableView.hidden=NO;
                [mainTableView reloadData];
            }else{
                [self showSimplePromptBox:self andMesage:@"没有对应的社区信息！"];
            }
        }
    }
}

- (void)addNearAreaButton{
    UILabel *nearLabel=[self addLabel:CGRectMake(10, 100, SCREENWIDTH-20, 20) andText:@"附近小区:" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
    [nearBGView addSubview:nearLabel];
    
    UIScrollView *nearButtonBGView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,130, SCREENWIDTH, nearBGView.frame.size.height-130)];
    [nearBGView addSubview:nearButtonBGView];
    
    for (int i=1; i<areaArray.count; i++) {
        NearAreaItem *item=[areaArray objectAtIndex:i];
        UIButton *nearAreaButton=[self addButton:CGRectMake(10,40*(i-1),SCREENWIDTH-20, 40) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(sureChoice:)];
        [nearButtonBGView addSubview:nearAreaButton];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(0, 10, SCREENWIDTH-80, 20) andText:[NSString stringWithFormat:@"%@%@",item.sDistrictAddress,item.sName] andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
        nameLabel.numberOfLines=0;
        [nameLabel sizeToFit];
        nameLabel.frame=CGRectMake(0,(40-nameLabel.frame.size.height)/2, SCREENWIDTH-110, nameLabel.frame.size.height);
        [nearAreaButton addSubview:nameLabel];
        
        UILabel *dicetanseLabel=[self addLabel:CGRectMake(SCREENWIDTH-70, 10,50, 20) andText:[NSString stringWithFormat:@"%.f米",item.Distance*1000] andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:2];
        [nearAreaButton addSubview:dicetanseLabel];
        
        [self addLineLabel:CGRectMake(0, 40,SCREENWIDTH-20, 0.5) andColor:LINECOLOR andBackView:nearAreaButton];
        nearButtonBGView.contentSize=CGSizeMake(0, nearAreaButton.frame.origin.y+nearAreaButton.frame.size.height);
    }
}


- (void)sureChoice:(UIButton*)button{
    UILabel *label=[[button subviews] firstObject];
    if (![label.text isEqualToString:@"未定位到"]) {
        NSMutableArray *hAreaArray=[[ArchiveClass new] getLocalArea];
        NearAreaItem *item=[areaArray objectAtIndex:button.tag-101];
        BOOL isHave=NO;
        for (NearAreaItem *hItem in hAreaArray) {
            if (hItem.AreaId==item.AreaId) {
                isHave=YES;
            }
        }
        if (isHave==NO) {
            if (hAreaArray.count>2) {
                [hAreaArray removeObjectAtIndex:0];
            }
            [hAreaArray addObject:item];
        }
        [[ArchiveClass new] saveAreaToLocal:hAreaArray];
        
        ChoiceNowAreaViewController *cvc=[ChoiceNowAreaViewController new];
        cvc.choiceVillageItem=item;
        cvc.whoPush=self.whoPush;
        cvc.userItem=self.userItem;
        [self.navigationController pushViewController:cvc animated:YES];
    }
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
