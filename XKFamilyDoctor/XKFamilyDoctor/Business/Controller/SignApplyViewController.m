//
//  SignApplyViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SignApplyViewController.h"
#import "SignImportViewController.h"
#import "SignTaskItem.h"
#import "SignTaskTableViewCell.h"
@interface SignApplyViewController ()

@end

@implementation SignApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"签约任务"];
    [self addLeftButtonItem];
    mainDataArray=[NSMutableArray new];
    [self creatUI];
    [self sendRequest:GETSIGNTYPE andPath:GETSIGNURL andSqlParameter:@{@"empkey":EMPKEY} and:self];
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    BGSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT)];
    [self.view addSubview:BGSrollView];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic=message;
        NSArray *list=[dataDic objectForKey:@"list"];
        if (list.count>0) {
            for (NSDictionary *dic in list) {
                SignTaskItem *item=[RMMapper objectWithClass:[SignTaskItem class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
            [self addDataView];
        }else{
            [self addNoDataView];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}


- (void)requestFail:(NSString *)type{
    
}

- (void)addDataView{
    NSMutableArray *btnArray=[NSMutableArray new];
    for (int i=0; i<mainDataArray.count; i++) {
        SignTaskItem *item=[mainDataArray objectAtIndex:i];
        UIButton *bgButton=[self addButton:CGRectMake(0, 0, SCREENWIDTH, 70) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(gotoSign:)];
        [BGSrollView addSubview:bgButton];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 10, 90, 20) andText:item.name andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [bgButton addSubview:nameLabel];
        
        UILabel *mobileLabel=[self addLabel:CGRectMake(100, 10,SCREENWIDTH-110, 20) andText:item.mobile andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [bgButton addSubview:mobileLabel];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(10,40,SCREENWIDTH-20, 20) andText:[NSString stringWithFormat:@"签约地址:%@%@%@%@%@",[item.address objectForKey:@"province"],[item.address objectForKey:@"city"],[item.address objectForKey:@"district"],[item.address objectForKey:@"street"],[item.address objectForKey:@"detail"]] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        addressLabel.numberOfLines=0;
        [addressLabel sizeToFit];
        [bgButton addSubview:addressLabel];
        
        bgButton.frame=CGRectMake(0, 0, SCREENWIDTH, addressLabel.frame.origin.y+addressLabel.frame.size.height+10);
        if (i>0) {
            UIButton*beforButton=[btnArray objectAtIndex:i-1];
            bgButton.frame=CGRectMake(0, beforButton.frame.origin.y+beforButton.frame.size.height,SCREENWIDTH,bgButton.frame.size.height);
        }
        [btnArray addObject:bgButton];
        
        [self addLineLabel:CGRectMake(0, bgButton.frame.size.height-0.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:bgButton];
        
        BGSrollView.contentSize=CGSizeMake(0,bgButton.frame.origin.y+bgButton.frame.size.height+40);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SignTaskTableViewCell";
    SignTaskTableViewCell *cell = (SignTaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[SignTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    SignTaskItem *item=[mainDataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=item.name;
    cell.mobileLabel.text=item.mobile;
    cell.addressLabel.text=[NSString stringWithFormat:@"签约地址:%@%@%@%@%@",[item.address objectForKey:@"province"],[item.address objectForKey:@"city"],[item.address objectForKey:@"district"],[item.address objectForKey:@"street"],[item.address objectForKey:@"detail"]];
    return  cell;
}

- (void)gotoSign:(UIButton*)button{
    SignTaskItem *item=[mainDataArray objectAtIndex:button.tag-101];
    SignImportViewController *svc=[SignImportViewController new];
    svc.taskItem=item;
    [self.navigationController pushViewController:svc animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        [self sendRequest:@"SearchApply" andPath:queryURL andSqlParameter:searchField.text and:self];
    }
    return YES;
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
