//
//  RoomMemberListViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RoomMemberListViewController.h"
#import "MyfrinedsTableViewCell.h"
#import "JSONKit.h"
#import "AppDelegate.h"

@interface RoomMemberListViewController ()

@end

@implementation RoomMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"聊天室成员"];
    [self addLeftButtonItem];
    mainArray=[NSMutableArray arrayWithArray:self.mainArray];
    [self creatUI];
}

- (void)creatUI{
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyfrinedsTableViewCell";
    MyfrinedsTableViewCell *cell = (MyfrinedsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[MyfrinedsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ChatRoomPeopleItem *item=[mainArray objectAtIndex:indexPath.row];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,[self changeNullString:item.LHeadPic]]] placeholderImage:USERDEFAULTPIC];
    if (![item.LName isKindOfClass:[NSNull class]]) {
        cell.nameLabel.text=item.LName;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{   ChatRoomPeopleItem *item=[self.mainArray objectAtIndex:indexPath.row];
    if (![item.LOnlyCode isKindOfClass:[NSNull class]]&&[item.LOnlyCode isEqualToString:CHATCODE]) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatRoomPeopleItem *item=[mainArray objectAtIndex:indexPath.row];
    choicePeopleItem=item;
    NSMutableArray *buttonArray=[NSMutableArray new];
    if ([self.chatRoomItem.LMainDoctorCode isEqualToString:CHATCODE]) {
        if (item.LForbiddenTalkTimeLength>0&&item.LostTime<item.LForbiddenTalkTimeLength) {
            UITableViewRowAction *noSendAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解除禁言" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [self showPromptBox:self andMesage:@"确定要解除该用户的禁言吗？" andSel:@selector(sureRelieve)];
            }];
            [buttonArray addObject:noSendAction];
        }else if (![item.LOnlyCode isKindOfClass:[NSNull class]]&&![item.LOnlyCode isEqualToString:CHATCODE]) {
            UITableViewRowAction *noSendAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"禁言" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [self returnSignApply];
            }];
            [buttonArray addObject:noSendAction];
        }
    }
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"加好友" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        [self showPromptBox:self andMesage:@"确定要添加该用户为好友吗？" andSel:@selector(sureAddFriend)];
        [self showSimplePromptBox:self andMesage:@"该功能暂未开放"];
    }];
    deleteAction.backgroundColor=GREENCOLOR;
    [buttonArray addObject:deleteAction];
    return buttonArray;
}

- (void)sureRelieve{
    [self sendRequest:@"ForbiddenTalk" andPath:queryWithoutURL andSqlParameter:@[self.chatRoomItem.LID,choicePeopleItem.LOnlyCode,@"0"] and:self];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleInsert;
}


- (void)sureAddFriend{
    
}

