//
//  ReceiveViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ChoiceCommunityViewController.h"
#import "ReferralViewController.h"
#import "ReferraItem.h"
@interface ReceiveViewController ()

@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"接收确认"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.communityItem) {
        NSLog(@"===============%@",self.communityItem.LName);
        UILabel *communityLabel=[[choiceCommunityButton subviews]firstObject];
        communityLabel.text=self.communityItem.Name;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:mainScrollView];
    
    UIView *labelBackView=[[UIView alloc]initWithFrame:CGRectMake(130, 0,SCREENWIDTH-130,450)];
    labelBackView.backgroundColor=MAINWHITECOLOR;
    [mainScrollView addSubview:labelBackView];
    
    UILabel *resultLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"审核结果" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:resultLabel];
    
    UILabel *agreeLabel=[self addLabel:CGRectMake(140, 15,SCREENWIDTH-150, 29) andText:@"同意" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:agreeLabel];
    
    UILabel *communityLabel=[self addLabel:CGRectMake(15, 65, 100, 20) andText:@"转入社区" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:communityLabel];
    
    choiceCommunityButton=[self addButton:CGRectMake(130,50, SCREENWIDTH-140,50) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceCommutyOnclick:)];
    [mainScrollView addSubview:choiceCommunityButton];
    
    UILabel *communityNLabel=[self addLabel:CGRectMake(10,15,SCREENWIDTH-150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceCommunityButton addSubview:communityNLabel];
    
//    if ([self changeNullString:self.Item.ExportOrg].length>0) {
//        communityNLabel.text=self.Item.ExportOrg;
//    }
    
    UILabel *receiveDNLabel=[self addLabel:CGRectMake(15,115,110, 20) andText:@"接诊医生姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:receiveDNLabel];
    
    docNameField=[[UITextField alloc]initWithFrame:CGRectMake(140, 115, SCREENWIDTH-150, 20)];
    docNameField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    docNameField.textColor=TEXTCOLOR;
    docNameField.delegate=self;
    [mainScrollView addSubview:docNameField];
//    if ([self changeNullString:self.Item.ExportOrg].length>0) {
//        communityNLabel.text=self.Item.ReceptionDoctor;
//    }
    
    
    UILabel *receiveDPLabel=[self addLabel:CGRectMake(15,165,110, 20) andText:@"接诊医生电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:receiveDPLabel];
    
    docPhoneField=[[UITextField alloc]initWithFrame:CGRectMake(140, 165, SCREENWIDTH-150, 20)];
    docPhoneField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    docPhoneField.textColor=TEXTCOLOR;
    docPhoneField.delegate=self;
    [mainScrollView addSubview:docPhoneField];
    //    if ([self changeNullString:self.Item.ExportOrg].length>0) {
    //        communityNLabel.text=self.Item.ReceptionDoctor;
    //    }
    
    UILabel *patientNLabel=[self addLabel:CGRectMake(15,215,110, 20) andText:@"入院联系人姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:patientNLabel];
    
    userNameField=[[UITextField alloc]initWithFrame:CGRectMake(140, 215, SCREENWIDTH-150, 20)];
    userNameField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    userNameField.textColor=TEXTCOLOR;
    userNameField.delegate=self;
    [mainScrollView addSubview:userNameField];
    
    UILabel *patientPLabel=[self addLabel:CGRectMake(15,265,110, 20) andText:@"入院联系人电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:patientPLabel];
    
    userPhoneField=[[UITextField alloc]initWithFrame:CGRectMake(140, 265, SCREENWIDTH-150, 20)];
    userPhoneField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    userPhoneField.textColor=TEXTCOLOR;
    userPhoneField.delegate=self;
    [mainScrollView addSubview:userPhoneField];
    
    UILabel *timeLabel=[self addLabel:CGRectMake(15,315,110, 20) andText:@"入院时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:timeLabel];
    
    choiceDateButton=[self addButton:CGRectMake(130,300, SCREENWIDTH,50) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(addDateChoiceView:)];
    [mainScrollView addSubview:choiceDateButton];
    
    UILabel *dataLabel=[self addLabel:CGRectMake(10,15,SCREENWIDTH-150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceDateButton addSubview:dataLabel];
    
    UILabel *remarkLabel=[self addLabel:CGRectMake(15,395,110, 20) andText:@"备注" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:remarkLabel];

    detailTextView=[[UITextView alloc]initWithFrame:CGRectMake(140, 355, SCREENWIDTH-150,90)];
    detailTextView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    detailTextView.textColor=TEXTCOLOR;
    detailTextView.delegate=self;
    [mainScrollView addSubview:detailTextView];
    
    for (int i=1; i<9; i++) {
        if (i<8) {
            [self addLineLabel:CGRectMake(0, 50*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else{
            [self addLineLabel:CGRectMake(0,450, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }
    }
    
    sureReseiveButton=[self addSimpleButton:CGRectMake(37,labelBackView.frame.origin.y+labelBackView.frame.size.height+60, SCREENWIDTH-75, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureReceive) andText:@"接收" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureReseiveButton.layer setCornerRadius:20];
    [mainScrollView addSubview:sureReseiveButton];
    
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, sureReseiveButton.frame.origin.y+sureReseiveButton.frame.size.height+40);
}

- (void)sureReceive{
    if (sureReseiveButton.selected==NO) {
        sureReseiveButton.selected=YES;
        UILabel *communityLabel=[[choiceCommunityButton subviews]firstObject];
        UILabel *dataLabel=[[choiceDateButton subviews]firstObject];
        [self sendRequest:@"SureReceive" andPath:excuteURL andSqlParameter:@[self.Item.ID,@"同意",communityLabel.text,docNameField.text,docPhoneField.text,userNameField.text,userPhoneField.text,dataLabel.text,detailTextView.text] and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:@"SureReceive"]) {
            sureReseiveButton.selected=NO;
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"接收成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ReferralViewController class]]) {
            ReferralViewController *pvc=(ReferralViewController*)vc;
            pvc.isChange=@"receive";
            [self.navigationController popToViewController:pvc animated:YES];
        }
    }
}

- (void)choiceCommutyOnclick:(UIButton*)button{
    ChoiceCommunityViewController *cvc=[ChoiceCommunityViewController new];
    cvc.whoPush=@"ReceiveR";
    [self.navigationController pushViewController:cvc animated:YES];
}


#pragma mark 选择时间
- (void)addDateChoiceView:(UIButton *)button{
    [self cancelKeyboard];
    if (button.selected==NO) {
        UILabel *label=[[button subviews] lastObject];
        DateChoiceView *dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
        if (label.text.length==0) {
            [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
        }else{
            [dateChoiceView initDateChoiceView:label.text];
        }
        dateChoiceView.delegate=self;
        [self.view addSubview:dateChoiceView];
        button.selected=YES;
    }
    choiceDateButton=button;
}

- (void)cancelKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

/**
 时间选择回调
 */
- (void)sureChoiceDate:(NSDate*)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    UILabel *label=[[choiceDateButton subviews] lastObject];
    label.text=s1;
    choiceDateButton.selected=NO;
}

- (void)cancelChoiceDate{
    choiceDateButton.selected=NO;
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resourcesthat can be recreated.
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
