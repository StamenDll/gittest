//
//  MyQuestionViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "MyQuestionTableViewCell.h"
#import "PutQuestionItem.h"
#import "PutQuestionFrame.h"
#import "PostDetailViewController.h"
#import "MJRefresh.h"

@interface MyQuestionViewController ()

@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[NSMutableArray new];
    [self addTitleView:@"我的提问"];
    [self addLeftButtonItem];
    [self creatUI];
    nowCount=1;
    [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",CHATCODE,@"我发起",@"1"] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"QuestionList"]) {
            [self cancelRefresh];
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    PutQuestionItem *item=[RMMapper objectWithClass:[PutQuestionItem class] fromDictionary:dic];
                    PutQuestionFrame *fram=[PutQuestionFrame new];
                    fram.questionMessage=item;
                    [dataArray addObject:fram];
                }
                [mainTableView reloadData];
                [noDataView hiddenNoDataView];
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
            [dataArray removeObjectAtIndex:delIndex];
            [mainTableView deleteSections:[NSIndexSet indexSetWithIndex:delIndex] withRowAnimation:UITableViewRowAnimationTop];
            if (dataArray.count==0) {
                [self addNoDataView];
                mainTableView.hidden=YES;
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
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.backgroundColor=BGGRAYCOLOR;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    [self refresh];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyQuestionTableViewCell";
    MyQuestionTableViewCell *cell = (MyQuestionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[MyQuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    PutQuestionFrame *fram=[dataArray objectAtIndex:indexPath.section];
    cell.titleLabel.text=fram.questionMessage.LTitle;
    cell.commentLabel.text=[NSString stringWithFormat:@"%d评论",fram.questionMessage.LAnswerNum];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    PutQuestionFrame *fram=[dataArray objectAtIndex:indexPath.section];
    if (fram.questionMessage.LAnswerNum>0) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        delIndex=indexPath.section;
        [self showPromptBox:self andMesage:@"确定要删除该帖子吗？" andSel:@selector(sureDel)];
    }];
    return @[deleteAction];
}

- (void)sureDel{
    PutQuestionFrame *fram=[dataArray objectAtIndex:delIndex];
    [self sendRequest:@"DelPost" andPath:excuteURL andSqlParameter:fram.questionMessage.LID and:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostDetailViewController *pvc=[PostDetailViewController new];
    pvc.putQuestionFrame=[dataArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)refresh{
    // 下拉刷新
    mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        nowCount=1;
        [dataArray removeAllObjects];
        [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",CHATCODE,@"我发起",@"1"] and:self];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mainTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (dataArray.count>0) {
            nowCount+=1;
            [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",CHATCODE,@"我发起",[NSString stringWithFormat:@"%d",nowCount]] and:self];
        }else{
            [self sendRequest:@"QuestionList" andPath:queryURL andSqlParameter:@[@"",CHATCODE,@"我发起",@"1"] and:self];
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
