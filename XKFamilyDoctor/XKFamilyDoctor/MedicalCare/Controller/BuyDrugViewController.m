//
//  BuyDrugViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BuyDrugViewController.h"
#import "SearchCommunityViewController.h"
#import "BillingViewController.h"
#import "DrugInfoTableViewCell.h"
#import "DrugDetailViewController.h"
#import "DrugInfoItem.h"
@interface BuyDrugViewController ()

@end

@implementation BuyDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择药品"];
    [self addLeftButtonItem];
    [self creatUI];
    mainArray=[NSMutableArray new];
    nowCount=1;
    [self sendRequest:@"DrugInfo" andPath:queryURL andSqlParameter:@[@"",@"1"] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        [self cancelRefresh];
        if (data.count>0) {
            if (nowCount==1) {
                [mainArray removeAllObjects];
            }
            for (NSDictionary *dic in data) {
                DrugInfoItem *item=[RMMapper objectWithClass:[DrugInfoItem class] fromDictionary:dic];
                [mainArray addObject:item];
            }
            [mainTableView reloadData];
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
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,115, SCREENWIDTH, SCREENHEIGHT-115) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    [self refresh];
}

- (void)searchCommunity{
    SearchCommunityViewController *svc=[SearchCommunityViewController new];
    svc.whoPush=@"DRUG";
    [self.navigationController pushViewController:svc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DrugInfoTableViewCell";
    DrugInfoTableViewCell *cell = (DrugInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[DrugInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    DrugInfoItem *item=[mainArray objectAtIndex:indexPath.row];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:[UIImage imageNamed:@"logosss"]];
    
    cell.nameLabel.text=[NSString stringWithFormat:@"%@",item.LName];
    cell.companyLabel.text=[NSString stringWithFormat:@"厂家:%@",item.LFromAddr];
    cell.priceLabel.attributedText=[self setString:[NSString stringWithFormat:@"价格: %.2f元",item.LNewPrice] andSubString:@"价格:" andDifColor:TEXTCOLORG];
    cell.choiceButton.tag=101+indexPath.row;
    [cell.choiceButton addTarget:self action:@selector(sureChoiceDrug:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)sureChoiceDrug:(UIButton*)button{
   DrugInfoItem *item=[mainArray objectAtIndex:button.tag-101];
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[BillingViewController class]]) {
            BillingViewController *bvc=(BillingViewController *)nvc;
            bvc.choiceDrugItem=item;
            [self.navigationController popToViewController:bvc animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DrugDetailViewController *dvc=[DrugDetailViewController new];
//    DrugInfoItem *item=[mainArray objectAtIndex:indexPath.row];
//    dvc.drugInfoItem=item;
//    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self sendRequest:@"DrugInfo" andPath:queryURL andSqlParameter:@[@"",@"1"] and:self];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        nowCount+=1;
        [self sendRequest:@"DrugInfo" andPath:queryURL andSqlParameter:@[@"",[NSString stringWithFormat:@"%d",nowCount]] and:self];
    }];
}

- (void)cancelRefresh{
    [mainTableView.mj_header endRefreshing];
    [mainTableView.mj_footer endRefreshing];
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
