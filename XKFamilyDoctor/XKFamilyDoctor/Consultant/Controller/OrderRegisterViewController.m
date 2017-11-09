//
//  OrderRegisterViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrderRegisterViewController.h"
#import "DataDisplayViewController.h"
#import "ORTableViewCell.h"
#import "ORItem.h"
@interface OrderRegisterViewController ()

@end

@implementation OrderRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"预约挂号"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    mainArray=[NSMutableArray new];
    [self creatUI];
    [self sendRequest:@"ORList" andPath:queryURL andSqlParameter:@[self.peopleOnlyID,CHATCODE] and:self];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isChange.length>0) {
        [mainArray removeAllObjects];
        [self sendRequest:@"ORList" andPath:queryURL andSqlParameter:@[self.peopleOnlyID,CHATCODE] and:self];
        self.isChange=nil;
    }
}

- (void)addRightButtonItem{
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0,40,44);
    [rButton setImage:[UIImage imageNamed:@"consultant_add"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(addNewOrder) forControlEvents:UIControlEventTouchUpInside];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(12,20,12,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)addNewOrder{
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    dvc.tableName=@"APP_Registration";
    dvc.tableAliasName=@"registration";
    dvc.peopleOnlyID=self.peopleOnlyID;
    dvc.titleString=@"预约挂号";
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                ORItem *item=[RMMapper objectWithClass:[ORItem class] fromDictionary:dic];
                [mainArray addObject:item];
            }
            [mainTableView reloadData];
        }else{
            [self showSimplePromptBox:self andMesage:@"暂无预约信息"];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ORTableViewCell";
    ORTableViewCell *cell = (ORTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ORTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ORItem *item=[mainArray objectAtIndex:indexPath.row];
    cell.mainImageView.backgroundColor=GREENCOLOR;
    cell.hospitalName.text=item.LHospitalName;
    cell.orderTime.text=[self getSubTime:item.LWTime andFormat:@"yyyy-MM-dd"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ORItem *item=[mainArray objectAtIndex:indexPath.row];
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    dvc.tableName=@"APP_Registration";
    dvc.tableAliasName=@"registration";
    dvc.item=item;
    dvc.titleString=@"预约挂号";
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
