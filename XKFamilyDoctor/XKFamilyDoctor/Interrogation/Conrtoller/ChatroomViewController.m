//
//  ChatroomViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatroomViewController.h"
#import "ChatroomTableViewCell.h"
#import "CRNewsViewController.h"
#import "ChatRoomItem.h"
#import "NoDataView.h"
@interface ChatroomViewController ()

@end

@implementation ChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"健康俱乐部"];
    [self addLeftButtonItem];
    myChatRoomArray=[NSMutableArray new];
    allChatRoomArray=[NSMutableArray new];
    [self creatUI];
    [self sendRequest:@"AllChatRoom" andPath:queryURL andSqlParameter:CHATCODE and:self];
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
//    UIView *fBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,41)];
//    fBackView.backgroundColor=[self colorWithHexString:@"e6e6e6"];
//    [self.view addSubview:fBackView];
//    
//    UIButton *searchButton=[self addButton:CGRectMake(15,70, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:nil];
//    [searchButton.layer setCornerRadius:15];
//    [self.view addSubview:searchButton];
//    
//    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((searchButton.frame.size.width-45)/2,9, 12,12)];
//    searchImageView.image=[UIImage imageNamed:@"search"];
//    [searchButton addSubview:searchImageView];
//    
//    UILabel *npLabel=[self addLabel:CGRectMake((searchButton.frame.size.width-45)/2+16,5,30,20) andText:@"搜索" andFont:14 andColor:TEXTCOLORG andAlignment:0];
//    [searchButton addSubview:npLabel];
    
    NSArray *nameArray=@[@"所有",@"我的"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *chatroomButton=[self addSimpleButton:CGRectMake(SCREENWIDTH/nameArray.count*i,65, SCREENWIDTH/nameArray.count,50) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(changeTableView:) andText:[nameArray objectAtIndex:i] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
        [self.view addSubview:chatroomButton];
        if (i==0) {
            chatroomButton.selected=YES;
            lastChatroomButton=chatroomButton;
        }
    }
    [self addLineLabel:CGRectMake(0, 114.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    UIImageView *blueLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,113, SCREENWIDTH/nameArray.count,2)];
    blueLineImageView.image=[UIImage imageNamed:@"rec_10"];
    blueLineImageView.tag=111;
    [self.view addSubview:blueLineImageView];
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,115,SCREENWIDTH, SCREENHEIGHT-115)];
    mainScrollView.pagingEnabled=YES;
    mainScrollView.showsHorizontalScrollIndicator=NO;
    mainScrollView.delegate=self;
    [self.view addSubview:mainScrollView];
    
    publicTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREENWIDTH,mainScrollView.frame.size.height) style:UITableViewStylePlain];
    publicTableView.delegate=self;
    publicTableView.dataSource=self;
    publicTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mainScrollView addSubview:publicTableView];
}

#pragma mark 请求后回调
- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"MyChatRoom"]) {
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                ChatRoomItem *Item=[RMMapper objectWithClass:[ChatRoomItem class] fromDictionary:dic];
                [myChatRoomArray addObject:Item];
            }
            [myTableView reloadData];
        }else{
            noDataView=[[NoDataView alloc]initWithFrame:CGRectMake(SCREENWIDTH,100, SCREENWIDTH, 100)];
            [mainScrollView addSubview:noDataView];
        }
        }else if([type isEqualToString:@"AllChatRoom"]){
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    ChatRoomItem *Item=[RMMapper objectWithClass:[ChatRoomItem class] fromDictionary:dic];
                    [allChatRoomArray addObject:Item];
                }
            }
            [publicTableView reloadData];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)changeTableView:(UIButton*)button{
    UIImageView *blueLineImageView=[self.view viewWithTag:111];
    mainScrollView.contentOffset=CGPointMake(SCREENWIDTH*(button.tag-101), 0);
    blueLineImageView.frame=CGRectMake(button.frame.origin.x, blueLineImageView.frame.origin.y, blueLineImageView.frame.size.width,2);
    if (button.tag==102&&!myTableView) {
        myTableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,mainScrollView.frame.size.height) style:UITableViewStylePlain];
        myTableView.delegate=self;
        myTableView.dataSource=self;
        myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [mainScrollView addSubview:myTableView];
        
        [self sendRequest:@"MyChatRoom" andPath:queryURL andSqlParameter:nil and:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==publicTableView) {
        return allChatRoomArray.count;
    }
    return myChatRoomArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchTableViewCell";
    ChatroomTableViewCell *cell = (ChatroomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ChatroomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ChatRoomItem *item=nil;
    if (tableView==myTableView) {
        item=[myChatRoomArray objectAtIndex:indexPath.row];
    }else{
       item=[allChatRoomArray objectAtIndex:indexPath.row];
    }
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:[UIImage imageNamed:@"logosss"]];
    [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LItemBigPic]] placeholderImage:[UIImage imageNamed:@"logosss"]];
    cell.nameLabel.text=item.LRoomName;
    cell.personLabel.text=[NSString stringWithFormat:@"%d人",item.LUserTotal];
    cell.doctorLabel.text=[NSString stringWithFormat:@"责任医生:%@",item.LMainDoctorName];
    cell.markLabel.text=item.LSpeakRange;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatRoomItem *item=nil;
    if (tableView==myTableView) {
        item=[myChatRoomArray objectAtIndex:indexPath.row];
    }else{
        item=[allChatRoomArray objectAtIndex:indexPath.row];
    }
    CRNewsViewController *cvc=[CRNewsViewController new];
    cvc.chatRoomItem=item;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"=====11=====%f",scrollView.contentOffset.x/scrollView.contentSize.width);
    UILabel *blueLine=[self.view viewWithTag:111];
    blueLine.frame=CGRectMake(scrollView.contentOffset.x/scrollView.contentSize.width*SCREENWIDTH, blueLine.frame.origin.y, blueLine.frame.size.width, 1);
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
