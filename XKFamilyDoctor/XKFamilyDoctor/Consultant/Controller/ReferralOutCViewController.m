//
//  ReferralOutCViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ReferralOutCViewController.h"
#import "DataDisplayViewController.h"
#import "ReferralTableViewCell.h"
#import "ReferralOutItem.h"
@interface ReferralOutCViewController ()

@end

@implementation ReferralOutCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after l´oading the view.
    [self addTitleView:@"转诊纪录"];
    referralOutArray=[NSMutableArray new];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self creatUI];
    [self sendRequest:@"ReferalOut" andPath:queryURL andSqlParameter:[NSString stringWithFormat:@"Member_id='%@'",self.peopleMemberID] and:self];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isChange.length>0) {
        [referralOutArray removeAllObjects];
        [self sendRequest:@"ReferalOut" andPath:queryURL andSqlParameter:[NSString stringWithFormat:@"Member_id='%@'",self.peopleMemberID] and:self];
        self.isChange=nil;
    }
}

- (void)addRightButtonItem{
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0,40,44);
    [rButton setImage:[UIImage imageNamed:@"consultant_add"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(addNewReferral) forControlEvents:UIControlEventTouchUpInside];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(12,20,12,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}


- (void)addNewReferral{
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    dvc.tableName=@"CureSwitch";
    dvc.tableAliasName=@"cureSwitch";
    dvc.peopleOnlyID=self.peopleOnlyID;
    dvc.peopleMemberID=self.peopleMemberID;
    dvc.titleString=@"转诊";
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                ReferralOutItem *item=[RMMapper objectWithClass:[ReferralOutItem class] fromDictionary:dic];
                [referralOutArray addObject:item];
            }
            [referralOutTableView reloadData];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    referralOutTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    referralOutTableView.delegate=self;
    referralOutTableView.dataSource=self;
    referralOutTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:referralOutTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return referralOutArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ReferralTableViewCell";
    ReferralTableViewCell *cell = (ReferralTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ReferralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    ReferralOutItem *item=[referralOutArray objectAtIndex:indexPath.row];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,@""]] placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    cell.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",item.Name];
    cell.numberLabel.text=[NSString stringWithFormat:@"编号:%@",item.FileNo];
    cell.stateLabel.text=[NSString stringWithFormat:@"状态:%@",[self changeNullString:item.sta]];
    cell.timeLabel.text=[self getSubTime:item.Date andFormat:@"yyyy-MM-dd"];
    
    cell.detailButton.hidden=YES;
    cell.handleButton.hidden=YES;
    cell.returnButton.hidden=YES;
    cell.applyButton.hidden=YES;
    cell.lineLabel2.hidden=YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReferralOutItem *item=[referralOutArray objectAtIndex:indexPath.row];
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    dvc.tableName=@"CureSwitch";
    dvc.tableAliasName=@"cureSwitch";
    dvc.item=item;
    dvc.titleString=@"转诊";
    [self.navigationController pushViewController:dvc animated:YES];
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
