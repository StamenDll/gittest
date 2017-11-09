//
//  PostDetailViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PostDetailViewController.h"
#import "QuestionDetailTableViewCell.h"
#import "QuestiondetailFrame.h"
#import "QuestionDetailIItem.h"
#import "WriteCommentViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "PutQuestionViewController.h"
@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray=[NSMutableArray new];
    [self addTitleView:@"提问详情"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self creatUI];
    nowCount=1;
    [self sendRequest:@"CommentList" andPath:queryURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID,@"",@"1"] and:self];
}

- (void)popViewController{
    if (isChange==YES) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[PutQuestionViewController class]]) {
                PutQuestionViewController *pvc=(PutQuestionViewController*)vc;
                pvc.isChange=@"Y";
                [self.navigationController popToViewController:pvc animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addRightButtonItem{
    UIButton *rButton=[self addButton:CGRectMake(0, 0, 50,45) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(collectOnclick:)];
    [rButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [rButton setImage:[UIImage imageNamed:@"collect_y"] forState:UIControlStateSelected];
    if (![self.putQuestionFrame.questionMessage.StoreTime isKindOfClass:[NSNull class]]) {
        rButton.selected=YES;
    }
    rButton.tag=11;
    rButton.imageEdgeInsets=UIEdgeInsetsMake(10,25,10,0);
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)collectOnclick:(UIButton*)button{
    if (button.selected==NO) {
        [self sendRequest:@"AddCollect" andPath:excuteURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID,[self getNowTime]] and:self];
    }else{
        [self showPromptBox:self andMesage:@"确定要取消收藏吗？" andSel:@selector(cancelCollect)];
    }
}

- (void)cancelCollect{
    [self sendRequest:@"DelCollect" andPath:excuteURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID] and:self];
}

- (void)viewDidAppear:(BOOL)animated{
    if ([self.isAdd isEqualToString:@"Y"]) {
        [self sendRequest:@"CommentList" andPath:queryURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID,@"",@"1"] and:self];
        self.isAdd=nil;
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"CommentList"]) {
            if (data.count>0) {
                [dataArray removeAllObjects];
                for (NSDictionary *dic in data) {
                    QuestionDetailIItem *item=[RMMapper objectWithClass:[QuestionDetailIItem class] fromDictionary:dic];
                    QuestiondetailFrame *fram=[QuestiondetailFrame new];
                    fram.questionAnswer=item;
                    totalCount=item.p_t_c_n;
                    [dataArray addObject:fram];
                }
                [self setPagView];
                if (nowCount!=1) {
                    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
                    [mainTableView setTableHeaderView:view];
                }else{
                  mainTableView.tableHeaderView=qBGView;
                }
                [mainTableView reloadData];
            }
        }else{
            isChange=!isChange;
            UIButton *collectButton=(UIButton*)[self.navigationController.view viewWithTag:11];
            NSString *advice=nil;
            if ([type isEqualToString:@"AddCollect"]){
                advice=@"添加收藏成功";
                collectButton.selected=YES;
            }else{
                advice=@"取消收藏成功";
                collectButton.selected=NO;
            }
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:advice preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFail:(NSString *)type{
    
}

- (void)creatUI{
    qBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 40) andColor:MAINWHITECOLOR];
    UILabel *qLabel=[self addLabel:CGRectMake(15, 10, SCREENWIDTH-30, 20) andText:self.putQuestionFrame.questionMessage.LTitle andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [qBGView addSubview:qLabel];
    
    UIImageView *userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 30, 30)];
    [userImageView.layer setCornerRadius:15];
    userImageView.clipsToBounds=YES;
    [userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,self.putQuestionFrame.questionMessage.LHeadPic]] placeholderImage:USERDEFAULTPIC];
    [qBGView addSubview:userImageView];
    
    UILabel *userNameLabel=[self addLabel:CGRectMake(50,45, SCREENWIDTH-65, 20) andText:self.putQuestionFrame.questionMessage.LSenderName andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [qBGView addSubview:userNameLabel];
    
    [self addLineLabel:CGRectMake(15, 80, SCREENWIDTH-30, 0.5) andColor:LINECOLOR andBackView:qBGView];
    
    UILabel *postContentLabel=[self addLabel:CGRectMake(15, 90, SCREENWIDTH-30, 20) andText:[self changeString:self.putQuestionFrame.questionMessage.LDetail andType:@"in"] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    postContentLabel.numberOfLines=0;
    [postContentLabel sizeToFit];
    [qBGView addSubview:postContentLabel];
    
    qBGView.frame=CGRectMake(0, 0, SCREENWIDTH,postContentLabel.frame.origin.y+postContentLabel.frame.size.height);
    
    if ([self changeNullString:self.putQuestionFrame.questionMessage.LPic1].length>0) {
        UIImageView *contentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, postContentLabel.frame.origin.y+postContentLabel.frame.size.height+10,(SCREENWIDTH-40)/2, (SCREENWIDTH-40)/2)];
        [contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,self.putQuestionFrame.questionMessage.LPic1]] placeholderImage:[UIImage imageNamed:@""]];
        contentImageView.contentMode=UIViewContentModeScaleAspectFill;
        contentImageView.clipsToBounds =YES;
        [qBGView addSubview:contentImageView];
        qBGView.frame=CGRectMake(0, 0, SCREENWIDTH,contentImageView.frame.origin.y+contentImageView.frame.size.height);
        
        if ([self changeNullString:self.putQuestionFrame.questionMessage.LPic2].length>0) {
            UIImageView *contentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(25+(SCREENWIDTH-40)/2, postContentLabel.frame.origin.y+postContentLabel.frame.size.height+10,(SCREENWIDTH-40)/2, (SCREENWIDTH-40)/2)];
            [contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,self.putQuestionFrame.questionMessage.LPic2]] placeholderImage:[UIImage imageNamed:@""]];
            contentImageView.contentMode=UIViewContentModeScaleAspectFill;
            contentImageView.clipsToBounds =YES;
            [qBGView addSubview:contentImageView];
        }
    }
    
    UILabel *timeLabel=[self addLabel:CGRectMake(15,qBGView.frame.size.height+10, SCREENWIDTH/2, 20) andText:[self getSubTime:self.putQuestionFrame.questionMessage.LWTime andFormat:@"yyyy-MM-dd HH:mm"] andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
    [qBGView addSubview:timeLabel];
    
    UIButton *commentButton=[self addButton:CGRectMake(SCREENWIDTH-115,qBGView.frame.size.height, 100, 40) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    commentButton.imageEdgeInsets=UIEdgeInsetsMake(13, 50, 12, 0);
    [qBGView addSubview:commentButton];
    
    UILabel *cCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10,50, 20)];
    cCountLabel.text=[NSString stringWithFormat:@"%d",self.putQuestionFrame.questionMessage.LAnswerNum];
    cCountLabel.textColor=TEXTCOLORDG;
    cCountLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    cCountLabel.textAlignment=2;
    [commentButton addSubview:cCountLabel];
    
    [self addLineLabel:CGRectMake(0, commentButton.frame.origin.y+commentButton.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:qBGView];
    
    UILabel *commentTitlelabel=[self addLabel:CGRectMake(15, commentButton.frame.origin.y+commentButton.frame.size.height+10, SCREENWIDTH, 20) andText:@"相关评价" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [qBGView addSubview:commentTitlelabel];
    qBGView.frame=CGRectMake(0, 0, SCREENWIDTH,commentTitlelabel.frame.origin.y+30);
    
    [self addLineLabel:CGRectMake(0,qBGView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:qBGView];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-114) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.backgroundColor=BGGRAYCOLOR;
    mainTableView.tableHeaderView=qBGView;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    
    writeCommentBGView=[self addSimpleBackView:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH,50) andColor:MAINWHITECOLOR];
    [self.view addSubview:writeCommentBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:writeCommentBGView];
    
    UIButton *writeButton=[self addButton:CGRectMake(15,10, SCREENWIDTH-30,30) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(writeComment)];
    writeButton.layer.borderWidth=0.5;
    writeButton.layer.borderColor=LINECOLOR.CGColor;
    [writeButton.layer setCornerRadius:5];
    [writeCommentBGView addSubview:writeButton];
    
    
    UILabel *commentLabel=[self addLabel:CGRectMake(0, 5,0, 20) andText:@"发表评论" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [commentLabel sizeToFit];
    commentLabel.frame=CGRectMake((writeButton.frame.size.width-commentLabel.frame.size.width-30)/2+30, 5, commentLabel.frame.size.width, 20);
    [writeButton addSubview:commentLabel];
    
    UIImageView *writeImageView=[self addImageView:CGRectMake(commentLabel.frame.origin.x-30, 2.5, 25, 25) andName:@"questions"];
    [writeButton addSubview:writeImageView];
    
    
    //    UIButton *inciteButton=[self addButton:CGRectMake(SCREENWIDTH-100, 10,85, 30) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    //    [inciteButton setImage:[UIImage imageNamed:@"incite"] forState:UIControlStateNormal];
    //    inciteButton.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 64);
    //   [writeCommentBGView addSubview:inciteButton];
    //
    //    UILabel *inciteLabel=[self addLabel:CGRectMake(25, 5,60, 20) andText:@"给点鼓励~" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:0];
    //    [inciteButton addSubview:inciteLabel];
}

- (void)setPagView{
    if (!pageBGView) {
        pageBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH,60) andColor:CLEARCOLOR];
        mainTableView.tableFooterView=pageBGView;
        
        UIView *subBGView=[self addSimpleBackView:CGRectMake(0, 10, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
        subBGView.tag=20;
        [pageBGView addSubview:subBGView];
        
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:subBGView];
        [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:subBGView];
        
        int totalPag=totalCount/30;
        if (totalCount%30>0) {
            totalPag+=1;
        }
        if (totalPag<6) {
            for (int i=0; i<totalPag; i++) {
                UIButton *pageButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-25*totalPag-5*(totalPag-1))/2+30*i,22.5,25,25) andBColor:CLEARCOLOR andTag:i andSEL:@selector(countPage:) andText:[NSString stringWithFormat:@"%d",i+1] andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
                pageButton.layer.borderColor=LINECOLOR.CGColor;
                pageButton.layer.borderWidth=0.5;
                [pageButton.layer setCornerRadius:12.5];
                [pageBGView addSubview:pageButton];
                if (i==0) {
                    pageButton.backgroundColor=GREENCOLOR;
                    UILabel *label=[[pageButton subviews]lastObject];
                    label.textColor=MAINWHITECOLOR;
                    pageButton.selected=YES;
                    lastCountButton=pageButton;
                }
            }
        }else{
            fPageButton=[self addSimpleButton:CGRectMake(10, 20, 30, 30) andBColor:CLEARCOLOR andTag:21 andSEL:@selector(changePage:) andText:@"首页" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
            fPageButton.hidden=YES;
            [pageBGView addSubview:fPageButton];
            
            upPageButton=[self addSimpleButton:CGRectMake(45, 20,40, 30) andBColor:CLEARCOLOR andTag:22 andSEL:@selector(changePage:) andText:@"上一页" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
            upPageButton.hidden=YES;
            [pageBGView addSubview:upPageButton];
            
            for (int i=0; i<5; i++) {
                UIButton *pageButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-145)/2+30*i,22.5,25,25) andBColor:CLEARCOLOR andTag:i andSEL:@selector(countPage:) andText:[NSString stringWithFormat:@"%d",i+1] andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
                pageButton.layer.borderColor=LINECOLOR.CGColor;
                pageButton.layer.borderWidth=0.5;
                [pageButton.layer setCornerRadius:12.5];
                [pageBGView addSubview:pageButton];
                if (i==0) {
                    pageButton.backgroundColor=GREENCOLOR;
                    UILabel *label=[[pageButton subviews]lastObject];
                    label.textColor=MAINWHITECOLOR;
                    pageButton.selected=YES;
                    lastCountButton=pageButton;
                }
            }
            
            lPageButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-40, 20, 30, 30) andBColor:CLEARCOLOR andTag:23 andSEL:@selector(changePage:) andText:@"尾页" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
            [pageBGView addSubview:lPageButton];
            
            nextPageButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-85,20,40, 30) andBColor:CLEARCOLOR andTag:24 andSEL:@selector(changePage:) andText:@"下一页" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
            [pageBGView addSubview:nextPageButton];
        }
    }
}

