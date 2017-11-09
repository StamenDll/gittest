//
//  AuditViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AuditViewController.h"
#import "AuditTableViewCell.h"
#import "SignViewController.h"
@interface AuditViewController ()

@end

@implementation AuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"签约审核"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    [self.view addSubview:mainTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AuditTableViewCell";
    AuditTableViewCell *cell = (AuditTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[AuditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.mainImageView.backgroundColor=[UIColor grayColor];
    cell.nameLabel.text=@"测试";
    [cell.nameLabel sizeToFit];
    
    cell.stateLabel.text=@"未审核";
    cell.stateLabel.backgroundColor=[UIColor redColor];
    [cell.stateLabel sizeToFit];
    
    cell.timeLabel.text=@"10－19";
    cell.ageLabel.text=@"24岁   男";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SignViewController *svc=[SignViewController new];
    [self.navigationController pushViewController:svc animated:YES];
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
