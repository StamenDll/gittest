//
//  WaitAuditingViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WaitAuditingViewController.h"
#import "AuditItem.h"
@interface WaitAuditingViewController ()

@end

@implementation WaitAuditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"待审核"];
    [self addLeftButtonItem];
//    [self addRightButtonItem];
    dataArray=[NSMutableArray new];
    choiceButtonArray=[NSMutableArray new];
    idsArray=[NSMutableArray new];
    BGSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGSrollView];

    [self sendRequest:AUDITLISTTYPE andPath:AUDITLISTAURL andSqlParameter:@{@"page":@"1",@"limit":@"100",@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]} and:self];
    
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightButtonItem{
    UIButton *lButton=[UIButton buttonWithType:UIButtonTypeCustom];
    lButton.frame=CGRectMake(0, 0,70,44);
    [lButton addTarget:self action:@selector(setmore:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *rLabel=[self addLabel:CGRectMake(0, 12, 70, 20) andText:@"批量操作" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:2];
    [lButton addSubview:rLabel];
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
    self.navigationItem.rightBarButtonItem=lItem;
    
    setAllMenuBGView=[self addSimpleBackView:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
    setAllMenuBGView.hidden=YES;
    [self.view addSubview:setAllMenuBGView];
    
    UIButton *agreeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-170,10, 40, 30) andBColor:GREENCOLOR andTag:1001 andSEL:@selector(agreeAllOnclik) andText:@"同意" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [agreeButton.layer setCornerRadius:5];
    [setAllMenuBGView addSubview:agreeButton];
    
    UIButton *disAgreeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-120,10, 40, 30) andBColor:GREENCOLOR andTag:1002 andSEL:@selector(disAgreeAllOnclick) andText:@"驳回" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [disAgreeButton.layer setCornerRadius:5];
    [setAllMenuBGView addSubview:disAgreeButton];
    
    UIButton *choicceAllButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-60,10, 40, 30) andBColor:CLEARCOLOR andTag:1002 andSEL:@selector(choiceAllOnclick:) andText:@"全选" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
    [choicceAllButton.layer setCornerRadius:5];
    choicceAllButton.layer.borderColor=LINECOLOR.CGColor;
    choicceAllButton.layer.borderWidth=0.5;
    [setAllMenuBGView addSubview:choicceAllButton];
    
    
}

- (void)disAgreeAllOnclick{
    if (idsArray.count>0) {
        [self showPromptBox:self andMesage:@"确定要驳回选中的申请吗？" andSel:@selector(sureDisAdreeAll)];
    }else{
        [self showSimplePromptBox:self andMesage:@"请选择您要处理的选项！"];
    }
}

- (void)sureDisAdreeAll{
    NSString *ids=@"";
    for (AuditItem *item in idsArray) {
        if (ids.length==0) {
            ids=[NSString stringWithFormat:@"%d",item.empkey];
        }else{
            ids=[NSString stringWithFormat:@"%@,%d",ids,item.empkey];
        }
    }
    
    NSLog(@"=%@",ids);
    self.isAgree=@"N";
    [self sendRequest:CHANGEATYPE andPath:CHANGEAURL andSqlParameter:@{@"opttype":@"0",@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],@"ids":ids} and:self];
}

- (void)agreeAllOnclik{
    if (idsArray.count>0) {
        [self showPromptBox:self andMesage:@"确定要同意选中的申请吗？" andSel:@selector(sureAgreeAll)];
    }else{
        [self showSimplePromptBox:self andMesage:@"请选择您要处理的选项！"];
    }
}

- (void)sureAgreeAll{
    NSLog(@"=%@",idsArray);
    NSString *ids=@"";
    for (AuditItem *item in idsArray) {
        if (ids.length==0) {
            ids=[NSString stringWithFormat:@"%d",item.empkey];
        }else{
            ids=[NSString stringWithFormat:@"%@,%d",ids,item.empkey];
        }
    }
    self.isAgree=@"Y";
    
    [self sendRequest:CHANGEATYPE andPath:CHANGEAURL andSqlParameter:@{@"opttype":@"1",@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],@"ids":ids} and:self];
}

