//
//  MyUserViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/8/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyUserViewController.h"
#import "SignImportViewController.h"
#import "AddOrderUserViewController.h"
#import "SearchMyUserViewController.h"
#import "SearchAreaViewController.h"
#import "MyUserItem.h"
#import "UserDetailViewController.h"
#import "NewFileViewController.h"
@interface MyUserViewController ()

@end

@implementation MyUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"我的用户"];
    [self addLeftButtonItem];
    
    mainDataArray=[NSMutableArray new];
    pageCount=1;
    [self creatUI];
    self.state=@"";
    self.info=@"";
    self.LAiderId=EMPKEY;
    [self sendRequest:MYUSERTYPE andPath:MYUSERURL andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LAiderId":self.LAiderId} and:self];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.isSearch) {
        [self addTitleView:@"筛选的用户"];
        pageCount=1;
        self.LAiderId=@"";
        [self sendRequest:MYUSERTYPE andPath:MYUSERURL andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LAiderId":self.LAiderId,@"state":self.state,@"info":self.info} and:self];
        self.isSearch=NO;
    }
    
    if (self.isRefresh) {
        pageCount=1;
        [self sendRequest:MYUSERTYPE andPath:MYUSERURL andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LAiderId":self.LAiderId,@"state":self.state,@"info":self.info} and:self];
    }
}


- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if (dataArray.count>0) {
            if (pageCount==1) {
                [mainDataArray removeAllObjects];
            }
            for (NSDictionary *dic in dataArray) {
                MyUserItem *item=[RMMapper objectWithClass:[MyUserItem class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
            [self addUserView];
        }else{
            if (pageCount==1) {
                [mainDataArray removeAllObjects];
            }
            [self addUserView];
        }
        [self cancelRefresh];
        if (dataArray.count<10) {
            [BGScrollViw.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}


- (void)requestFail:(NSString *)type{}

- (void)creatUI{
    UIButton *searchButton=[self addButton:CGRectMake(15,NAVHEIGHT+10, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(searchUser)];
    [searchButton.layer setCornerRadius:15];
    [self.view addSubview:searchButton];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchButton addSubview:searchImageView];
    
    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:14 andColor:TEXTCOLORG andAlignment:0];
    [searchButton addSubview:npLabel];
    
    BGScrollViw=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT+50, SCREENWIDTH, SCREENHEIGHT-(NAVHEIGHT+50))];
    [self.view addSubview:BGScrollViw];
    [self refresh];
    
}

- (void)addUserView{
    for (UIView *subView in [BGScrollViw subviews]) {
        if (subView!=BGScrollViw.mj_header&&subView!=BGScrollViw.mj_footer) {
            [subView removeFromSuperview];
        }
    }
    if (mainDataArray.count==0) {
        [self addNoDataView];
        noDataView.frame=CGRectMake(0, 150, noDataView.frame.size.width, noDataView.frame.size.height);
    }else{
        noDataView.hidden=YES;
   
        NSMutableArray *userBGViewArray=[NSMutableArray new];
    for (int i=0; i<mainDataArray.count; i++) {
        MyUserItem *item=[mainDataArray objectAtIndex:i];
        UIButton *userBGView=[self addButton:CGRectMake(0,210*i, SCREENWIDTH,200) adnColor:MAINWHITECOLOR andTag:1001+i andSEL:
                              @selector(gotoDetail:)
//                              nil
                              ];
        [BGScrollViw addSubview:userBGView];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,70, 20) andText:item.LName andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
        nameLabel.numberOfLines=0;
        [nameLabel sizeToFit];
        [userBGView addSubview:nameLabel];
        
        UILabel *sabLabel=[self addLabel:CGRectMake(90, 10, SCREENWIDTH-100,20) andText:[NSString stringWithFormat:@"%@   %@",item.LSex,[self getAgeByBir:[self getSubTime:item.LBirthday andFormat:@"yyyy-MM-dd"]]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [userBGView addSubview:sabLabel];
        
        nameLabel.center=CGPointMake(nameLabel.center.x,userBGView.frame.size.height/2);
        
        UIImageView *idImageView=[self addImageView:CGRectMake(90, 40,22,18) andName:@"identity card"];
        [userBGView addSubview:idImageView];
        
        UILabel *idLabel=[self addLabel:CGRectMake(120,40, SCREENWIDTH-(idImageView.frame.origin.x+40)-10,20) andText:[self changeNullString:item.LIdNum] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        [userBGView addSubview:idLabel];
        
        UIButton *callButton=[self addButton:CGRectMake(90, 70, SCREENWIDTH-90,30) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(callUser:)];
        [userBGView addSubview:callButton];
        
        UIImageView *mobileImageView=[self addImageView:CGRectMake(0,0, 22,22) andName:@"mobile"];
        [callButton addSubview:mobileImageView];
        
        UILabel *mobileLabel=[self addLabel:CGRectMake(30,2, SCREENWIDTH-140,20) andText:[[item.LMobile componentsSeparatedByString:@"_"] firstObject] andFont:MIDDLEFONT andColor:[self colorWithHexString:@"#407FEB"] andAlignment:0];
        mobileLabel.numberOfLines=0;
        [mobileLabel sizeToFit];
        [callButton addSubview:mobileLabel];
        
        [self addLineLabel:CGRectMake(30, mobileLabel.frame.origin.y+mobileLabel.frame.size.height, mobileLabel.frame.size.width, 0.5) andColor:[self colorWithHexString:@"#407FEB"] andBackView:callButton];
        
        UIView *ptBGView=[self addSimpleBackView:CGRectMake(90, 105, SCREENWIDTH-90,0) andColor:CLEARCOLOR];
        [userBGView addSubview:ptBGView];
        
        NSMutableArray *ptArray=[NSMutableArray new];
        if ([self changeNullString:item.LDiseaseType].length>0) {
            for (NSString *ptString in [[self changeNullString:item.LDiseaseType] componentsSeparatedByString:@","]) {
                [ptArray addObject:ptString];
            }
        }
        if ([self changeNullString:item.LPersonKind].length>0) {
            for (NSString *ptString in [[self changeNullString:item.LPersonKind] componentsSeparatedByString:@","]) {
                [ptArray addObject:ptString];
            }
        }
        if (ptArray.count>0) {
            NSMutableArray *labelArray=[NSMutableArray new];
            for (int j=0; j<ptArray.count; j++) {
                NSString *ptString=[ptArray objectAtIndex:j];
                UILabel *tagLabel=[self addLabel:CGRectMake(0, 0, 0,0) andText:ptString andFont:SMALLFONT andColor:GREENCOLOR andAlignment:1];
                tagLabel.numberOfLines=0;
                [tagLabel sizeToFit];
                tagLabel.frame=CGRectMake(0, 0, tagLabel.frame.size.width+10,22);
                tagLabel.clipsToBounds=YES;
                tagLabel.layer.borderColor=GREENCOLOR.CGColor;
                tagLabel.layer.borderWidth=0.5;
                [tagLabel.layer setCornerRadius:11];
                [ptBGView addSubview:tagLabel];
                
                if (j>0) {
                    UILabel *beforLabel=[labelArray objectAtIndex:j-1];
                    tagLabel.frame=CGRectMake(beforLabel.frame.origin.x+beforLabel.frame.size.width+10,beforLabel.frame.origin.y, tagLabel.frame.size.width, tagLabel.frame.size.height);
                    if (tagLabel.frame.origin.x+tagLabel.frame.size.width>SCREENWIDTH-100) {
                        tagLabel.frame=CGRectMake(0,beforLabel.frame.origin.y+beforLabel.frame.size.height+10, tagLabel.frame.size.width, tagLabel.frame.size.height);
                    }
                }
                [labelArray addObject:tagLabel];
                
                ptBGView.frame=CGRectMake(90, ptBGView.frame.origin.y, ptBGView.frame.size.width,tagLabel.frame.origin.y+30);
            }
        }
        
        [self addLineLabel:CGRectMake(90, ptBGView.frame.origin.y+ptBGView.frame.size.height, SCREENWIDTH-100, 0.5) andColor:LINECOLOR andBackView:userBGView];
        
        
        CGFloat bw=75;
        if ((SCREENWIDTH-120)/3<75) {
            bw=(SCREENWIDTH-120)/3;
        }
        UIButton *signButton=[self addButton:CGRectMake(90, ptBGView.frame.origin.y+ptBGView.frame.size.height+5, bw, 30) adnColor:CLEARCOLOR andTag:1001+i andSEL:@selector(gotoSign:)];
        if ([item.signState isEqualToString:@"已签约"]) {
            [signButton setImage:[UIImage imageNamed:@"haveSign"] forState:UIControlStateNormal];
        }else{
            [signButton setImage:[UIImage imageNamed:@"gotoSign"] forState:UIControlStateNormal];
        }
        [signButton.layer setCornerRadius:15];
        [userBGView addSubview:signButton];
        
        UIButton *hfButton=[self addButton:CGRectMake(signButton.frame.origin.x+signButton.frame.size.width+10, ptBGView.frame.origin.y+ptBGView.frame.size.height+5, bw, 30) adnColor:CLEARCOLOR andTag:1001+i andSEL:@selector(gotoBuildFile:)];
        if ([item.documentState isEqualToString:@"已建档"]) {
            [self addLabel:CGRectMake(0, 5, bw, 20) andText:@"查看档案" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1 andBGView:hfButton];
            hfButton.backgroundColor=GREENCOLOR;
        }else{
            [hfButton setImage:[UIImage imageNamed:@"buildHF"] forState:UIControlStateNormal];
        }
        [hfButton.layer setCornerRadius:15];
        [userBGView addSubview:hfButton];
        
        UIButton *dzButton=[self addSimpleButton:CGRectMake(hfButton.frame.origin.x+hfButton.frame.size.width+10, ptBGView.frame.origin.y+ptBGView.frame.size.height+5, bw, 30) andBColor:GREENCOLOR andTag:1001+i andSEL:@selector(gotoDZ:) andText:@"导诊" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [dzButton.layer setCornerRadius:15];
        [userBGView addSubview:dzButton];
        
        userBGView.frame=CGRectMake(0, userBGView.frame.origin.y, SCREENWIDTH, dzButton.frame.origin.y+dzButton.frame.size.height+10);
        
        if (i>0) {
            UIView *beforBGView=[userBGViewArray objectAtIndex:i-1];
            userBGView.frame=CGRectMake(0, beforBGView.frame.origin.y+beforBGView.frame.size.height+10, SCREENWIDTH, userBGView.frame.size.height);
        }
        [userBGViewArray addObject:userBGView];
        nameLabel.frame=CGRectMake(nameLabel.frame.origin.x, (userBGView.frame.size.height-nameLabel.frame.size.height)/2, nameLabel.frame.size.width, nameLabel.frame.size.height);
        
//        UIImageView *goImagView=[[UIImageView alloc]initWithFrame:CGRectMake(userBGView.frame.size.width-24,(userBGView.frame.size.height-54)/2,14,14)];
//        goImagView.image=[UIImage imageNamed:@"arrow_2"];
//        [userBGView addSubview:goImagView];
        
        BGScrollViw.contentSize=CGSizeMake(0, userBGView.frame.origin.y+userBGView.frame.size.height+10);
    }
    if (pageCount>1) {
        BGScrollViw.contentOffset=CGPointMake(0, lastOff+10);
    }
    }
}

- (void)searchUser{
    SearchMyUserViewController *svc=[SearchMyUserViewController new];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)callUser:(UIButton*)button{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"拨打电话", @"发送短信",nil];
    myActionSheet.tag=button.tag;
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {}
    MyUserItem *userItem=[mainDataArray objectAtIndex:actionSheet.tag-101];
    switch (buttonIndex)
    {
        case 0:
            [self callUserMobill:[[userItem.LMobile componentsSeparatedByString:@"_"] firstObject]];
            break;
            
        case 1:  //打开本地相册
            [self sendMessage:[[userItem.LMobile componentsSeparatedByString:@"_"] firstObject]];
            break;
    }
}

- (void)callUserMobill:(NSString*)phone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)sendMessage:(NSString*)phone{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]];
    [[UIApplication sharedApplication]openURL:url];
}

- (void)gotoSign:(UIButton*)button{
    MyUserItem *userItem=[mainDataArray objectAtIndex:button.tag-1001];
    if ([userItem.signState isEqualToString:@"未签约"]) {
        SignImportViewController *svc=[SignImportViewController new];
        svc.whoPush=@"MU";
        svc.userItem=userItem;
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (void)gotoBuildFile:(UIButton*)button{
    MyUserItem *userItem=[mainDataArray objectAtIndex:button.tag-1001];
    if ([userItem.documentState isEqualToString:@"未建档"]) {
        SearchAreaViewController *svc=[SearchAreaViewController new];
        svc.whoPush=@"MU";
        svc.userItem=userItem;
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        NewFileViewController *nvc=[NewFileViewController new];
        nvc.userItem=userItem;
        [self.navigationController pushViewController:nvc animated:YES];
    }
}

- (void)gotoDZ:(UIButton*)button{
    AddOrderUserViewController *svc=[AddOrderUserViewController new];
    svc.isMU=@"MU";
    svc.userItem=[mainDataArray objectAtIndex:button.tag-1001];
    [self.navigationController pushViewController:svc animated:YES];
}



- (void)refresh{
    // 下拉刷新
    BGScrollViw.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount=1;
        [self sendRequest:MYUSERTYPE andPath:MYUSERURL andSqlParameter:@{@"pageNumber":@"1",@"pageSize":@"10",@"LAiderId":self.LAiderId,@"state":self.state,@"info":self.info} and:self];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    BGScrollViw.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    
    BGScrollViw.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount+=1;
        lastOff=BGScrollViw.contentOffset.y;
        [self sendRequest:MYUSERTYPE andPath:MYUSERURL andSqlParameter:@{@"pageNumber":[NSString stringWithFormat:@"%d",pageCount],@"pageSize":@"10",@"LAiderId":self.LAiderId,@"state":self.state,@"info":self.info} and:self];
    }];
    
}

- (void)gotoDetail:(UIButton*)button{
    UserDetailViewController *uvc=[UserDetailViewController new];
    uvc.userItem=[mainDataArray objectAtIndex:button.tag-1001];
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)cancelRefresh{
    [BGScrollViw.mj_header endRefreshing];
    [BGScrollViw.mj_footer endRefreshing];
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
