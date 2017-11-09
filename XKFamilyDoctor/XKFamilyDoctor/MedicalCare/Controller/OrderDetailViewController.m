//
//  OrderDetailViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "SQLItem.h"
#import "WXApi.h"
#import "OrderGoodsItem.h"
#import "OrderItem.h"
@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"订单详情"];
    [self addLeftButtonItem];
    goodsArray=[NSMutableArray new];
    [self sendRequest:@"OrderDetail" andPath:queryURL andSqlParameter:self.orderNumber and:self];
}

- (void)popViewController{
    if ([self.whoPush isEqualToString:@"center"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    if ([self.payIsSuccess isEqualToString:@"Y"]) {
        [self sureChoice];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}
//weixin：//wxpay/bizpayurl?sign=94DC8A4E0F60F23C5FBA918A7C51212A&appid=wxf3aebb36fd9bf92c&mch_id=1481755842&product_id=wx20171107095605835be7c4800842640881&time_stamp=1510019363&nonce_str=OQB74i7DBEG9BGL9CL58

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([type isEqualToString:@"WxPay"]) {
        NSLog(@"weixin=====================%@",message);
        if ([message rangeOfString:@"prepayid"].location!=NSNotFound) {
            PayReq *request = [[PayReq alloc] init];
            request.openID= [self getSubstringWithRange:@"<appid>" andEString:@"</appid>" andSuperString:message];
            request.partnerId =[self getSubstringWithRange:@"<partnerid>" andEString:@"</partnerid>" andSuperString:message];
            request.prepayId= [self getSubstringWithRange:@"<prepayid>" andEString:@"</prepayid>" andSuperString:message];
            request.package =@"Sign=WXPay";
            request.nonceStr= [self getSubstringWithRange:@"<noncestr>" andEString:@"</noncestr>" andSuperString:message];
            request.timeStamp= [[self getSubstringWithRange:@"<timestamp>" andEString:@"</timestamp>" andSuperString:message] intValue];
            request.sign= [self getSubstringWithRange:@"<sign>" andEString:@"</sign>" andSuperString:message];
            [WXApi sendReq:request];
        }else{
            [self showSimplePromptBox:self andMesage:@"获取支付信息失败，请稍候重试！"];
        }
    }else if ([message isKindOfClass:[NSArray class]]){
        NSArray *data=message;
        if ([type isEqualToString:@"OrderDetail"]) {
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    OrderGoodsItem *item=[RMMapper objectWithClass:[OrderGoodsItem class] fromDictionary:dic];
                    [goodsArray addObject:item];
                }
                [self creatUI];
            }
        }else  if ([type isEqualToString:@"GetCode"]) {
            UILabel *label=[[getCodeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            label.textColor=[UIColor grayColor];
            maCount=60;
            [self startAutoScroll];
        }
        else if ([type isEqualToString:@"MemberOrderList"]){
            if (data.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                OrderItem *item=[RMMapper objectWithClass:[OrderItem class] fromDictionary:dic];
                if ([item.LState rangeOfString:@"未付"].location!=NSNotFound) {
                    [self showSimplePromptBox:self andMesage:@"该用户暂未完成支付，请核对后重试！"];
                }else{
                    [self sureChoice];
                    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                    [self sendRequest:@"GetSureOrderCode" andPath:excuteURL andSqlParameter:@[self.orderUserPhone,[usd objectForKey:@"LName"],self.VCode] and:self];
                }
            }
        }else if ([type isEqualToString:@"ChangeOrderState"]) {
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"确定交货成功，订单已完成！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
        }
    }
    else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestFail:(NSString *)type{
    [self showSimplePromptBox:self andMesage:@"服务器开小差了"];
}

- (NSString*)getSubstringWithRange:(NSString*)fString andEString:(NSString*)eString andSuperString:(NSString*)string{
    NSRange startRange = [string rangeOfString:fString];
    NSRange endRange = [string rangeOfString:eString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [string substringWithRange:range];
}

- (void)creatUI{
    mainBGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:mainBGScrollView];
    
    UIView *fBGView=[self addSimpleBackView:CGRectMake(0, 10, SCREENWIDTH, 100) andColor:MAINWHITECOLOR];
    [mainBGScrollView addSubview:fBGView];
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBGView];
    [self addLineLabel:CGRectMake(0, 100, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBGView];
    
    UILabel *orderNumberLabel=[self addLabel:CGRectMake(15, 10, SCREENWIDTH-30,20) andText:[NSString stringWithFormat:@"订单编号  %@",self.orderNumber] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:orderNumberLabel];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(15,40, SCREENWIDTH-30,20) andText:[NSString stringWithFormat:@"客户姓名  %@",self.orderUserName] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:nameLabel];
    
    UILabel *phoneLabel=[self addLabel:CGRectMake(15,70, SCREENWIDTH-30,20) andText:[NSString stringWithFormat:@"客户电话  %@",self.orderUserPhone] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:phoneLabel];
    
    UIView *sBGView=[self addSimpleBackView:CGRectMake(0, fBGView.frame.origin.y+fBGView.frame.size.height+10, SCREENWIDTH, 100) andColor:MAINWHITECOLOR];
    [mainBGScrollView addSubview:sBGView];
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sBGView];
    
    UILabel *orderDetailLabel=[self addLabel:CGRectMake(15, 10, SCREENWIDTH-30,20) andText:@"商品详情" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [sBGView addSubview:orderDetailLabel];
    
    UILabel *dNameLabel=[self addLabel:CGRectMake(15,40,(SCREENWIDTH-30)/2, 20) andText:@"药品名称" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
    [sBGView addSubview:dNameLabel];
    
    UILabel *countLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2,40,(SCREENWIDTH-30)/4, 20) andText:@"数量" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
    [sBGView addSubview:countLabel];
    
    UILabel *priceLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2+(SCREENWIDTH-30)/4,40,(SCREENWIDTH-30)/4, 20) andText:@"金额" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
    [sBGView addSubview:priceLabel];
    
    UIView *drugBGView=[self addSimpleBackView:CGRectMake(0, 70, SCREENWIDTH,0) andColor:CLEARCOLOR];
    [sBGView addSubview:drugBGView];
    
    UILabel *totalMoneyLabel=[self addLabel:CGRectMake(15, drugBGView.frame.origin.y+drugBGView.frame.size.height+10, SCREENWIDTH-30, 20) andText:@"" andFont:BIGFONT andColor:GREENCOLOR andAlignment:0];
    [sBGView addSubview:totalMoneyLabel];
    
    for (int i=0; i<goodsArray.count; i++) {
        OrderGoodsItem *item=[goodsArray objectAtIndex:i];
        totleMoney+=item.LMoney;
        UILabel *drugNameLabel=[self addLabel:CGRectMake(15, drugBGView.frame.size.height+10, (SCREENWIDTH-30)/2-10, 20) andText:item.LGoodsName andFont:SMALLFONT andColor:[UIColor redColor] andAlignment:0];
        drugNameLabel.numberOfLines=2;
        [drugNameLabel sizeToFit];
        [drugBGView addSubview:drugNameLabel];
        
        UILabel *drugCountLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2, drugBGView.frame.size.height+10, (SCREENWIDTH-30)/4, 20) andText:[NSString stringWithFormat:@"%d%@",item.LNumber,item.LUnit] andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
        [drugBGView addSubview:drugCountLabel];
        
        UILabel *drugPriceLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2+(SCREENWIDTH-30)/4, drugBGView.frame.size.height+10, (SCREENWIDTH-30)/4, 20) andText:[NSString stringWithFormat:@"￥%.2f",item.LMoney] andFont:SMALLFONT andColor:[UIColor redColor] andAlignment:1];
        [drugBGView addSubview:drugPriceLabel];
        
        if (drugNameLabel.frame.size.height>=30) {
            drugBGView.frame=CGRectMake(0, drugBGView.frame.origin.y, drugBGView.frame.size.width,drugNameLabel.frame.origin.y+drugNameLabel.frame.size.height);
        }else{
            drugBGView.frame=CGRectMake(0, drugBGView.frame.origin.y, drugBGView.frame.size.width,drugNameLabel.frame.origin.y+30);
        }
    }
    totalMoneyLabel.frame=CGRectMake(15, drugBGView.frame.origin.y+drugBGView.frame.size.height+10, SCREENWIDTH-30, 20);
    totalMoneyLabel.attributedText=[self setString:[NSString stringWithFormat:@"总金额  ￥%.2f",totleMoney] andSubString:@"总金额" andDifColor:TEXTCOLOR];
    
    
    UILabel *getWayLabel=[self addLabel:CGRectMake(15, totalMoneyLabel.frame.origin.y+totalMoneyLabel.frame.size.height+20, SCREENWIDTH-30, 20) andText:@"" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    getWayLabel.attributedText=[self setString:@"配送方式   配送" andSubString:@" 配送" andDifColor:GREENCOLOR];
    [sBGView addSubview:getWayLabel];
    
    sBGView.frame=CGRectMake(0, sBGView.frame.origin.y, sBGView.frame.size.width, getWayLabel.frame.origin.y+getWayLabel.frame.size.height+10);
    [self addLineLabel:CGRectMake(0,sBGView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sBGView];
    
    if ((self.orderItem&&[self.orderItem.LState rangeOfString:@"未付"].location!=NSNotFound)||[self.whoPush isEqualToString:@"新订单"]){
        payByCashButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-100)/2, sBGView.frame.origin.y+sBGView.frame.size.height+10, 100, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(payByCash) andText:@"现金支付" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [payByCashButton.layer setCornerRadius:5];
        [mainBGScrollView addSubview:payByCashButton];
        
        mainBGScrollView.contentSize=CGSizeMake(0, payOnlineButton.frame.origin.y+payOnlineButton.frame.size.height+40);
    }else if([self.orderItem.LSendSta rangeOfString:@"已交货"].location==NSNotFound){
        UIView *tBGview=[self addSimpleBackView:CGRectMake(0, sBGView.frame.origin.y+sBGView.frame.size.height+10, SCREENWIDTH,90) andColor:MAINWHITECOLOR];
        [mainBGScrollView addSubview:tBGview];
        
        [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sBGView];
        [self addLineLabel:CGRectMake(0,sBGView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sBGView];
        
        UILabel *codeLabel=[self addLabel:CGRectMake(15, 10,SCREENWIDTH-30,30) andText:@"收货验证码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [tBGview addSubview:codeLabel];
        
        UIView *codeBGView=[self addSimpleBackView:CGRectMake(15, codeLabel.frame.origin.y+codeLabel.frame.size.height+10,SCREENWIDTH-120, 30) andColor:MAINWHITECOLOR];
        codeBGView.layer.borderColor=LINECOLOR.CGColor;
        codeBGView.layer.borderWidth=0.5;
        [tBGview addSubview:codeBGView];
        
        codeTextField=[self addTextfield:CGRectMake(5, 0,codeBGView.frame.size.width-10, 30) andPlaceholder:@"输入收货验证码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        codeTextField.delegate=self;
        [codeBGView addSubview:codeTextField];
        
        getCodeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-95,codeLabel.frame.origin.y+codeLabel.frame.size.height+10,80,30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(getCode:) andText:@"发送验证码" andFont:SMALLFONT andColor:GREENCOLOR andAlignment:1];
        getCodeButton.layer.borderColor=GREENCOLOR.CGColor;
        getCodeButton.layer.borderWidth=0.5;
        [getCodeButton.layer setCornerRadius:15];
        [codeBGView addSubview:getCodeButton];
        
        sureFinishButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-100)/2, tBGview.frame.origin.y+tBGview.frame.size.height+40, 100, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureOver) andText:@"确认交货" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [sureFinishButton.layer setCornerRadius:5];
        [mainBGScrollView addSubview:sureFinishButton];
        
        mainBGScrollView.contentSize=CGSizeMake(0, sureFinishButton.frame.origin.y+sureFinishButton.frame.size.height+40);
    }
}

