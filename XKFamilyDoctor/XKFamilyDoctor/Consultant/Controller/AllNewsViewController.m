//
//  AllNewsViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AllNewsViewController.h"
#import "ChatItem.h"
@interface AllNewsViewController ()

@end

@implementation AllNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"群体消息"];
    [self addLeftButtonItem];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtable:) name:@"OfflineHaveNews" object:nil];
}

- (void)creatUI{
//    UIButton *searchButton=[self addButton:CGRectMake(15,75, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:nil];
//    [searchButton.layer setCornerRadius:15];
//    [self.view addSubview:searchButton];
//    
//    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
//    searchImageView.image=[UIImage imageNamed:@"search"];
//    [searchButton addSubview:searchImageView];
//    
//    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:14 andColor:TEXTCOLORG andAlignment:0];
//    [searchButton addSubview:npLabel];
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:mainScrollView];
    
    specialBackView=[self addButton:CGRectMake(0, 0, SCREENWIDTH, 45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(getSData:)];
    [mainScrollView addSubview:specialBackView];
    
    UIImageView *openImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,18, 10, 10)];
    openImageView.image=[UIImage imageNamed:@"arrow"];
    [specialBackView addSubview:openImageView];
    
    UILabel *sLabel=[self addLabel:CGRectMake(33,13,100,20) andText:@"新消息" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [specialBackView addSubview:sLabel];
    
    newNewsCountLabel=[self addLabel:CGRectMake(SCREENWIDTH-35,12.5,20,20) andText:@"" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    newNewsCountLabel.backgroundColor=[UIColor redColor];
    newNewsCountLabel.clipsToBounds=YES;
    newNewsCountLabel.hidden=YES;
    [newNewsCountLabel.layer setCornerRadius:10];
    [specialBackView addSubview:newNewsCountLabel];
    
    NSInteger newsCount=0;
    if (newNewsArray.count>0) {
        for (ChatItem *item in newNewsArray) {
            newsCount+=item.unsend;
        }
        newNewsCountLabel.hidden=NO;
        newNewsCountLabel.text=[NSString stringWithFormat:@"%ld",newsCount];
        self.myTabBarController.newsLabel.hidden=NO;
        self.myTabBarController.newsLabel.text=[NSString stringWithFormat:@"%ld",newsCount];
    }
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:specialBackView];
    [self addLineLabel:CGRectMake(0,44.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:specialBackView];
    
    
    complaintBackView=[self addButton:CGRectMake(0, specialBackView.frame.origin.y+specialBackView.frame.size.height+8, SCREENWIDTH, 45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(getCData:)];
    [mainScrollView addSubview:complaintBackView];
    
    UIImageView *openImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(15,18, 10, 10)];
    openImageView1.image=[UIImage imageNamed:@"arrow"];
    [complaintBackView addSubview:openImageView1];
    
    UILabel *cLabel=[self addLabel:CGRectMake(33,13,SCREENWIDTH-40,20) andText:@"最近联系人" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [complaintBackView addSubview:cLabel];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:complaintBackView];
    [self addLineLabel:CGRectMake(0,44.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:complaintBackView];
}

- (void)getSData:(UIButton*)button{
    UIImageView *openImageView=[[button subviews] objectAtIndex:0];
    if (newNewsArray.count>0) {
        openImageView.image=[UIImage imageNamed:@"arrow_down"];
        if (button.selected==NO) {
            if (newNewsTableView) {
                newNewsTableView.hidden=NO;
                [newNewsTableView reloadData];
                newNewsTableView.frame=CGRectMake(0, newNewsTableView.frame.origin.y,SCREENWIDTH, newNewsArray.count*67);
            }else{
                newNewsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, specialBackView.frame.origin.y+45, SCREENWIDTH, 67*newNewsArray.count) style:UITableViewStylePlain];
                newNewsTableView.delegate=self;
                newNewsTableView.dataSource=self;
                newNewsTableView.scrollEnabled=NO;
                newNewsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                [mainScrollView addSubview:newNewsTableView];
            }
            complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,newNewsTableView.frame.origin.y+newNewsTableView.frame.size.height+8, complaintBackView.frame.size.width, complaintBackView.frame.size.height);
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
            button.selected=YES;
        }else{
            openImageView.image=[UIImage imageNamed:@"arrow"];
            UIView *sListBackView=[self.view viewWithTag:111];
            [sListBackView removeFromSuperview];
            newNewsTableView.hidden=YES;
            
            complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,specialBackView.frame.origin.y+specialBackView.frame.size.height+8, complaintBackView.frame.size.width, complaintBackView.frame.size.height);
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
            button.selected=NO;
        }
    }else{
        [self showSimplePromptBox:self andMesage:@"暂无新消息"];
    }
}

- (void)getCData:(UIButton*)button{
    UIImageView *openImageView=[[button subviews] objectAtIndex:0];
    if (contactsArray.count>0) {
        if (button.selected==NO) {
            openImageView.image=[UIImage imageNamed:@"arrow_down"];
            if (contactsTableView) {
                contactsTableView.hidden=NO;
                [contactsTableView reloadData];
            }else{
                contactsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, complaintBackView.frame.origin.y+45, SCREENWIDTH, 67*contactsArray.count) style:UITableViewStylePlain];
                contactsTableView.delegate=self;
                contactsTableView.dataSource=self;
                contactsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                [mainScrollView addSubview:contactsTableView];
            }
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, contactsTableView.frame.origin.y+contactsTableView.frame.size.height+20);
            button.selected=YES;
        }else{
            openImageView.image=[UIImage imageNamed:@"arrow"];
            UIView *cListBackView=[self.view viewWithTag:112];
            [cListBackView removeFromSuperview];
            contactsTableView.hidden=YES;
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
            button.selected=NO;
        }
    }else{
        [self showSimplePromptBox:self andMesage:@"暂无联系人信息"];
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
