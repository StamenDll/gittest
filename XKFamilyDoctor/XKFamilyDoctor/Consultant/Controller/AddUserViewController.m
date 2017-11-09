//
//  AddUserViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddUserViewController.h"
#import "CommWriteItme.h"
#import "ChoiceCommunityViewController.h"
#import "ConsultantViewController.h"
@interface AddUserViewController ()

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"添加居民"];
    overArray=[NSMutableArray new];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.communityItem) {
        self.communityLabel.text=self.communityItem.Name;
    }
}

- (void)creatUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-64)];
    [self.view addSubview:mainScrollView];
    
    UIView *whiteBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100, 100)];
    whiteBGView.backgroundColor=[UIColor whiteColor];
    [mainScrollView addSubview:whiteBGView];
    
    NSMutableArray *viewArray=[NSMutableArray new];
    for (int i=0; i<self.dataArray.count; i++) {
        CommWriteItme *item=[self.dataArray objectAtIndex:i];
        NSString *name=item.name;
        NSString *type=item.LValueType;
        NSString *value=item.value;
        
        UILabel *nameLabel=[self addLabel:CGRectMake(15,10,70, 20) andText:name andFont:14 andColor:nil andAlignment:0];
        [mainScrollView addSubview:nameLabel];
        //时间类型
        if ([type isEqualToString:@"时间"]) {
            UIButton *choiceDateBtn=[self addButton:CGRectMake(100,0,SCREENWIDTH-115,50) adnColor:[UIColor whiteColor] andTag:1001+i andSEL:@selector(addDateChoiceView:)];
            [mainScrollView addSubview:choiceDateBtn];
            
            UILabel *dateLabel=[self addLabel:CGRectMake(10,15,200, 20) andText:value andFont:14 andColor:nil andAlignment:0];
            [choiceDateBtn addSubview:dateLabel];
        }
        else if ([type isEqualToString:@"sex"]){
            UIButton *choiceDateBtn=[self addButton:CGRectMake(100,0,SCREENWIDTH-115,50) adnColor:[UIColor whiteColor] andTag:1001+i andSEL:@selector(addMenuChoiceView:)];
            [mainScrollView addSubview:choiceDateBtn];
            
            UILabel *dateLabel=[self addLabel:CGRectMake(10,15,200, 20) andText:value andFont:14 andColor:nil andAlignment:0];
            [choiceDateBtn addSubview:dateLabel];
        }
        
        else if ([type isEqualToString:@"字符"]){
            UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100, 50)];
            textFieldBGView.tag=1001+i;
            [mainScrollView addSubview:textFieldBGView];
            
            UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10,15,SCREENWIDTH-120,20)];
            textField.text=value;
            textField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
            textField.textColor=TEXTCOLOR;
            [textFieldBGView addSubview:textField];
        }
        //会员卡
        else if ([type isEqualToString:@"memberCard"]){
            UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100, 50)];
            textFieldBGView.tag=1001+i;
            [mainScrollView addSubview:textFieldBGView];
            
            memberNumberField=[[UITextField alloc]initWithFrame:CGRectMake(10,15,SCREENWIDTH-170,20)];
            memberNumberField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
            memberNumberField.textColor=TEXTCOLOR;
            [textFieldBGView addSubview:memberNumberField];
            
            UIButton *getMemberNumButton=[self addSimpleButton:CGRectMake(textFieldBGView.frame.size.width-60,10, 50, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(getMemberNum:) andText:@"生成" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
            getMemberNumButton.layer.borderColor=LINECOLOR.CGColor;
            getMemberNumButton.layer.borderWidth=0.5;
            [getMemberNumButton.layer setCornerRadius:15];
            [textFieldBGView addSubview:getMemberNumButton];
        }
        else if ([type isEqualToString:@"code"]){
            UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100, 50)];
            textFieldBGView.tag=1001+i;
            [mainScrollView addSubview:textFieldBGView];
            
            codeField=[[UITextField alloc]initWithFrame:CGRectMake(10,15, SCREENWIDTH-220,20)];
            codeField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
            codeField.textColor=TEXTCOLOR;
            codeField.keyboardType=UIKeyboardTypeNumberPad;
            [textFieldBGView addSubview:codeField];
            
            UIButton *getMemberNumButton=[self addSimpleButton:CGRectMake(textFieldBGView.frame.size.width-110,10,100, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(sendCode:) andText:@"获取验证码" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
            getMemberNumButton.layer.borderColor=LINECOLOR.CGColor;
            getMemberNumButton.layer.borderWidth=0.5;
            [getMemberNumButton.layer setCornerRadius:15];
            [textFieldBGView addSubview:getMemberNumButton];
        }
        else if ([type isEqualToString:@"int"]||[type isEqualToString:@"phone"]){
            UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100,50)];
            textFieldBGView.tag=1001+i;
            [mainScrollView addSubview:textFieldBGView];
            
            UITextField *numberFidle=[[UITextField alloc]initWithFrame:CGRectMake(10,10,SCREENWIDTH-120,20)];
            if (value.length>0) {
                numberFidle.text=[NSString stringWithFormat:@"%d",[value intValue]];
            }
            numberFidle.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
            numberFidle.textColor=TEXTCOLOR;
            numberFidle.keyboardType=UIKeyboardTypeNumberPad;
            [textFieldBGView addSubview:numberFidle];
        }
        else if ([type isEqualToString:@"text"]){
            UIView *textViewBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100,100)];
            textViewBGView.tag=1001+i;
            [mainScrollView addSubview:textViewBGView];
            
            UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(10,5,SCREENWIDTH-120,80)];
            textView.text=value;
            textView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
            textView.textColor=TEXTCOLOR;
            [textViewBGView addSubview:textView];
        }
        else if ([type isEqualToString:@"community"]){
            UIButton *choiceCommunityBtn=[self addButton:CGRectMake(100,0,SCREENWIDTH-115,50) adnColor:[UIColor whiteColor] andTag:1001+i andSEL:@selector(choiceCommutyOnclick:)];
            [mainScrollView addSubview:choiceCommunityBtn];
            
            UILabel *communityLabel=[self addLabel:CGRectMake(10,15,200, 20) andText:value andFont:14 andColor:nil andAlignment:0];
            [choiceCommunityBtn addSubview:communityLabel];
        }
        
        
        UIView *nowView=[self.view viewWithTag:1001+i];
        if (i>0) {
            UIView *beforView=[viewArray objectAtIndex:i-1];
            nowView.frame=CGRectMake(nowView.frame.origin.x, beforView.frame.origin.y+beforView.frame.size.height,nowView.frame.size.width, nowView.frame.size.height);
            nameLabel.center=CGPointMake(nameLabel.center.x, nowView.center.y);
        }
        [self addLineLabel:CGRectMake(0,nowView.frame.origin.y+nowView.frame.size.height-0.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        [viewArray addObject:nowView];
        
        whiteBGView.frame=CGRectMake(100, 0, SCREENWIDTH-100, nowView.frame.origin.y+nowView.frame.size.height);
    }
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake(40,whiteBGView.frame.size.height+40, SCREENWIDTH-80, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(saveData) andText:@"完成" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureButton.layer setCornerRadius:20];
    [mainScrollView addSubview:sureButton];
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, sureButton.frame.origin.y+sureButton.frame.size.height+40);
}


