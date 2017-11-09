//
//  ChangeInfoViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()<UITextFieldDelegate>

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"修改资料"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)creatUI{
    mainBGVSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH, SCREENHEIGHT-64)];
    mainBGVSrollView.delegate=self;
    [self.view addSubview:mainBGVSrollView];
    
    UIView *IDcardInfoView=[self addSimpleBackView:CGRectMake(0,15, SCREENWIDTH,200) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:IDcardInfoView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    [self addLineLabel:CGRectMake(0,200, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10, 15, 70,20) andText:@"姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:nameLabel];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    nameTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nameTextField.delegate=self;
    nameTextField.text=[usd objectForKey:@"truename"];
    nameTextField.textAlignment=2;
    [IDcardInfoView addSubview:nameTextField];
    
//    UIButton *birDateButton=[self addButton:CGRectMake(0, 50, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceDate)];
//    [IDcardInfoView addSubview:birDateButton];
    
//    UILabel *dateLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"出生日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
//    [birDateButton addSubview:dateLabel];
    
//   birDateLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-100, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
//    [birDateButton addSubview:birDateLabel];
    
    sexButton=[self addButton:CGRectMake(0, 50, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceSex:)];
    [IDcardInfoView addSubview:sexButton];
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"性别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [sexButton addSubview:sexLabel];
    
    sexNumLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-100, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    sexNumLabel.text=[usd objectForKey:@"gender"];
    [sexButton addSubview:sexNumLabel];
    
//    UILabel *nationLabel=[self addLabel:CGRectMake(10, 165,70, 20) andText:@"民族" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
//    [IDcardInfoView addSubview:nationLabel];
    
//    nationTextField=[self addTextfield:CGRectMake(90,160, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
//    nationTextField.delegate=self;
//    nationTextField.textAlignment=2;
//   [IDcardInfoView addSubview:nationTextField];
    
    UILabel *addressLabel=[self addLabel:CGRectMake(10, 115,70, 20) andText:@"住址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:addressLabel];
    
    addressTextField=[self addTextfield:CGRectMake(90,110, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    addressTextField.delegate=self;
    addressTextField.text=[usd objectForKey:@"address"];
    addressTextField.textAlignment=2;
    [IDcardInfoView addSubview:addressTextField];
    
    UILabel *IDCardLabel=[self addLabel:CGRectMake(10, 165,70, 20) andText:@"身份证号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:IDCardLabel];
    
    IDCardTextField=[self addTextfield:CGRectMake(90,160, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    IDCardTextField.delegate=self;
    IDCardTextField.textAlignment=2;
    IDCardTextField.text=[usd objectForKey:@"idno"];
    [IDcardInfoView addSubview:IDCardTextField];
    
    for (int i=0; i<3; i++) {
        [self addLineLabel:CGRectMake(10, 50*(i+1),SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    }
    
    uploadButton=[self addSimpleButton:CGRectMake(20, IDcardInfoView.frame.origin.y+IDcardInfoView.frame.size.height+10, SCREENWIDTH-40, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(upload) andText:@"提交" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
    uploadButton.layer.borderColor=GREENCOLOR.CGColor;
    uploadButton.layer.borderWidth=0.5;
    [uploadButton.layer setCornerRadius:25];
    [mainBGVSrollView addSubview:uploadButton];
    
    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
}

- (void)upload{
    if (uploadButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *name = [nameTextField.text stringByTrimmingCharactersInSet:set];
        NSString *address = [addressTextField.text stringByTrimmingCharactersInSet:set];
        NSString *IDCard = [IDCardTextField.text stringByTrimmingCharactersInSet:set];
        if (name.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入您的真实姓名！"];
        }else if (sexNumLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择您的性别！"];
        }else if (address.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入您的住址信息！"];
        }else if (IDCard.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入您的身份证号码！"];
        }else{
            [self sendRequest:SAVEDATATYPE andPath:SAVEDATAURL andSqlParameter:@{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"id"],@"mobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"],@"truename":name,@"idno":IDCard,@"gender":sexNumLabel.text,@"address":address} and:self];
            uploadButton.selected=YES;
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    uploadButton.selected=NO;
    if([message isKindOfClass:[NSDictionary class]]){
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        [usd setObject:nameTextField.text forKey:@"truename"];
        
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"信息修改成功！" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:av animated:YES completion:nil];
        
        [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFail:(NSString *)type{
    uploadButton.selected=NO;
    [self showSimplePromptBox:self andMesage:@"服务器开小差了，请稍后重试！"];
}

- (void)choiceDate{
    [self.view endEditing:YES];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
        dateChoiceView=nil;
    }
    dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
    [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
    dateChoiceView.delegate=self;
    [self.view addSubview:dateChoiceView];
}

- (void)sureChoiceDate:(NSDate *)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    birDateLabel.text=s1;
}

- (void)cancelChoiceDate{}

- (void)choiceSex:(UIButton*)button{
    NSMutableArray *sexArray=[NSMutableArray arrayWithObjects:@"男",@"女", nil];
    [self addChoiceView:sexArray];
}

- (void)addChoiceView:(NSMutableArray*)array{
    [self.view endEditing:YES];
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200, SCREENWIDTH, 200)];
    [menuChoiceView initMenuChoiceView:array andFirst:[array objectAtIndex:0]];
    menuChoiceView.delegate=self;
    [self.view addSubview:menuChoiceView];
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-200);
}

- (void)cancelChoiceMenu{
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)sureChoiceMenu:(NSString *)menuString{
    sexNumLabel.text=menuString;
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64);
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
