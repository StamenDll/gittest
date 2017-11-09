//
//  SearchCommunityViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SearchCommunityViewController.h"
#import "SearchTableViewCell.h"
#import "CommunityTableViewCell.h"
#import "RecentCTableViewCell.h"
#import "MemberInfoViewController.h"
#import "ResidentItem.h"
#import "CommunityItem.h"
#import "DataDisplayViewController.h"
#import "AddUserViewController.h"
#import "ReceiveViewController.h"
#import "DrugInfoTableViewCell.h"
#import "DrugInfoItem.h"
#import "BillingViewController.h"
@interface SearchCommunityViewController ()

@end

@implementation SearchCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[NSMutableArray new];
    self.view.backgroundColor=MAINWHITECOLOR;
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)creatUI{
    self.view.backgroundColor=MAINWHITECOLOR;
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 64) andColor:GREENCOLOR];
    [self.view addSubview:titleBGView];
    
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,27, SCREENWIDTH-70,30) andColor:MAINWHITECOLOR];
    [searchBGView.layer setCornerRadius:15];
    [titleBGView addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 20)];
    searchField.placeholder=@"搜索";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchField becomeFirstResponder];
    [searchBGView addSubview:searchField];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-50,28, 40, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(cancelSearch) andText:@"取消" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:cancelButton];
    
}

- (void)cancelSearch{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, mainWidth, mainHeight-64) style:UITableViewStylePlain];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:mainTableView];
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        if ([self.whoPush isEqualToString:@"Recent"]) {
            [self sendRequest:@"Resident" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"LTeamId"],searchField.text,@"1"] and:self];
        }else if([self.whoPush isEqualToString:@"DRUG"]){
            [self sendRequest:@"DrugInfo" andPath:queryURL andSqlParameter:@[searchField.text,@"1"] and:self];
        }else{
            [self sendRequest:@"NearbyCommunity" andPath:queryURL andSqlParameter:@[searchField.text,@"0",@"0",@"0"] and:self];
        }
    }
    return YES;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"NearbyCommunity"]) {
            for (int i=0; i<data.count; i++) {
                NSDictionary *dic=[data objectAtIndex:i];
                CommunityItem *item=[RMMapper objectWithClass:[CommunityItem class] fromDictionary:dic];
                [dataArray addObject:item];
            }
            [mainTableView reloadData];
        }else if ([type isEqualToString:@"Resident"]){
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    ResidentItem *Item=[RMMapper objectWithClass:[ResidentItem class] fromDictionary:dic];
                    [dataArray addObject:Item];
                }
                [mainTableView reloadData];
            }else{
                if (/* DISABLES CODE */ (1)) {
                    [mainTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self addNoDataView];
                    [mainTableView isHidden];
                }
            }
        }else if ([type isEqualToString:@"DrugInfo"]){
            if (data.count>0) {
                if (nowCount==1) {
                    [dataArray removeAllObjects];
                }
                for (NSDictionary *dic in data) {
                    DrugInfoItem *item=[RMMapper objectWithClass:[DrugInfoItem class] fromDictionary:dic];
                    [dataArray addObject:item];
                }
                mainTableView.hidden=NO;
                [mainTableView reloadData];
                [noDataView hiddenNoDataView];
            }else{
                if (nowCount==0) {
                    [self addNoDataView];
                    mainTableView.hidden=YES;
                }else{
                    [mainTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.whoPush isEqualToString:@"DRUG"]){
        return 125;
    }
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.whoPush isEqualToString:@"Data"]||[self.whoPush isEqualToString:@"ReceiveR"]||[self.whoPush isEqualToString:@"AddUser"]) {
        static NSString *identifier = @"CommunityTableViewCell";
        CommunityTableViewCell *cell = (CommunityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        if (!cell) {
            cell = [[CommunityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        CommunityItem *item=[dataArray objectAtIndex:indexPath.row];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text=item.Name;
        cell.addressImageView.image=[UIImage imageNamed:@"location"];
        cell.addressLabel.text=item.LAddr;
        return cell;
    }else if([self.whoPush isEqualToString:@"Recent"]){
        static NSString *identifier = @"RecentCTableViewCell";
        RecentCTableViewCell *cell = (RecentCTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        if (!cell) {
            cell = [[RecentCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        ResidentItem *item=[dataArray objectAtIndex:indexPath.row];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,@""]] placeholderImage:USERDEFAULTPIC];
        cell.nameLabel.text=item.LName;
        cell.infoLabel.text=item.LMobile;
        return cell;
    }else if ([self.whoPush isEqualToString:@"DRUG"]){
        static NSString *identifier = @"DrugInfoTableViewCell";
        DrugInfoTableViewCell *cell = (DrugInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        if (!cell) {
            cell = [[DrugInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        DrugInfoItem *item=[dataArray objectAtIndex:indexPath.row];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:[UIImage imageNamed:@"logosss"]];
        
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",item.LName];
        cell.companyLabel.text=[NSString stringWithFormat:@"厂家:%@",item.LFromAddr];
        cell.priceLabel.attributedText=[self setString:[NSString stringWithFormat:@"价格: %.2f元",item.LNewPrice] andSubString:@"价格:" andDifColor:TEXTCOLORG];
        cell.choiceButton.tag=101+indexPath.row;
        [cell.choiceButton addTarget:self action:@selector(sureChoiceDrug:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    UITableViewCell *cell=nil;
    return  cell;
}

- (void)sureChoiceDrug:(UIButton*)button{
    DrugInfoItem *item=[dataArray objectAtIndex:button.tag-101];
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[BillingViewController class]]) {
            BillingViewController *bvc=(BillingViewController *)nvc;
            bvc.choiceDrugItem=item;
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController popToViewController:bvc animated:YES];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [searchField resignFirstResponder];
    CommunityItem *item=[dataArray objectAtIndex:indexPath.row];
    if([self.whoPush isEqualToString:@"Recent"]){
        ResidentItem *item=[dataArray objectAtIndex:indexPath.row];
        MemberInfoViewController *mvc=[MemberInfoViewController new];
        mvc.titleString=item.LName;
        mvc.LOnlyCode=item.LOnlyCode;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    else{
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchField resignFirstResponder];
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
