//
//  ChoiceDocTeamViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoiceDocTeamViewController.h"
#import "SAMemberInfoViewController.h"
#import "SignImportViewController.h"
#import "SATemaTableViewCell.h"
#import "TeamItem.h"
@interface ChoiceDocTeamViewController ()

@end

@implementation ChoiceDocTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择家庭医生团队"];
    [self addLeftButtonItem];
    mainDataArray=[NSMutableArray new];
    [self creatUI];
    [self sendRequest:@"CommunityHomeDoctorTeam" andPath:queryURL andSqlParameter:[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"] and:self];
}

- (void)creatUI{
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(0,64, SCREENWIDTH,50) andColor:MAINWHITECOLOR];
    [self.view addSubview:titleBGView];
    
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,5, SCREENWIDTH-20,40) andColor:BGGRAYCOLOR];
    [searchBGView.layer setCornerRadius:10];
    [titleBGView addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,14, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 30)];
    searchField.placeholder=@"输入社区名称关键字查询医生团队";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchField becomeFirstResponder];
    [searchBGView addSubview:searchField];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,114, SCREENWIDTH, SCREENHEIGHT-114) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        [searchField resignFirstResponder];
        NSArray *dataArray=message;
        if (dataArray.count>0) {
            [mainDataArray removeAllObjects];
            for (NSDictionary *dic in dataArray) {
                TeamItem *item=[RMMapper objectWithClass:[TeamItem class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
            [mainTableView reloadData];
        }else{
            [self showSimplePromptBox:self andMesage:@"暂无对应的医生团队信息！"];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SATemaTableViewCell";
    SATemaTableViewCell *cell = (SATemaTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[SATemaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    TeamItem *item=[mainDataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=item.LName;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamItem *item=[mainDataArray objectAtIndex:indexPath.row];
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([self.whoPush isEqualToString:@"SI"]) {
            if ([nvc isKindOfClass:[SignImportViewController class]]) {
                SignImportViewController *svc=(SignImportViewController*)nvc;
                svc.teamItem=item;
                [self.navigationController popToViewController:svc animated:YES];
            }
        }else{
            if ([nvc isKindOfClass:[SAMemberInfoViewController class]]) {
                SAMemberInfoViewController *svc=(SAMemberInfoViewController*)nvc;
                svc.teamItem=item;
                [self.navigationController popToViewController:svc animated:YES];
            }
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        [self sendRequest:@"SearchSATeam" andPath:queryURL andSqlParameter:searchField.text and:self];
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
