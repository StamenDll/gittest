//
//  InterrogationViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InterrogationViewController.h"
#import "DateChoiceView.h"
#import "SearchViewController.h"
#import "RecentCViewController.h"
#import "ChatroomViewController.h"
#import "MemberInfoViewController.h"
#import "PutQuestionViewController.h"
#import "CNewsViewController.h"
#import "VPKCClientManager.h"
#import "ChatItem.h"
#import "ContactsItem.h"
#import "ArchiveClass.h"
#import "InterrogationCell.h"
#import "TeamChatViewController.h"
#import "MJRefresh.h"

@interface InterrogationViewController ()<DateChoiceDelegate>

@end
@implementation InterrogationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"问诊"];
    newNewsArray=[[ArchiveClass new] getLocalNews];
    contactsArray=[NSMutableArray new];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtable:) name:@"OfflineHaveNews" object:nil];
    [self sendRequest:@"Complaint" andPath:queryURL andSqlParameter:@[CHATCODE,@""] and:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.myTabBarController showTabBar];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        NSLog(@"=========%@",data);
        if (data>0) {
            for (NSDictionary *dict in data) {
                ContactsItem *Item=[RMMapper objectWithClass:[ContactsItem class] fromDictionary:dict];
                [contactsArray addObject:Item];
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"暂无联系人信息"];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    
}

- (void)refreshtable:(NSNotification*)not{
    newNewsArray=not.object;
    if (newNewsTableView&&newNewsTableView.hidden==NO){
        [newNewsTableView reloadData];
        newNewsTableView.frame=CGRectMake(0, newNewsTableView.frame.origin.y, SCREENWIDTH,67*newNewsArray.count);
        complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,newNewsTableView.frame.origin.y+newNewsTableView.frame.size.height+8, complaintBackView.frame.size.width, complaintBackView.frame.size.height);
    }
    int newsCount=0;
    for (ChatItem *item in newNewsArray) {
        newsCount+=item.unsend;
    }
    [self addNewsCount:[NSString stringWithFormat:@"%d",newsCount]];
}

- (void)addNewsCount:(NSString*)newsCount{
    if ([newsCount intValue]==0) {
        self.myTabBarController.newsLabel.text=@"0";
        self.myTabBarController.newsLabel.hidden=YES;
        newNewsCountLabel.text=@"0";
        newNewsCountLabel.hidden=YES;
        UIImageView *openImageView=[[specialBackView subviews] objectAtIndex:0];
        openImageView.image=[UIImage imageNamed:@"arrow"];
        specialBackView.selected=NO;
    }else{
        self.myTabBarController.newsLabel.hidden=NO;
        self.myTabBarController.newsLabel.text=newsCount;
        newNewsCountLabel.hidden=NO;
        newNewsCountLabel.text=newsCount;
    }
}

- (void)creatUI{
    UIView *fBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 122)];
    fBackView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:fBackView];