#pragma mark 选择时间
- (void)addDateChoiceView:(UIButton *)button{
    [self cancelKeyboard];
    if (button.selected==NO) {
        UILabel *label=[[button subviews] lastObject];
        DateChoiceView *dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
        [dateChoiceView initDateChoiceView:label.text];
        dateChoiceView.delegate=self;
        [self.view addSubview:dateChoiceView];
        button.selected=YES;
    }
    lastTimeButton=button;
}


/**
 时间选择回调
 */
- (void)sureChoiceDate:(NSDate*)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    UILabel *label=[[lastTimeButton subviews] lastObject];
    label.text=s1;
    lastTimeButton.selected=NO;
}

- (void)cancelChoiceDate{
    lastTimeButton.selected=NO;
}

/**
 性别选择
 */
- (void)addMenuChoiceView:(UIButton *)button{
    [self cancelKeyboard];
    if (button.selected==NO) {
        UILabel *label=[[button subviews] lastObject];
        PMenuChoiceView *menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200, SCREENWIDTH, 200)];
        [menuChoiceView initMenuChoiceView:@[@"男",@"女"] andFirst:label.text];
        menuChoiceView.delegate=self;
        [self.view addSubview:menuChoiceView];
        button.selected=YES;
    }
    lastSexButton=button;
}

/**
 性别选择回调
 */
- (void)sureChoiceMenu:(NSString *)menuString{
    UILabel *label=[[lastSexButton subviews] lastObject];
    label.text=menuString;
    lastSexButton.selected=NO;
}

- (void)cancelChoiceMenu{
    lastSexButton.selected=NO;
}

- (void)getMemberNumber:(UITextField *)textField{
    self.memberTextField=textField;
    [self sendRequest:@"MemberCode" andPath:queryURL andSqlParameter:nil and:self];
}

- (void)getMemberNum:(UIButton*)button{
    UITextField *textField=[[button.superview subviews]firstObject];
    self.memberTextField=textField;
    [self sendRequest:@"MemberCode" andPath:queryURL andSqlParameter:nil and:self];
}

