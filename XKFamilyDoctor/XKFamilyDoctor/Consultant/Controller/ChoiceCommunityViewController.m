//
//  ChoiceCommunityViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChoiceCommunityViewController.h"
#import "CommunityTableViewCell.h"
#import "CommunityItem.h"
#import "SearchCommunityViewController.h"
#import "DataDisplayViewController.h"
#import "AddUserViewController.h"
#import "ReceiveViewController.h"
@interface ChoiceCommunityViewController ()

@end

@implementation ChoiceCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择社区"];
    [self addLeftButtonItem];
    [self initializationArray];
    
    locationService=[[BMKLocationService alloc]init];
    locationService.delegate=self;
    [locationService startUserLocationService];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initializationArray{
    mainArray=[NSMutableArray new];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:@"NearbyCommunity"]) {
            NSArray *data=message;
            if (data.count>0) {
                [mainArray removeAllObjects];
                for (NSDictionary *dic in data) {
                    CommunityItem *item=[RMMapper objectWithClass:[CommunityItem class] fromDictionary:dic];
                    [mainArray addObject:item];
                }
                [mainTableView reloadData];
            }else{
                [self showSimplePromptBox:self andMesage:[NSString stringWithFormat:@"您附近%@千米范围内暂无社区，您可以扩大搜索范围进行搜索！",self.radiusString]];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    UIButton *searchButton=[self addButton:CGRectMake(15,75, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(searchCommunity)];
    [searchButton.layer setCornerRadius:15];
    [self.view addSubview:searchButton];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchButton addSubview:searchImageView];
    
    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:14 andColor:TEXTCOLORG andAlignment:0];
    [searchButton addSubview:npLabel];
    
    NSArray *distanceArray=@[@"1千米",@"2千米",@"3千米",@"5千米"];
    for (int i=0; i<distanceArray.count; i++) {
        UIButton *radiusButton=[self addSimpleButton:CGRectMake(15+((SCREENWIDTH-60)/4+10)*i, 115,(SCREENWIDTH-60)/4, 35) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(changeRadius:) andText:[distanceArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [self.view addSubview:radiusButton];
    }
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,160, SCREENWIDTH, SCREENHEIGHT-160) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
}


- (void)searchCommunity{
    SearchCommunityViewController *svc=[SearchCommunityViewController new];
    svc.whoPush=self.whoPush;
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)changeRadius:(UIButton*)button{
    NSString *radiusString=@"5";
    if (button.tag<104) {
        radiusString=[NSString stringWithFormat:@"%ld",button.tag-100];
    }
    self.radiusString=radiusString;
    [self sendRequest:@"NearbyCommunity" andPath:queryURL andSqlParameter:@[@"",[NSString stringWithFormat:@"%f",self.latitude],[NSString stringWithFormat:@"%f",self.longitude],radiusString] and:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CommunityTableViewCell";
    CommunityTableViewCell *cell = (CommunityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[CommunityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    CommunityItem *item=[mainArray objectAtIndex:indexPath.row];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:[UIImage imageNamed:@""]];
    cell.nameLabel.text=item.Name;
    cell.addressImageView.image=[UIImage imageNamed:@"location"];
    cell.addressLabel.text=item.LAddr;

    if ([item.Distance floatValue]<1) {
        NSLog(@"距离%@",[NSString stringWithFormat:@"%.f",[item.Distance floatValue]*1000]);
        cell.distanceLabel.text=[NSString stringWithFormat:@"%.f米",[item.Distance floatValue]*1000];
    }else{
        cell.distanceLabel.text=[NSString stringWithFormat:@"%.2f千米",[item.Distance floatValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityItem *item=[mainArray objectAtIndex:indexPath.row];
    NSLog(@"=============%@========%@========%ld",mainArray,item.Name,(long)indexPath.row);
    for (UIViewController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[DataDisplayViewController class]]&&[self.whoPush isEqualToString:@"Data"]) {
            DataDisplayViewController *dvc=(DataDisplayViewController*)nvc;
            dvc.communityItem=item;
            [self.navigationController popToViewController:dvc animated:YES];
        }else if ([nvc isKindOfClass:[ReceiveViewController class]]&&[self.whoPush isEqualToString:@"ReceiveR"]){
            ReceiveViewController *dvc=(ReceiveViewController*)nvc;
            dvc.communityItem=item;
            [self.navigationController popToViewController:dvc animated:YES];
        }else if([nvc isKindOfClass:[AddUserViewController class]]&&[self.whoPush isEqualToString:@"AddUser"]){
            AddUserViewController *dvc=(AddUserViewController*)nvc;
            dvc.communityItem=item;
            [self.navigationController popToViewController:dvc animated:YES];
        }
    }
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (self.latitude==0) {
        self.longitude=userLocation.location.coordinate.longitude;
        self.latitude=userLocation.location.coordinate.latitude;
        
        self.radiusString=@"1";
        [self sendRequest:@"NearbyCommunity" andPath:queryURL andSqlParameter:@[@"",[NSString stringWithFormat:@"%f",self.latitude],[NSString stringWithFormat:@"%f",self.longitude],@"1"] and:self];
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