//
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
    
    NSArray *btnNameArray=@[@"签约居民",@"健康俱乐部",@"问诊贴吧"];
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
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,fBackView.frame.origin.y+fBackView.frame.size.height+8,SCREENWIDTH, SCREENHEIGHT-230)];
    [self.view addSubview:mainScrollView];
    
    specialBackView=[self addButton:CGRectMake(0, 0, SCREENWIDTH, 45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(getSData:)];
    [mainScrollView addSubview:specialBackView];
    
    UIImageView *openImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,18, 10, 10)];
    openImageView.image=[UIImage imageNamed:@"arrow"];
    [specialBackView addSubview:openImageView];
    
    UILabel *sLabel=[self addLabel:CGRectMake(33,13,100,20) andText:@"新消息" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [specialBackView addSubview:sLabel];
    
    newNewsCountLabel=[self addLabel:CGRectMake(SCREENWIDTH-35,12.5,20,20) andText:@"" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    newNewsCountLabel.backgroundColor=[UIColor redColor];
    newNewsCountLabel.clipsToBounds=YES;
    newNewsCountLabel.hidden=YES;
    [newNewsCountLabel.layer setCornerRadius:10];
    [specialBackView addSubview:newNewsCountLabel];
    
    NSInteger newsCount=0;
    if (newNewsArray.count>0) {
        for (ChatItem *item in newNewsArray) {
            newsCount+=item.unsend;
        }
        newNewsCountLabel.hidden=NO;
        newNewsCountLabel.text=[NSString stringWithFormat:@"%ld",newsCount];
        self.myTabBarController.newsLabel.hidden=NO;
        self.myTabBarController.newsLabel.text=[NSString stringWithFormat:@"%ld",newsCount];
    }
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:specialBackView];
    [self addLineLabel:CGRectMake(0,44.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:specialBackView];
    
    
    complaintBackView=[self addButton:CGRectMake(0, specialBackView.frame.origin.y+specialBackView.frame.size.height+8, SCREENWIDTH, 45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(getCData:)];
    [mainScrollView addSubview:complaintBackView];
    
    UIImageView *openImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(15,18, 10, 10)];
    openImageView1.image=[UIImage imageNamed:@"arrow"];
    [complaintBackView addSubview:openImageView1];
    
    UILabel *cLabel=[self addLabel:CGRectMake(33,13,SCREENWIDTH-40,20) andText:@"最近联系人" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [complaintBackView addSubview:cLabel];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:complaintBackView];
    [self addLineLabel:CGRectMake(0,44.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:complaintBackView];
}

- (void)menuButtonClick:(UIButton*)button{
    if (button.tag==101) {
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        if ([self changeNullString:[usd objectForKey:@"LTeamId"]].length>0) {
            RecentCViewController*rvc=[RecentCViewController new];
            [self.myTabBarController hidesTabBar];
            [self.navigationController pushViewController:rvc animated:YES];
        }else{
            [self showSimplePromptBox:self andMesage:@"您暂未加入医生团队"];
        }
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

- (void)searchClick:(UIButton*)button{
    [self.navigationController setNavigationBarHidden:YES];
    [self.myTabBarController hidesTabBar];
    SearchViewController *svc=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)getSData:(UIButton*)button{
    UIImageView *openImageView=[[button subviews] objectAtIndex:0];
    if (newNewsArray.count>0) {
        openImageView.image=[UIImage imageNamed:@"arrow_down"];
        if (button.selected==NO) {
            if (newNewsTableView) {
                newNewsTableView.hidden=NO;
                [newNewsTableView reloadData];
                newNewsTableView.frame=CGRectMake(0, newNewsTableView.frame.origin.y,SCREENWIDTH, newNewsArray.count*67);
            }else{
                newNewsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, specialBackView.frame.origin.y+45, SCREENWIDTH, 67*newNewsArray.count) style:UITableViewStylePlain];
                newNewsTableView.delegate=self;
                newNewsTableView.dataSource=self;
                newNewsTableView.scrollEnabled=NO;
                newNewsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                [mainScrollView addSubview:newNewsTableView];
            }
            complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,newNewsTableView.frame.origin.y+newNewsTableView.frame.size.height+8, complaintBackView.frame.size.width, complaintBackView.frame.size.height);
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
            button.selected=YES;
        }else{
            openImageView.image=[UIImage imageNamed:@"arrow"];
            UIView *sListBackView=[self.view viewWithTag:111];
            [sListBackView removeFromSuperview];
            newNewsTableView.hidden=YES;
            
            complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,specialBackView.frame.origin.y+specialBackView.frame.size.height+8, complaintBackView.frame.size.width, complaintBackView.frame.size.height);
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
            button.selected=NO;
        }
    }else{
        [self showSimplePromptBox:self andMesage:@"暂无新消息"];
    }
}




- (void)getCData:(UIButton*)button{
    UIImageView *openImageView=[[button subviews] objectAtIndex:0];
    if (contactsArray.count>0) {
        if (button.selected==NO) {
            openImageView.image=[UIImage imageNamed:@"arrow_down"];
            if (contactsTableView) {
                contactsTableView.hidden=NO;
                [contactsTableView reloadData];
            }else{
                contactsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, complaintBackView.frame.origin.y+45, SCREENWIDTH, 67*contactsArray.count) style:UITableViewStylePlain];
                contactsTableView.delegate=self;
                contactsTableView.dataSource=self;
                contactsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                [mainScrollView addSubview:contactsTableView];
            }
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, contactsTableView.frame.origin.y+contactsTableView.frame.size.height+20);
            button.selected=YES;
        }else{
            openImageView.image=[UIImage imageNamed:@"arrow"];
            UIView *cListBackView=[self.view viewWithTag:112];
            [cListBackView removeFromSuperview];
            contactsTableView.hidden=YES;
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
            button.selected=NO;
        }
    }else{
        [self showSimplePromptBox:self andMesage:@"暂无联系人信息"];
    }
}