- (void)choiceAllOnclick:(UIButton*)button{
    UILabel *nameLabel=[[button subviews] lastObject];
    if (button.selected==NO) {
        nameLabel.text=@"清空";
        button.selected=YES;
        if (dataArray.count>0) {
            for (int i=0; i<dataArray.count; i++) {
                UIButton *choiceButton=(UIButton*)[self.view viewWithTag:101+i];
                choiceButton.selected=YES;
                for (UIView *subView in [BGSrollView subviews]) {
                    if (subView.tag==choiceButton.tag) {
                        AuditItem *item=[dataArray objectAtIndex:i];
                        [choiceButtonArray addObject:choiceButton];
                        [idsArray addObject:item];
                    }
                }
                
            }
        }
    }else{
        nameLabel.text=@"全选";
        button.selected=NO;
        if (dataArray.count>0) {
            for (int i=0; i<dataArray.count; i++) {
                UIButton *choiceButton=(UIButton*)[self.view viewWithTag:101+i];
                choiceButton.selected=NO;
                for (UIView *subView in [BGSrollView subviews]) {
                    if (subView.tag==choiceButton.tag) {
                        AuditItem *item=[dataArray objectAtIndex:i];
                        [choiceButtonArray removeObject:choiceButton];
                        [idsArray removeObject:item];
                    }
                }
                
            }
        }
    }
}

- (void)setmore:(UIButton*)button{
    if (button.selected==NO) {
        setAllMenuBGView.hidden=NO;
        button.selected=YES;
        
        if (dataArray.count>0) {
            for (int i=0; i<dataArray.count; i++) {
                UIButton *agreeButton=(UIButton*)[self.view viewWithTag:201+i];
                UIButton *disagreeButton=(UIButton*)[self.view viewWithTag:301+i];
                
                agreeButton.hidden=YES;
                disagreeButton.hidden=YES;
            }
        }
    }else{
        setAllMenuBGView.hidden=YES;
        button.selected=NO;
        
        if (dataArray.count>0) {
            for (int i=0; i<dataArray.count; i++) {
                UIButton *agreeButton=(UIButton*)[self.view viewWithTag:201+i];
                UIButton *disagreeButton=(UIButton*)[self.view viewWithTag:301+i];
                
                agreeButton.hidden=NO;
                disagreeButton.hidden=NO;
            }
        }
    }
    
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSString class]]) {
        [self showSimplePromptBox:self andMesage:message];
    }else if ([type isEqualToString:AUDITLISTTYPE]){
        NSArray *rows=[message objectForKey:@"rows"];
        for (NSDictionary *dic in rows) {
            AuditItem *item=[RMMapper objectWithClass:[AuditItem class] fromDictionary:dic];
            [dataArray addObject:item];
        }
        [self creatUI];
    }else if ([type isEqualToString:CHANGEATYPE]){
        for (UIButton *button in choiceButtonArray) {
            [button removeFromSuperview];
            for (UIView *subView in [BGSrollView subviews]) {
                if (subView.frame.origin.y>button.frame.origin.y) {
                    subView.frame=CGRectMake(0, subView.frame.origin.y-button.frame.size.height, SCREENWIDTH, subView.frame.size.height);
                }
            }
        }
        for (AuditItem *item in idsArray) {
            if ([self.isAgree isEqualToString:@"Y"]) {
                [self sendRequest:@"SendMessage" andPath:excuteURL andSqlParameter:@[item.mobile,[NSString stringWithFormat:@"您的注册申请已通过，可立即登录。退订回T"]] and:self];
            }else
                [self sendRequest:@"SendMessage" andPath:excuteURL andSqlParameter:@[item.mobile,[NSString stringWithFormat:@"很抱歉，您的注册申请被驳回。退订回T"]] and:self];
        }
        [idsArray removeAllObjects];
    }
}

- (void)requestFail:(NSString *)type{

}

