//
//  ChoicePlatetViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoicePlatetViewController.h"
#import "CommenModel.h"
#import "OrgItem.h"
#import "ChoicePlateTableViewCell.h"
#import "ChangeJobViewController.h"
#import "EntryRegViewController.h"
@interface ChoicePlatetViewController ()

@end

@implementation ChoicePlatetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    mainDataArray=[NSMutableArray new];
    nextDataArray=[NSMutableArray new];
    [self creatUI];
    if (self.parentID) {
        if ([self.titleString isEqualToString:@"选择事业部"]) {
            [self sendRequest:BDLISTTYPE andPath:BDLISTURL andSqlParameter:@{@"parentid":self.parentID} and:self];
        }else{
            [self sendRequest:MECLISTTYPE andPath:MECLISTURL andSqlParameter:@{@"orgkey":self.parentID} and:self];
        }
    }
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    if (self.dataArray.count>0) {
        mainDataArray=self.dataArray;
        [mainTableView reloadData];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if([type isEqualToString:BDLISTTYPE]){
            for (NSDictionary *dic in message) {
                CommenModel *item=[RMMapper objectWithClass:[CommenModel class] fromDictionary:dic];
                if (self.isNext.length==0) {
                    [mainDataArray addObject:item];
                }else{
                    [nextDataArray addObject:item];
                }
            }
        }else if([type isEqualToString:MECLISTTYPE]){
            for (NSDictionary *dic in message) {
                OrgItem *item=[RMMapper objectWithClass:[OrgItem class] fromDictionary:dic];
                if (self.isNext.length==0) {
                    [mainDataArray addObject:item];
                }else{
                    [nextDataArray addObject:item];
                }
            }
        }
        NSLog(@"=================%@",self.isNext);
        if (self.isNext.length==0) {
            [mainTableView reloadData];
        }else{
            
            self.isNext=nil;
            if (nextDataArray.count>0) {
                ChoicePlatetViewController *cvc=[ChoicePlatetViewController new];
                cvc.titleString=self.titleString;
                cvc.whoPush=self.whoPush;
                cvc.dataArray=nextDataArray;
                [self.navigationController pushViewController:cvc animated:YES];
            }else{
                [self showSimplePromptBox:self andMesage:@"当前选项已无下级目录"];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ChoicePlateTableViewCell";
    ChoicePlateTableViewCell *cell = (ChoicePlateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ChoicePlateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (![self.titleString isEqualToString:@"选择机构"]) {
        CommenModel *item=[mainDataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text=item.text;
    }else{
        OrgItem *item=[mainDataArray objectAtIndex:indexPath.row];
        NSLog(@"========================%@",item.orgname);
        cell.nameLabel.text=[self changeNullString:item.orgname];
    }
    cell.addButton.tag=101+indexPath.row;
    [cell.addButton addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchUpInside];
    return  cell;
}

- (void)gotoNext:(UIButton*)button{
    [nextDataArray removeAllObjects];
    self.isNext=@"Y";
    if (![self.titleString isEqualToString:@"选择机构"]) {
        CommenModel *item=[mainDataArray objectAtIndex:button.tag-101];
        [self sendRequest:BDLISTTYPE andPath:BDLISTURL andSqlParameter:@{@"parentid":item.value} and:self];
    }else{
        OrgItem *item=[mainDataArray objectAtIndex:button.tag-101];
        
        [self sendRequest:MECLISTTYPE andPath:MECLISTURL andSqlParameter:@{@"orgkey":[NSString stringWithFormat:@"%@",item.orgkey]} and:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.whoPush isEqualToString:@"C"]) {
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[ChangeJobViewController class]]) {
                ChangeJobViewController *cvc=(ChangeJobViewController*)nvc;
                if ([self.titleString isEqualToString:@"选择事业部"]) {
                    cvc.bdItem=[mainDataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择机构"]){
                    cvc.orgItem=[mainDataArray objectAtIndex:indexPath.row];
                }
                [self.navigationController popToViewController:cvc animated:YES];
            }
        }
    }else{
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[EntryRegViewController class]]) {
                EntryRegViewController *cvc=(EntryRegViewController*)nvc;
                if ([self.titleString isEqualToString:@"选择事业部"]) {
                    cvc.bdItem=[mainDataArray objectAtIndex:indexPath.row];
                }else if ([self.titleString isEqualToString:@"选择机构"]){
                    cvc.orgItem=[mainDataArray objectAtIndex:indexPath.row];
                    NSLog(@"========%@=========",cvc.orgItem.orgkey);
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
