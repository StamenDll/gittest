//
//  ChatView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatView.h"
#import "ChatTableViewCell.h"
#import "ChatItem.h"
#import "ChartFrame.h"
#import "VPKCClientManager.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation ChatView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
MQTTClient *client;
NSString *topic;
int count=0;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=MAINWHITECOLOR;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


//创建聊天界面
- (void)creatUI:(NSString*)topc andName:(NSString*)name andFace:(NSString *)face andType:(NSString *)type andOwer:(NSString *)owerID{
    self.isCanSend=@"0";
    self.toName=name;
    self.toTopc=topc;
    self.toFace=face;
    self.chatType=type;
    self.owerID=owerID;
    chatArray=[NSMutableArray new];
    imageArray=[NSMutableArray new];
    
    self.mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.frame.size.height-50) style:UITableViewStylePlain];
    self.mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    [self addSubview:self.mainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewsToView:) name:@"HaveNews" object:nil];
    
    [self creatChat];
    
    writeBAckView=[[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-49, self.frame.size.width, 49)];
    writeBAckView.backgroundColor=[UIColor whiteColor];
    [self addSubview:writeBAckView];
    
    [self addLineLabel:CGRectMake(0, 0, self.frame.size.width, 0.5) andColor:[UIColor grayColor] andBackView:writeBAckView];
    
    UIButton *yyButton=[self addButton:CGRectMake(15,7, 34, 34) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(yyOnclick:)];
    [yyButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [writeBAckView addSubview:yyButton];
    
    [yyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(writeBAckView.mas_left).offset(15);
        make.centerY.equalTo(writeBAckView.mas_centerY);
        make.height.with.mas_equalTo(34);
    }];
    
    newsTextView=[UITextView new];
    newsTextView.font=[UIFont systemFontOfSize:16];
    newsTextView.delegate=self;
    newsTextView.returnKeyType=UIReturnKeySend;
    [writeBAckView addSubview:newsTextView];
    
    [newsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(62);
        make.bottom.mas_equalTo(-6);
        make.width.mas_equalTo(SCREENWIDTH-156);
    }];
    
    UIImageView *lineImageView=[UIImageView new];
    lineImageView.image=[UIImage imageNamed:@"rec_8"];
    [writeBAckView addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(writeBAckView.mas_bottom).offset(-8);
        make.left.equalTo(writeBAckView.mas_left).offset(62);
        make.right.equalTo(writeBAckView.mas_right).offset(-62);
        make.height.mas_equalTo(0.5);
    }];
    
    //    UIButton *bqButton=[self addButton:CGRectMake(SCREENWIDTH-94,12, 24, 24) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    //    [bqButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    //    [writeBAckView addSubview:bqButton];
    //
    //    [bqButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(writeBAckView.mas_right).offset(-94);
    //        make.centerY.equalTo(writeBAckView.mas_centerY);
    //        make.height.with.mas_equalTo(24);
    //    }];
    
    yyBGView=[YYView new];
    yyBGView.backgroundColor=MAINWHITECOLOR;
    yyBGView.layer.borderColor=LINECOLOR.CGColor;
    yyBGView.layer.borderWidth=0.5;
    yyBGView.delegate=self;
    yyBGView.hidden=YES;
    [writeBAckView addSubview:yyBGView];
    [yyBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(writeBAckView.mas_top).offset(7);
        make.left.right.bottom.equalTo(lineImageView);
    }];
    
    UIButton *addButton=[self addButton:CGRectMake(SCREENWIDTH-49,7,34,34) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(moreMenuClick:)];
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [writeBAckView addSubview:addButton];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(writeBAckView.mas_right ).offset(-49);
        make.centerY.equalTo(writeBAckView.mas_centerY);
        make.height.with.mas_equalTo(34);
    }];
}

