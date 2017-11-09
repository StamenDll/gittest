//
//  RecipeDetailViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "DrugInfoViewController.h"
@interface RecipeDetailViewController ()

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"处方详情单"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-114)];
    mainScrollView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview: mainScrollView];
    
    UILabel *numberLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"处方编号： 259741235952" andFont:16 andColor:nil andAlignment:0];
    [mainScrollView addSubview:numberLabel];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10,numberLabel.frame.origin.y+numberLabel.frame.size.height+20, SCREENWIDTH-20, 20) andText:@"问诊人： 测试测试" andFont:16 andColor:nil andAlignment:0];
    [mainScrollView addSubview:nameLabel];
    
    UILabel *sicknessLabel=[self addLabel:CGRectMake(10,nameLabel.frame.origin.y+nameLabel.frame.size.height+20,SCREENWIDTH-20, 20) andText:@"疾病名称： 糖尿病" andFont:16 andColor:nil andAlignment:0];
    [mainScrollView addSubview:sicknessLabel];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    UILabel *timeLabel=[self addLabel:CGRectMake(10,sicknessLabel.frame.origin.y+sicknessLabel.frame.size.height+20,SCREENWIDTH-20, 20) andText:[NSString stringWithFormat:@"发病时间： %@",locationString] andFont:16 andColor:nil andAlignment:0];
    [mainScrollView addSubview:timeLabel];
    
    for (int i=1; i<5; i++) {
        [self addLineLabel:CGRectMake(0, 40*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        
    }
    
    UILabel *symptomLabel=[self addLabel:CGRectMake(10,timeLabel.frame.origin.y+timeLabel.frame.size.height+20,80, 20) andText:@"症状:" andFont:16 andColor:nil andAlignment:0];
    [mainScrollView addSubview:symptomLabel];
    
    UILabel *symptomNLabel=[self addLabel:CGRectMake(15,symptomLabel.frame.origin.y+symptomLabel.frame.size.height+10,SCREENWIDTH-30, 20) andText:@"症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状症状" andFont:14 andColor:MAINGRAYCOLOR andAlignment:0];
    symptomNLabel.numberOfLines=0;
    [symptomNLabel sizeToFit];
    [mainScrollView addSubview:symptomNLabel];
    
    [self addLineLabel:CGRectMake(0, symptomNLabel.frame.origin.y+symptomNLabel.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
 
    UILabel *recipeLabel=[self addLabel:CGRectMake(10,symptomNLabel.frame.origin.y+symptomNLabel.frame.size.height+20,80, 20) andText:@"处方:" andFont:16 andColor:nil andAlignment:0];
    [mainScrollView addSubview:recipeLabel];
    
    for (int i=0; i<5; i++) {
        UIImageView *drugImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+((SCREENWIDTH-40)/3+10)*(i%3), recipeLabel.frame.origin.y+recipeLabel.frame.size.height+10+((SCREENWIDTH-40)/3+10)*(i/3), (SCREENWIDTH-40)/3, (SCREENWIDTH-40)/3)];
        drugImageView.backgroundColor=[UIColor grayColor];
        drugImageView.userInteractionEnabled=YES;
        [self addOneTapGestureRecognizer:drugImageView andSel:@selector(drugInfo:)];
        [mainScrollView addSubview:drugImageView];
        
        
        mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, drugImageView.frame.origin.y+drugImageView.frame.size.height+20);
    }
    
    UIButton *sureRecipeButton=[self addSimpleButton:CGRectMake(10, SCREENHEIGHT-45, SCREENWIDTH-20, 40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(sureRecipe:) andText:@"确认处方" andFont:14 andColor:nil andAlignment:1];
    sureRecipeButton.layer.borderColor=LINECOLOR.CGColor;
    sureRecipeButton.layer.borderWidth=0.5;
    [self.view addSubview:sureRecipeButton];
}

- (void)sureRecipe:(UIButton*)button{
    
}

- (void)drugInfo:(UITapGestureRecognizer*)tap{
    DrugInfoViewController *dvc=[DrugInfoViewController new];
    dvc.titleString=@"测试药品";
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:dvc animated:YES];
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
