//
//  DataDisplayViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DataDisplayViewController.h"
#import "ChoiceCommunityViewController.h"
#import "CommWriteItme.h"
#import "ORItem.h"
#import <objc/runtime.h>
#import "OrderRegisterViewController.h"
#import "FollowUpViewController.h"
#import "ReferralOutCViewController.h"
@interface DataDisplayViewController ()

@end

@implementation DataDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    mainArray=[NSMutableArray new];
    [self addLeftButtonItem];
    [self sendRequest:@"GetModel" andPath:queryURL andSqlParameter:self.tableName and:self];
}


- (void)viewDidAppear:(BOOL)animated{
    if (self.communityItem) {
        dView.communityID=[NSString stringWithFormat:@"%d",self.communityItem.id];
        self.communityLabel.text=self.communityItem.Name;
    }
}

#pragma mark 保存后的处理方法
- (void)saveSuccess:(NSMutableArray *)Array{
    NSMutableArray *sqlParameter=[NSMutableArray new];
    [sqlParameter addObject:self.tableAliasName];
    for (id parameter in Array) {
        [sqlParameter addObject:parameter];
    }
    [self sendRequest:@"CommenUpload" andPath:excuteURL andSqlParameter:sqlParameter and:self];
}

- (void)choiceCommuty:(UIButton *)button{
    self.communityLabel=[[button subviews] firstObject];
    ChoiceCommunityViewController *cvc=[ChoiceCommunityViewController new];
    cvc.whoPush=@"Data";
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)sendCode:(UIButton *)button andData:(NSArray *)sqlParameter{
    self.getCodeButton=button;
    [self sendRequest:@"GetCode" andPath:excuteURL andSqlParameter:sqlParameter and:self];
}

#pragma mark 获取单列表选项代理方法
- (void)getCommenList:(NSString *)tableName andKey:(NSString *)key andWhere:(NSString *)where andButton:(UIButton *)btn andType:(NSString *)type{
    self.listTypeString=type;
    self.getCommenListButton=btn;
    self.commenListKeyArray=[key componentsSeparatedByString:@","];
    [self sendRequest:@"GetCommenList" andPath:queryURL andSqlParameter:@[key,tableName,where] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"GetModel"]) {
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    CommWriteItme *item=[RMMapper objectWithClass:[CommWriteItme class] fromDictionary:dic];
                    [mainArray addObject:item];
                }
                if (self.item) {
                    for (CommWriteItme *item in mainArray) {
                        unsigned int propertyCount = 0;
                        objc_property_t *properties = class_copyPropertyList([self.item class], &propertyCount);
                        for (unsigned int i = 0; i < propertyCount; ++i) {
                            objc_property_t property = properties[i];
                            const char * name = property_getName(property);
                            NSString *str=[NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                            if ([item.LFieldName isEqualToString:str]) {
                                item.LDefaultValue=[self.item valueForKey:str];
                            }
                        }
                        if (self.writeType.length>0) {
                            item.LCanEdit=@"否";
                        }
                    }
                    if (self.writeType.length==0) {
                        if ([self changeNullString:[self.item valueForKey:@"LID"]].length>0) {
                            self.LID=[self.item valueForKey:@"LID"];
                        }else if ([self changeNullString:[self.item valueForKey:@"ID"]].length>0)
                        {
                            self.LID=[self.item valueForKey:@"ID"];
                        }else{
                           self.LID=@"";
                        }
                    }
                }
                
                dView=[[DataDisplayView alloc]initWithFrame:CGRectMake(0, 64, mainWidth, mainHeight-64)];
                dView.delegate=self;
                dView.peopleOnlyID=self.peopleOnlyID;
                dView.peopleMemberID=self.peopleMemberID;
                dView.LID=self.LID;
                [dView initSubViews:mainArray andController:self];
                [self.view addSubview:dView];
            }
        }
        else if ([type isEqualToString:@"GetCode"]){
            UILabel *label=[[self.getCodeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            label.textColor=[UIColor grayColor];
            maCount=60;
            [self startAutoScroll];
        }
        else if ([type isEqualToString:@"GetCommenList"]) {
            if (data.count>0){
                dView.commenListArray=data;
                if (self.listTypeString.length>0) {
                    [dView saveParentArray];
                    self.listTypeString=nil;
                }else{
                    [dView addCommenListView];
                    self.getCommenListButton.selected=NO;
                }
            }
        }
        else if ([type isEqualToString:@"CommenUpload"]) {
                for (UIViewController *nvc in self.navigationController.viewControllers) {
                    if ([self.titleString isEqualToString:@"预约挂号"]) {
                        if ([nvc isKindOfClass:[OrderRegisterViewController class]]) {
                            OrderRegisterViewController *ovc=(OrderRegisterViewController *)nvc;
                            ovc.isChange=@"Y";
                            [self.navigationController popToViewController:ovc animated:YES];
                        }
                    }else if([self.titleString rangeOfString:@"随访"].location!=NSNotFound){
                        if ([nvc isKindOfClass:[FollowUpViewController class]]) {
                            FollowUpViewController *ovc=(FollowUpViewController *)nvc;
                            ovc.isChange=@"Y";
                            [self.navigationController popToViewController:ovc animated:YES];
                        }
                    }else if([self.titleString isEqualToString:@"转诊"]){
                        if ([nvc isKindOfClass:[ReferralOutCViewController class]]) {
                            ReferralOutCViewController *ovc=(ReferralOutCViewController *)nvc;
                            ovc.isChange=@"Y";
                            [self.navigationController popToViewController:ovc animated:YES];
                        }
                    }
                }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}


- (void)scrollToNextPage{
    for (UIView *subView in [self.getCodeButton subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)subView;
            maCount-=1;
            if (maCount>0) {
                label.text=[NSString stringWithFormat:@"重新发送(%ld)",(long)maCount];
                label.textColor=[UIColor grayColor];
            }else{
                label.text=@"获取验证码";
                label.textColor=GREENCOLOR;
                self.getCodeButton.selected=NO;
                [timer invalidate];
                timer=nil;
            }
        }
    }
}

- (void)startAutoScroll{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
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
