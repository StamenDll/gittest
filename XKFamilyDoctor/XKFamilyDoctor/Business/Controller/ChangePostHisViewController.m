//
//  ChangePostHisViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChangePostHisViewController.h"
#import "ChangeHisTableViewCell.h"
#import "ChangeHisItem.h"
@interface ChangePostHisViewController ()

@end

@implementation ChangePostHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"调换记录"];
    [self addLeftButtonItem];
    mainDataArray=[NSMutableArray new];
    [self sendRequest:CHANGEHISTTYPE andPath:CHANGEHISURL andSqlParameter:@{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]} and:self];
    [self creatUI];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        for (NSDictionary *dic in data) {
            ChangeHisItem *item=[RMMapper objectWithClass:[ChangeHisItem class] fromDictionary:dic];
            [mainDataArray addObject:item];
        }
        [mainTableView reloadData];
    }
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor=BGGRAYCOLOR;
    [self.view addSubview:mainTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ChangeHisTableViewCell";
    ChangeHisTableViewCell *cell = (ChangeHisTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ChangeHisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=BGGRAYCOLOR;
    }
    ChangeHisItem *item=[mainDataArray objectAtIndex:indexPath.row];
    cell.depNameLabel.text=[NSString stringWithFormat:@"原社区:%@",item.oldvalue];
    cell.nowDepNameLabel.text=[NSString stringWithFormat:@"目标社区:%@",item.newvalue];
    cell.timeLabel.text=[NSString stringWithFormat:@"调换时间:%@",item.optdate];
    return cell;
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