- (void)sendCode:(UIButton *)button{
    if (button.selected==NO) {
        for (int i=0; i<self.dataArray.count; i++) {
            CommWriteItme *item=[self.dataArray objectAtIndex:i];
            if ([item.LValueType isEqualToString:@"phone"]) {
                UIView *subView=[self.view viewWithTag:1001+i];
                UITextField *phoneField=(UITextField *)[[subView subviews] firstObject];
                if ([self checkPhoneNumber:phoneField.text]==NO) {
                    [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
                }else{
                    self.getCodeButton=button;
                    int code = (arc4random() % 1000) + 1000;
                    if (!localCodeDic) {
                        localCodeDic=[NSMutableDictionary new];
                    }
                    [localCodeDic setValue:[NSString stringWithFormat:@"%d",code] forKey:@"code"];
                    [localCodeDic setValue:phoneField.text forKey:@"phone"];
                    NSArray *sqlParameter=@[phoneField.text,[NSString stringWithFormat:@"%d",code]];
                    self.getCodeButton=button;
                    [self sendRequest:@"GetCode" andPath:excuteURL andSqlParameter:sqlParameter and:self];
                    button.selected=YES;
                }
            }
        }
    }
}

- (void)choiceCommutyOnclick:(UIButton*)button{
    self.communityLabel=[[button subviews] firstObject];
    ChoiceCommunityViewController *cvc=[ChoiceCommunityViewController new];
    cvc.whoPush=@"AddUser";
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"MemberCode"]){
            if (data.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                self.memberTextField.text=[self overMemberCod:[[dic objectForKey:@"nid"] stringValue]];
            }
        }else if([type isEqualToString:@"GetCode"]) {
            UILabel *label=[[self.getCodeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            label.textColor=[UIColor grayColor];
            maCount=60;
            [self startAutoScroll];
        }else if([type isEqualToString:@"Login"]) {
            if (data.count>0) {
                [self showSimplePromptBox:self andMesage:@"该手机号已注册!"];
            }else{
              [self sendRequest:@"AddUser" andPath:queryWithoutURL andSqlParameter:overArray and:self];  
            }
        }else if([type isEqualToString:@"AddUser"]) {
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"添加居民成功" preferredStyle:UIAlertControllerStyleAlert];
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
        if ([vc isKindOfClass:[ConsultantViewController class]]) {
            ConsultantViewController *pvc=(ConsultantViewController*)vc;
            pvc.isAdd=@"Y";
            [self.navigationController popToViewController:pvc animated:YES];
        }
    }
}

- (void)startAutoScroll{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
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

- (void)saveData{
    if (overArray) {
        [overArray removeAllObjects];
    }else{
        overArray=[NSMutableArray new];
    }
    for (int i=0; i<self.dataArray.count; i++) {
        CommWriteItme *item=[self.dataArray objectAtIndex:i];
        UIView *subView=[self.view viewWithTag:1001+i];
        UIView *sSubView=[[subView subviews] firstObject];
        if ([sSubView isKindOfClass:[UITextField class]]) {
            UITextField *newSubView=(UITextField *)sSubView;
            item.value=newSubView.text;
        }else if ([sSubView isKindOfClass:[UITextView class]]) {
            UITextView *newSubView=(UITextView *)sSubView;
            item.value=newSubView.text;
        }else if ([sSubView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)sSubView;
            item.value=label.text;
        }
        if (item.isNeed==YES) {
            if ([item.LValueType isEqualToString:@"phone"]&&[self checkPhoneNumber:item.value]==NO) {
                [self showSimplePromptBox:self andMesage:@"请输入正确的手机号！"];
                return;
            }else if([item.LValueType isEqualToString:@"phone"]){
                phoneText=item.value;
            }
            else if ([item.LValueType isEqualToString:@"code"]){
                if (![phoneText isEqualToString:[localCodeDic objectForKey:@"phone"]]||![item.value isEqualToString:[localCodeDic objectForKey:@"code"]]) {
                    [self showSimplePromptBox:self andMesage:@"验证码错误！"];
                    return;
                }
            }
            else if ([item.name isEqualToString:@"确认密码"]){
                CommWriteItme *beforItem=[self.dataArray objectAtIndex:i-1];
                if (![item.value isEqualToString:beforItem.value]) {
                    [self showSimplePromptBox:self andMesage:@"两次密码输入不一致，请重新输入"];
                    return;
                }
            }
            else{
                NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSString *string = [item.value stringByTrimmingCharactersInSet:set];
                if (string.length==0) {
                    [self showSimplePromptBox:self andMesage:[NSString stringWithFormat:@"%@不能为空",item.name]];
                    return;
                }
            }
        }
        if ([item.LValueType isEqualToString:@"community"]) {
            [overArray addObject:[NSString stringWithFormat:@"%d",self.communityItem.id]];
        }else{
            [overArray addObject:item.value];
        }
        
    }
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    [overArray insertObject:[self getUniqueStrByUUID] atIndex:3];
    [overArray insertObject:[NSString stringWithFormat:@"iOS(Version %@)",[[UIDevice currentDevice] systemVersion]] atIndex:11];
    [overArray insertObject:[usd objectForKey:@"LMyWorkCode"] atIndex:12];
    [self sendRequest:@"Login" andPath:queryURL andSqlParameter:@[phoneText,@"居民"] and:self];
}


- (void)cancelKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainScrollView.frame=CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-64-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainScrollView.frame=CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-64);
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