- (void)yyOnclick:(UIButton*)button{
    if (button.selected==NO){
        [button setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        [newsTextView resignFirstResponder];
        yyBGView.hidden=NO;
        button.selected=YES;
    }else{
        [button setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        yyBGView.hidden=YES;
        button.selected=NO;
    }
}

- (void)sendYYNews:(NSString *)yyString{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    NSDictionary *msgDic = @{@"from" :CHATCODE, @"fromName" :[usd objectForKey:@"LName"], @"fromFace":[self changeNullString:self.toFace], @"channel" : @"ios", @"to" : self.toTopc,@"toName":self.toName,@"toFace" :[self changeNullString:self.toFace],@"type" : self.chatType,@"contentType" : @"audio", @"content":[NSString stringWithFormat:@"%.0f|%@",[self yyLength:yyString],yyString]};
    [self showSendNews:[NSString stringWithFormat:@"%.0f|%@",[self yyLength:yyString],yyString] andContentType:@"语音" andNews:msgDic];
}

- (void)moreMenuClick:(UIButton*)button{
    NSLog(@"======111111111=====");
    [newsTextView resignFirstResponder];
    if (!moreMenuBGView) {
        moreMenuBGView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SCREENWIDTH, 110)];
        moreMenuBGView.backgroundColor=MAINWHITECOLOR;
        [self addSubview:moreMenuBGView];
        
        NSArray *menuArray=@[@"拍照",@"相册照片"];
        NSArray *menuImageArray=@[@"camera",@"photo"];
        for (int i=0; i<menuArray.count; i++) {
            UIButton *menuButton=[self addButton:CGRectMake(SCREENWIDTH/4*(i%4),80*(i/4), SCREENWIDTH/4,80) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(menuOnclick:)];
            [moreMenuBGView addSubview:menuButton];
            
            UIImageView *menuImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH/4-30)/2, 20, 34, 31)];
            menuImageView.image=[UIImage imageNamed:[menuImageArray objectAtIndex:i]];
            [menuButton addSubview:menuImageView];
            
            UILabel *menuNaemLabel=[self addLabel:CGRectMake(0,60, SCREENWIDTH/4, 20) andText:[menuArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
            [menuButton addSubview:menuNaemLabel];
        }
    }
    if (moreMenuBGView.frame.origin.y==self.frame.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            moreMenuBGView.frame=CGRectMake(0, self.frame.size.height-moreMenuBGView.frame.size.height, SCREENWIDTH,moreMenuBGView.frame.size.height);
            writeBAckView.frame=CGRectMake(0,moreMenuBGView.frame.origin.y-writeBAckView.frame.size.height, SCREENWIDTH, writeBAckView.frame.size.height);
            self.mainTableView.frame=CGRectMake(0,0, self.frame.size.width,writeBAckView.frame.origin.y);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            moreMenuBGView.frame=CGRectMake(0, self.frame.size.height, SCREENWIDTH, moreMenuBGView.frame.size.height);
            writeBAckView.frame=CGRectMake(0,self.frame.size.height-writeBAckView.frame.size.height, SCREENWIDTH, writeBAckView.frame.size.height);
            self.mainTableView.frame=CGRectMake(0,0, self.frame.size.width,writeBAckView.frame.origin.y);
            
        }];
    }
}

- (void)menuOnclick:(UIButton*)button{
    if (button.tag==101) {
        if ([self.delegate respondsToSelector:@selector(choiceImageView:)]) {
            [self.delegate choiceImageView:@"TP"];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(choiceImageView:)]) {
            [self.delegate choiceImageView:@"CP"];
        }
    }
}

#pragma  mark  发送图片消息
- (void)sendPicNews:(NSString*)imageString{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    NSDictionary *msgDic = @{@"from" :CHATCODE, @"fromName" :[usd objectForKey:@"LName"], @"fromFace":[self changeNullString:HEADPIC], @"channel" : @"ios", @"to" : self.toTopc,@"toName":self.toName,@"toFace" :[self changeNullString:self.toFace],@"type" : self.chatType,@"contentType" : @"img", @"content":imageString};
    [self showSendNews:imageString andContentType:@"图片" andNews:msgDic];
    [UIView animateWithDuration:0.1 animations:^{
        moreMenuBGView.frame=CGRectMake(0, self.frame.size.height, SCREENWIDTH, moreMenuBGView.frame.size.height);writeBAckView.frame=CGRectMake(0,self.frame.size.height-writeBAckView.frame.size.height, self.frame.size.width,writeBAckView.frame.size.height);
    }];
}