- (void)changePage:(UIButton*)button{
    if (button==fPageButton) {
        for (UIButton *countButton in [pageBGView subviews]) {
            if (countButton.tag<5) {
                UILabel *label=[[countButton subviews] lastObject];
                label.text=[NSString stringWithFormat:@"%ld",countButton.tag+1];
                if (countButton.tag==0) {
                    fPageButton.hidden=YES;
                    upPageButton.hidden=YES;
                    nextPageButton.hidden=NO;
                    lPageButton.hidden=NO;
                    
                    UILabel *lastLabel=[[lastCountButton subviews] lastObject];
                    UILabel *nowLabel=[[countButton subviews] lastObject];
                    lastCountButton.backgroundColor=CLEARCOLOR;
                    lastLabel.textColor=TEXTCOLOR;
                    countButton.backgroundColor=GREENCOLOR;
                    nowLabel.textColor=MAINWHITECOLOR;
                    countButton.selected=YES;
                    lastCountButton.selected=NO;
                    lastCountButton=countButton;
                }
            }
        }
        nowCount=1;
        [self sendRequest:@"CommentList" andPath:queryURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID,@"",@"1"] and:self];
    }else if (button==upPageButton){
        for (UIButton *countButton in [pageBGView subviews]) {
            if (countButton.tag==lastCountButton.tag-1) {
                [self countPage:countButton];
                break;
            }
        }
    }else if (button==lPageButton){
        int totalPag=totalCount/30;
        if (totalCount%30>0) {
            totalPag+=1;
        }
        for (UIButton *countButton in [pageBGView subviews]) {
            if (countButton.tag<5) {
                UILabel *label=[[countButton subviews] lastObject];
                label.text=[NSString stringWithFormat:@"%ld",totalPag-4+countButton.tag];
                if (countButton.tag==4) {
                    fPageButton.hidden=NO;
                    upPageButton.hidden=NO;
                    nextPageButton.hidden=YES;
                    lPageButton.hidden=YES;
                    
                    UILabel *lastLabel=[[lastCountButton subviews] lastObject];
                    UILabel *nowLabel=[[countButton subviews] lastObject];
                    lastCountButton.backgroundColor=CLEARCOLOR;
                    lastLabel.textColor=TEXTCOLOR;
                    countButton.backgroundColor=GREENCOLOR;
                    nowLabel.textColor=MAINWHITECOLOR;
                    countButton.selected=YES;
                    lastCountButton.selected=NO;
                    lastCountButton=countButton;
                }
            }
        }
        nowCount=totalPag;
        [self sendRequest:@"CommentList" andPath:queryURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID,@"",[NSString stringWithFormat:@"%d",totalPag]] and:self];
    }else if (button==nextPageButton){
        for (UIButton *countButton in [pageBGView subviews]) {
            if (countButton.tag==lastCountButton.tag+1) {
                [self countPage:countButton];
                break;
            }
        }
    }
}

