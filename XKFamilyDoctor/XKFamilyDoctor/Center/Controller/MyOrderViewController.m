//
//  MyOrderViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "OrderItem.h"
#import "OrderFrame.h"
#import "WXApi.h"
#import "OrderDetailViewController.h"
@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    waitPayOrderArray=[NSMutableArray new];
    paySuccessOrderArray=[NSMutableArray new];
    [self addTitleView:@"我的订单"];
    [self addLeftButtonItem];
    [self creatUI];
    [self sendRequest:@"MemberOrderList" andPath:queryURL andSqlParameter:nil and:self];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isPaySuccess.length>0) {
        [waitPayOrderArray removeAllObjects];
        [paySuccessOrderArray removeAllObjects];
        [self sendRequest:@"MemberOrderList" andPath:queryURL andSqlParameter:nil and:self];
        self.isPaySuccess=nil;
    }
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                OrderItem *item=[RMMapper objectWithClass:[OrderItem class] fromDictionary:dic];
                if ([item.LSendSta rangeOfString:@"已交货"].location==NSNotFound) {
                    [waitPayOrderArray addObject:item];
                }else{
                    [paySuccessOrderArray addObject:item];
                }
            }
            if ([self.isChoiceWho isEqualToString:@"W"]) {
                self.dataArray=waitPayOrderArray;
            }else{
                self.dataArray=paySuccessOrderArray;
            }
            [mainTableView reloadData];
        }else{
            [self showSimplePromptBox:self andMesage:@"暂无订单信息！"];
        }
        [self cancelRefresh];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    [self cancelRefresh];
}

- (void)creatUI{
    NSArray *nameArray=@[@"未完成",@"已完成"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *menuButton=[self addSimpleButton:CGRectMake(SCREENWIDTH/nameArray.count*i, 64, SCREENWIDTH/nameArray.count, 50) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(changeOrder:) andText:[nameArray objectAtIndex:i] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
        [self.view addSubview:menuButton];
        
        if (i==0) {
            menuButton.selected=YES;
            lastButton=menuButton;
        }
    }
    self.isChoiceWho=@"W";
    
    scrollLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,112, SCREENWIDTH/nameArray.count, 2)];
    scrollLineLabel.backgroundColor=GREENCOLOR;
    [self.view addSubview:scrollLineLabel];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,114, SCREENWIDTH, SCREENHEIGHT-114) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor=BGGRAYCOLOR;
    [self.view addSubview:mainTableView];
    [self refresh];
}

- (void)changeOrder:(UIButton*)button{
    if (button.selected==NO) {
        if (button.tag==101) {
            self.isChoiceWho=@"W";
            self.dataArray=waitPayOrderArray;
        }else{
            self.isChoiceWho=@"S";
            self.dataArray=paySuccessOrderArray;
        }
        button.selected=YES;
        lastButton.selected=NO;
        lastButton=button;
        [UIView animateWithDuration:0.2 animations:^{
            scrollLineLabel.frame=CGRectMake(button.frame.origin.x, scrollLineLabel.frame.origin.y, scrollLineLabel.frame.size.width, scrollLineLabel.frame.size.height);
        }];
        [mainTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyOrderTableViewCell";
    MyOrderTableViewCell *cell = (MyOrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[MyOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=BGGRAYCOLOR;
    }
    OrderItem *item=[self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=[NSString stringWithFormat:@"客户名称:%@",item.LUserName];
    cell.moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[item.LMoney floatValue]];
    cell.stateLabel.text=[NSString stringWithFormat:@"状态:%@",item.LState];
    cell.timeLabel.text= [NSString stringWithFormat:@"下单时间:%@",item.LOrderTime];
    
    if ([item.LState rangeOfString:@"未付"].location!=NSNotFound){
        cell.selLabel.backgroundColor=[UIColor redColor];
        cell.selLabel.text=@"去支付";
    }else if([item.LSendSta rangeOfString:@"待收货"].location!=NSNotFound){
        cell.selLabel.backgroundColor=GREENCOLOR;
        cell.selLabel.text=@"去交货";
    }else{
        cell.selLabel.backgroundColor=GREENCOLOR;
        cell.selLabel.text=@"查看";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderItem *item=[self.dataArray objectAtIndex:indexPath.row];
    OrderDetailViewController *ovc=[OrderDetailViewController new];
    ovc.orderUserName=item.LUserName;
    ovc.orderUserPhone=item.LMobile;
    ovc.userCode=item.LOnlyCode;
    ovc.orderNumber=item.LID;
    ovc.orderItem=item;
    ovc.whoPush=@"center";
    [self.navigationController pushViewController:ovc animated:YES];
}


- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [waitPayOrderArray removeAllObjects];
        [paySuccessOrderArray removeAllObjects];
        [self sendRequest:@"MemberOrderList" andPath:queryURL andSqlParameter:nil and:self];;
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    //    // 上拉加载
    //    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //    }];
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
