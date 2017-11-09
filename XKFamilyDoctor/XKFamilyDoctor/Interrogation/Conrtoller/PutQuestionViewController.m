//
//  PutQuestionViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PutQuestionViewController.h"
#import "PutQuestionTableViewCell.h"
#import "PutQuestionItem.h"
#import "PutQuestionFrame.h"
#import "MyQuestionViewController.h"
#import "MyCollectionViewController.h"
#import "PostDetailViewController.h"
#import "WriteQuestionViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
@interface PutQuestionViewController ()

@end

@implementation PutQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[NSMutableArray new];
    [self addTitleView:@"提问吧"];
    [self addLeftButtonItem];
    //    [self addRightButtonItem];
    [self creatUI];
    nowCount=1;
    [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",[self changeNullString:CHATCODE],@"所有",@"1"] and:self];
    
}

- (void)viewDidAppear:(BOOL)animated{
    if ([self.isChange isEqualToString:@"Y"]) {
        nowCount=1;
        [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",CHATCODE,@"所有",@"1"] and:self];
        self.isChange=nil;
    }
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightButtonItem{
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0,40,44);
    [rButton setImage:[UIImage imageNamed:@"search_q"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(myFriendOnClick) forControlEvents:UIControlEventTouchUpInside];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(10,15,9,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    [self cancelRefresh];
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            if (nowCount==1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in data) {
                PutQuestionItem *item=[RMMapper objectWithClass:[PutQuestionItem class] fromDictionary:dic];
                PutQuestionFrame *fram=[PutQuestionFrame new];
                fram.questionMessage=item;
                [dataArray addObject:fram];
            }
            [mainTableView reloadData];
        }else{
            if (nowCount==1) {
                [self addNoDataView];
                mainTableView.hidden=YES;
            }
            if (nowCount>1) {
                [mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    [self cancelRefresh];
}

- (void)creatUI{
    UIButton *myQuestionButton=[self addButton:CGRectMake(0,64,SCREENWIDTH/3, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(myQuestionOnclick)];
    [self.view addSubview:myQuestionButton];
    
    UILabel *myQuestionLabel=[self addLabel:CGRectMake(0, 10, 0, 20) andText:@"我的提问" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    myQuestionLabel.numberOfLines=0;
    [myQuestionLabel sizeToFit];
    [myQuestionButton addSubview:myQuestionLabel];
    
    UIImageView *myQuestionImageView=[self addImageView:CGRectMake((myQuestionButton.frame.size.width-myQuestionLabel.frame.size.width-25)/2, 8, 25, 25) andName:@"My-questions"];
    [myQuestionButton addSubview:myQuestionImageView];
    
    myQuestionLabel.frame=CGRectMake(myQuestionImageView.frame.origin.x+25, 10, myQuestionLabel.frame.size.width, 20);
    
    UIButton *collectButton=[self addButton:CGRectMake(SCREENWIDTH/3,64,SCREENWIDTH/3, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(myCollectionOnclick)];
    [self.view addSubview:collectButton];
    
    UILabel *collectLabel=[self addLabel:CGRectMake(0, 10, 0, 20) andText:@"收藏" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    collectLabel.numberOfLines=0;
    [collectLabel sizeToFit];
    [collectButton addSubview:collectLabel];
    
    UIImageView *collectImageView=[self addImageView:CGRectMake((collectButton.frame.size.width-collectLabel.frame.size.width-25)/2, 8, 25, 25) andName:@"collect"];
    [collectButton addSubview:collectImageView];
    collectLabel.frame=CGRectMake(collectImageView.frame.origin.x+25, 10, collectLabel.frame.size.width, 20);
    
    UIButton *askButton=[self addButton:CGRectMake(SCREENWIDTH/3*2,64,SCREENWIDTH/3, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(questionOnclick)];
    [self.view addSubview:askButton];
    
    UILabel *askLabel=[self addLabel:CGRectMake(0, 10, 0, 20) andText:@"提问" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    askLabel.numberOfLines=0;
    [askLabel sizeToFit];
    [askButton addSubview:askLabel];
    
    UIImageView *askImageView=[self addImageView:CGRectMake((askButton.frame.size.width-askLabel.frame.size.width-25)/2, 8, 25, 25) andName:@"questions"];
    [askButton addSubview:askImageView];
    askLabel.frame=CGRectMake(askImageView.frame.origin.x+25, 10, askLabel.frame.size.width, 20);
    
    [self addLineLabel:CGRectMake(SCREENWIDTH/3, 5, 0.5, 30) andColor:LINECOLOR andBackView:myQuestionButton];
    [self addLineLabel:CGRectMake(SCREENWIDTH/3, 5, 0.5, 30) andColor:LINECOLOR andBackView:collectButton];
    [self addLineLabel:CGRectMake(0,104,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:self.view];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 114, SCREENWIDTH, SCREENHEIGHT-114) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.backgroundColor=BGGRAYCOLOR;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    [self refresh];
}

- (void)questionOnclick{
    WriteQuestionViewController *wvc=[WriteQuestionViewController new];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)myQuestionOnclick{
    MyQuestionViewController *mvc=[MyQuestionViewController new];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)myCollectionOnclick{
    MyCollectionViewController *mvc=[MyCollectionViewController new];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"===111111===%f",[[dataArray objectAtIndex:indexPath.row] cellHeight]);
    return [[dataArray objectAtIndex:indexPath.row] cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PutQuestionTableViewCell";
    PutQuestionTableViewCell *cell = (PutQuestionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[PutQuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell setMessageFrame:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostDetailViewController *pvc=[PostDetailViewController new];
    pvc.putQuestionFrame=[dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pvc animated:YES];
}


- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        nowCount=1;
        [dataArray removeAllObjects];
        [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",[self changeNullString:CHATCODE],@"所有",@"1"] and:self];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (dataArray.count>0) {
            nowCount+=1;
            [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",[self changeNullString:CHATCODE],@"所有",[NSString stringWithFormat:@"%d",nowCount]] and:self];
        }else{
            [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",[self changeNullString:CHATCODE],@"所有",@"1"] and:self];
        }
    }];
}

- (void)cancelRefresh{
    [mainTableView.mj_header endRefreshing];
    [mainTableView.mj_footer endRefreshing];
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
