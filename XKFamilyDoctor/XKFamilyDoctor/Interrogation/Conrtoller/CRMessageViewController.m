//
//  CRMessageViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CRMessageViewController.h"
#import "ChatRoomPeopleItem.h"
#import "RoomMemberListViewController.h"
@interface CRMessageViewController ()

@end

@implementation CRMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.chatRoomItem.LRoomName];
    [self addLeftButtonItem];
    mainArray=[NSMutableArray new];
    [self creatUI];
    [self sendRequest:@"ChatRoomPeople" andPath:queryURL andSqlParameter:@[self.chatRoomItem.LID,@"",@"1"] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in data) {
                ChatRoomPeopleItem *item=[RMMapper objectWithClass:[ChatRoomPeopleItem class] fromDictionary:dic];
                [mainArray addObject:item];
            }
            [self addMember];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    if ([type isEqualToString:@"ChatRoomPeople"]) {
        [self showSimplePromptBox:self andMesage:@"获取聊天室群成员信息失败"];
    }
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH,SCREENHEIGHT-64)];
    [self.view addSubview:mainScrollView];
    
    UIView *fBackView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 198) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:fBackView];
    
    UIImageView *hpImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-63)/2,34,63,63)];
    //    hpImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,self.chatRoomItem]] placeholderImage:<#(UIImage *)#>;
    hpImageView.image=DOCDEFAULTPIC;
    [fBackView addSubview:hpImageView];
    
    UILabel *levelLabel=[self addLabel:CGRectMake(0,hpImageView.frame.origin.y+hpImageView.frame.size.height+10, SCREENWIDTH, 20) andText:[NSString stringWithFormat:@"责任医生:%@",self.chatRoomItem.LMainDoctorName] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
    [fBackView addSubview:levelLabel];
    
    fBackView.frame=CGRectMake(0, 0, SCREENWIDTH, levelLabel.frame.origin.y+levelLabel.frame.size.height+20);
    
    //    UILabel *numberLabel=[self addLabel:CGRectMake(0,levelLabel.frame.origin.y+levelLabel.frame.size.height, SCREENWIDTH, 20) andText:@"工号:003" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
    //    [fBackView addSubview:numberLabel];
    
    if (self.chatRoomItem.LSpeakRange.length>0) {
        UILabel *tagLabel=[self addLabel:CGRectMake(15,levelLabel.frame.origin.y+levelLabel.frame.size.height, 0, 0) andText:self.chatRoomItem.LSpeakRange andFont:12 andColor:MAINWHITECOLOR andAlignment:1];
        [tagLabel sizeToFit];
        tagLabel.frame=CGRectMake((SCREENWIDTH-tagLabel.frame.size.width-20)/2,tagLabel.frame.origin.y, tagLabel.frame.size.width+20, 20);
        tagLabel.backgroundColor=GREENCOLOR;
        [tagLabel.layer setCornerRadius:10];
        tagLabel.layer.masksToBounds=YES;
        [fBackView addSubview:tagLabel];
        
        fBackView.frame=CGRectMake(0, 0, SCREENWIDTH, tagLabel.frame.origin.y+tagLabel.frame.size.height+20);
        
    }
    
    //    NSArray *tagArray=@[@"美容",@"瘦身",@"马甲"];
    //    NSMutableArray *tagLabelArray=[NSMutableArray new];
    //    for (int i=0; i<tagArray.count; i++) {
    //        UILabel *tagLabel=[self addLabel:CGRectMake(15, numberLabel.frame.origin.y+numberLabel.frame.size.height+15, 0, 0) andText:[tagArray objectAtIndex:i] andFont:12 andColor:MAINWHITECOLOR andAlignment:1];
    //        [tagLabel sizeToFit];
    //        tagLabel.frame=CGRectMake(15,tagLabel.frame.origin.y, tagLabel.frame.size.width+20, 20);
    //        tagLabel.backgroundColor=LINECOLOR;
    //        [tagLabel.layer setCornerRadius:10];
    //        tagLabel.layer.masksToBounds=YES;
    //        [fBackView addSubview:tagLabel];
    //
    //        if (i>0) {
    //            UILabel *upLabel=[tagLabelArray objectAtIndex:i-1];
    //            tagLabel.frame=CGRectMake(upLabel.frame.origin.x+upLabel.frame.size.width+10,tagLabel.frame.origin.y, tagLabel.frame.size.width, 20);
    //        }
    //        [tagLabelArray addObject:tagLabel];
    //    }
    
    [self addLineLabel:CGRectMake(0,fBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    self.allMemberButton=[self addButton:CGRectMake(0,fBackView.frame.origin.y+fBackView.frame.size.height+8, SCREENWIDTH,111) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(roomMemberOnclick)];
    [mainScrollView addSubview:self.allMemberButton];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(15, 10,60, 20) andText:@"群成员" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [self.allMemberButton addSubview:nameLabel];
    
    UIImageView *mImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-22,16,7, 13)];
    mImageView.image=[UIImage imageNamed:@"arrow_2"];
    [self.allMemberButton addSubview:mImageView];
    
    [self addLineLabel:CGRectMake(0,44.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.allMemberButton];
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.allMemberButton];
    [self addLineLabel:CGRectMake(0,self.allMemberButton.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.allMemberButton];
    
    
    UIView *introduceBackView=[self addSimpleBackView:CGRectMake(0, self.allMemberButton.frame.origin.y+self.allMemberButton.frame.size.height+8, SCREENWIDTH, 110) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:introduceBackView];
    
    UILabel *introduceLabel=[self addLabel:CGRectMake(15, 12.5,200, 20) andText:@"聊天室介绍" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [introduceBackView addSubview:introduceLabel];
    
    UILabel *introduceCLabel=[self addLabel:CGRectMake(15,45,SCREENWIDTH-30, 20) andText:self.chatRoomItem.LRoomDetail andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
    introduceCLabel.numberOfLines=0;
    [introduceCLabel sizeToFit];
    [introduceBackView addSubview:introduceCLabel];
    introduceBackView.frame=CGRectMake(0, introduceBackView.frame.origin.y, SCREENWIDTH, introduceCLabel.frame.origin.y+introduceCLabel.frame.size.height+10);
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:introduceBackView];
    [self addLineLabel:CGRectMake(0,introduceBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:introduceBackView];
    
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH,  introduceBackView.frame.origin.y+introduceBackView.frame.size.height+20);
}

- (void)addMember{
    UILabel *countLabel=[self addLabel:CGRectMake(85,12.5,SCREENWIDTH-115, 20) andText:[NSString stringWithFormat:@"%lu人",(unsigned long)mainArray.count] andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [self.allMemberButton addSubview:countLabel];
    
    for (int i=0; i<mainArray.count; i++) {
        ChatRoomPeopleItem *item=[mainArray objectAtIndex:i];
        UIImageView *memberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+61*i, 53, 50,50)];
        [memberImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LHeadPic]] placeholderImage:USERDEFAULTPIC];
        [memberImageView.layer setCornerRadius:25];
        memberImageView.clipsToBounds=YES;
        [self.allMemberButton addSubview:memberImageView];
    }
}

- (void)roomMemberOnclick{
    if (mainArray.count>0) {
        RoomMemberListViewController *rvc=[RoomMemberListViewController new];
        rvc.mainArray=mainArray;
        rvc.chatRoomItem=self.chatRoomItem;
        [self.navigationController pushViewController:rvc animated:YES];
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