- (void)creatUI{
    for (UIView *subView in [BGSrollView subviews]) {
        [subView removeFromSuperview];
    }
    NSMutableArray *btnArray=[NSMutableArray new];
    for (int i=0; i<dataArray.count; i++) {
        AuditItem *item=[dataArray objectAtIndex:i];
        UIButton *auditButton=[self addButton:CGRectMake(0, 0, SCREENWIDTH, 0) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(choiceOnclick:)];
        [auditButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [auditButton setImage:[UIImage imageNamed:@"select_vaccine"] forState:UIControlStateSelected];
        [BGSrollView addSubview:auditButton];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        nameLabel.attributedText=[self setString:[NSString stringWithFormat:@"申请人: %@",item.truename] andSubString:@"申请人:" andDifColor:TEXTCOLOR];
        [auditButton addSubview:nameLabel];
        
        
        UILabel *phoneLabel=[self addLabel:CGRectMake(10, 40, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        phoneLabel.attributedText=[self setString:[NSString stringWithFormat:@"联系电话: %@",item.mobile] andSubString:@"联系电话:" andDifColor:TEXTCOLOR];
        [auditButton addSubview:phoneLabel];
        
        UILabel *idNumLabel=[self addLabel:CGRectMake(10, 65, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        idNumLabel.attributedText=[self setString:[NSString stringWithFormat:@"身份证号: %@",item.mobile] andSubString:@"身份证号:" andDifColor:TEXTCOLOR];
        [auditButton addSubview:idNumLabel];
        
        UILabel *postLabel=[self addLabel:CGRectMake(10, 90, 40, 20) andText:@"单位:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [auditButton addSubview:postLabel];
        
        UILabel *postCLabel=[self addLabel:CGRectMake(55, 90,SCREENWIDTH-165, 20) andText:[NSString stringWithFormat:@"%@ %@ %@ %@",item.platename,item.orgname,item.departmentname,[self changeNullString:item.postname]] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        postCLabel.numberOfLines=0;
        [postCLabel sizeToFit];
        [auditButton addSubview:postCLabel];
        
        
        auditButton.frame=CGRectMake(0, 0, SCREENWIDTH, postCLabel.frame.origin.y+postCLabel.frame.size.height+15);
        auditButton.imageEdgeInsets=UIEdgeInsetsMake((auditButton.frame.size.height-15)/2,SCREENWIDTH-25, (auditButton.frame.size.height-15)/2, 10);
        
        [self addLineLabel:CGRectMake(0, auditButton.frame.size.height-0.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:auditButton];
        
        UIButton *agreeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-100, (auditButton.frame.size.height-30)/2, 40, 30) andBColor:GREENCOLOR andTag:201+i andSEL:@selector(agreeOnclick:) andText:@"同意" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [agreeButton.layer setCornerRadius:5];
        [auditButton addSubview:agreeButton];
        
        UIButton *disAgreeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-50, (auditButton.frame.size.height-30)/2, 40, 30) andBColor:GREENCOLOR andTag:301+i andSEL:@selector(disAgreeOnclick:) andText:@"驳回" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [disAgreeButton.layer setCornerRadius:5];
        [auditButton addSubview:disAgreeButton];
        
        if (i>0) {
            UIButton *upButton=[btnArray objectAtIndex:i-1];
            auditButton.frame=CGRectMake(0, upButton.frame.origin.y+upButton.frame.size.height, SCREENWIDTH, auditButton.frame.size.height);
        }
        [btnArray addObject:auditButton];
        BGSrollView.contentSize=CGSizeMake(0, auditButton.frame.origin.y+auditButton.frame.size.height+40);
    }
}

- (void)choiceOnclick:(UIButton*)button{
    if (button.selected==NO) {
        button.selected=YES;
        [choiceButtonArray addObject:button];
        AuditItem *item=[dataArray objectAtIndex:button.tag-101];
        [idsArray addObject:item];
    }else{
        button.selected=NO;
        [choiceButtonArray removeObject:button];
        AuditItem *item=[dataArray objectAtIndex:button.tag-101];
        [idsArray removeObject:item];
    }
}

- (void)agreeOnclick:(UIButton*)button{
    lastChoiceButton=(UIButton*)button.superview;
    [self showPromptBox:self andMesage:@"确定要同意该申请吗？" andSel:@selector(sureAgree)];
}

- (void)sureAgree{
    [choiceButtonArray addObject:lastChoiceButton];
    AuditItem *item=[dataArray objectAtIndex:lastChoiceButton.tag-101];
    [idsArray addObject:item];
    self.isAgree=@"Y";
    
    [self sendRequest:CHANGEATYPE andPath:CHANGEAURL andSqlParameter:@{@"opttype":@"1",@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],@"ids":[NSString stringWithFormat:@"%d",item.empkey]} and:self];
}


- (void)disAgreeOnclick:(UIButton*)button{
    lastChoiceButton=(UIButton*)button.superview;
    [self showPromptBox:self andMesage:@"确定要驳回该申请吗？" andSel:@selector(sureDisAgree)];
}

- (void)sureDisAgree{
    [choiceButtonArray addObject:lastChoiceButton];
    
    AuditItem *item=[dataArray objectAtIndex:lastChoiceButton.tag-101];
    [idsArray addObject:item];
    self.isAgree=@"N";
    [self sendRequest:CHANGEATYPE andPath:CHANGEAURL andSqlParameter:@{@"opttype":@"0",@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],@"ids":[NSString stringWithFormat:@"%d",item.empkey]} and:self];
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
