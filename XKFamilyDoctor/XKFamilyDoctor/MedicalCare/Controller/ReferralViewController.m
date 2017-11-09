//
//  ReferralViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReferralViewController.h"
#import "ReferralTableViewCell.h"
#import "ReferralInTableViewCell.h"
#import "ApplyDetailViewController.h"
#import "HandleViewController.h"
#import "ReturnApplyViewController.h"
#import "TurnoutApplyViewController.h"
#import "ReceiveViewController.h"
#import "InApplyDetailViewController.h"
#import "ReferraItem.h"
#import "ReferralOutItem.h"
#import "DataDisplayViewController.h"

@interface ReferralViewController ()

@end

@implementation ReferralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    referralOutArray=[NSMutableArray new];
    referralInArray=[NSMutableArray new];
    [self addLeftButtonItem];
    [self creatUI];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    
    if ([[usd objectForKey:@"LPowerList"] rangeOfString:@"审核员"].location!=NSNotFound) {
        [self addTitleView];
    }else{
        [self addTitleView:@"转诊"];
    }
    [self sendRequest:@"ReferalOut" andPath:queryURL andSqlParameter:[NSString stringWithFormat:@"Orgid=%d",[[usd objectForKey:@"LOrgid"] intValue]] and:self];
    
}

- (void)viewDidAppear:(BOOL)animated{
    if ([self.isChange isEqualToString:@"receive"]||[self.isChange isEqualToString:@"in"]) {
        self.navigationItem.rightBarButtonItem=nil;
        self.stateString=nil;
        [referralInArray removeAllObjects];
        [referralInCopyArray removeAllObjects];
        [self sendRequest:@"ReferalIn" andPath:queryURL andSqlParameter:@"" and:self];
    }else if(self.isChange.length>0){
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        self.navigationItem.rightBarButtonItem=nil;
        self.stateString=nil;
        [referralOutArray removeAllObjects];
        [referralOutCopyArray removeAllObjects];
        [self sendRequest:@"ReferalOut" andPath:queryURL andSqlParameter:@[[NSString stringWithFormat:@"%d",[[usd objectForKey:@"LOrgid"] intValue]],@""] and:self];
    }
    self.isChange=nil;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"ReferalOut"]) {
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    ReferralOutItem *item=[RMMapper objectWithClass:[ReferralOutItem class] fromDictionary:dic];
                    [referralOutArray addObject:item];
                }
                referralOutCopyArray=[referralOutArray mutableCopy];
                [self addRightButtonItem];
                [referralOutTableView reloadData];
            }else{
                [self showSimplePromptBox:self andMesage:@"暂无转出的转诊信息"];
            }
        }else if ([type isEqualToString:@"ReferalIn"]) {
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    ReferraItem *item=[RMMapper objectWithClass:[ReferraItem class] fromDictionary:dic];
                    [referralInArray addObject:item];
                }
                referralInCopyArray=[referralInArray mutableCopy];
                [self addRightButtonItem];
                [referralInTableView reloadData];
            }else{
                [self showSimplePromptBox:self andMesage:@"暂无转入的转诊信息"];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    
}

- (void)addRightButtonItem{
    if (self.navigationItem.rightBarButtonItem==nil) {
        UIButton *lButton=[UIButton buttonWithType:UIButtonTypeCustom];
        lButton.frame=CGRectMake(0, 0,40,44);
        [lButton addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
        lButton.imageEdgeInsets=UIEdgeInsetsMake(13,0,13,22);
        
        UILabel *cancelLabel=[self addLabel:CGRectMake(0,12, 40, 20) andText:@"所有" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:2];
        cancelLabel.tag=10;
        [lButton addSubview:cancelLabel];
        if (self.stateString.length==0) {
            self.stateString=@"所有";
        }else{
            cancelLabel.text=self.stateString;
        }
        UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
        self.navigationItem.rightBarButtonItem=lItem;
    }
}

- (void)changeState{
    UIView *fBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andColor:TEXTCOLORG];
    fBGView.alpha=0.7;
    fBGView.tag=11;
    [self.navigationController.view addSubview:fBGView];
    
    UIView *sBGView=[self addSimpleBackView:CGRectMake(0,SCREENHEIGHT-200, SCREENWIDTH,200) andColor:[self colorWithHexString:@"e6e6e6"]];
    sBGView.tag=12;
    [self.navigationController.view addSubview:sBGView];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(15, 10,100, 20) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(cancelView) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [sBGView addSubview:cancelButton];
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-115, 10,100, 20) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(sureChoiceState) andText:@"确定" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:2];
    [sBGView addSubview:sureButton];
    
    UIView *tBGView=[self addSimpleBackView:CGRectMake(0,40, SCREENWIDTH,160) andColor:[self colorWithHexString:@"e6e6e6"]];
    tBGView.backgroundColor=MAINWHITECOLOR;
    [sBGView addSubview:tBGView];
    
    UIPickerView *picker=[[UIPickerView alloc]initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 0, 200, 160)];
    picker.backgroundColor=MAINWHITECOLOR;
    picker.delegate=self;
    picker.dataSource=self;
    [picker selectRow:[pickerArray indexOfObject:self.stateString] inComponent:0 animated:NO];
    [tBGView addSubview:picker];
}

