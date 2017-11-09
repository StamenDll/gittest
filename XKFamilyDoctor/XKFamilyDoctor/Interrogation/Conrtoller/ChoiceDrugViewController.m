//
//  ChoiceDrugViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChoiceDrugViewController.h"
#import "ChoiceDrugTableViewCell.h"
#import "DrugInfoViewController.h"
@interface ChoiceDrugViewController ()

@end

@implementation ChoiceDrugViewController
#define CELLHIGHT ((SCREENWIDTH-19)/2-16)*0.6+110
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=MAINWHITECOLOR;
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)creatUI{
    UIImageView *searchVBackView=[[UIImageView alloc]initWithFrame:CGRectMake(15,28, SCREENWIDTH-70,29)];
    searchVBackView.image=[UIImage imageNamed:@"rec_search_3"];
    [self.view addSubview:searchVBackView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchVBackView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 20)];
    searchField.placeholder=@"搜索";
    searchField.font=[UIFont systemFontOfSize:12];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchVBackView addSubview:searchField];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-50,28, 40, 30) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(cancelSearch) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [self.view addSubview:cancelButton];
    
    [self addLineLabel:CGRectMake(0, 69.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    [self creatHistoryView];
}

- (void)creatHistoryView{
    historyView=[[UIView alloc]initWithFrame:CGRectMake(0,65, SCREENWIDTH,SCREENHEIGHT-65)];
    historyView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:historyView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:historyView];
    
    NSString * fileName = @"drugHistory.txt";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *array =[NSArray arrayWithContentsOfFile:path];
    
    if (array.count==0) {
        UILabel *hTitleLabel=[self addLabel:CGRectMake(0,20,SCREENWIDTH, 20) andText:@"暂无搜索纪录" andFont:BIGFONT andColor:TEXTCOLORDG andAlignment:1];
        [historyView addSubview:hTitleLabel];
    }else{
        historyView.backgroundColor=BGGRAYCOLOR;
        
        UILabel *hTitleLabel=[self addLabel:CGRectMake(15,12.5, 100, 20) andText:@"搜索历史" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [historyView addSubview:hTitleLabel];
        
        UIButton *delButton=[self addButton:CGRectMake(SCREENWIDTH-45,0,45,45) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(deleteHistory)];
        [delButton setImage:[UIImage imageNamed:@"dustbin"] forState:UIControlStateNormal];
        delButton.imageEdgeInsets=UIEdgeInsetsMake(14.5, 14, 14.5, 15);
        [historyView addSubview:delButton];
    
        
        for (int i=0; i<array.count; i++) {
            UIButton *hButton=[self addButton:CGRectMake(0,45+45*i,SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(sureChoice:)];
            [historyView addSubview:hButton];
            
            UILabel *hNameLabel=[self addLabel:CGRectMake(15,12.5,SCREENWIDTH-30,20) andText:[array objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
            [hButton addSubview:hNameLabel];
            
            if (i==array.count-1) {
                [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:hButton];
            }else{
                [self addLineLabel:CGRectMake(15, 44.5, SCREENWIDTH-15, 0.5) andColor:LINECOLOR andBackView:hButton];
            }
        }
        
            [self addLineLabel:CGRectMake(0,45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:historyView];
    }
}

- (void)sureChoice:(UIButton*)button{
    UILabel *label=[[button subviews]lastObject];
    searchField.text=label.text;
    [searchField resignFirstResponder];
    [historyView removeFromSuperview];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70, mainWidth, mainHeight-70) style:UITableViewStylePlain];
    mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    [self.view addSubview:mainTableView];
}

- (void)deleteHistory{
    [self showPromptBox:self andMesage:@"确定要删除搜索记录吗？" andSel:@selector(sureDel)];
}

- (void)sureDel{
    NSString * fileName=@"drugHistory.txt";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *array =[NSArray arrayWithContentsOfFile:path];
    [array removeAllObjects];
    [array writeToFile:path atomically:YES];
    for (UIView *view in historyView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *noLabel=[self addLabel:CGRectMake(0,20,SCREENWIDTH, 20) andText:@"暂无搜索记录" andFont:BIGFONT andColor:TEXTCOLORDG andAlignment:1];
    [historyView addSubview:noLabel];
}


- (void)cancelSearch{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        NSMutableArray *array;
        NSString * fileName = @"drugHistory.txt";
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                           , NSUserDomainMask
                                                           , YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
        array=[NSArray arrayWithContentsOfFile:path];
        BOOL isHave=NO;
        if (array.count>0) {
            for (NSString *str in array) {
                if ([searchField.text isEqualToString:str]) {
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                if (array.count>7) {
                    [array removeObjectAtIndex:0];
                    [array addObject:searchField.text];
                    [array writeToFile:path atomically:YES];
                }else{
                    [array addObject:searchField.text];
                    [array writeToFile:path atomically:YES];
                    
                }
            }
        }else{
            array=[[NSMutableArray alloc]init];
            [array addObject:searchField.text];
            [array writeToFile:path atomically:YES];
        }
        [textField resignFirstResponder];
        [historyView removeFromSuperview];
        
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70, mainWidth, mainHeight-70) style:UITableViewStylePlain];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        [self.view addSubview:mainTableView];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELLHIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchTableViewCell";
    ChoiceDrugTableViewCell *cell = (ChoiceDrugTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ChoiceDrugTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor=BGGRAYCOLOR;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSArray *btnArray=[NSArray arrayWithObjects:cell.drugBackViewO,cell.drugBackViewT, nil];
    NSArray *imageArray=[NSArray arrayWithObjects:cell.drugImageViewO,cell.drugImageViewT, nil];
    NSArray *signImageArray=[NSArray arrayWithObjects:cell.signImageViewO,cell.signImageViewT, nil];
    NSArray *nameLabelArray=[NSArray arrayWithObjects:cell.drugNameLabelO,cell.drugNameLabelT, nil];
    NSArray *priceLabelArray=[NSArray arrayWithObjects:cell.priceLabelO,cell.priceLabelT,nil];
    NSArray *addBtnArray=[NSArray arrayWithObjects:cell.addButtonO,cell.addButtonT,nil];
    NSInteger index=indexPath.row*2;
    for (UIButton *drugButton in btnArray){
        drugButton.backgroundColor=MAINWHITECOLOR;
        [drugButton addTarget:self action:@selector(drugInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *drugImageView=[imageArray objectAtIndex:index%2];
        UIImageView *signImageView=[signImageArray objectAtIndex:index%2];
        UILabel *drugNameLabel=[nameLabelArray objectAtIndex:index%2];
        UILabel *priceLabel=[priceLabelArray objectAtIndex:index%2];
        UIButton *addButton=[addBtnArray objectAtIndex:index%2];
        [addButton addTarget:self action:@selector(addDrug:) forControlEvents:UIControlEventTouchUpInside];
        if (index<9) {
            drugButton.tag=index+101;
            drugImageView.backgroundColor=MAINGRAYCOLOR;
            signImageView.image=[UIImage imageNamed:@"bjsp"];
            
            drugNameLabel.text=@"      药品名称药品名称药品名称药品名称药品名称药品名称药品名称药品名称";
            NSMutableAttributedString *priceString=[[NSMutableAttributedString alloc]initWithString:@"¥106.00 ¥156.00"];
            NSRange nRange=[@"¥106.00 ¥156.00" rangeOfString:@"106.00"];
            NSRange oRange=[@"¥106.00 ¥156.00" rangeOfString:@"¥156.00"];
            [priceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SMALLFONT] range:NSMakeRange(0, 1)];
            [priceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SMALLFONT] range:NSMakeRange(oRange.location,oRange.length)];
            [priceString addAttribute:NSForegroundColorAttributeName value:TEXTCOLORDG range:NSMakeRange(oRange.location,oRange.length)];
            priceLabel.attributedText=priceString;
            
            drugButton.hidden=NO;
            drugImageView.hidden=NO;
            signImageView.hidden=NO;
            drugNameLabel.hidden=NO;
            priceLabel.hidden=NO;
            addButton.hidden=NO;
        }else{
            drugButton.hidden=YES;
            drugImageView.hidden=YES;
            signImageView.hidden=YES;
            drugNameLabel.hidden=YES;
            priceLabel.hidden=YES;
            addButton.hidden=YES;
        }
        index++;
    }
    return cell;
}


- (void)drugInfo:(UIButton*)button{
    DrugInfoViewController *dvc=[DrugInfoViewController new];
    dvc.titleString=@"测试药品";
    dvc.isChoiceDrug=@"Y";
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)addDrug:(UIButton*)button{
    UIView *drugFBackView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andColor:BGGRAYCOLOR];
    drugFBackView.alpha=0.7;
    drugFBackView.tag=11;
    [self addOneTapGestureRecognizer:drugFBackView andSel:@selector(cancelAddDrug)];
    [self.navigationController.view addSubview:drugFBackView];
    
    
    
    UIView *drugSBackView=[self addSimpleBackView:CGRectMake(0, SCREENHEIGHT-295, SCREENWIDTH,295) andColor:BGGRAYCOLOR];
    drugSBackView.tag=12;
    [self.navigationController.view addSubview:drugSBackView];
    
    UIScrollView *drugScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH,231)];
    drugScrollView.backgroundColor=MAINWHITECOLOR;
    [drugSBackView addSubview:drugScrollView];
    
    UIImageView *drugImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 16, 63, 63)];
    drugImageView.backgroundColor=MAINGRAYCOLOR;
    [drugScrollView addSubview:drugImageView];
    
    UILabel *priceLabel=[self addLabel:CGRectMake(90, 20, SCREENWIDTH-100, 20) andText:@"" andFont:BIGFONT andColor:PRICECOLOR andAlignment:0];
    NSMutableAttributedString *priceString=[[NSMutableAttributedString alloc]initWithString:@"¥106.00"];
    [priceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SMALLFONT] range:NSMakeRange(0, 1)];
    priceLabel.attributedText=priceString;
    [drugScrollView addSubview:priceLabel];
    
    UILabel *cGGLabel=[self addLabel:CGRectMake(90,55, SCREENWIDTH-100, 20) andText:@"已选600mg*100片" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:0];
    [drugScrollView addSubview:cGGLabel];
    
    UILabel *ggLabel=[self addLabel:CGRectMake(15, 100, SCREENWIDTH-30, 20) andText:@"规格" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugScrollView addSubview:ggLabel];
    
    NSArray *ggArray=@[@"600mg*100片",@"500mg*100片"];
    for (int i=0; i<ggArray.count; i++) {
        UIButton *ggButton=[self addSimpleButton:CGRectMake(15+120*i, ggLabel.frame.origin.y+25, 110, 25) andBColor:CLEARCOLOR andTag:0 andSEL:nil andText:[ggArray objectAtIndex:i] andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
        [ggButton setImage:[UIImage imageNamed:@"rec_gg"] forState:UIControlStateNormal];
        [drugScrollView addSubview:ggButton];
        
        drugScrollView.contentSize=CGSizeMake(SCREENWIDTH, ggButton.frame.origin.y+ggButton.frame.size.height+15);
    }
    
    UILabel *countLabel=[self addLabel:CGRectMake(15,drugScrollView.contentSize.height, SCREENWIDTH-30, 20) andText:@"数量" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugScrollView addSubview:countLabel];
    
    UIButton *reduceButton=[self addButton:CGRectMake(15, 190, 32, 25) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(reduceDrugCount)];
    [reduceButton setImage:[UIImage imageNamed:@"reduce_3"] forState:UIControlStateNormal];
    [drugScrollView addSubview:reduceButton];
    
    UILabel *countCLabel=[self addLabel:CGRectMake(47, 196, 46, 20) andText:@"1" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    countCLabel.tag=13;
    [drugScrollView addSubview:countCLabel];
    
    UIButton *addButton=[self addButton:CGRectMake(93, 190, 32, 25) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(addDrugCount)];
    [addButton setImage:[UIImage imageNamed:@"add_3"] forState:UIControlStateNormal];
    [drugScrollView addSubview:addButton];
    
    
    UIButton *sureAddButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-140)/2,243, 140,40) andBColor:CLEARCOLOR andTag:0 andSEL:nil andText:@"添加" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureAddButton setImage:[UIImage imageNamed:@"rec_tj"] forState:UIControlStateNormal];
    [drugSBackView addSubview:sureAddButton];
}

- (void)cancelAddDrug{
    UIView *shareFBackView=[self.navigationController.view viewWithTag:11];
    UIView *shareSBackView=[self.navigationController.view viewWithTag:12];
    [shareFBackView removeFromSuperview];
    [shareSBackView removeFromSuperview];
}

- (void)reduceDrugCount{
    UILabel *countLabel=(UILabel*)[self.navigationController.view viewWithTag:13];
    if ([countLabel.text intValue]>1) {
        countLabel.text=[NSString stringWithFormat:@"%d",[countLabel.text intValue]-1];
    }
}

- (void)addDrugCount{
    UILabel *countLabel=(UILabel*)[self.navigationController.view viewWithTag:13];
    countLabel.text=[NSString stringWithFormat:@"%d",[countLabel.text intValue]+1];
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
