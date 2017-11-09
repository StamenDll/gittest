//
//  ChoicePostViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoicePostViewController.h"
#import "ChoicePostTableViewCell.h"
#import "ChangeJobViewController.h"
#import "EntryRegViewController.h"
#import "CommenModel.h"
#import "OrgItem.h"
@interface ChoicePostViewController ()

@end

@implementation ChoicePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self creatUI];
    dataArray=[NSMutableArray new];
    searchDataArray=[NSMutableArray new];
    mainDataArray=[NSMutableArray new];
    
    if ([self.titleString isEqualToString:@"选择事业部"]) {
        [self sendRequest:BDLISTTYPE andPath:BDLISTURL andSqlParameter:@{} and:self];
    }else if ([self.titleString isEqualToString:@"选择机构"]){
        [self sendRequest:MECLISTTYPE andPath:MECLISTURL andSqlParameter:@{} and:self];
    }else if ([self.titleString isEqualToString:@"选择岗位"]){
        [self sendRequest:POSTLISTTYPE andPath:POSTLISTURL andSqlParameter:@{} and:self];
    }else{
        [self sendRequest:DEPLISTTYPE andPath:DEPLISTURL andSqlParameter:@{} and:self];
    }
}

- (void)creatUI{
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,75, SCREENWIDTH-20,30) andColor:MAINWHITECOLOR];
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
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,115, SCREENWIDTH, SCREENHEIGHT-115) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if([type isEqualToString:BDLISTTYPE]){
            for (NSDictionary *dic in message) {
                CommenModel *item=[RMMapper objectWithClass:[CommenModel class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
        }else if([type isEqualToString:MECLISTTYPE]){
            for (NSDictionary *dic in message) {
                OrgItem *item=[RMMapper objectWithClass:[OrgItem class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
        }else if([type isEqualToString:DEPLISTTYPE]){
            for (NSDictionary *dic in message) {
                CommenModel *item=[RMMapper objectWithClass:[CommenModel class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
        }else if([type isEqualToString:POSTLISTTYPE]){
            for (NSDictionary *dic in message) {
                CommenModel *item=[RMMapper objectWithClass:[CommenModel class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
        }
        dataArray=mainDataArray;
        [mainTableView reloadData];
    }
    else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        [searchDataArray removeAllObjects];
        if (![self.titleString isEqualToString:@"选择机构"]) {
            for (CommenModel *item in mainDataArray) {
                if ([item.text rangeOfString:textField.text].location!=NSNotFound) {
                    [searchDataArray addObject:item];
                }
            }
        }else{
            for (OrgItem *item in mainDataArray) {
                if ([item.orgname rangeOfString:textField.text].location!=NSNotFound) {
                    [searchDataArray addObject:item];
                }
            }
        }
        if (searchDataArray.count==0) {
            [self showSimplePromptBox:self andMesage:@"没有对应信息！"];
        }else{
            isSearch=YES;
            dataArray=searchDataArray;
            [mainTableView reloadData];
            [textField resignFirstResponder];
        }
    }else if ([string isEqualToString:@"\n"]&&textField.text.length==0){
        isSearch=NO;
        dataArray=mainDataArray;
        [mainTableView reloadData];
        [textField resignFirstResponder];
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ChoicePostTableViewCell";
    ChoicePostTableViewCell *cell = (ChoicePostTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ChoicePostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (![self.titleString isEqualToString:@"选择机构"]) {
        CommenModel *item=[dataArray objectAtIndex:indexPath.row];
        if (isSearch==YES) {
            cell.nameLabel.attributedText=[self setString:item.text andSubString:searchField.text andDifColor:GREENCOLOR];
        }else{
            cell.nameLabel.text=item.text;
        }
    }else{
        OrgItem *item=[dataArray objectAtIndex:indexPath.row];
        if (isSearch==YES) {
            cell.nameLabel.attributedText=[self setString:item.orgname andSubString:searchField.text andDifColor:GREENCOLOR];
        }else{
            cell.nameLabel.text=item.orgname;
        }
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.whoPush isEqualToString:@"C"]) {
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[ChangeJobViewController class]]) {
                ChangeJobViewController *cvc=(ChangeJobViewController*)nvc;
                if ([self.titleString isEqualToString:@"选择事业部"]) {
                    cvc.bdItem=[dataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择机构"]){
                    cvc.orgItem=[dataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择岗位"]){
                    cvc.postItem=[dataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择科室"]){
                    cvc.depItem=[dataArray objectAtIndex:indexPath.row];
                }
                [self.navigationController popToViewController:cvc animated:YES];
            }
        }
    }else{
        NSLog(@"=======================%@",self.titleString);
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[EntryRegViewController class]]) {
                EntryRegViewController *cvc=(EntryRegViewController*)nvc;
                if ([self.titleString isEqualToString:@"选择事业部"]) {
                    cvc.bdItem=[dataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择机构"]){
                    cvc.orgItem=[dataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择岗位"]){
                    cvc.postItem=[dataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择科室"]){
                    cvc.depItem=[dataArray objectAtIndex:indexPath.row];
                }
                [self.navigationController popToViewController:cvc animated:YES];
            }
        }
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