- (void)cancelView{
    UIView *fBGView=[self.navigationController.view viewWithTag:11];
    [fBGView removeFromSuperview];
    UIView *sBGView=[self.navigationController.view viewWithTag:12];
    [sBGView removeFromSuperview];
}

- (void)sureChoiceState{
    UILabel *cancelLabel=(UILabel*)[self.navigationController.view viewWithTag:10];
    if (![cancelLabel.text isEqualToString:self.stateString]) {
        cancelLabel.text=self.stateString;
    }
    if (referralInTableView&&referralInTableView.hidden==NO) {
        if ([self.stateString isEqualToString:@"所有"]) {
            referralInCopyArray=[referralInArray mutableCopy];
        }else if ([self.stateString isEqualToString:@"完成"]){
            [referralInCopyArray removeAllObjects];
            for (ReferraItem *item in referralInArray) {
                if ([[self changeNullString:item.sta] rangeOfString:@"完成"].location!=NSNotFound) {
                    [referralInCopyArray addObject:item];
                }
            }
        }else if ([self.stateString isEqualToString:@"代办"]){
            [referralInCopyArray removeAllObjects];
            for (ReferraItem *item in referralInArray) {
                if ([[self changeNullString:item.sta] rangeOfString:@"申请"].location!=NSNotFound) {
                    [referralInCopyArray addObject:item];
                }
            }
        }else if ([self.stateString isEqualToString:@"已办"]){
            [referralInCopyArray removeAllObjects];
            for (ReferraItem *item in referralInArray) {
                if ([[self changeNullString:item.sta] rangeOfString:@"完成"].location==NSNotFound&&[[self changeNullString:item.sta] rangeOfString:@"申请"].location==NSNotFound) {
                    [referralInCopyArray addObject:item];
                }
            }
        }
        [referralInTableView reloadData];
    }else if(referralOutTableView&&referralOutTableView.hidden==NO){
        if ([self.stateString isEqualToString:@"所有"]) {
            referralOutCopyArray=[referralOutArray mutableCopy];
        }else if ([self.stateString isEqualToString:@"完成"]){
            [referralOutCopyArray removeAllObjects];
            for (ReferraItem *item in referralOutArray) {
                if ([[self changeNullString:item.sta] rangeOfString:@"完成"].location!=NSNotFound) {
                    [referralOutCopyArray addObject:item];
                }
            }
        }else if ([self.stateString isEqualToString:@"代办"]){
            [referralOutCopyArray removeAllObjects];
            for (ReferraItem *item in referralOutArray) {
                if ([[self changeNullString:item.sta] rangeOfString:@"申请"].location!=NSNotFound) {
                    [referralOutCopyArray addObject:item];
                }
            }
        }else if ([self.stateString isEqualToString:@"已办"]){
            [referralOutCopyArray removeAllObjects];
            for (ReferraItem *item in referralOutArray) {
                if ([[self changeNullString:item.sta] rangeOfString:@"完成"].location==NSNotFound&&[[self changeNullString:item.sta] rangeOfString:@"申请"].location==NSNotFound) {
                    [referralOutCopyArray addObject:item];
                }
            }
        }
        [referralOutTableView reloadData];
    }
    [self cancelView];
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTitleView{
    NSArray *array = [NSArray arrayWithObjects:@"转出",@"转入",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.frame = CGRectMake(0, 100,180, 30);
    segment.tintColor=MAINWHITECOLOR;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:FONTTYPEME size:BIGFONT] forKey:NSFontAttributeName];
    [segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex=0;
    self.navigationItem.titleView=segment;
}

- (void)change:(UISegmentedControl*)segment{
    if (segment.selectedSegmentIndex==0) {
        referralOutTableView.hidden=NO;
        applyButton.hidden=NO;
        referralInTableView.hidden=YES;
        if (referralOutArray.count==0) {
            self.navigationItem.rightBarButtonItem=nil;
        }else{
            [self addRightButtonItem];
        }
    }else{
        if (referralInArray.count==0) {
            self.navigationItem.rightBarButtonItem=nil;
            [self sendRequest:@"ReferalIn" andPath:queryURL andSqlParameter:@"" and:self];
        }else{
            [self addRightButtonItem];
        }
        referralOutTableView.hidden=YES;
        if (!referralInTableView) {
            referralInTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
            referralInTableView.delegate=self;
            referralInTableView.dataSource=self;
            referralInTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            [self.view addSubview:referralInTableView];
        }else{
            referralInTableView.hidden=NO;
            applyButton.hidden=YES;
            
        }
    }
}

- (void)creatUI{
    referralOutTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    referralOutTableView.delegate=self;
    referralOutTableView.dataSource=self;
    referralOutTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:referralOutTableView];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if (![[usd objectForKey:@"LRole"] isEqualToString:@"健康顾问"]) {
//        applyButton=[self addSimpleButton:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50) andBColor:GREENCOLOR andTag:0 andSEL:@selector(turnout) andText:@"申请转诊" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
//        [self.view addSubview:applyButton];
    }else{
        referralOutTableView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    }
    pickerArray = [[NSArray alloc]initWithObjects:@"所有",@"已办",
                   @"代办",@"完成", nil];
}

