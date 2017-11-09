//
//  BPSListViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BPSListViewController.h"
#import "BPSListTableViewCell.h"
#import "AddBPViewController.h"
#import "MyUserViewController.h"
#import "BPSListItem.h"

@interface BPSListViewController ()

@end

@implementation BPSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self creatUI];
    mainDataArray=[NSMutableArray new];
    pageCount=1;
    if ([self.titleString isEqualToString:@"血压数据"]) {
        [self sendRequest:GETBPTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBPURL] andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
    }else{
        [self sendRequest:GETBSTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBSURL] andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
    }
    
}

- (void)popViewController{
    if (self.whoPush.length>0) {
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[MyUserViewController class]]) {
            MyUserViewController *mvc=(MyUserViewController*)nvc;
            if (self.whoPush.length>0) {
                mvc.isRefresh=YES;
            }
            [self.navigationController popToViewController:mvc animated:YES];
        }
    }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isRefresh) {
        if ([self.titleString isEqualToString:@"血压数据"]) {
            [self sendRequest:GETBPTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBPURL] andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
        }else{
            [self sendRequest:GETBSTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBSURL] andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
        }
    }
}

- (void)addRightButtonItem{
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0,40,44);
    [rButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(addBPHData) forControlEvents:UIControlEventTouchUpInside];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(10,16,10,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if (pageCount==1) {
            [mainDataArray removeAllObjects];
        }
        if (dataArray.count>0) {
            for (int i=0;i<dataArray.count;i++) {
                NSDictionary *dic=[dataArray objectAtIndex:i];
                BPSListItem*item=[RMMapper objectWithClass:[BPSListItem class] fromDictionary:dic];
                if (self.isRefresh==YES&&i==0) {
                    self.BPSItem=item;
                }
                [mainDataArray addObject:item];
            }
            [mainTableView reloadData];
            noDataView.hidden=YES;
        }else if(pageCount==1){
            [self addNoDataView];
        }
        [self cancelRefresh];
        if (dataArray.count<10) {
            [mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)addBPHData{
    AddBPViewController *bvc=[AddBPViewController new];
    if ([self.titleString isEqualToString:@"血压数据"]) {
        bvc.titleString=@"血压录入";
    }else{
        bvc.titleString=@"血糖录入";
    }
    bvc.LOnlyCode=self.LOnlyCode;
    bvc.memberID=self.memberID;
    bvc.name=self.name;
    [self.navigationController pushViewController:bvc animated:YES];
}


- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor=BGGRAYCOLOR;
    [self.view addSubview:mainTableView];
    [self refresh];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BPSListTableViewCell";
    BPSListTableViewCell *cell = (BPSListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[BPSListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    BPSListItem *item=[mainDataArray objectAtIndex:indexPath.row];
    cell.timeLabel.text=item.adddate;
    if ([self.titleString isEqualToString:@"血压数据"]) {
        cell.BPSCountLabel.text=[NSString stringWithFormat:@"%dmmHg/%dmmHg",item.highpressure,item.lowpressure];
        cell.HRCountLabel.text=[NSString stringWithFormat:@"%dbpm",item.pulse];
        NSString *stateStr=@"正常";
        if (item.highpressure>140) {
            stateStr=@"偏高";
            cell.stateLabel.textColor=[self colorWithHexString:@"#FE7871"];
        }
        if (item.lowpressure<60) {
            stateStr=@"偏低";
            cell.stateLabel.textColor=[self colorWithHexString:@"#FFA903"];
        }
        cell.stateLabel.text=stateStr;
    }else{
        cell.BPSCountLabel.text=[NSString stringWithFormat:@"%@mol/L",item.checkvalue];
        cell.HRCountLabel.text=item.checkType;
        NSString *stateStr=@"正常";
        if ([item.checkType rangeOfString:@"餐后"].location!=NSNotFound) {
            if ([item.checkvalue floatValue]>7.8) {
                stateStr=@"偏高";
                cell.stateLabel.textColor=[self colorWithHexString:@"#FE7871"];
            }
            if ([item.checkvalue floatValue]>6.1) {
                stateStr=@"偏低";
                cell.stateLabel.textColor=[self colorWithHexString:@"#FFA903"];
            }
        }else{
            if ([item.checkvalue floatValue]>6.1) {
                stateStr=@"偏高";
                cell.stateLabel.textColor=[self colorWithHexString:@"#FE7871"];
            }
            if ([item.checkvalue floatValue]<3.9) {
                stateStr=@"偏低";
                cell.stateLabel.textColor=[self colorWithHexString:@"#FFA903"];
            }
        }
        cell.stateLabel.text=stateStr;
    }
    return cell;
}


- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount=1;
        if ([self.titleString isEqualToString:@"血压数据"]) {
            [self sendRequest:GETBPTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBPURL] andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
        }else{
            [self sendRequest:GETBSTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBSURL] andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
        }
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount+=1;
        if ([self.titleString isEqualToString:@"血压数据"]) {
            [self sendRequest:GETBPTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBPURL] andSqlParameter:@{@"pageNumber":[NSString stringWithFormat:@"%d",pageCount],@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
        }else{
            [self sendRequest:GETBSTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,GETBSURL] andSqlParameter:@{@"pageNumber":[NSString stringWithFormat:@"%d",pageCount],@"pageSize":@"10",@"LOnlyCode":self.LOnlyCode} and:self];
        }
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
