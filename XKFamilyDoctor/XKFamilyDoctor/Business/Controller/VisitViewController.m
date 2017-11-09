//
//  VisitViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VisitViewController.h"
#import "AddOrderUserViewController.h"
#import "VisitTableViewCell.h"
#import "VisitItem.h"
@interface VisitViewController ()

@end

@implementation VisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"复诊查询"];
    [self addLeftButtonItem];
    mainDataArray=[NSMutableArray new];
    [self creatUI];
}

- (void)creatUI{
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,80, SCREENWIDTH-20,30) andColor:MAINWHITECOLOR];
    [searchBGView.layer setCornerRadius:15];
    [self.view addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-60, 20)];
    searchField.placeholder=@"输入姓名或身份证号码进行搜索";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchBGView addSubview:searchField];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,120, SCREENWIDTH, SCREENHEIGHT-120) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if (dataArray.count>0) {
        for (NSDictionary *dic in message) {
            VisitItem *item=[RMMapper objectWithClass:[VisitItem class] fromDictionary:dic];
            [mainDataArray addObject:item];
        }
            [searchField resignFirstResponder];
        [mainTableView reloadData];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchAreaTableViewCell";
    VisitTableViewCell *cell = (VisitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[VisitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    VisitItem *item=[mainDataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=item.member_truename;
    cell.IDCardLabel.text=[NSString stringWithFormat:@"身份证号:%@",item.sIDCard];
    NSString *sex=@"男";
    if ([item.member_sex intValue]==2) {
        sex=@"女";
    }
    NSString *nation=@"未添加民族信息";
    if ([self changeNullString:item.sFolk].length>0) {
        nation=item.sFolk;
    }
    cell.sexAndNationLabel.text=[NSString stringWithFormat:@"性别:%@   民族:%@",sex,nation];
    cell.birLabel.text=[NSString stringWithFormat:@"出生日期:%@",[self getSubTime:item.member_birthday andFormat:@"yyyy-MM-dd"]];
    cell.addressLabel.text=[NSString stringWithFormat:@"地址:%@",item.sAddress];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VisitItem *item=[mainDataArray objectAtIndex:indexPath.row];
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[AddOrderUserViewController class]]) {
            AddOrderUserViewController *avc=(AddOrderUserViewController*)nvc;
            avc.visitItem=item;
            [self.navigationController popToViewController:avc animated:YES];
            break;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        [self sendRequest:@"SearchPatientInfo" andPath:queryURL andSqlParameter:textField.text and:self];
    }
    return YES;
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
