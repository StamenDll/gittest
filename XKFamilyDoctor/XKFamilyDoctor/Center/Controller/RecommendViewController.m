//
//  RecommendViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendTableViewCell.h"
#import "MyRecommenItem.h"
@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"我推荐的用户"];
    mainArray=[NSMutableArray new];
    [self addLeftButtonItem];
    [self creatUI];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    [self sendRequest:@"MyRecommend" andPath:queryURL andSqlParameter:[usd objectForKey:@"LMyWorkCode"] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                MyRecommenItem *Item=[RMMapper objectWithClass:[MyRecommenItem class] fromDictionary:dic];
                [mainArray addObject:Item];
            }
            [mainTableView reloadData];
        }else{
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"暂无推荐用户信息" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    [self.view addSubview:mainTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecommendTableViewCell";
    RecommendTableViewCell *cell = (RecommendTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[RecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    MyRecommenItem *item=[mainArray objectAtIndex:indexPath.row];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LHeadPic]] placeholderImage:USERDEFAULTPIC];

    cell.nameLabel.text=item.LName;
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