- (void)getCode:(UIButton*)button{
    if (button.selected==NO) {
            int code = (arc4random() % 1000) + 1000;
            self.codeString=[NSString stringWithFormat:@"%d",code];
            NSLog(@"=+%@",self.codeString);
        [self sendRequest:@"GetCode" andPath:excuteURL andSqlParameter:@[self.orderUserPhone,[NSString stringWithFormat:@"您好，您的收货验证码为：%@，有效期10分钟。",self.codeString]] and:self];
            button.selected=YES;
    }
}

- (void)scrollToNextPage{
    for (UIView *subView in [getCodeButton subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)subView;
            maCount-=1;
            if (maCount>0) {
                label.text=[NSString stringWithFormat:@"重新发送(%ld)",(long)maCount];
                label.textColor=[UIColor grayColor];
            }else{
                label.text=@"获取验证码";
                label.textColor=[UIColor blackColor];
                getCodeButton.selected=NO;
                [timer invalidate];
                timer=nil;
            }
        }
    }
}

- (void)startAutoScroll{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}




- (void)payOnline{
    [self sendRequest:@"MemberOrderList" andPath:queryURL andSqlParameter:self.orderNumber and:self];
}

- (void)payByCash{
    SQLItem *item=[SQLItem new];
    OrderGoodsItem *goodsItem=[goodsArray objectAtIndex:0];
    NSString *sqlString=[item returnSqlString:@[[NSString stringWithFormat:@"%.0f",totleMoney*100],goodsItem.LOnlyCode,goodsItem.LBillId] andType:@"WxPay"];
    selfRequest=[[SelfRequestClass alloc]init];
    selfRequest.path=[NSString stringWithFormat:@"%@%@",GETWXPAY,sqlString];
    selfRequest.type=@"WxPay";
    selfRequest.delegate=self;
    [selfRequest startGetRequestInfo];
}