//处理收到的消息
- (void)addNewsToView:(NSNotification*)notification{
    NSDictionary *dict=notification.object;
    if ((([self.chatType isEqualToString:@"group"]&&[self.toTopc isEqualToString:[dict objectForKey:@"to"]])||
         ([self.chatType isEqualToString:@"chat"]&&[self.toTopc isEqualToString:[dict objectForKey:@"from"]])||
         ([self.chatType isEqualToString:@"home"]&&[self.toTopc isEqualToString:[dict objectForKey:@"to"]]))) {
        ChatItem *item2=[ChatItem new];
        item2.content=[dict objectForKey:@"content"];
        item2.contentType=[dict objectForKey:@"contentType"];
        item2.from=[dict objectForKey:@"from"];
        item2.fromName=[dict objectForKey:@"fromName"];
        item2.fromFace=[dict objectForKey:@"fromFace"];
        item2.to=[dict objectForKey:@"to"];
        item2.toName=[dict objectForKey:@"toName"];
        item2.toFace=[dict objectForKey:@"toFace"];
        item2.type=[dict objectForKey:@"type"];
        if ([item2.content rangeOfString:@"|"].location!=NSNotFound) {
            NSArray *array=[item2.content componentsSeparatedByString:@"|"];
            NSLog(@"语音长度＝＝＝＝＝＝＝＝＝＝%@",[array objectAtIndex:0]);
            item2.yyLength=[[array objectAtIndex:0] intValue];
        }else{
            item2.yyLength=0;
        }
        if ([[dict objectForKey:@"contentType"] isEqualToString:@"img"]) {
            NSLog(@"==================%@",imageArray);
//            [imageArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,[dict objectForKey:@"content"]]]];
        }
        item2.timestamp=[self getSubTime:[self setTime:[dict objectForKey:@"timestamp"]] andFormat:@"MM-dd HH:mm"];
        if ([self.lastTimeString rangeOfString:@" "].location!=NSNotFound) {
            NSArray *timeArray=[self intervalFromLastDate:self.lastTimeString toTheDate:[self getSubTime:[self setTime:[dict objectForKey:@"timestamp"]] andFormat:@"MM-dd HH:mm"] andFormat:@"MM-dd HH:mm"];
            int hour=[[timeArray objectAtIndex:0] intValue];
            int min=[[timeArray objectAtIndex:1] intValue];
            if (abs(hour)==0&&abs(min)==0){
                item2.timestamp=@"";
            }else if (abs(hour)<24){
                item2.timestamp=[self getSubTime:[self setTime:[dict objectForKey:@"timestamp"]] andFormat:@"MM-dd HH:mm"];
            }
            self.lastTimeString=item2.timestamp;
        }else{
            NSArray *timeArray=[self intervalFromLastDate:self.lastTimeString toTheDate:[self getSubTime:[self setTime:[dict objectForKey:@"timestamp"]] andFormat:@"HH:mm"] andFormat:@"HH:mm"];
            int hour=[[timeArray objectAtIndex:0] intValue];
            int min=[[timeArray objectAtIndex:1] intValue];
            if (abs(hour)==0&&abs(min)==0){
                item2.timestamp=@"";
                self.lastTimeString=item2.timestamp;
            }else{
                item2.timestamp=[self getSubTime:[self setTime:[dict objectForKey:@"timestamp"]] andFormat:@"HH:mm"];
            }
            self.lastTimeString=item2.timestamp;
        }
        
        ChartFrame *frame2=[ChartFrame new];
        frame2.chartMessage=item2;
        
        
        [chatArray addObject:frame2];
        [self.mainTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:chatArray.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

//创建会话
- (void)creatChat{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if(([self.chatType isEqualToString:@"group"]&&![self.owerID isEqualToString:CHATCODE])){
        NSString *LHeadPic=nil;
        if ([usd objectForKey:@"LHeadPic"]==nil) {
            LHeadPic=@"";
        }else{
            LHeadPic=[usd objectForKey:@"LHeadPic"];
        }
        NSDictionary *dict = @{@"groupid" :self.toTopc, @"who" :CHATCODE, @"type" :@"group-join"};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
        
        NSString *text =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [client publishString:text
                      toTopic:@"com.dav.icdp.message"
                      withQos:AtMostOnce
                       retain:NO
            completionHandler:^(int mid) {
                
        }];
    }
}

//判断输入内容
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if ([self.chatType isEqualToString:@"group"]) {
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            if ([self.isCanSend isEqualToString:@"0"]) {
                if ([self.delegate respondsToSelector:@selector(showMessage:)]) {
                    [self.delegate showMessage:@"网络错误，请尝试退出聊天室，重新进入!"];
                }
            }else if ([self.isCanSend isEqualToString:@"2"]||[usd objectForKey:self.toTopc]){
                if ([self.delegate respondsToSelector:@selector(getUserState)]) {
                    [self.delegate getUserState];
                }
            }else{
                [self sendNews];
            }
        }else{
            [self sendNews];
        }
        return NO;
    }
    return YES;
}

//输入框适应内容高度
- (void)textViewDidChange:(UITextView *)textView{
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(self.frame.size.width-20, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(writeBAckView.frame);
    if (textView.contentSize.height<49) {
        writeBAckView.frame = CGRectMake(0, y-49,self.frame.size.width,49);
    }else if(curheight <40){
        writeBAckView.frame = CGRectMake(0, y-textView.contentSize.height-10, self.frame.size.width,textView.contentSize.height+10);
    }else{
        return;
    }
}

//计算内容高度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//发送文字消息
- (void)sendNews{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newsString = [newsTextView.text stringByTrimmingCharactersInSet:set];
    if (newsString.length==0) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }else{
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        NSDictionary *msgDic = @{@"from" :CHATCODE, @"fromName" :[usd objectForKey:@"LName"], @"fromFace":[self changeNullString:HEADPIC], @"channel" : @"ios", @"to" : self.toTopc,@"toName":self.toName,@"toFace" :[self changeNullString:self.toFace],@"type" : self.chatType,@"contentType" : @"txt", @"content":newsTextView.text};
        [self showSendNews:newsTextView.text andContentType:@"文本" andNews:msgDic];
        newsTextView.text=nil;
        CGFloat y = CGRectGetMaxY(writeBAckView.frame);
        writeBAckView.frame = CGRectMake(0, y-49,SCREENWIDTH,49);
    }
}

#pragma mark 显示发送的信息
- (void)showSendNews:(NSString *)content andContentType:(NSString*)contentType andNews:(NSDictionary*)newsDic{
    //计算显示时间
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if (!client) {
        NSString *clientId =  [NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]];
        client = [[MQTTClient alloc] initWithClientId:clientId];
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        client.host = appDelegate.MQTT_HOST;
        client.port = appDelegate.MQTT_PORT;
        
        dispatch_semaphore_t subscribed = dispatch_semaphore_create(0);
        [client connectWithCompletionHandler:^(NSUInteger code) {
            [client subscribe:CHATCODE
                      withQos:AtMostOnce
            completionHandler:^(NSArray *grantedQos) {
                dispatch_semaphore_signal(subscribed);
            }];
        }];
    }
    NSData *jsonmsg = [NSJSONSerialization dataWithJSONObject:newsDic options:0 error:NULL];
    NSString *textmsg =  [[NSString alloc] initWithData:jsonmsg encoding:NSUTF8StringEncoding];
    NSLog(@"测试发送消息＝＝＝＝＝＝＝＝＝%@",textmsg);
    [client publishString:textmsg
                  toTopic:@"com.dav.icdp.message"
                  withQos:AtMostOnce
                   retain:NO
        completionHandler:^(int mid) {}];
    
    dispatch_semaphore_t received = dispatch_semaphore_create(0);
    [client setMessageHandler:^(MQTTMessage *message) {
        dispatch_semaphore_signal(received);
    }];
    
    
    ChatItem *item=[ChatItem new];
    item.content=content;
    item.from=CHATCODE;
    item.fromName=[usd objectForKey:@"LName"];
    item.fromFace=[self changeNullString:HEADPIC];
    item.to=self.toTopc;
    item.toFace=self.toFace;
    item.toName=self.toName;
    item.contentType=contentType;
    item.type=self.chatType;
    if ([item.content rangeOfString:@"|"].location!=NSNotFound) {
        NSArray *array=[item.content componentsSeparatedByString:@"|"];
        NSLog(@"语音长度＝＝＝＝＝＝＝＝＝＝%@",[array objectAtIndex:0]);
        item.yyLength=[[array objectAtIndex:0] intValue];
    }else{
        item.yyLength=0;
    }
    if ([contentType isEqualToString:@"图片"]||[contentType isEqualToString:@"图片"]) {
//        [imageArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,content]]];
    }
    
    NSString *dateString =[self getNowTime];
    item.timestamp=[self getSubTime:dateString andFormat:@"MM-dd HH:mm"];
    if ([self.lastTimeString rangeOfString:@" "].location!=NSNotFound) {
        NSArray *timeArray=[self intervalFromLastDate:self.lastTimeString toTheDate:[self getSubTime:dateString andFormat:@"MM-dd HH:mm"] andFormat:@"MM-dd HH:mm"];
        int hour=[[timeArray objectAtIndex:0] intValue];
        int min=[[timeArray objectAtIndex:1] intValue];
        if (abs(hour)==0&&abs(min)==0){
            item.timestamp=@"";
        }else if (abs(hour)<24){
            item.timestamp=[self getSubTime:dateString andFormat:@"MM-dd HH:mm"];
        }
        self.lastTimeString=[self getSubTime:dateString andFormat:@"MM-dd HH:mm"];
    }else{
        NSArray *timeArray=[self intervalFromLastDate:self.lastTimeString toTheDate:[self getSubTime:dateString andFormat:@"HH:mm"] andFormat:@"HH:mm"];
        int hour=[[timeArray objectAtIndex:0] intValue];
        int min=[[timeArray objectAtIndex:1] intValue];
        if (abs(hour)==0&&abs(min)==0){
            item.timestamp=@"";
        }else{
            item.timestamp=[self getSubTime:dateString andFormat:@"HH:mm"];
        }
        self.lastTimeString=[self getSubTime:dateString andFormat:@"HH:mm"];
    }
    
    if ([self.delegate respondsToSelector:@selector(saveMessage:)]) {
        [self.delegate saveMessage:item];
    }
    
    ChartFrame *frame=[ChartFrame new];
    frame.chartMessage=item;
    [chatArray addObject:frame];
    [self.mainTableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:chatArray.count-1 inSection:0];
    [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//刷新聊天消息
- (void)relaodMainTableView:(NSMutableArray*)array{
    if (array.count>0) {
        if (chatArray.count==0) {
            chatArray=array;
            for (ChartFrame *fram in chatArray) {
                if ([fram.chartMessage.contentType isEqualToString:@"图片"]) {
//                    [imageArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,fram.chartMessage.content]]];
                }
            }
            [self.mainTableView reloadData];
            if (self.mainTableView.contentSize.height>self.mainTableView.frame.size.height) {
                self.mainTableView.contentOffset=CGPointMake(0,self.mainTableView.contentSize.height-self.mainTableView.frame.size.height);
            }
        }else{
            array=(NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
            for (ChartFrame *fram in array) {
                self.lastContentOffset+=fram.cellHeight;
                [chatArray insertObject:fram atIndex:0];
            }
            for (ChartFrame *fram in chatArray) {
                if ([fram.chartMessage.contentType isEqualToString:@"图片"]) {
//                    [imageArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,fram.chartMessage.content]]];
                }
            }
            [self.mainTableView reloadData];
            [UIView animateWithDuration:0.1 animations:^{
                self.mainTableView.contentOffset=CGPointMake(0, self.lastContentOffset-10);
                self.lastContentOffset=0;
            }];
        }
        ChartFrame *fram=[chatArray lastObject];
        ChatItem *item=fram.chartMessage;
        self.lastTimeString=item.timestamp;
    }
    
}


- (void)sendRecipe:(id)recipe{
    
}

- (void)seeRecipeDetail{
    if ([self.delegate respondsToSelector:@selector(seeRecipeDetail:)]) {
        [self.delegate seeRecipeDetail:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[chatArray objectAtIndex:indexPath.row] cellHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chatArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    ChatTableViewCell *cell = (ChatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell setMessageFrame:[chatArray objectAtIndex:indexPath.row]];
    ChartFrame *fram=[chatArray objectAtIndex:indexPath.row];
    if ([fram.chartMessage.contentType isEqualToString:@"图片"]||[fram.chartMessage.contentType isEqualToString:@"img"]) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPic:)];
        tap.numberOfTapsRequired=1;
//        cell.newsImageView.tag=[imageArray indexOfObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,fram.chartMessage.content]]];
        [cell.newsImageView addGestureRecognizer:tap];
    }else if ([fram.chartMessage.contentType isEqualToString:@"语音"]||[fram.chartMessage.contentType isEqualToString:@"audio"]){
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playYY:)];
        tap.numberOfTapsRequired=1;
        cell.newsBackView.tag=indexPath.row;
        [cell.newsBackView addGestureRecognizer:tap];
    }
    return cell;
}

