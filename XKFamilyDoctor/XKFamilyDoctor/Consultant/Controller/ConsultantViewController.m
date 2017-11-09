//
//  ConsultantViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ConsultantViewController.h"
#import "ChatroomViewController.h"
#import "PutQuestionViewController.h"
#import "SearchViewController.h"
#import "ConsultantTableViewCell.h"
#import "AllNewsViewController.h"
#import "DataDisplayViewController.h"
#import "SearchAreaViewController.h"
#import "ConsultantItem.h"
#import "CommWriteItme.h"
#import "MyUaserDetailItem.h"
#import "AddUserViewController.h"
#import "OrderRegisterViewController.h"
#import "FollowListViewController.h"
#import "ReferralOutCViewController.h"
@interface ConsultantViewController ()

@end

@implementation ConsultantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"健康顾问"];
    dataArray=[NSMutableArray new];
    [self addButtonItem];
    [self creatUI];
    [self sendRequest:@"MyUser" andPath:queryURL andSqlParameter:nil and:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isAdd.length>0) {
        [self sendRequest:@"MyUser" andPath:queryURL andSqlParameter:nil and:self];
    }
    [self.myTabBarController showTabBar];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}

- (void)addButtonItem{
//    UIButton *lButton=[self addSimpleButton:CGRectMake(0, 0, 40, 40) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(addUesr) andText:@"所有" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:0];
//    
//    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
//    self.navigationItem.leftBarButtonItem=lItem;
    
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0,40,44);
    [rButton setImage:[UIImage imageNamed:@"consultant_add"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(addUesr) forControlEvents:UIControlEventTouchUpInside];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(12,20,12,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)addUesr{
    AddUserViewController *dvc=[AddUserViewController new];
    [self.myTabBarController hidesTabBar];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    CommWriteItme *nameItem=[CommWriteItme new];
    nameItem.name=@"姓名";
    nameItem.LValueType=@"字符";
    nameItem.value=@"";
    nameItem.isNeed=YES;
    [array addObject:nameItem];
    
    CommWriteItme *phoneItem=[CommWriteItme new];
    phoneItem.name=@"手机号";
    phoneItem.LValueType=@"phone";
    phoneItem.value=@"";
    phoneItem.isNeed=YES;
    [array addObject:phoneItem];
    
    
    CommWriteItme *memberCardItem=[CommWriteItme new];
    memberCardItem.name=@"会员卡号";
    memberCardItem.LValueType=@"memberCard";
    memberCardItem.value=@"";
    memberCardItem.isNeed=YES;
    [array addObject:memberCardItem];
    
    CommWriteItme *codeItem=[CommWriteItme new];
    codeItem.name=@"验证码";
    codeItem.LValueType=@"code";
    codeItem.value=@"";
    codeItem.isNeed=YES;
    [array addObject:codeItem];
    
    CommWriteItme *sexItem=[CommWriteItme new];
    sexItem.name=@"性别";
    sexItem.LValueType=@"sex";
    sexItem.value=@"男";
    sexItem.isNeed=YES;
    [array addObject:sexItem];
    
    CommWriteItme *numberItem=[CommWriteItme new];
    numberItem.name=@"生日";
    numberItem.LValueType=@"时间";
    numberItem.value=[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"];
    numberItem.isNeed=YES;
    [array addObject:numberItem];
    
    CommWriteItme *cardItem=[CommWriteItme new];
    cardItem.name=@"身份证";
    cardItem.LValueType=@"int";
    cardItem.value=@"";
    cardItem.isNeed=YES;
    [array addObject:cardItem];
    
    CommWriteItme *addressItem=[CommWriteItme new];
    addressItem.name=@"住址";
    addressItem.LValueType=@"字符";
    addressItem.value=@"";
    addressItem.isNeed=YES;
    [array addObject:addressItem];
    
    CommWriteItme *communityItem=[CommWriteItme new];
    communityItem.name=@"社区";
    communityItem.LValueType=@"community";
    communityItem.value=@"";
    communityItem.isNeed=YES;
    [array addObject:communityItem];
    
    CommWriteItme *passwordItem=[CommWriteItme new];
    passwordItem.name=@"密码";
    passwordItem.LValueType=@"字符";
    passwordItem.value=@"";
    passwordItem.isNeed=YES;
    [array addObject:passwordItem];
    
    CommWriteItme *surePasswordItem=[CommWriteItme new];
    surePasswordItem.name=@"确认密码";
    surePasswordItem.LValueType=@"字符";
    surePasswordItem.value=@"";
    surePasswordItem.isNeed=YES;
    [array addObject:surePasswordItem];
    dvc.dataArray=array;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"MyUser"]) {
            if (data.count>0) {
                [dataArray removeAllObjects];
                for (NSDictionary *dic in data) {
                    ConsultantItem *item=[RMMapper objectWithClass:[ConsultantItem class] fromDictionary:dic];
                    [dataArray addObject:item];
                }
                [mainTableView reloadData];
            }else{
                [self showSimplePromptBox:self andMesage:@"暂无负责的居民信息"];
            }
        }else if([type isEqualToString:@"MyUserDetail"]){
            if (data.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                
                MyUaserDetailItem *item=[RMMapper objectWithClass:[MyUaserDetailItem class] fromDictionary:dic];
                ConsultantItem *userItem=[dataArray objectAtIndex:userButton.tag];
                
                DataDisplayViewController *dvc=[DataDisplayViewController new];
                [self.myTabBarController hidesTabBar];
                dvc.tableName=@"personalinfo";
                dvc.titleString=@"详细信息";
                dvc.item=item;
                dvc.writeType=@"UD";
                dvc.peopleOnlyID=userItem.LOnlyCode;
                [self.navigationController pushViewController:dvc animated:YES];
            }else{
                [self showSimplePromptBox:self andMesage:@"该居民暂无档案信息"];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    UIView *fBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 122)];
    fBackView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:fBackView];
    
