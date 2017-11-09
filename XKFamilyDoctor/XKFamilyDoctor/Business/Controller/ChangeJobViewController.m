//
//  ChangeJobViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChangeJobViewController.h"
#import "ChoicePostViewController.h"
#import "ChoicePlatetViewController.h"
@interface ChangeJobViewController ()

@end

@implementation ChangeJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"调换岗位"];
    [self addLeftButtonItem];
    [self creatUI];
    
    //workdepartment	16
    //    id	4a8066e0-3b79-11e7-9e9b-f353305b1756
    //    	33
    //    workorgkey	62
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.bdItem) {
        UILabel *namelabel=[[choiceBusinessDep subviews] objectAtIndex:2];
        namelabel.text=self.bdItem.text;
    }
    if (self.orgItem) {
        UILabel *namelabel=[[choiceMechanism subviews] objectAtIndex:2];
        namelabel.text=self.orgItem.orgname;
    }
    if (self.depItem) {
        UILabel *namelabel=[[choiceDepartment subviews] objectAtIndex:2];
        namelabel.text=self.depItem.text;
    }
    if (self.postItem) {
        UILabel *namelabel=[[choicePost subviews] objectAtIndex:2];
        namelabel.text=self.postItem.text;
    }
}

- (void)creatUI{
    mainBGVSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT,SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT)];
    mainBGVSrollView.delegate=self;
    [self.view addSubview:mainBGVSrollView];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    CommenModel *bdItem=[CommenModel new];
    bdItem.key=[[usd objectForKey:@"workplate"] intValue];
    bdItem.text=[usd objectForKey:@"platename"];
    self.bdItem=bdItem;
    
    OrgItem *orgItem=[OrgItem new];
    orgItem.orgkey=[usd objectForKey:@"workorgkey"];
    orgItem.orgname=[usd objectForKey:@"orgname"];
    self.orgItem=orgItem;
    
    CommenModel *depItem=[CommenModel new];
    depItem.key=[[usd objectForKey:@"workdepartment"] intValue];
    depItem.text=[usd objectForKey:@"departmentname"];
    self.depItem=depItem;
    
    CommenModel *postItem=[CommenModel new];
    postItem.key=[[usd objectForKey:@"post"] intValue];
    postItem.text=[usd objectForKey:@"postname"];
    self.postItem=postItem;
    
    choiceBusinessDep=[self addButton:CGRectMake(0,10, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:nil];
    [mainBGVSrollView addSubview:choiceBusinessDep];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choiceBusinessDep];
    
    UILabel *bdLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"事业部" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceBusinessDep addSubview:bdLabel];
    
    UILabel *bdCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:self.bdItem.text andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choiceBusinessDep addSubview:bdCLabel];
    
    
    choiceMechanism=[self addButton:CGRectMake(0,choiceBusinessDep.frame.origin.y+choiceBusinessDep.frame.size.height, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choicePost:)];
    [mainBGVSrollView addSubview:choiceMechanism];
    
    [self addLineLabel:CGRectMake(10, 0, SCREENWIDTH-10, 0.5) andColor:LINECOLOR andBackView:choiceMechanism];
    
    UILabel *departmentLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"机构" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceMechanism addSubview:departmentLabel];
    
    UILabel *departmentCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:self.orgItem.orgname andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choiceMechanism addSubview:departmentCLabel];
    
    UIImageView *dGoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    dGoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [choiceMechanism addSubview:dGoImagView];
    
    choiceDepartment=[self addButton:CGRectMake(0,choiceMechanism.frame.origin.y+choiceMechanism.frame.size.height, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:0 andSEL:nil];
    [mainBGVSrollView addSubview:choiceDepartment];
    
    [self addLineLabel:CGRectMake(10, 0, SCREENWIDTH-10, 0.5) andColor:LINECOLOR andBackView:choiceDepartment];
    
    UILabel *mechanismLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"科室" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceDepartment addSubview:mechanismLabel];
    
    UILabel *mechanismCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:self.depItem.text andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choiceDepartment addSubview:mechanismCLabel];
    
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choiceDepartment];
    
    
    choicePost=[self addButton:CGRectMake(0,choiceDepartment.frame.origin.y+choiceDepartment.frame.size.height, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:0 andSEL:nil];
    [mainBGVSrollView addSubview:choicePost];
    
    [self addLineLabel:CGRectMake(10, 0, SCREENWIDTH-10, 0.5) andColor:LINECOLOR andBackView:choicePost];
    
    UILabel *postLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"岗位" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choicePost addSubview:postLabel];
    
    UILabel *postCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:self.postItem.text andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choicePost addSubview:postCLabel];
    
    
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choicePost];
    
    uploadButton=[self addSimpleButton:CGRectMake(20, choicePost.frame.origin.y+choicePost.frame.size.height+10, SCREENWIDTH-40, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(upload) andText:@"提交" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
    uploadButton.layer.borderColor=GREENCOLOR.CGColor;
    uploadButton.layer.borderWidth=0.5;
    [uploadButton.layer setCornerRadius:25];
    [mainBGVSrollView addSubview:uploadButton];
    
    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
    
}

- (void)upload{
    if (uploadButton.selected==NO) {
        uploadButton.selected=YES;
        [self sendRequest:CHANGEPROTYPE andPath:CHANGEPROAURL andSqlParameter:@{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"id"],@"workorgkey":[NSString stringWithFormat:@"%d",[self.orgItem.orgkey intValue]]} and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    uploadButton.selected=NO;
    if([message isKindOfClass:[NSDictionary class]]){
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        [usd setObject:[NSString stringWithFormat:@"%@",self.orgItem.orgkey] forKey:@"workorgkey"];
        [usd setObject:self.orgItem.orgname forKey:@"orgname"];
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"岗位信息修改成功！" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:av animated:YES completion:nil];
        [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
        
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestFail:(NSString *)type{
    uploadButton.selected=NO;
}

- (void)choicePost:(UIButton*)button{
    
    if (button==choiceMechanism){
        ChoicePlatetViewController *cvc=[ChoicePlatetViewController new];
        cvc.whoPush=@"C";
        cvc.titleString=@"选择机构";
        cvc.parentID=@"0";
        [self.navigationController pushViewController:cvc animated:YES];
    }else{
        ChoicePostViewController *cvc=[ChoicePostViewController new];
        cvc.whoPush=@"C";
        if (button==choiceBusinessDep) {
            cvc.titleString=@"选择事业部";
            
        }else if (button==choicePost){
            cvc.titleString=@"选择岗位";
            
        }else{
            cvc.titleString=@"选择科室";
        }
        [self.navigationController pushViewController:cvc animated:YES];
    }
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