- (void)returnSignApply{
    UIView *FBGView=[self addSimpleBackView:self.view.bounds andColor:[UIColor blackColor]];
    FBGView.alpha=0.6;
    FBGView.tag=11;
    [self.navigationController.view addSubview:FBGView];
    
    UIView *SBGView=[self addSimpleBackView:CGRectMake(40,100, SCREENWIDTH-80, 260) andColor:MAINWHITECOLOR];
    SBGView.tag=12;
    [self.navigationController.view addSubview:SBGView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:SBGView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = SBGView.bounds;
    maskLayer.path = maskPath.CGPath;
    SBGView.layer.mask = maskLayer;
    
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(0, 0, SBGView.frame.size.width, 40) andColor:GREENCOLOR];
    [SBGView addSubview:titleBGView];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:titleBGView.bounds byRoundingCorners:UIRectCornerTopLeft  cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = titleBGView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    titleBGView.layer.mask = maskLayer1;
    
    
    UILabel *reasonlabel=[self addLabel:CGRectMake(15, 10, SBGView.frame.size.width-30, 20) andText:@"禁言原因:" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:0];
    [SBGView addSubview:reasonlabel];
    
    UIView *reasonBGView=[self addSimpleBackView:CGRectMake(15, 55, SBGView.frame.size.width-30, 100) andColor:MAINWHITECOLOR];
    reasonBGView.layer.borderColor=LINECOLOR.CGColor;
    reasonBGView.layer.borderWidth=0.5;
    [SBGView addSubview:reasonBGView];
    
    reasonTextView=[[UITextView alloc]initWithFrame:CGRectMake(5,5, reasonBGView.frame.size.width-10,90)];
    reasonTextView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    reasonTextView.textColor=TEXTCOLOR;
    [reasonBGView addSubview:reasonTextView];
    
    UIView *timeBGView=[self addSimpleBackView:CGRectMake(15,170, SBGView.frame.size.width-60,30) andColor:MAINWHITECOLOR];
    timeBGView.layer.borderColor=LINECOLOR.CGColor;
    timeBGView.layer.borderWidth=0.5;
    [SBGView addSubview:timeBGView];
    
    UILabel *timeLabel=[self addLabel:CGRectMake(SBGView.frame.size.width-45, 175, 30, 20) andText:@"分钟" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [SBGView addSubview:timeLabel];
    
    timeField=[self addTextfield:CGRectMake(5, 5, timeBGView.frame.size.width-10, 20) andPlaceholder:@"请输入禁言时长" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    timeField.keyboardType=UIKeyboardTypeNumberPad;
    [timeBGView addSubview:timeField];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(15,215, (SBGView.frame.size.width-40)/2, 35) andBColor:BGGRAYCOLOR andTag:0 andSEL:@selector(cancelReturnView) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
    [SBGView addSubview:cancelButton];
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake(25+(SBGView.frame.size.width-40)/2, 215, (SBGView.frame.size.width-40)/2, 35) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureReturnApply:) andText:@"确定" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [SBGView addSubview:sureButton];
}

- (void)sureReturnApply:(UIButton*)button{
    if (button.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *remarkString = [reasonTextView.text stringByTrimmingCharactersInSet:set];
        if (remarkString.length==0) {
            [self showSimplePromptBox:self andMesage:@"禁言原因不能为空"];
        }else if([timeField.text intValue]>1000||timeField.text.length==0){
            [self showSimplePromptBox:self andMesage:@"禁言时长在0到1000分钟之内"];
        }
        else{
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
                        for (NSNumber *qos in grantedQos) {
                            NSLog(@"wwww--%@", qos);
                        }
                        dispatch_semaphore_signal(subscribed);
                    }];
                }];
            }
            
            NSDictionary *contentDic=@{@"groupid" :self.chatRoomItem.LID,@"timelen" :timeField.text,@"reason" :reasonTextView.text,@"type" :@"forbidden_order"};
            NSData *contentJson = [NSJSONSerialization dataWithJSONObject:contentDic options:0 error:NULL];
            NSString *content =  [[NSString alloc] initWithData:contentJson encoding:NSUTF8StringEncoding];
            
            [client publishString:content
                          toTopic:choicePeopleItem.LOnlyCode
                          withQos:AtMostOnce
                           retain:NO
                completionHandler:^(int mid) {}];
            
            dispatch_semaphore_t received = dispatch_semaphore_create(0);
            [client setMessageHandler:^(MQTTMessage *message) {
                dispatch_semaphore_signal(received);
            }];
            [self sendRequest:@"ForbiddenTalk" andPath:queryWithoutURL andSqlParameter:@[self.chatRoomItem.LID,choicePeopleItem.LOnlyCode,timeField.text] and:self];
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:@"ForbiddenTalk"]) {
            [self cancelReturnView];
            [self showSimplePromptBox:self andMesage:@"设置成功"];
            [mainArray removeAllObjects];
            
            [self sendRequest:@"ChatRoomPeople" andPath:queryURL andSqlParameter:@[self.chatRoomItem.LID,@"",@"1"] and:self];
        }else if ([type isEqualToString:@"ChatRoomPeople"]){
            NSArray *data=message;
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    ChatRoomPeopleItem *item=[RMMapper objectWithClass:[ChatRoomPeopleItem class] fromDictionary:dic];
                    [mainArray addObject:item];
                }
                [mainTableView reloadData];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    if ([type isEqualToString:@"ForbiddenTalk"]) {
        [self showSimplePromptBox:self andMesage:@"设置失败，请重试"];
    }
}

- (void)cancelReturnView{
    UIView *FBGView=[self.navigationController.view viewWithTag:11];
    [FBGView removeFromSuperview];
    UIView *SBGView=[self.navigationController.view viewWithTag:12];
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
