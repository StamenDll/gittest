//
//  SearchMyUserViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/8/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SearchMyUserViewController.h"
#import "MyUserViewController.h"
@interface SearchMyUserViewController ()

@end

@implementation SearchMyUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@""];
    [self addLeftButtonItem];
    [self creatUI];
    [self sendRequest:GETUSERTAGTYPE andPath:GETUSERTAGURL andSqlParameter:@{} and:self];
}

- (void)creatUI{
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(0,NAVHEIGHT, SCREENWIDTH,50) andColor:MAINWHITECOLOR];
    [self.view addSubview:titleBGView];
    
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,5, SCREENWIDTH-20,40) andColor:BGGRAYCOLOR];
    [searchBGView.layer setCornerRadius:20];
    [titleBGView addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,14, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 30)];
    searchField.placeholder=@"输入用户姓名、号码、身份证号码进行搜索";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchBGView addSubview:searchField];
    
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT+50,SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT-50)];
    [self.view addSubview:BGScrollView];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:GETUSERTAGTYPE]) {
            NSArray *dataArray=message;
            if (dataArray.count>0){
                mainArray=[[NSMutableArray alloc]initWithArray:dataArray];
                [self addTagView];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)addTagView{
    tagBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH,100) andColor:CLEARCOLOR];
    [BGScrollView addSubview:tagBGView];
    
    NSMutableArray *bgViewArray=[NSMutableArray new];
    for (int i=0; i<mainArray.count; i++) {
        UIView *subBGview=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 100) andColor:CLEARCOLOR];
        subBGview.tag=101+i;
        [tagBGView addSubview:subBGview];
        
        NSDictionary *dataDic=[mainArray objectAtIndex:i];
        UILabel *titleLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:[dataDic objectForKey:@"title"] andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
        [subBGview addSubview:titleLabel];
        
        NSArray *dataArray=[dataDic objectForKey:@"data"];
        NSMutableArray *btnArray=[NSMutableArray new];
        for (int j=0; j<dataArray.count; j++) {
            NSDictionary *subDic=[dataArray objectAtIndex:j];
            UIButton *hBtn=[self addButton:CGRectMake(10, 40, 0, 30) adnColor:MAINWHITECOLOR andTag:101+j andSEL:@selector(sureChoiceh:)];
            [subBGview addSubview:hBtn];
            
            UILabel *hNameLable=[self addLabel:CGRectMake(0, 5,0,20) andText:[subDic objectForKey:@"LValue"] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
            [hNameLable sizeToFit];
            hNameLable.frame=CGRectMake(10, 5, hNameLable.frame.size.width, 20);
            hBtn.frame=CGRectMake(10, 40, hNameLable.frame.size.width+20, 30);
            hBtn.layer.borderWidth=0.5;
            hBtn.layer.borderColor=LINECOLOR.CGColor;
            [hBtn addSubview:hNameLable];
            
            if (j>0) {
                UIButton *upButton=[btnArray objectAtIndex:j-1];
                hBtn.frame=CGRectMake(upButton.frame.origin.x+upButton.frame.size.width+10,upButton.frame.origin.y, hBtn.frame.size.width, 30);
                if (hBtn.frame.origin.x+hBtn.frame.size.width>SCREENWIDTH-10) {
                    hBtn.frame=CGRectMake(10,upButton.frame.origin.y+40, hBtn.frame.size.width, 30);
                }
            }
            [btnArray addObject:hBtn];
            subBGview.frame=CGRectMake(0,subBGview.frame.origin.y, SCREENWIDTH,hBtn.frame.origin.y+hBtn.frame.size.height+10);
        }
        if (i>0) {
            UIView *beforView=[bgViewArray objectAtIndex:i-1];
            subBGview.frame=CGRectMake(0,beforView.frame.origin.y+beforView.frame.size.height+10, SCREENWIDTH,subBGview.frame.size.height);
        }
        [bgViewArray addObject:subBGview];
        
        tagBGView.frame=CGRectMake(0,0, SCREENWIDTH, subBGview.frame.origin.y+subBGview.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, tagBGView.frame.origin.y+tagBGView.frame.size.height+20);
    }
}

- (void)requestFail:(NSString *)type{}


- (void)sureChoiceh:(UIButton*)button{
    UILabel *menuLabel=[[button subviews] firstObject];
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[MyUserViewController class]]) {
            MyUserViewController *mvc=(MyUserViewController*)nvc;
            mvc.state=menuLabel.text;
            mvc.info=@"";
            mvc.isSearch=YES;
            [self.navigationController popToViewController:mvc animated:YES];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[MyUserViewController class]]) {
                MyUserViewController *mvc=(MyUserViewController*)nvc;
                mvc.info=textField.text;
                mvc.state=@"";
                mvc.isSearch=YES;
                [self.navigationController popToViewController:mvc animated:YES];
            }
        }
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