- (void)countPage:(UIButton*)button{
    if (lastCountButton!=button) {
        UIButton *nowButton=button;
        UILabel *label=[[button subviews]lastObject];
        nowCount=[label.text intValue];
        
        int totalPag=totalCount/30;
        if (totalCount%30>0) {
            totalPag+=1;
        }
        if (totalPag>5){
            if (nowCount==1) {
                fPageButton.hidden=YES;
                upPageButton.hidden=YES;
                nextPageButton.hidden=NO;
                lPageButton.hidden=NO;
            }else if (nowCount==totalPag){
                nextPageButton.hidden=YES;
                lPageButton.hidden=YES;
            }else{
                fPageButton.hidden=NO;
                upPageButton.hidden=NO;
                nextPageButton.hidden=NO;
                lPageButton.hidden=NO;
            }
            
            if ((button.tag==4&&nowCount<=totalPag-2)||(button.tag==0&&nowCount>2)) {
                for (UIButton *button in [pageBGView subviews]) {
                    UILabel *label=[[button subviews]lastObject];
                    if (button.tag==0) {
                        label.text=[NSString stringWithFormat:@"%d",nowCount-2];
                    }else if (button.tag==1){
                        label.text=[NSString stringWithFormat:@"%d",nowCount-1];
                    }else if (button.tag==2){
                        label.text=[NSString stringWithFormat:@"%d",nowCount];
                        nowButton=button;
                    }else if (button.tag==3){
                        label.text=[NSString stringWithFormat:@"%d",nowCount+1];
                    }else if (button.tag==4){
                        label.text=[NSString stringWithFormat:@"%d",nowCount+2];
                    }
                }
            }
        }
        
        UILabel *lastLabel=[[lastCountButton subviews] lastObject];
        UILabel *nowLabel=[[nowButton subviews] lastObject];
        lastCountButton.backgroundColor=CLEARCOLOR;
        lastLabel.textColor=TEXTCOLOR;
        nowButton.backgroundColor=GREENCOLOR;
        nowLabel.textColor=MAINWHITECOLOR;
        nowButton.selected=YES;
        lastCountButton.selected=NO;
        lastCountButton=nowButton;
        
        nowCount=[nowLabel.text intValue];
        [self sendRequest:@"CommentList" andPath:queryURL andSqlParameter:@[self.putQuestionFrame.questionMessage.LID,@"",nowLabel.text] and:self];
    }
}

