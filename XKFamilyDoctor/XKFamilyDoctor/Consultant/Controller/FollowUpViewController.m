//
//  FollowUpViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FollowUpViewController.h"
#import "DataDisplayViewController.h"
#import "FollowUpTableViewCell.h"
#import "FollowUpItem.h"
@interface FollowUpViewController ()

@end

@implementation FollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    mainArray=[NSMutableArray new];
    [self creatUI];
    [self sendRequest:@"FollowUpList" andPath:queryURL andSqlParameter:@[self.tableName,self.peopleOnlyID] and:self];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isChange.length>0) {
        [mainArray removeAllObjects];
        [self sendRequest:@"FollowUpList" andPath:queryURL andSqlParameter:@[self.tableName,self.peopleOnlyID] and:self];
        self.isChange=nil;
    }
}

- (void)addRightButtonItem{
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0,40,44);
    [rButton setImage:[UIImage imageNamed:@"consultant_add"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(addFollowUp) forControlEvents:UIControlEventTouchUpInside];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(12,20,12,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)addFollowUp{
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    dvc.tableName=self.tableName;
    dvc.tableAliasName=self.tableAliasName;
    dvc.peopleOnlyID=self.peopleOnlyID;
    dvc.titleString=self.titleString;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                FollowUpItem *item=[RMMapper objectWithClass:[FollowUpItem class] fromDictionary:dic];
                [mainArray addObject:item];
            }
            [mainTableView reloadData];
        }else{
            [self showSimplePromptBox:self andMesage:@"暂无随访信息"];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FollowUpTableViewCell";
    FollowUpTableViewCell *cell = (FollowUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[FollowUpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    FollowUpItem *item=[mainArray objectAtIndex:indexPath.row];
    cell.mainImageView.backgroundColor=GREENCOLOR;
    cell.writeTimeLabel.text=[self getSubTime:item.LTime andFormat:@"yyyy-MM-dd"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowUpItem *item=[mainArray objectAtIndex:indexPath.row];
    DataDisplayViewController *dvc=[DataDisplayViewController new];
    dvc.tableName=self.tableName;
    dvc.tableAliasName=self.tableAliasName;
    dvc.peopleOnlyID=self.peopleOnlyID;
    dvc.item=item;
    dvc.titleString=self.titleString;
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