//    UIButton *searchButton=[self addButton:CGRectMake(15,70, SCREENWIDTH-30,30) adnColor:BTNGRAYCOLOR andTag:0 andSEL:@selector(searchClick:)];
//    [searchButton.layer setCornerRadius:15];
//    [self.view addSubview:searchButton];
//    
//    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
//    searchImageView.image=[UIImage imageNamed:@"search"];
//    [searchButton addSubview:searchImageView];
//    
//    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
//    [searchButton addSubview:npLabel];
    
    NSArray *btnNameArray=@[@"群体消息",@"健康俱乐部",@"问诊贴吧"];
    NSArray *btnImageArray=@[@"resident",@"chat",@"tieba"];
    for (int i=0; i<btnNameArray.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(SCREENWIDTH/3*i,30, SCREENWIDTH/3,79) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(menuButtonClick:)];
        [fBackView addSubview:menuButton];
        
        UIImageView *menuImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH/3-34)/2,5, 35, 35)];
        menuImageView.image=[UIImage imageNamed:[btnImageArray objectAtIndex:i]];
        [menuButton addSubview:menuImageView];
        
        UILabel *menuLabel=[self addLabel:CGRectMake(0,45,SCREENWIDTH/3,20) andText:[btnNameArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [menuButton addSubview:menuLabel];
    }
    [self addLineLabel:CGRectMake(0, 122, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,200,SCREENWIDTH, SCREENHEIGHT-250) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainTableView];
}

- (void)searchClick:(UIButton*)button{
    [self.navigationController setNavigationBarHidden:YES];
    [self.myTabBarController hidesTabBar];
    SearchViewController *svc=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)menuButtonClick:(UIButton*)button{
    if (button.tag==101) {
        AllNewsViewController *cvc=[AllNewsViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (button.tag==102){
        ChatroomViewController *cvc=[ChatroomViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:cvc animated:YES];
    }else{
        PutQuestionViewController *pvc=[PutQuestionViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ConsultantTableViewCell";
    ConsultantTableViewCell *cell = (ConsultantTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ConsultantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ConsultantItem *item=[dataArray objectAtIndex:indexPath.row];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LHeadPic]] placeholderImage:[UIImage imageNamed:@"user_default"]];
    cell.nameLabel.text=item.LName;
    //    cell.infoLabel.text=@"65岁 男";
    cell.manageButton.tag=indexPath.row;
    [cell.manageButton addTarget:self action:@selector(addMenuView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)addMenuView:(UIButton*)button{
    userButton=button;
    UIView *fBGView=[self addSimpleBackView:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-114) andColor:[UIColor blackColor]];
    fBGView.alpha=0.7;
    fBGView.tag=11;
    [self.view addSubview:fBGView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [fBGView addGestureRecognizer:tap];
    
    UIView *sBGView=[self addSimpleBackView:CGRectMake(0, 64, SCREENWIDTH, 270) andColor:MAINWHITECOLOR];
    sBGView.tag=12;
    [self.view addSubview:sBGView];
    
    UIScrollView *menuButtonBGView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, sBGView.frame.size.height-80)];
    [sBGView addSubview:menuButtonBGView];
    
    UILabel *titleLabel=[self addLabel:CGRectMake(0, 30, SCREENWIDTH, 20) andText:@"王琪－信息管理" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [menuButtonBGView addSubview:titleLabel];
    
    NSArray *menuArray=@[@"预约挂号",@"体检信息",@"详细信息",@"转诊",@"随访记",@"建档"];
    for (int i=0; i<menuArray.count; i++) {
        UIButton *classButton=[self addSimpleButton:CGRectMake(15+(10+(SCREENWIDTH-60)/4)*(i%4), 70+50*(i/4), (SCREENWIDTH-60)/4,30) andBColor:CLEARCOLOR andTag:201+i andSEL:@selector(gotoWrite:) andText:[menuArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        classButton.layer.borderColor=GREENCOLOR.CGColor;
        classButton.layer.borderWidth=0.5;
        [menuButtonBGView addSubview:classButton];
        menuButtonBGView.contentSize=CGSizeMake(SCREENWIDTH, classButton.frame.origin.y+classButton.frame.size.height+20);
    }
}

- (void)gotoWrite:(UIButton*)button{
    ConsultantItem *item=[dataArray objectAtIndex:userButton.tag];
    if (button.tag==201){
        OrderRegisterViewController *ovc=[OrderRegisterViewController new];
        ovc.peopleOnlyID=item.LOnlyCode;
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:ovc animated:YES];
    }else if (button.tag==203){
        [self sendRequest:@"MyUserDetail" andPath:queryURL andSqlParameter:item.LOnlyCode and:self];
    }else if (button.tag==204){
        ReferralOutCViewController *dvc=[ReferralOutCViewController new];
        [self.navigationController.myTabBarController hidesTabBar];
        dvc.peopleMemberID=item.LCode;
        dvc.peopleOnlyID=item.LOnlyCode;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (button.tag==205){
        FollowListViewController *ovc=[FollowListViewController new];
        ovc.peopleOnlyID=item.LOnlyCode;
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:ovc animated:YES];
    }else{
        SearchAreaViewController *ovc=[SearchAreaViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:ovc animated:YES];
    }
}

- (void)cancelKeyboard{
    UIView *FBGView=[self.view viewWithTag:11];
    [FBGView removeFromSuperview];
    UIView *SBGView=[self.view viewWithTag:12];
    [SBGView removeFromSuperview];
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
