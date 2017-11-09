//
//  WriteRecipeViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WriteRecipeViewController.h"
#import "CNewsViewController.h"
#import "DateChoiceView.h"
#import "ChoiceDrugViewController.h"
@interface WriteRecipeViewController ()<DateChoiceDelegate>

@end

@implementation WriteRecipeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"开处方"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self creatUI];
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    if (self.isAddDrug.length>0) {
        UIImageView *drugImageView=[[UIImageView alloc]initWithFrame:addDrugButton.frame];
        drugImageView.backgroundColor=[UIColor orangeColor];
        [mainScrollView addSubview:drugImageView];
        
        addDrugButton.frame=CGRectMake(drugImageView.frame.origin.x+drugImageView.frame.size.width+15, addDrugButton.frame.origin.y, addDrugButton.frame.size.width, addDrugButton.frame.size.height);
        if (addDrugButton.frame.origin.x+addDrugButton.frame.size.width>SCREENWIDTH) {
            addDrugButton.frame=CGRectMake(15,drugImageView.frame.origin.y+drugImageView.frame.size.height+15, addDrugButton.frame.size.width, addDrugButton.frame.size.height);
        }
        mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, addDrugButton.frame.origin.y+addDrugButton.frame.size.height+20);
        self.isAddDrug=nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)addRightButtonItem{
    UIButton *rButton=[self addSimpleButton:CGRectMake(0, 0,40,30) andBColor:[UIColor clearColor] andTag:0 andSEL:@selector(sureUpdate:) andText:@"提交" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:2];
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=lItem;
}

- (void)sureUpdate:(UIButton*)button{
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[CNewsViewController class]]) {
            CNewsViewController *cvc=(CNewsViewController*)nvc;
            //cvc.isWiteRecipe=@"Y";
            [self.navigationController popToViewController:cvc animated:YES];
        }
    }
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    mainScrollView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview: mainScrollView];
    
    UILabel *numberLabel=[self addLabel:CGRectMake(15,10, SCREENWIDTH-20, 20) andText:@"处方编号： 259741235952" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:numberLabel];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(15,numberLabel.frame.origin.y+numberLabel.frame.size.height+20, SCREENWIDTH-20, 20) andText:@"问诊人： 测试测试" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:nameLabel];
    
    UILabel *sicknessLabel=[self addLabel:CGRectMake(15,nameLabel.frame.origin.y+nameLabel.frame.size.height+20,75, 20) andText:@"疾病名称:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:sicknessLabel];
    
    sicknessField=[[UITextField alloc]initWithFrame:CGRectMake(90, nameLabel.frame.origin.y+nameLabel.frame.size.height+20, SCREENWIDTH-100, 20)];
    [mainScrollView addSubview:sicknessField];
    
    UIButton *choiceTimeButton=[self addButton:CGRectMake(0, sicknessField.frame.origin.y+sicknessField.frame.size.height+10, SCREENWIDTH,34) adnColor:MAINWHITECOLOR andTag:11 andSEL:@selector(addDateChoiceView:)];
    [mainScrollView addSubview:choiceTimeButton];
    
    UILabel *timeLabel=[self addLabel:CGRectMake(15,10,75, 20) andText:@"发病时间:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceTimeButton addSubview:timeLabel];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 hh时:mm分"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeNLabel=[self addLabel:CGRectMake(90,10, SCREENWIDTH-100, 20) andText:locationString andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceTimeButton addSubview:timeNLabel];
    
    UILabel *symptomLabel=[self addLabel:CGRectMake(15,choiceTimeButton.frame.origin.y+choiceTimeButton.frame.size.height+20,80, 20) andText:@"症状:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:symptomLabel];
    
    UILabel *textNumLabel=[self addLabel:CGRectMake(SCREENWIDTH-95,choiceTimeButton.frame.origin.y+choiceTimeButton.frame.size.height+20,80, 20) andText:@"剩余300" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    textNumLabel.tag=21;
    [mainScrollView addSubview:textNumLabel];
    
    introduceTextView=[[UITextView alloc]initWithFrame:CGRectMake(15, textNumLabel.frame.origin.y+textNumLabel.frame.size.height+10, SCREENWIDTH-30,150)];
    introduceTextView.backgroundColor=LINECOLOR;
    introduceTextView.font=[UIFont systemFontOfSize:MIDDLEFONT];
    introduceTextView.textColor=TEXTCOLOR;
    introduceTextView.delegate=self;
    [mainScrollView addSubview:introduceTextView];
    
    for (int i=1; i<5; i++) {
        [self addLineLabel:CGRectMake(0,40*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];

    }
    [self addLineLabel:CGRectMake(0,introduceTextView.frame.origin.y+introduceTextView.frame.size.height+8,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:mainScrollView];
    
    UILabel *recipeLabel=[self addLabel:CGRectMake(15,introduceTextView.frame.origin.y+introduceTextView.frame.size.height+18,80, 20) andText:@"处方:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:recipeLabel];
    
    addDrugButton=[self addButton:CGRectMake(15, recipeLabel.frame.origin.y+recipeLabel.frame.size.height+10, 70,70) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(addDrug)];
    [addDrugButton setImage:[UIImage imageNamed:@"add_1"] forState:UIControlStateNormal];
    [mainScrollView addSubview:addDrugButton];
    
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH,addDrugButton.frame.origin.y+addDrugButton.frame.size.height+20);
    
}

- (void)addDrug{
    ChoiceDrugViewController *cvc=[ChoiceDrugViewController new];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)addDateChoiceView:(UIButton *)button{
    if (button.selected==NO) {
        DateChoiceView *dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
        [dateChoiceView initDateChoiceView:timeNLabel.text];
        dateChoiceView.delegate=self;
        [self.view addSubview:dateChoiceView];
        button.selected=YES;
    }
}

- (void)sureChoiceDate:(NSDate*)date{
    UIButton *button=[self.view viewWithTag:11];
    button.selected=NO;
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"YYYY年MM月dd日 hh时:mm分"];
    NSString* s1 = [df stringFromDate:date];
    timeNLabel.text=s1;
}

- (void)cancelChoiceDate{
    UIButton *button=[self.view viewWithTag:11];
    button.selected=NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    mainScrollView.contentOffset=CGPointMake(0,introduceTextView.frame.origin.y-40);
}

- (void)textViewDidChange:(UITextView *)textView{
    UILabel *textNumLabel=[self.view viewWithTag:21];
    if (textView.text.length<=300) {
    textNumLabel.text=[NSString stringWithFormat:@"剩余%lu",300-textView.text.length];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location==3000&&![text isEqualToString:@""]) {
        return NO;
    }else if (text.length>300-range.location){
        [self showSimplePromptBox:self andMesage:@"症状描述在300字以内"];
        return NO;
    }
    return YES;
}


//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainScrollView.frame=CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-size.height-64);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainScrollView.frame=CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-64);
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