- (void)sureChoice{
    payByCashButton.hidden=YES;
    payOnlineButton.hidden=YES;
    
    UIView *tBGview=[self addSimpleBackView:CGRectMake(0, payByCashButton.frame.origin.y, SCREENWIDTH,90) andColor:MAINWHITECOLOR];
    [mainBGScrollView addSubview:tBGview];
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:tBGview];
    [self addLineLabel:CGRectMake(0,tBGview.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:tBGview];
    
    UILabel *codeLabel=[self addLabel:CGRectMake(15, 10,SCREENWIDTH-30,30) andText:@"收货验证码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [tBGview addSubview:codeLabel];
    
    UIView *codeBGView=[self addSimpleBackView:CGRectMake(15, codeLabel.frame.origin.y+codeLabel.frame.size.height+10,SCREENWIDTH-120, 30) andColor:MAINWHITECOLOR];
    codeBGView.layer.borderColor=LINECOLOR.CGColor;
    codeBGView.layer.borderWidth=0.5;
    [tBGview addSubview:codeBGView];
    
    codeTextField=[self addTextfield:CGRectMake(5, 0,codeBGView.frame.size.width-10, 30) andPlaceholder:@"输入收货验证码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    codeTextField.delegate=self;
    [codeBGView addSubview:codeTextField];
    
    getCodeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-95,codeLabel.frame.origin.y+codeLabel.frame.size.height+10,80,30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(getCode:) andText:@"发送验证码" andFont:SMALLFONT andColor:GREENCOLOR andAlignment:1];
    getCodeButton.layer.borderColor=GREENCOLOR.CGColor;
    getCodeButton.layer.borderWidth=0.5;
    [getCodeButton.layer setCornerRadius:15];
    [tBGview addSubview:getCodeButton];
    
    sureFinishButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-100)/2, tBGview.frame.origin.y+tBGview.frame.size.height+40, 100, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureOver) andText:@"确认交货" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureFinishButton.layer setCornerRadius:5];
    [mainBGScrollView addSubview:sureFinishButton];
    
    mainBGScrollView.contentSize=CGSizeMake(0, sureFinishButton.frame.origin.y+sureFinishButton.frame.size.height+40);
}

- (void)sureOver{
    if (sureFinishButton.selected==NO) {
        sureFinishButton.selected=YES;
        if (![codeTextField.text isEqualToString:self.codeString]) {
            [self showSimplePromptBox:self andMesage:@"收货验证码不正确！"];
        }else{
            [self sendRequest:@"ChangeOrderState" andPath:excuteURL andSqlParameter:@[@"已交货",self.orderNumber] and:self];
        }
    }
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainBGScrollView.frame=CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-size.height-64);
    mainBGScrollView.contentOffset=CGPointMake(0, codeTextField.superview.superview.frame.origin.y-100);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainBGScrollView.frame=CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-64);
    mainBGScrollView.contentOffset=CGPointMake(0,0);
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