- (void)writeComment{
    WriteCommentViewController *wvc=[WriteCommentViewController new];
    wvc.titleString=@"评论";
    wvc.postID=self.putQuestionFrame.questionMessage.LID;
    [self.navigationController pushViewController:wvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[dataArray objectAtIndex:indexPath.row] cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QuestionDetailTableViewCell";
    QuestionDetailTableViewCell *cell = (QuestionDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[QuestionDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell setAnswerViewFrame:[dataArray objectAtIndex:indexPath.row]];
    cell.replyButton.tag=indexPath.row;
    [cell.replyButton addTarget:self action:@selector(replyOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (cell.commentImageView.hidden==NO) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPic:)];
        tap.numberOfTapsRequired=1;
        cell.commentImageView.tag=indexPath.row;
        [cell.commentImageView addGestureRecognizer:tap];
    }
    return cell;
}

- (void)replyOnclick:(UIButton*)button{
    QuestiondetailFrame *fram=[dataArray objectAtIndex:button.tag];
    WriteCommentViewController *wvc=[WriteCommentViewController new];
    wvc.titleString=[NSString stringWithFormat:@"回复%d楼",fram.questionAnswer.rowid];
    wvc.postID=fram.questionAnswer.LSubjectCode;
    [self.navigationController pushViewController:wvc animated:YES];
}

#pragma mark 查看图片
- (void)lookPic:(UITapGestureRecognizer*)recognizer{
    NSMutableArray *kjphotos = [NSMutableArray array];
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    
    QuestiondetailFrame *fram=[dataArray objectAtIndex:recognizer.view.tag];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,fram.questionAnswer.LPic1]];
    photo.srcImageView =(UIImageView*)recognizer.view; //设置来源哪一个UIImageView
    [kjphotos addObject:photo];
    brower.photos = kjphotos;
    [brower show];
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