- (void)userBtnClick:(UIButton*)button{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==newNewsTableView) {
        return newNewsArray.count;
    }else{
        return contactsArray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"InterrogationCell";
    InterrogationCell *cell = (InterrogationCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[InterrogationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (tableView==newNewsTableView) {
        ChatItem *item=[newNewsArray objectAtIndex:indexPath.row];
        if ([item.type isEqualToString:@"home"]) {
            cell.nameLabel.text=item.toName;
            [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.fromFace]] placeholderImage:[UIImage imageNamed:@"doctorteam_default"]];
        }else{
            [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.fromFace]] placeholderImage:[UIImage imageNamed:@"user_default"]];
            cell.nameLabel.text=item.fromName;
        }
        cell.timeLabel.text=[self getSubTime:[self setTime:item.timestamp] andFormat:@"MM-dd"];
        if ([item.contentType isEqualToString:@"文本"]||[item.contentType isEqualToString:@"txt"]) {
            cell.newsLabel.text=item.content;
        }else if ([item.contentType isEqualToString:@"图片"]||[item.contentType isEqualToString:@"img"]){
            cell.newsLabel.text=@"[图片]";
        }
        cell.countLabel.text=[NSString stringWithFormat:@"%d",item.unsend];
    }else{
        ContactsItem *item=[contactsArray objectAtIndex:indexPath.row];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,@""]] placeholderImage:[UIImage imageNamed:@"ell_1"]];
        
        if ([item.LIsTeam isEqualToString:@"是"]) {
            cell.nameLabel.text=[NSString stringWithFormat:@"%@(%@)",item.teamName,item.jmName];
        }else{
            cell.nameLabel.text=item.jmName;
        }
        cell.timeLabel.text=@"";
        cell.newsLabel.text=item.jmName;
        cell.countLabel.hidden=YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==newNewsTableView) {
        ChatItem *item=[newNewsArray objectAtIndex:indexPath.row];
        [newNewsArray removeObjectAtIndex:indexPath.row];
        newNewsTableView.frame=CGRectMake(0, newNewsTableView.frame.origin.y, SCREENWIDTH, 67+newNewsArray.count);
        if (newNewsArray.count==0) {
            newNewsTableView.hidden=YES;
            complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,specialBackView.frame.origin.y+specialBackView.frame.size.height+8, complaintBackView.frame.size.width,45);
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
        }else{
            complaintBackView.frame=CGRectMake(complaintBackView.frame.origin.x,newNewsTableView.frame.origin.y+newNewsTableView.frame.size.height+8, complaintBackView.frame.size.width,45);
            mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, complaintBackView.frame.origin.y+complaintBackView.frame.size.height+20);
        }
        [newNewsTableView reloadData];
        
        int newsCount=[newNewsCountLabel.text intValue]-item.unsend;
        [self addNewsCount:[NSString stringWithFormat:@"%d",newsCount]];
        if ([item.type isEqualToString:@"home"]) {
            TeamChatViewController *mvc=[TeamChatViewController new];
            ChatItem *nItem=[ChatItem new];
            nItem.from=item.to;
            nItem.fromName=item.toName;
            nItem.fromFace=item.toFace;
            mvc.chatItem=nItem;
            mvc.whoPush=@"INT";
            [self.myTabBarController hidesTabBar];
            [self.navigationController pushViewController:mvc animated:YES];
        }else{
            CNewsViewController *mvc=[CNewsViewController new];
            mvc.chatItem=item;
            mvc.whoPush=@"INT";
            [self.myTabBarController hidesTabBar];
            [self.navigationController pushViewController:mvc animated:YES];
        }
        [[ArchiveClass new] saveNewsToLocal:newNewsArray];
        
    }else{
        ChatItem *item=[ChatItem new];
        ContactsItem *cItem=[contactsArray objectAtIndex:indexPath.row];
        if ([cItem.LIsTeam isEqualToString:@"是"]) {
            item.fromName=cItem.teamName;
            item.from=cItem.LTeamId;
            item.fromFace=@"";
            
            TeamChatViewController *mvc=[TeamChatViewController new];
            mvc.chatItem=item;
            mvc.whoPush=@"INT";
            [self.myTabBarController hidesTabBar];
            [self.navigationController pushViewController:mvc animated:YES];
        }else{
            item.fromName=cItem.jmName;
            item.from=cItem.LOnlyCode;
            item.fromFace=@"";
            CNewsViewController *mvc=[CNewsViewController new];
            mvc.chatItem=item;
            mvc.whoPush=@"INT";
            [self.myTabBarController hidesTabBar];
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }
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
