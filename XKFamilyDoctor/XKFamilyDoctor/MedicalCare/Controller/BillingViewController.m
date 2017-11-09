//
//  BillingViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BillingViewController.h"
#import "BillingTableViewCell.h"
#import "BuyDrugViewController.h"
#import "OrderDetailViewController.h"
#import "OrderGoodsItem.h"
@interface BillingViewController ()

@end

@implementation BillingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"配送开单"];
    [self addLeftButtonItem];
    choiceDrugArray=[NSMutableArray new];
    orderGoods=[NSMutableArray new];
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.choiceDrugItem) {
        BOOL isHave=NO;
        for (DrugInfoItem *item in choiceDrugArray) {
            if ([item.LID isEqualToString:self.choiceDrugItem.LID]) {
                isHave=YES;
            }
        }
        if (!drugView) {
            drugView=[self addSimpleBackView:CGRectMake(0,addDrugButton.frame.origin.y+addDrugButton.frame.size.height+10, SCREENWIDTH,20) andColor:CLEARCOLOR];
            [mainBGScrollView addSubview:drugView];
            
            UILabel *nameLabel=[self addLabel:CGRectMake(15,0,(SCREENWIDTH-30)/2, 20) andText:@"药品名称" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
            [drugView addSubview:nameLabel];
            
            UILabel *countLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2,0,(SCREENWIDTH-30)/4, 20) andText:@"数量" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
            [drugView addSubview:countLabel];
            
            UILabel *priceLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2+(SCREENWIDTH-30)/4,0,(SCREENWIDTH-30)/4, 20) andText:@"金额" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
            [drugView addSubview:priceLabel];
            
            sureOrderView=[self addSimpleBackView:CGRectMake(0,drugView.frame.origin.y+drugView.frame.size.height+20, SCREENWIDTH,90) andColor:CLEARCOLOR];
            [mainBGScrollView addSubview:sureOrderView];
            
            UILabel *getWayLabel=[self addLabel:CGRectMake(15, 0,70,30) andText:@"配送方式" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
            [sureOrderView addSubview:getWayLabel];
            
            distributionButton=[self addButton:CGRectMake(100, 0, 50, 30) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(getWayByDistribution)];
            [distributionButton setImage:[UIImage imageNamed:@"select_true"] forState:UIControlStateNormal];;
            [distributionButton setImage:[UIImage imageNamed:@"select_vaccine"] forState:UIControlStateSelected];
            distributionButton.imageEdgeInsets=UIEdgeInsetsMake(7.5,0,7.5,35);
            distributionButton.selected=YES;
            getWay=@"配送";
            [sureOrderView addSubview:distributionButton];
            
            UILabel *disLabel=[self addLabel:CGRectMake(10,0, 40, 30) andText:@"配送" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [distributionButton addSubview:disLabel];
            
            getBySelfButton=[self addButton:CGRectMake(180, 0, 50, 30) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(getWayBySelf)];
            [getBySelfButton setImage:[UIImage imageNamed:@"select_true"] forState:UIControlStateNormal];;
            [getBySelfButton setImage:[UIImage imageNamed:@"select_vaccine"] forState:UIControlStateSelected];
            getBySelfButton.imageEdgeInsets=UIEdgeInsetsMake(7.5,0,7.5,35);
            [sureOrderView addSubview:getBySelfButton];
            
            UILabel *getBySelfLabel=[self addLabel:CGRectMake(10,0, 40, 30) andText:@"自取" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [getBySelfButton addSubview:getBySelfLabel];
            
            sureOrderButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-100)/2, 50, 100, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureUploadOrder) andText:@"确认订单" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
            [sureOrderButton.layer setCornerRadius:5];
            [sureOrderView addSubview:sureOrderButton];
        }
        if (isHave==NO) {
            [choiceDrugArray addObject:self.choiceDrugItem];
            OrderGoodsItem *goodsItem=[OrderGoodsItem new];
            goodsItem.LID=self.choiceDrugItem.LID;
            goodsItem.LGoodsName=self.choiceDrugItem.LName;
            goodsItem.LMoney=self.choiceDrugItem.LNewPrice;
            goodsItem.LNumber=1;
            [orderGoods addObject:goodsItem];
            
            UILabel *drugNameLabel=[self addLabel:CGRectMake(15, drugView.frame.size.height+10, (SCREENWIDTH-30)/2-10, 20) andText:self.choiceDrugItem.LName andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
            drugNameLabel.numberOfLines=2;
            [drugNameLabel sizeToFit];
            drugNameLabel.tag=1000+choiceDrugArray.count;
            [drugView addSubview:drugNameLabel];
            
            UITextField *drugCount=[self addTextfield:CGRectMake(15+(SCREENWIDTH-30)/2, drugView.frame.size.height+10,((SCREENWIDTH-30)/4-15)/2,30) andPlaceholder:@"数量" andFont:MIDDLEFONT andTextColor:TEXTCOLORG];
            drugCount.textAlignment=1;
            drugCount.text=@"1";
            drugCount.layer.borderColor=LINECOLOR.CGColor;
            drugCount.layer.borderWidth=0.5;
            drugCount.keyboardType=UIKeyboardTypeNumberPad;
            drugCount.tag=1100+choiceDrugArray.count;
            drugCount.delegate=self;
            [drugView addSubview:drugCount];
            
            UIButton *unitButton=[self addButton:CGRectMake(drugCount.frame.origin.x+drugCount.frame.size.width+5, drugCount.frame.origin.y, ((SCREENWIDTH-30)/4-15)/2, 30) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
            unitButton.layer.borderWidth=0.5;
            unitButton.layer.borderColor=LINECOLOR.CGColor;
            [drugView addSubview:unitButton];
            
            UILabel *unitLabel=[self addLabel:CGRectMake(0, 0, unitButton.frame.size.width,30) andText:@"瓶" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [unitButton addSubview:unitLabel];
            
            UILabel *drugPriceLabel=[self addLabel:CGRectMake(15+(SCREENWIDTH-30)/2+(SCREENWIDTH-30)/4, drugView.frame.size.height+10, (SCREENWIDTH-30)/4, 20) andText:[NSString stringWithFormat:@"￥%.2f",self.choiceDrugItem.LNewPrice] andFont:SMALLFONT andColor:[UIColor redColor] andAlignment:1];
            drugPriceLabel.tag=1200+choiceDrugArray.count;
            [drugView addSubview:drugPriceLabel];
            
            if (drugNameLabel.frame.size.height>=30) {
                drugView.frame=CGRectMake(0, drugView.frame.origin.y, drugView.frame.size.width,drugNameLabel.frame.origin.y+drugNameLabel.frame.size.height);
            }else{
                drugView.frame=CGRectMake(0, drugView.frame.origin.y, drugView.frame.size.width,drugNameLabel.frame.origin.y+30);
            }
            
            sureOrderView.frame=CGRectMake(0,drugView.frame.origin.y+drugView.frame.size.height+20, SCREENWIDTH,90);
            mainBGScrollView.contentSize=CGSizeMake(0, sureOrderView.frame.origin.y+sureOrderView.frame.size.height+20);
            
        }
        self.choiceDrugItem=nil;
    }
}

- (void)getWayByDistribution{
    if (distributionButton.selected==NO) {
        distributionButton.selected=YES;
        getBySelfButton.selected=NO;
        getWay=@"配送";
    }
}

- (void)getWayBySelf{
    if (getBySelfButton.selected==NO) {
        getBySelfButton.selected=YES;
        distributionButton.selected=NO;
        getWay=@"自取";
    }
}

- (void)sureUploadOrder{
    if (sureOrderButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *userNaemString = [nameTextField.text stringByTrimmingCharactersInSet:set];
        if (userNaemString.length==0) {
            [self showSimplePromptBox:self andMesage:@"请输入用户名称！"];
        }else if (![self checkPhoneNumber:phoneTextField.text]) {
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码！"];
        }else{
            sureOrderButton.selected=YES;
            [self sendRequest:@"Login" andPath:queryURL andSqlParameter:@[phoneTextField.text,@"居民"] and:self];
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    sureOrderButton.selected=NO;
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"Login"]){
            self.userCode=@"";
            if (data.count>0){
                NSDictionary *dic=[data objectAtIndex:0];
                self.userCode=[dic objectForKey:@"LOnlyCode"];
            }
            self.oederID=[self getUniqueStrByUUID];
            CGFloat totalMoney=0;
            NSMutableArray *orderDetailArray=[NSMutableArray new];
            for (OrderGoodsItem *item in orderGoods) {
                if (item.LNumber>0) {
                    totalMoney+=item.LMoney;
                    NSArray *dicArray=@[self.oederID,self.userCode,item.LGoodsName,item.LID,[NSString stringWithFormat:@"%.2f",item.LMoney],[NSString stringWithFormat:@"%d",item.LNumber],@""];
                    [orderDetailArray addObject:dicArray];
                }
            }
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            NSArray *orderArray=@[self.oederID,self.userCode,@"保健产品",[NSString stringWithFormat:@"%.2f",totalMoney],[usd objectForKey:@"workorgkey"],[usd objectForKey:@"empkey"],[usd objectForKey:@"empkey"],[usd objectForKey:@"truename"],@"",@"健教商品",@"",@"待收货",@"未付款",@"",nameTextField.text,phoneTextField.text];
            sureOrderButton.selected=YES;
            [self sendRequest:@"SureOrder" andPath:excuteURL andSqlParameter:@[orderArray,orderDetailArray] and:self];
        }else if ([type isEqualToString:@"SureOrder"]){
            OrderDetailViewController *ovc=[OrderDetailViewController new];
            ovc.orderNumber=self.oederID;
            ovc.userCode=self.userCode;
            ovc.orderUserName=nameTextField.text;
            ovc.orderUserPhone=phoneTextField.text;
            ovc.whoPush=@"新订单";
            [self.navigationController pushViewController:ovc animated:YES];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    if ([type isEqualToString:@"Login"]){
        sureOrderButton.selected=NO;
    }else if ([type isEqualToString:@"SureOrder"]){
        sureOrderButton.selected=NO;
    }
    [self showSimplePromptBox:self andMesage:@"服务器开小差了，请稍后重试！"];
}

- (void)creatUI{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
//    if ([[usd objectForKey:@"LRole"] isEqualToString:@"健康顾问"]) {
        mainBGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
        [self.view addSubview:mainBGScrollView];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(15, 10, SCREENWIDTH-30, 20) andText:@"客户姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [mainBGScrollView addSubview:nameLabel];
        
        UIView *nameBGView=[self addSimpleBackView:CGRectMake(15, 40, SCREENWIDTH-30,40) andColor:MAINWHITECOLOR];
        [mainBGScrollView addSubview:nameBGView];
        
        nameTextField=[self addTextfield:CGRectMake(10, 5, SCREENWIDTH-50, 30) andPlaceholder:@"输入客户姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        nameTextField.delegate=self;
        [nameBGView addSubview:nameTextField];
        
        UILabel *phoneLabel=[self addLabel:CGRectMake(15,nameBGView.frame.origin.y+nameBGView.frame.size.height+20, SCREENWIDTH-30, 20) andText:@"客户电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [mainBGScrollView addSubview:phoneLabel];
        
        UIView *phoneBGView=[self addSimpleBackView:CGRectMake(15,phoneLabel.frame.origin.y+phoneLabel.frame.size.height+10, SCREENWIDTH-30,40) andColor:MAINWHITECOLOR];
        [mainBGScrollView addSubview:phoneBGView];
        
        phoneTextField=[self addTextfield:CGRectMake(10, 5, SCREENWIDTH-50, 30) andPlaceholder:@"输入客户电话" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
        phoneTextField.delegate=self;
        [phoneBGView addSubview:phoneTextField];
        
        UILabel *choiceLabel=[self addLabel:CGRectMake(15, phoneBGView.frame.origin.y+phoneBGView.frame.size.height+20, SCREENWIDTH-30, 20) andText:@"选择商品" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [mainBGScrollView addSubview:choiceLabel];
        
        addDrugButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-45, choiceLabel.frame.origin.y-5, 30, 30) andBColor:GREENCOLOR andTag:0 andSEL:@selector(choiceDrug) andText:@"+" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
        [mainBGScrollView addSubview:addDrugButton];
   // }else{
    //    [self addNoDataView];
  //  }
}

- (void)choiceDrug{
    BuyDrugViewController *bvc=[BuyDrugViewController new];
    [self.navigationController pushViewController:bvc animated:YES];
}

#pragma mark 键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainBGScrollView.frame=CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-size.height-64);
}

#pragma mark 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainBGScrollView.frame=CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-50);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag>1000) {
        DrugInfoItem *item=[choiceDrugArray objectAtIndex:textField.tag-1101];
        NSString *allText=nil;
        if (range.location<textField.text.length) {
            allText=[textField.text substringToIndex:range.location];
        }else{
            allText=[NSString stringWithFormat:@"%@%@",textField.text,string];
        }
        UILabel *priceLabel=(UILabel*)[self.view viewWithTag:textField.tag+100];
        priceLabel.text=[NSString stringWithFormat:@"￥%.2f",item.LNewPrice*[allText integerValue]];
        
        OrderGoodsItem *goodsItem=[orderGoods objectAtIndex:textField.tag-1101];
        goodsItem.LNumber=[allText intValue];
        goodsItem.LMoney=item.LNewPrice*[allText integerValue];
        
    }
    return YES;
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
