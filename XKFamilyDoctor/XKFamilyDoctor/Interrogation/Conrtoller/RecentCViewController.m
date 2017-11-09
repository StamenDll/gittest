//
//  RecentCViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RecentCViewController.h"
#import "SearchCommunityViewController.h"
#import "MemberInfoViewController.h"
#import "RecentCTableViewCell.h"
#import "ResidentItem.h"
@interface RecentCViewController ()

@end

@implementation RecentCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"签约居民"];
    [self addLeftButtonItem];
    [self creatUI];
    mainArray=[NSMutableArray new];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    nowCount=1;
    [self sendRequest:@"Resident" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"LTeamId"],@"",@"1"] and:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    [self cancelRefresh];
    if ([message isKindOfClass:[NSArray class]]) {
        nowCount+=1;
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                ResidentItem *Item=[RMMapper objectWithClass:[ResidentItem class] fromDictionary:dic];
                [mainArray addObject:Item];
            }
            [mainTableView reloadData];
        }else{
            if (nowCount>1) {
                [mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self addNoDataView];
                [mainTableView isHidden];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    UIView *fBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,41)];
    fBackView.backgroundColor=[self colorWithHexString:@"e6e6e6"];
    [self.view addSubview:fBackView];
    
    UIButton *searchButton=[self addButton:CGRectMake(15,70, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(searchClick:)];
    [searchButton.layer setCornerRadius:15];
    [self.view addSubview:searchButton];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchButton addSubview:searchImageView];
    
    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:14 andColor:TEXTCOLORG andAlignment:0];
    [searchButton addSubview:npLabel];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,105, SCREENWIDTH,SCREENHEIGHT-105) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    [self refresh];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecentCTableViewCell";
    RecentCTableViewCell *cell = (RecentCTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[RecentCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ResidentItem *item=[mainArray objectAtIndex:indexPath.row];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,@""]] placeholderImage:USERDEFAULTPIC];
    cell.nameLabel.text=item.LName;
    cell.infoLabel.text=item.LMobile;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResidentItem *item=[mainArray objectAtIndex:indexPath.row];
    MemberInfoViewController *mvc=[MemberInfoViewController new];
    mvc.titleString=item.LName;
    mvc.LOnlyCode=item.LOnlyCode;
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)lookMemberInfo:(UIButton*)button{
    
}


- (void)searchClick:(UIButton*)button{
    [self.navigationController setNavigationBarHidden:YES];
    SearchCommunityViewController *svc=[[SearchCommunityViewController alloc]init];
    svc.whoPush=@"Recent";
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        nowCount=1;
        [mainArray removeAllObjects];
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        [self sendRequest:@"Resident" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"LTeamId"],@"",@"1"] and:self];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        [self sendRequest:@"Resident" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"LTeamId"],@"",[NSString stringWithFormat:@"%d",nowCount]] and:self];
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