- (void)playYY:(UITapGestureRecognizer*)tap{
    NSLog(@"没有反应");
    ChartFrame *fram=[chatArray objectAtIndex:tap.view.tag];
    if ([fram.chartMessage.content rangeOfString:@"|"].location!=NSNotFound) {
        NSArray *array=[fram.chartMessage.content componentsSeparatedByString:@"|"];
        [yyBGView startAudioPlayer:[array objectAtIndex:1]];
    }else{
        [yyBGView startAudioPlayer:fram.chartMessage.content];
    }
}

#pragma mark 查看图片
- (void)lookPic:(UITapGestureRecognizer*)recognizer{
    NSMutableArray *kjphotos = [NSMutableArray array];
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    
    for (int i = 0 ; i < imageArray.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url =imageArray[i];
        photo.srcImageView =(UIImageView*)recognizer.view; //设置来源哪一个UIImageView
        [kjphotos addObject:photo];
    }
    brower.photos = kjphotos;
    
    brower.currentPhotoIndex = recognizer.view.tag;
    
    [brower show];
}


//下拉加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y<-5) {
        if ([self.delegate respondsToSelector:@selector(getHistoryNews)]) {
            [self.delegate getHistoryNews];
        }
    }
}
//收键盘
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.mainTableView) {
        [newsTextView resignFirstResponder];
        [UIView animateWithDuration:0.1 animations:^{
            moreMenuBGView.frame=CGRectMake(0, self.frame.size.height, SCREENWIDTH, moreMenuBGView.frame.size.height);
            writeBAckView.frame=CGRectMake(0,self.frame.size.height-writeBAckView.frame.size.height, self.frame.size.width,writeBAckView.frame.size.height);
            self.mainTableView.frame=CGRectMake(0, 0, SCREENWIDTH,writeBAckView.frame.origin.y);
        }];
        
    }
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    writeBAckView.frame=CGRectMake(0,self.frame.size.height-size.height-writeBAckView.frame.size.height, self.frame.size.width, writeBAckView.frame.size.height);
    moreMenuBGView.frame=CGRectMake(0, self.frame.size.height, SCREENWIDTH, moreMenuBGView.frame.size.height);
    
    self.mainTableView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height-size.height-50);
    if (self.mainTableView.contentSize.height>self.mainTableView.frame.size.height&&self.mainTableView.contentOffset.y>=(self.mainTableView.contentSize.height-self.frame.size.height+40)) {
        self.mainTableView.contentOffset=CGPointMake(0,self.mainTableView.contentSize.height-self.mainTableView.frame.size.height+10);
    }
}
//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    if (moreMenuBGView.frame.origin.y!=self.frame.size.height-moreMenuBGView.frame.size.height) {
        writeBAckView.frame=CGRectMake(0,self.frame.size.height-writeBAckView.frame.size.height, self.frame.size.width,writeBAckView.frame.size.height);
    }
    self.mainTableView.frame=CGRectMake(0,0, self.frame.size.width,self.frame.size.height-50);
    if (self.mainTableView.contentSize.height>self.mainTableView.frame.size.height) {
        self.mainTableView.contentOffset=CGPointMake(0,self.mainTableView.contentSize.height-self.mainTableView.frame.size.height);
    }
}



@end
