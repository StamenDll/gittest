
//
//  ChoiceFamilyViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/11/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoiceFamilyViewController.h"
#import "FamilyTableViewCell.h"
#import "AddNewFamilyViewController.h"
@interface ChoiceFamilyViewController ()

@end

@implementation ChoiceFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择家庭"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    mainDataArray=[NSMutableArray new];
    [self creatUI];
}


- (void)addRightButtonItem{
    UIButton *rButton=[self addSimpleButton:CGRectMake(0, 0, 80, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(goAddNewFamily) andText:@"添加家庭" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:2];
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)goAddNewFamily{
    AddNewFamilyViewController *ovc=[AddNewFamilyViewController new];
    [self.navigationController pushViewController:ovc animated:YES];
}

- (void)creatUI{
    UIButton *searchButton=[self addButton:CGRectMake(15,NAVHEIGHT+10, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(searchUser)];
    [searchButton.layer setCornerRadius:15];
    [self.view addSubview:searchButton];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchButton addSubview:searchImageView];
    
    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:14 andColor:TEXTCOLORG andAlignment:0];
    [searchButton addSubview:npLabel];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT+50, SCREENWIDTH, SCREENHEIGHT-(NAVHEIGHT+50)) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:mainTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FamilyTableViewCell";
    FamilyTableViewCell *cell = (FamilyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[FamilyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
//    SignTaskItem *item=[mainDataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=@"张三";
    return  cell;
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