- (void)turnout{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 153;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==referralOutTableView) {
        return referralOutCopyArray .count;
    }else{
        return referralInCopyArray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==referralOutTableView) {
        static NSString *identifier = @"ReferralTableViewCell";
        ReferralTableViewCell *cell = (ReferralTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        if (!cell) {
            cell = [[ReferralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        ReferralOutItem *item=[referralOutCopyArray objectAtIndex:indexPath.row];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,@""]] placeholderImage:[UIImage imageNamed:@"user_default"]];
        cell.nameLabel.text=item.Name;
        cell.numberLabel.text=[NSString stringWithFormat:@"编号:%@",item.FileNo];
        cell.stateLabel.text=[NSString stringWithFormat:@"原因:%@",item.Reason];
        cell.timeLabel.text=[self getSubTime:item.Date andFormat:@"yyyy-MM-dd"];
        
        if ([[self changeNullString:item.sta] rangeOfString:@"完成"].location==NSNotFound) {
        }
        [cell.detailButton addTarget:self action:@selector(detailOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.handleButton addTarget:self action:@selector(gotoHandle:) forControlEvents:UIControlEventTouchUpInside];
        [cell.returnButton addTarget:self action:@selector(returnApply:) forControlEvents:UIControlEventTouchUpInside];
        [cell.applyButton addTarget:self action:@selector(gotoTurnOutApply:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *identifier = @"ReferralInTableViewCell";
        ReferralInTableViewCell *cell = (ReferralInTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        if (!cell) {
            cell = [[ReferralInTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        ReferraItem *item=[referralInCopyArray objectAtIndex:indexPath.row];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,@""]] placeholderImage:[UIImage imageNamed:@"user_default"]];
        cell.nameLabel.text=[self changeNullString:item.PatientName];
        cell.numberLabel.text=[NSString stringWithFormat:@"编号:%@",item.FileNo];
        cell.stateLabel.text=[NSString stringWithFormat:@"状态:%@",[self changeNullString:item.sta]];
        cell.timeLabel.text=item.Date;
        
        if ([[self changeNullString:item.sta] rangeOfString:@"完成"].location!=NSNotFound) {
            cell.receiveButton.hidden=YES;
            cell.returnButton.hidden=YES;
        }else{
            cell.receiveButton.hidden=NO;
            cell.returnButton.hidden=NO;
            cell.returnButton.tag=indexPath.row;
            [cell.returnButton addTarget:self action:@selector(returnApply:) forControlEvents:UIControlEventTouchUpInside];
            cell.receiveButton.tag=indexPath.row;
            [cell.receiveButton addTarget:self action:@selector(receiveApply:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.detailButton.tag=indexPath.row;
        [cell.detailButton addTarget:self action:@selector(inDetailOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    return nil;
}

- (void)detailOnclick:(UIButton*)button{
    ApplyDetailViewController *rvc=[ApplyDetailViewController new];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)gotoTurnOutApply:(UIButton*)button{
    TurnoutApplyViewController *rvc=[TurnoutApplyViewController new];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)returnApply:(UIButton*)button{
    id item=nil;
    if (referralInTableView.hidden==NO) {
        item=[referralInCopyArray objectAtIndex:button.tag];
    }else{
        item=[referralOutCopyArray objectAtIndex:button.tag];
    }
    ReturnApplyViewController *rvc=[ReturnApplyViewController new];
    rvc.Item=item;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)gotoHandle:(UIButton*)button{
    HandleViewController *hvc=[HandleViewController new];
    [self.navigationController pushViewController:hvc animated:YES];
}

- (void)inDetailOnclick:(UIButton*)button{
    id item=nil;
    if (referralInTableView.hidden==NO) {
        item=[referralInCopyArray objectAtIndex:button.tag];
    }else{
        item=[referralOutCopyArray objectAtIndex:button.tag];
    }
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    [self.navigationController.myTabBarController hidesTabBar];
    dvc.tableName=@"CureBack";
    dvc.tableAliasName=@"CureBack";
    dvc.titleString=@"转诊";
    dvc.item=item;
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)receiveApply:(UIButton*)button{
    ReferraItem *item=[referralInCopyArray objectAtIndex:button.tag];
    ReceiveViewController *hvc=[ReceiveViewController new];
    hvc.Item=item;
    [self.navigationController pushViewController:hvc animated:YES];
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel=[self addLabel:view.frame andText:[self pickerView:pickerView titleForRow:row forComponent:component] andFont:SUPERFONT andColor:TEXTCOLORG andAlignment:1];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    self.stateString=[pickerArray objectAtIndex:row];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
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
