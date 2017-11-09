//
//  MyAddPersonViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyAddPersonViewController.h"
#import "PersonListTableViewCell.h"
#import "MyAddPersonItem.h"
#import "AppDelegate.h"
@interface MyAddPersonViewController ()

@end

@implementation MyAddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"我添加的人员信息"];
    [self addLeftButtonItem];
    dataArray=[NSMutableArray new];
    mainDataArray=[NSMutableArray new];
    searchDataArray=[NSMutableArray new];
    nowCount=1;
    [self creatUI];
    if ([self.whoPush isEqualToString:@"Sta_D"]) {
        [self sendRequest:@"MyAddDPerson" andPath:queryURL andSqlParameter:@"1" and:self];
        [self sendRequest:@"MyAddDPersonCount" andPath:queryURL andSqlParameter:self.fdSid and:self];
    }else{
        [self sendRequest:@"MyAddPerson" andPath:queryURL andSqlParameter:@[@"1",self.fdSid] and:self];
        [self sendRequest:@"FreeDiagnoseCount" andPath:queryURL andSqlParameter:self.fdSid and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"MyAddPerson"]||[type isEqualToString:@"MyAddDPerson"]) {
            if (nowCount==1){
                [dataArray removeAllObjects];
            }
            [self cancelRefresh];
            if (data.count<30) {
                [mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (NSDictionary *dic in data) {
                MyAddPersonItem *item=[RMMapper objectWithClass:[MyAddPersonItem class] fromDictionary:dic];
                [dataArray addObject:item];
            }
            [mainTableView reloadData];
            //            if ([type isEqualToString:@"MyAddPerson"]) {
            //                NSMutableArray *personArray=[NSMutableArray new];
            //                for (MyAddPersonItem *item in dataArray) {
            //                    if (![personArray containsObject:item.sIdCard]) {
            //                        [personArray addObject:item.sIdCard];
            //                    }
            //                }
            //                countLabel.text=[NSString stringWithFormat:@"我已添加:%lu人  共%lu人次",(unsigned long)personArray.count,(unsigned long)dataArray.count];
            //
            //            }
        }
        else if ([type isEqualToString:@"MyAddDPersonCount"]){
            count=data.count;
            [self sendRequest:@"MyAddDPersonTotalCount" andPath:queryURL andSqlParameter:self.fdSid and:self];
        }
        else if ([type isEqualToString:@"MyAddDPersonTotalCount"]){
            countLabel.text=[NSString stringWithFormat:@"我已添加:%lu人  共%lu人次",count,(unsigned long)data.count];
        }
        else if ([type isEqualToString:@"FreeDiagnoseCount"]){
            if (data.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                totalCountLabel.text=[NSString stringWithFormat:@"活动共计:%@人  %@人次",[dic objectForKey:@"PersonTimes"],[dic objectForKey:@"TotalTimes"]];
                countLabel.text=[NSString stringWithFormat:@"我已添加:%@人  共%@人次",[dic objectForKey:@"WorkPersonTimes"],[dic objectForKey:@"WorkStatis"]];
            }
        }else if ([type isEqualToString:@"SearchFOD"]){
            if (data.count>0) {
                [searchField resignFirstResponder];
                nowCount=1;
                [dataArray removeAllObjects];
                for (NSDictionary *dic in data) {
                    MyAddPersonItem *item=[RMMapper objectWithClass:[MyAddPersonItem class] fromDictionary:dic];
                    [mainDataArray addObject:item];
                }
                dataArray=mainDataArray;
                [mainTableView reloadData];
            }else{
                [self showSimplePromptBox:self andMesage:@"没有对应的数据信息！"];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
}

- (void)creatUI{
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,75, SCREENWIDTH-20,30) andColor:MAINWHITECOLOR];
    [searchBGView.layer setCornerRadius:15];
    [self.view addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 20)];
    searchField.placeholder=@"挂号人姓名或挂号科室或挂号医生";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchBGView addSubview:searchField];
    
    
    countLabel=[self addLabel:CGRectMake(10, 115,SCREENWIDTH-20, 20) andText:@"我已添加:人  共人次" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:0];
    countLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:countLabel];
    
    if (![self.whoPush isEqualToString:@"Sta_D"]){
        countLabel.frame=CGRectMake(10, 115,(SCREENWIDTH-30)/2, 20);
        totalCountLabel=[self addLabel:CGRectMake((SCREENWIDTH-30)/2+20, 115, (SCREENWIDTH-30)/2, 20) andText:@"活动总计:人  人次" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:2];
        totalCountLabel.adjustsFontSizeToFitWidth=YES;
        [self.view addSubview:totalCountLabel];
    }
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,140, SCREENWIDTH, SCREENHEIGHT-140) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    [self refresh];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PersonListTableViewCell";
    PersonListTableViewCell *cell = (PersonListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[PersonListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    MyAddPersonItem *item=[dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=item.sName;
    cell.phoneLabel.text=[NSString stringWithFormat:@"联系电话: 未填写联系方式"];
    cell.depNameLabel.text=[NSString stringWithFormat:@"挂号科室: %@  挂号医生: %@",item.sDeptsName,item.sDoctorName];
    cell.printLabel.attributedText=[self setString:[NSString stringWithFormat:@"是否已打印条码：%@",item.sIsPrint] andSubString:@"是否已打印条码：" andDifColor:TEXTCOLORG];
    cell.addressLabel.text=[NSString stringWithFormat:@"联系地址: %@",item.sIDAddr];
    cell.timeLabel.text=[NSString stringWithFormat:@"添加时间: %@",item.dTime];
    NSArray *timeArray=[self intervalFromLastDate:[self getNowTime] toTheDate:item.dTime];
    int hour=[[timeArray objectAtIndex:0] intValue];
    if (![self.whoPush isEqualToString:@"Sta_Y"]) {
        if (([item.sIsPrint isEqualToString:@"未打印"]&&[self.whoPush isEqualToString:@"Sta_D"]&&abs(hour)<12)||![self.whoPush isEqualToString:@"Sta_D"]) {
            cell.printButton.hidden=NO;
            cell.printButton.tag=101+indexPath.row;
            [cell.printButton addTarget:self action:@selector(printClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.printButton.hidden=YES;
        }
    }else{
        cell.printButton.hidden=YES;
    }
    return cell;
}

- (void)printClick:(UIButton*)button{
    UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"确定要打印该用户的条码信息吗？（该功能为有条码打印机的站点可用！）" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        MyAddPersonItem *item=[dataArray objectAtIndex:button.tag-101];
        if (!client) {
            NSString *clientId =  [NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]];
            client = [[MQTTClient alloc] initWithClientId:clientId];
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            client.host = appDelegate.MQTT_HOST;
            client.port = appDelegate.MQTT_PORT;
            dispatch_semaphore_t subscribed = dispatch_semaphore_create(0);
            [client connectWithCompletionHandler:^(NSUInteger code) {
                [client subscribe:CHATCODE
                          withQos:AtMostOnce
                completionHandler:^(NSArray *grantedQos) {
                    dispatch_semaphore_signal(subscribed);
                }];
            }];
        }
        
        NSDictionary *contentDic=contentDic=@{@"action" :@"义诊",@"orgid":[NSString stringWithFormat:@"%d",[item.iOrgId intValue]],@"data":@[@{@"projid":item.sID,@"department":[NSString stringWithFormat:@"%d",[item.iDepartmentId intValue]],@"print":@"yes"}]};
        
        NSData *contentJson = [NSJSONSerialization dataWithJSONObject:contentDic options:0 error:NULL];
        NSString *content =  [[NSString alloc] initWithData:contentJson encoding:NSUTF8StringEncoding];
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [client publishString:content
                      toTopic:appDelegate.MQTT_HOST_ID
                      withQos:AtMostOnce
                       retain:NO
            completionHandler:^(int mid) {
                if (mid==1) {
                    [self showSimplePromptBox:self andMesage:@"打印信息提交成功，请核实是否已打印成功！"];
                    [self performSelector:@selector(printRefresh) withObject:av afterDelay:4.0f];
                }else{
                    [self showSimplePromptBox:self andMesage:@"打印失败，请重试！"];
                }
            }];
        
        dispatch_semaphore_t received = dispatch_semaphore_create(0);
        [client setMessageHandler:^(MQTTMessage *message) {
            dispatch_semaphore_signal(received);
        }];
    }];
    [av addAction:sureAC];
    
    UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    [av addAction:cancelAC];
    [self presentViewController:av animated:YES completion:nil];
}

- (void)printRefresh{
    [self sendRequest:@"MyAddPerson" andPath:queryURL andSqlParameter:self.fdSid and:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        if ([self.whoPush isEqualToString:@"Sta_D"]) {
            [self sendRequest:@"SearchFOD" andPath:queryURL andSqlParameter:@[@"导诊",textField.text,@""] and:self];
        }else{
            [self sendRequest:@"SearchFOD" andPath:queryURL andSqlParameter:@[@"义诊",textField.text,[NSString stringWithFormat:@"and sProjId='%@'",self.fdSid]] and:self];
        }
    }
    return YES;
}

- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        nowCount=1;
        if ([self.whoPush isEqualToString:@"Sta_D"]) {
            [self sendRequest:@"MyAddDPerson" andPath:queryURL andSqlParameter:@"1" and:self];
        }else{
            [self sendRequest:@"MyAddPerson" andPath:queryURL andSqlParameter:@[@"1",self.fdSid] and:self];
        }
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        nowCount+=1;
        if ([self.whoPush isEqualToString:@"Sta_D"]) {
            [self sendRequest:@"MyAddDPerson" andPath:queryURL andSqlParameter:[NSString stringWithFormat:@"%d",nowCount] and:self];
        }else{
            [self sendRequest:@"MyAddPerson" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%d",nowCount],self.fdSid] and:self];
            
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
