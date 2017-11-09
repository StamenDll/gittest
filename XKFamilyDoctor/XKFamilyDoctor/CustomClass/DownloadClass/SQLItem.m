//
//  SQLItem.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SQLItem.h"
#import "JSONKit.h"
@implementation SQLItem

- (NSString*)returnSqlString:(id)sqlParameter andType:(NSString*)type{
    NSLog(@"请求参数＝＝＝＝＝＝＝＝＝%@",sqlParameter);
    NSString *sqlString=@"";
    //    登录
    if ([type rangeOfString:@"Login"].location!=NSNotFound) {
        sqlString=[NSString stringWithFormat:@"exec App_Proc_Entry '%@','%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    修改密码
    else if ([type isEqualToString:@"ChangePW"]){
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"update",@"function":@"regUserInfo",
                                           @"data":@{@"LPwd":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:0]}},
                                           @"where":[NSString stringWithFormat:@"LMobile='%@' and LUserType='医生'",[sqlParameter objectAtIndex:1]]}]};
        sqlString=[jsonDic JSONString];
    }
    //    更新登录状态
    else if ([type isEqualToString:@"LoginUpdate"]) {
        NSDictionary *jsonDic=@{@"cmd":@[
                                        @{@"action":@"update",@"function":@"regUserInfo",
                                          @"data":@{
                                                  @"LState":@{@"type":@"text",@"value":@"激活"},
                                                  @"LMsgOnlineID":@{@"type":@"text",@"value":[sqlParameter objectForKey:@"LMsgOnlineID"]},
                                                  @"LDeviceToken":@{@"type":@"text",@"value":@""},
                                                  @"LActiveTime":@{@"type":@"func",@"value":@"getdate()"},
                                                  @"LUserType":@{@"type":@"text",@"value":@"医生"},
                                                  @"LDeviceType":@{@"type":@"text",@"value":@"iOS"},
                                                  @"LDeviceOs":@{@"type":@"text",@"value":[[UIDevice currentDevice] systemVersion]},
                                                  @"LJfWhileSignTimes":@{@"type":@"int",@"value":[sqlParameter objectForKey:@"LJfWhileSignTimes"]},
                                                  @"LTodayGameTimes":@{@"type":@"int",@"value":[sqlParameter objectForKey:@"LTodayGameTimes"]},
                                                  @"LVipWhileSignTimes":@{@"type":@"int",@"value":[sqlParameter objectForKey:@"LVipWhileSignTimes"]}},
                                          @"where":[NSString stringWithFormat:@"LOnlyCode='%@'",[sqlParameter objectForKey:@"LOnlyCode"]]}]};
        sqlString=[jsonDic JSONString];
    }
    //    获取验证码
    else if ([type isEqualToString:@"GetCode"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert",@"function":@"smsMt",
                                           @"data":@{
                                                   @"LMobile":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LNeedBuild":[self generateTextDic:@"验证码"],
                                                   @"LContent":[self generateTextDic:[sqlParameter objectAtIndex:1]]}}]};
        sqlString=[jsonDic JSONString];
    }
    //    发送短信
    else if ([type isEqualToString:@"SendMessage"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert",@"function":@"smsMt",
                                           @"data":@{
                                                   @"LMobile":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LNeedBuild":[self generateTextDic:@"否"],
                                                   @"LContent":[self generateTextDic:[sqlParameter objectAtIndex:1]]}}]};
        sqlString=[jsonDic JSONString];
    }
    //    查找社区
    else if([type isEqualToString:@"searchCommunity"]){
        sqlString=[NSString stringWithFormat:@"EXEC App_Search_Community  @AContent='%@'",sqlParameter];
    }
    //    社区信息
    else if([type isEqualToString:@"CommunityDetail"]){
        sqlString=[NSString stringWithFormat:@"select LName,LDetail,LPic,LAddr,LAddrPic,LTel,LOrgId from APP_Community_Detail where  LOrgId='%@'",sqlParameter];
    }
    //    获取社区的医生
    else if([type isEqualToString:@"CommunityDoctor"]){
        sqlString=[NSString stringWithFormat:@"select LName,LOnlyCode,LMobile,LPic,LSpecialty from APP_Community_Expert where IsHide='否' and LOrgid=%@ order by SortId",sqlParameter];
    }
    //    获取社区中的家庭医生团队
    else if([type isEqualToString:@"CommunityHomeDoctorTeam"]){
        sqlString=[NSString stringWithFormat:@"select LID,LName from  APP_HomeDoctorTeam where LOrgid='%@'",sqlParameter];
    }
    //    获取家庭医生团队中的医生
    else if([type isEqualToString:@"TeamDoctor"]){
        sqlString=[NSString stringWithFormat:@"select b.LName,b.LDetail,b.LOnlyCode,b.LPic,b.LSpecialty,a.LLeader from ( select * from APP_HomeDoctorTeam_List where LTeamId='%@' ) a left join APP_Community_Expert b on a.LUserId=b.LId order by b.SortId",sqlParameter];
    }
    //    获取申请
    else if([type isEqualToString:@"SignState"]){
        sqlString=[NSString stringWithFormat:@"SELECT a.*, APP_HomeDoctorTeam.LOrgId, APP_HomeDoctorTeam.LName AS TeamName, APP_HomeDoctorTeam.LTime AS TeamCreateTime FROM( SELECT * FROM APP_Doctor_Bind WHERE LPeoper_OnlyCode = '%@') a LEFT JOIN APP_HomeDoctorTeam ON a.LDoctorTeamId = APP_HomeDoctorTeam.LID ORDER BY LBindTime DESC",sqlParameter];
    }
    //    发起签约申请
    else if ([type isEqualToString:@"SignApply"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action": @"insert or update",
                                           @"function":@"doctorBind",
                                           @"where":[NSString stringWithFormat:@"LID='%@'",[sqlParameter objectAtIndex:6]],
                                           @"update":@{
                                                   @"LDoctorTeamId":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LDoctorName":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   @"LPeoper_OnlyCode":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                                   @"LState":[self generateTextDic:[sqlParameter objectAtIndex:3]],
                                                   @"LAiderId":[self generateTextDic:[sqlParameter objectAtIndex:4]],
                                                   @"LBindTime":[self generateFuncDic:@"getdate()"],
                                                   @"LBindLength":[self generateIntDic:@"100"],
                                                   @"LMedicalInsurance":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:5]}},
                                           @"insert":@{
                                                   @"LDoctorTeamId":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LDoctorName":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:1]},
                                                   @"LPeoper_OnlyCode":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:2]},
                                                   @"LState":[self generateTextDic:[sqlParameter objectAtIndex:3]],
                                                   @"LAiderId":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:4]},
                                                   @"LBindTime":@{@"type":@"func",@"value":@"getdate()"},
                                                   @"LBindLength":@{@"type":@"int",@"value":@"100"},
                                                   @"LMedicalInsurance":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:5]},
                                                   @"LBindMode ":@{@"type":@"text",@"value":@"健教主动"},
                                                   @"LID":[self generateTextDic:[sqlParameter objectAtIndex:6]]}}]};
        sqlString=[jsonDic JSONString];
    }
    //    取消打回请求
    else if ([type isEqualToString:@"CancelSign"]){
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"update",@"function":@"doctorBind",
                                           @"data":@{@"LState":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                     @"LRemark":[self generateTextDic:[sqlParameter objectAtIndex:1]]},
                                           @"where":[NSString stringWithFormat:@"LPeoper_OnlyCode='%@' and LDoctorTeamId='%@'",[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]]}]};
        sqlString=[jsonDic JSONString];
    }
    //    获取签约申请列表
    else if([type isEqualToString:@"SignAuditing"]){
        sqlString=[NSString stringWithFormat:@"select b.LOnlyCode,b.LCode,b.LName,b.LMobile,b.LHeadPic,b.LDeviceType,b.LMsgOnlineID,a.LBindTime,a.LDoctorName,a.LID from ( select * from APP_Doctor_Bind where LState='申请' and LDoctorTeamId='%@') a left join APP_RegUserInfo b on a.LPeoper_OnlyCode=b.LOnlyCode and b.LName like '%%'",sqlParameter];
    }
    //    获取会员信息
    else if([type isEqualToString:@"MemberInfo"]){
        sqlString=[NSString stringWithFormat:@"select member_id,member_truename,member_sex,sLinkPhone,sLinkPhone,LOnlyCode from shopnc_member where LOnlyCOde='%@'",sqlParameter];
    }
    //    获取我的聊天室
    else if ([type isEqualToString:@"AllChatRoom"]){
        sqlString=@"select * from APP_ChatRoomLst Order by LSortId";
    }
    //    获取所有聊天室
    else if ([type isEqualToString:@"MyChatRoom"]){
        sqlString=[NSString stringWithFormat:@"select * from APP_ChatRoomLst Where LMainDoctorCode='%@' Order by LSortId",sqlParameter];
    }
    //    获取消息记录
    else if ([type isEqualToString:@"HistoryNews"]){
        sqlString= [NSString stringWithFormat:@"EXEC App_Proc_GetMsgHistory_2 @MyId='%@',@FriendId='%@',@Type='%@',@SendTime='%@',@PageNum=1",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]];
    }
    //    保存消息
    else if ([type isEqualToString:@"SaveNews"]){
        sqlString= [NSString stringWithFormat:@"EXEC App_Proc_RecordChatMsg @ASenderCode =N'%@',@ASenderName =N'%@',@AFriendCode =N'%@',@AFriendName=N'%@',@APeopleCode =N'%@',@ADoctorCode =N'%@',@AMsgContent =N'%@',@AMsgType =N'%@',@AChatType=N'%@',@AChannel=N'%@',@SenderFace =N'%@',@FriendFace =N'%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3],[sqlParameter objectAtIndex:4],[sqlParameter objectAtIndex:5],[sqlParameter objectAtIndex:6],[sqlParameter objectAtIndex:7],[sqlParameter objectAtIndex:8],[sqlParameter objectAtIndex:9],[sqlParameter objectAtIndex:10],[sqlParameter objectAtIndex:11]];
    }
    //    获取聊天室成员(AUserName不为空为查询用户设置)
    else if ([type isEqualToString:@"ChatRoomPeople"]||[type isEqualToString:@"PeopleState"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_GetRoomUserInfo @ARoomID=N'%@',@AUserName=N'%@',@APageNum=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    禁言用户
    else if ([type isEqualToString:@"ForbiddenTalk"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_SetForbiddenTalk @ARoomID =N'%@',@AUserCode =N'%@',@ATimeLen =%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    聊天室成员离在线状态
    else if ([type isEqualToString:@"OnOrOffLine"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_EntryRoomSet @ARoomID=N'%@',@AUserCode=N'%@',@AState='%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    获取签约居民
    else if([type isEqualToString:@"Resident"]){
        sqlString=[NSString stringWithFormat:@"EXEC App_Proc_GetAgreePeople @ATeamID=N'%@',@AName=N'%@',@APageNum=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    获取最近联系人
    else if([type isEqualToString:@"Complaint"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_LookRecentFriend  @AOnlyCode=N'%@',@AFilterUsName=N'%@',@ALookNewMsg=N'否'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    健康顾问负责的居民
    else if ([type isEqualToString:@"MyUser"]){
        sqlString=[NSString stringWithFormat:@"select LCode,LMobile,LName,LOnlyCode,LHeadPic from App_reguserinfo where LAider='%@'",CHATCODE];
    }
    //    生成会员卡
    else if ([type isEqualToString:@"MemberCode"]){
        sqlString=@"EXEC App_Proc_GetSeq";
    }
    //    健康顾问添加居民
    else if ([type isEqualToString:@"AddUser"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_Register '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3],[sqlParameter objectAtIndex:4],[sqlParameter objectAtIndex:5],[sqlParameter objectAtIndex:6],[sqlParameter objectAtIndex:7],[sqlParameter objectAtIndex:8],[sqlParameter objectAtIndex:9],[sqlParameter objectAtIndex:10],[sqlParameter objectAtIndex:11],[sqlParameter objectAtIndex:12],@"居民",EMPKEY,[sqlParameter objectAtIndex:13],[sqlParameter objectAtIndex:14]];
    }
    //    获取验证码
    else if ([type isEqualToString:@"GetCode"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert",@"function":@"smsMt",
                                           @"data":@{
                                                   @"LMobile":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LNeedBuild":[self generateTextDic:@"验证码"],
                                                   @"LContent":[self generateTextDic:[NSString stringWithFormat: @"您好，您的验证码为:%@ 有效期5分钟。",[sqlParameter objectAtIndex:1]]]}}]};
        sqlString=[jsonDic JSONString];
        
    }
    //    附近社区
    else if([type isEqualToString:@"NearbyCommunity"]){
        sqlString=[NSString stringWithFormat:@"exec App_Search_Community_2 @AContent='%@',@ALatitude=%@, @ALongitude=%@, @AMinDistance=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]];
    }
    //    提问列表
    else if ([type isEqualToString:@"QuestionList"]) {
        sqlString=[NSString stringWithFormat:@"exec App_Proc_HealthPostBar @AFilter=N'%@',@ASendCode=N'%@',@AType=N'%@',@APageNum=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]];
        //        type（所有、我收藏、我发起）
    }
    //    删除提问
    else if ([type isEqualToString:@"DelPost"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action": @"delete",@"function": @"healthPostbar",
                                           @"data":@{
                                                   @"LSenderCode":[self generateTextDic:CHATCODE],
                                                   @"LID":[self generateTextDic:sqlParameter],
                                                   }}]};
        sqlString=[jsonDic JSONString];
    }
    //    评论列表
    else if ([type isEqualToString:@"CommentList"]) {
        sqlString=[NSString stringWithFormat:@"exec App_Proc_HealthPostBarAnswer @SubjectCode=N'%@',@Filter=N'%@',@APageNum=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    添加收藏
    else if ([type isEqualToString:@"AddCollect"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action": @"insert",@"function": @"postbarStore",
                                           @"data":@{
                                                   @"LOwnerCode":@{@"type":@"text",@"value":CHATCODE},
                                                   @"LSubjectCode":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LWTime":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   }}]};
        sqlString=[jsonDic JSONString];
    }
    //    取消收藏
    else if ([type isEqualToString:@"DelCollect"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action": @"delete",@"function": @"postbarStore",
                                           @"data":@{
                                                   @"LOwnerCode":[self generateTextDic:CHATCODE],
                                                   @"LSubjectCode":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   }}]};
        sqlString=[jsonDic JSONString];
    }
    //    我的收藏列表
    else if ([type isEqualToString:@"CollectList"]) {
        sqlString=[NSString stringWithFormat:@"select * from APP_Health_PostBar_Store where LOwnerCode='%@'",sqlParameter];
    }
    //    发布问题
    else if ([type isEqualToString:@"PutQuestion"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action": @"insert",@"function": @"healthPostbar",
                                           @"data":@{
                                                   @"LSenderCode":[self generateTextDic:CHATCODE],
                                                   @"LSenderName":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LTitle":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   @"LDetail":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                                   @"LPic1":[self generateTextDic:[sqlParameter objectAtIndex:3]],
                                                   @"LPic2":[self generateTextDic:[sqlParameter objectAtIndex:4]],
                                                   }}]};
        sqlString=[jsonDic JSONString];
    }
    //    添加评论
    else if ([type isEqualToString:@"CommentPost"]) {
        sqlString=[NSString stringWithFormat:@"exec App_Proc_Post_HealthPostBarAnswer @ASubjectCode=N'%@',@ASenderCode=N'%@',@ASenderName=N'%@',@AContent=N'%@',@APic=N'%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3],[sqlParameter objectAtIndex:4]];
    }
    
    //    获取编辑模版
    else if([type isEqualToString:@"GetModel"]){
        sqlString=[NSString stringWithFormat:@"select * from APP_TableEditConfig where (LRange='公共' or LRange='医生') and LTableName='%@' order by LSortID",sqlParameter];
    }
    //    获取预约列表
    else if([type isEqualToString:@"ORList"]){
        sqlString=[NSString stringWithFormat:@"select * from APP_Registration where LPeopleOnlyCode='%@' and LAiderOnlyCode='%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    获取档案列表
    else if([type isEqualToString:@"MyUserDetail"]){
        sqlString=[NSString stringWithFormat:@"select * from V_file where IDNumber in (select sIDCard from shopnc_member where LOnlyCode='%@') and isxk='是'",sqlParameter];
    }
    //    获取随访列表
    else if([type isEqualToString:@"FollowUpList"]){
        sqlString=[NSString stringWithFormat:@"select * from %@ where LOnlyCode='%@'",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    获取单列表选项
    else if([type isEqualToString:@"GetCommenList"]){
        sqlString=[NSString stringWithFormat:@"select %@ from %@ %@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    获取转诊转出列表
    else if([type isEqualToString:@"ReferalOut"]){
        NSLog(@"==========%@",sqlParameter);
        sqlString=[NSString stringWithFormat:@"select * from  CureSwitch where %@",sqlParameter];
    }
    //    获取转诊转入列表
    else if([type isEqualToString:@"ReferalIn"]){
        NSLog(@"==========%@",sqlParameter);
        sqlString=[NSString stringWithFormat:@"select * from  CureBack %@",sqlParameter];
    }
    //    通用提交方法
    else if([type isEqualToString:@"CommenUpload"]){
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert or update",@"function":[sqlParameter objectAtIndex:0],
                                           @"where":[sqlParameter objectAtIndex:1],
                                           @"update":[sqlParameter objectAtIndex:2],
                                           @"insert":[sqlParameter objectAtIndex:2]}]};
        sqlString=[jsonDic JSONString];
    }
    //    接收转诊
    else if([type isEqualToString:@"SureReceive"]){
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert or update",@"function":@"cureBack",
                                           @"where":[NSString stringWithFormat:@"ID='%@'",[sqlParameter objectAtIndex:0]],
                                           @"update":@{
                                                   @"DealResult":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   @"ExportOrg":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                                   @"Doctor":[self generateTextDic:[sqlParameter objectAtIndex:3]],
                                                   @"Tel":[self generateTextDic:[sqlParameter objectAtIndex:4]],
                                                   @"LinkmanName":[self generateTextDic:[sqlParameter objectAtIndex:5]],
                                                   @"CommunityRemark":[self generateTextDic:[sqlParameter objectAtIndex:6]],
                                                   },
                                           @"insert":@{
                                                   @"DealResult":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   @"ExportOrg":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                                   @"Doctor":[self generateTextDic:[sqlParameter objectAtIndex:3]],
                                                   @"Tel":[self generateTextDic:[sqlParameter objectAtIndex:4]],
                                                   @"LinkmanName":[self generateTextDic:[sqlParameter objectAtIndex:5]],
                                                   @"CommunityRemark":[self generateTextDic:[sqlParameter objectAtIndex:6]]
                                                   }}]};
        sqlString=[jsonDic JSONString];
    }
    //    退回转诊申请
    else if([type isEqualToString:@"SureBack"]){
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert or update",@"function":@"cureBack",
                                           @"where":[NSString stringWithFormat:@"ID='%@'",[sqlParameter objectAtIndex:0]],
                                           @"update":@{
                                                   @"DealResult":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   @"CommunityRemark":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                                   },
                                           @"insert":@{
                                                   @"DealResult":[self generateTextDic:[sqlParameter objectAtIndex:1]],
                                                   @"CommunityRemark":[self generateTextDic:[sqlParameter objectAtIndex:2]]
                                                   }}]};
        sqlString=[jsonDic JSONString];
    }
    //    获取我推荐的人
    else if([type isEqualToString:@"MyRecommend"]){
        sqlString=[NSString stringWithFormat:@"select LHeadPic,LName,LCode,LRegTime from APP_RegUserInfo where LIntroducer='%@' and LUserType='居民' order by LRegtime desc",sqlParameter];
    }
    //    意见反馈
    else if ([type isEqualToString:@"Feedback"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert",@"function":@"notionInfo",
                                           @"data":@{
                                                   @"LContent":[self generateTextDic:sqlParameter],
                                                   @"LOnlyCde":[self generateTextDic:CHATCODE]}}]};
        sqlString=[jsonDic JSONString];
    }
    
    //    建档相关
    //    查询附近小区信息
    else if([type rangeOfString:@"SearchNearArea"].location!=NSNotFound){
        sqlString=[NSString stringWithFormat:@"exec [App_Search_Settlement] @ALatitude='%@',@ALongitude='%@',@AMinDistance=2,@AAreaName='%@',@AOrgid=%@ ",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]];
    }
    //    根据小区查找居委会
    else if([type rangeOfString:@"NearAreaNC"].location!=NSNotFound){
        sqlString=[NSString stringWithFormat:@"select * from District where ID ='%@'",sqlParameter];
    }
    //    查询区域
    else if([type rangeOfString:@"SearchRegion"].location!=NSNotFound){
        sqlString=[NSString stringWithFormat:@"select * from District where ParentId ='%@'",sqlParameter];
    }
    //    查询小区
    else if([type isEqualToString:@"SearchVillage"]){
        sqlString=[NSString stringWithFormat:@"select sName,AreaId,iUnit,sUnit,iTotalCell,OrgID from Net_Area where sDistrictId='%@'",sqlParameter];
    }
    //    查询小区楼栋
    else if([type isEqualToString:@"SearchFloor"]){
        NSLog(@"==========%@",sqlParameter);
        sqlString=[NSString stringWithFormat:@"select sUnitName,sUnit,UnitID from Net_Unit where orgid=%@ and AreaID=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    查询小区楼栋住户
    else if([type isEqualToString:@"SearchHousehold"]){
        NSLog(@"==========%@",sqlParameter);
        sqlString=[NSString stringWithFormat:@"select * from Net_Cell where orgid=%@ and AreaID=%@ and UnitID=%@ order by sCellName desc",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    生成档案号
    else if([type isEqualToString:@"GenerateFileNO"]){
        sqlString=[NSString stringWithFormat:@"exec  App_Proc_BuilderFileNO '%@'",sqlParameter];
    }
    //    获取建档选项
    else if([type isEqualToString:@"GetArchiveOption"]){
        sqlString=@"select type,ID,Name from BasicInformation where type in('123','34','192','38','148','6') order by type";
    }
    //    身份证重复检测
    else if([type isEqualToString:@"SearchIDNumber"]){
        sqlString=[NSString stringWithFormat:@"select * from healthFile join PersonalInfo on healthFile.FileNo=PersonalInfo.FileNo where PersonalInfo.IDNumber='%@'",sqlParameter];
        
    }
    //    提交建档信息
    else if ([type isEqualToString:@"UploadArchive"]){
        NSMutableArray *dataArray=[NSMutableArray new];
        for (NSDictionary *dic in [sqlParameter objectAtIndex:3]) {
            [dataArray addObject:dic];
        }
        [dataArray addObject:@{@"action":@"insert",@"function":@"healthFile",
                               @"data":@{@"Name":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:0]],
                                         @"FileNo":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                         @"PaperFileNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:2]],
                                         @"ResidenceAddress":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:3]],
                                         @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:4]],
                                         @"DistrictNumber":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:5]],
                                         @"Township":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:6]],
                                         @"Village":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
                                         @"BuildUnit":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:8]],
                                         @"BuildPerson":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:9]],
                                         @"Doctor":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:10]],
                                         @"BuildDate":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:11]],
                                         @"InputDate":[self generateFuncDic:@"getdate()"],
                                         @"BarCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:12]],
                                         @"HouseMaster":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:13]],
                                         @"CupboardNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:14]],
                                         @"BoxNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:15]],
                                         @"LAiderName":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:16]],
                                         @"LAiderCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:17]],
                                         @"AreaID":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:18]],
                                         @"UnitID":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:19]],
                                         @"CellID":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:20]],
                                         @"Address":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:21]],
                                         @"CurrentOrgId":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:22]],
                                         @"InputPersonID":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:23]]}}];
        [dataArray addObject:@{@"action":@"insert",@"function":@"personalInfo",
                               @"data":@{
                                       @"FileNo":[self generateTextDic:[sqlParameter objectAtIndex:2]],
                                       @"Sex":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:1]],
                                       @"Birthday":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:2]],
                                       @"IDNumber":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:3]],
                                       @"WorkUnit":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:4]],
                                       @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:5]],
                                       @"Linkman":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:6]],
                                       @"LinkmanTEL":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:7]],
                                       @"resideType":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:8]],
                                       @"Folk":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:9]],
                                       @"BloodTypeABO":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:10]],
                                       @"BloodTypeRH":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:11]],
                                       @"Education":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:12]],
                                       @"occupation":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:13]],
                                       @"maritalStatus":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:14]],
                                       @"farmStatus":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:15]],
                                       @"townStatus":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:16]],
                                       @"bornStatus":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:17]],
                                       @"Kitchen":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:18]],
                                       @"Bunkers":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:19]],
                                       @"drinkingWater":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:20]],
                                       @"Toilet":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:21]],
                                       @"Poultry":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:22]],
                                       @"GeneticHistory":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:23]],
                                       @"InputPersonID":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:23]],
                                       @"InputDate":[self generateFuncDic:@"getdate()"],
                                       @"filenosub":[self generateTextDic:[sqlParameter objectAtIndex:4]],
                                       @"ID":[self generateTextDic:[sqlParameter objectAtIndex:5]]}}];
        NSDictionary *jsonDic=@{@"cmd":dataArray};
        sqlString=[jsonDic JSONString];
    }
    //    获取药品信息
    else if([type isEqualToString:@"DrugInfo"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_GetGoodsInfo @AFilter=N'%@',@AKind='保健品',@APageNum=%@",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    获取微信支付参数
    else if([type isEqualToString:@"WxPay"]){
        sqlString=[NSString stringWithFormat:@"action=request&money=%@&callbackcode=%@&billcode=%@&channel=3",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    确认订单
    else if([type isEqualToString:@"SureOrder"]){
        NSMutableArray *dataArray=[NSMutableArray new];
        [dataArray addObject:@{@"action":@"insert",@"function":@"payBill",
                               @"data":@{
                                       @"LID":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:0]],
                                       @"LOnlyCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:1]],
                                       @"LGoodsName":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:2]],
                                       @"LMoney":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:3]],
                                       @"nonce_str":[self generateTextDic:@""],
                                       @"out_trade_no":[self generateTextDic:@""],
                                       @"LOrgId":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:4]],
                                       @"LSalespersonCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:5]],
                                       @"LSellerId":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:6]],
                                       @"LSellerName":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
                                       @"LMqId":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:8]],
                                       @"LSellKind":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:9]],
                                       @"LOrderTime":[self generateFuncDic:@"getdate()"],
                                       @"LPayTime":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:10]],
                                       @"LSendSta":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:11]],
                                       @"LState":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:12]],
                                       @"LRemark":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:13]],
                                       @"LUserName":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:14]],
                                       @"LMobile":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:15]],
                                       @"LChannel":[self generateTextDic:@"助手"],
                                       @"LWTime":[self generateFuncDic:@"getdate()"]}}];
        for (NSArray *dicArray in [sqlParameter objectAtIndex:1]) {
            NSDictionary *dic=@{@"action":@"insert",@"function":@"payBillList",
                                    @"data":@{
                                        @"LID":[self generateIntDic:@"newid()"],
                                        @"LBillId":[self generateTextDic:[dicArray objectAtIndex:0]],
                                        @"LOnlyCode":[self generateTextDic:[dicArray objectAtIndex:1]],
                                        @"LGoodsName":[self generateTextDic:[dicArray objectAtIndex:2]],
                                        @"LGoodsID":[self generateTextDic:[dicArray objectAtIndex:3]],
                                        @"LMoney":[self generateTextDic:[dicArray objectAtIndex:4]],
                                        @"LNumber":[self generateTextDic:[dicArray objectAtIndex:5]],
                                        @"LRemark":[self generateTextDic:[dicArray objectAtIndex:6]],
                                        @"LWTime":[self generateFuncDic:@"getdate()"]}};
            
            [dataArray addObject:dic];
        }
        NSDictionary *jsonDic=@{@"cmd":dataArray};
        sqlString=[jsonDic JSONString];
    }
    //    获取会员订单
    else if([type isEqualToString:@"MemberOrderList"]){
        sqlString=[NSString stringWithFormat:@"select * from APP_App_PayBill where LSalespersonCode='%@'",EMPKEY];
        if (sqlParameter) {
            sqlString=[NSString stringWithFormat:@"select * from APP_App_PayBill where LSalespersonCode='%@' and LID='%@'",EMPKEY,sqlParameter];
        }
    }
    //    获取订单详情
    else if([type isEqualToString:@"OrderDetail"]){
        sqlString=[NSString stringWithFormat:@"select * from  APP_App_PayBill_List  where LBillId='%@'",sqlParameter];
    }
    //    获取收货验证码
    else if ([type isEqualToString:@"GetSureOrderCode"]) {
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert",@"function":@"smsMt",
                                           @"data":@{
                                                   @"LMobile":[self generateTextDic:[sqlParameter objectAtIndex:0]],
                                                   @"LNeedBuild":[self generateTextDic:@"验证码"],
                                                   @"LContent":[self generateTextDic:[NSString stringWithFormat: @"您好，我们的专干(%@)为您生成一个保健品订单，确认收货验证码为:%@ 有效期5分钟。",[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]]]}}]};
        sqlString=[jsonDic JSONString];
    }
    //    更新用户信息
    else if([type isEqualToString:@"ChangeOrderState"]){
        NSDictionary *jsonDic=@{@"cmd": @[@{@"action": @"update",@"function": @"payBill",
                                            @"data":@{@"LSendSta":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:0]}},
                                            @"where":[NSString stringWithFormat:@"LID='%@'",[sqlParameter objectAtIndex:1]]}]};
        sqlString=[jsonDic JSONString];
    }
    //    获取行政区划列表信息
    else if([type isEqualToString:@"GetOrgDistrict"]){
        sqlString=[NSString stringWithFormat:@"execute APP_pW_GetDistrictInfo '%@'",sqlParameter];
    }
    //    获取义诊列表信息
    else if([type isEqualToString:@"FreeDiagnose"]){
        sqlString=[NSString stringWithFormat:@"SELECT *,(CASE WHEN getdate() >= dBeginTime THEN '分诊' ELSE '即将开始' END ) AS state FROM his_FreeDiagnose WHERE getdate() <= dEndTime AND iOrgId = '%@'",sqlParameter];
    }
    //    搜索义诊、导诊信息
    else if([type isEqualToString:@"SearchFOD"]){
        sqlString=[NSString stringWithFormat:@"SELECT * FROM his_BespokeUserLst WHERE sProjType='%@' %@ and  sAiderId='%@' and (sName like '%%%@%%'  or sDeptsName like '%%%@%%'  or sDoctorName like '%%%@%%' ) ",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:2],[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:1]];
    }
    //    获取义诊历史记录
    else if([type isEqualToString:@"FreeDiagnoseHis"]){
        sqlString=[NSString stringWithFormat:@"select  * from his_FreeDiagnose where getdate()>dEndTime and iOrgId='%@'",sqlParameter];
    }
    //    获取义诊活动总人数
    else if([type isEqualToString:@"FreeDiagnoseCount"]){
        sqlString=[NSString stringWithFormat:@"exec App_Proc_GetFreeDiagnoseStatis @AAiderId='%@',@AProjId='%@'",[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],sqlParameter];
    }
    //    获取用户添加的义诊活动人员信息
    else if([type isEqualToString:@"MyAddPerson"]){
        
        sqlString=[NSString stringWithFormat:@"EXEC [UP_Pagination] @Tables = N'his_BespokeUserLst',@PrimaryKey = N'SID',@Sort = N'dTime desc',@CurrentPage = %@,@PageSize = 30,@Fields = N'*',@Filter =N'sProjType=''义诊'' and sProjId=''%@'' and sAiderId=''%@''',@Group=''",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]];
    }
    //    获取用户添加的导诊人员信息
    else if([type isEqualToString:@"MyAddDPerson"]){
        sqlString=[NSString stringWithFormat:@" EXEC [UP_Pagination] @Tables = N'his_BespokeUserLst',@PrimaryKey = N'SID',@Sort = N'dTime desc',@CurrentPage = %@,@PageSize = 30,@Fields = N'*',@Filter =N'sProjType=''导诊'' and sAiderId=''%@''',@Group=''",sqlParameter,[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]];
    }
    //    获取用户添加的导诊人员人数
    else if([type isEqualToString:@"MyAddDPersonCount"]){
        sqlString=[NSString stringWithFormat:@"select  sIdCard from his_BespokeUserLst where sProjType='导诊' and sAiderId='%@' GROUP BY sIdCard",[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]];
    }
    //    获取用户添加的导诊人员人次
    else if([type isEqualToString:@"MyAddDPersonTotalCount"]){
        sqlString=[NSString stringWithFormat:@"select sid from his_BespokeUserLst where sProjType='导诊' and sAiderId='%@'",[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]];
    }
    //    获取身份证用户信息
    else if([type rangeOfString:@"IDCardIsHave"].location!=NSNotFound){
        sqlString=[NSString stringWithFormat:@"select LOnlyCode,member_id from shopnc_member where sIDCard='%@'",sqlParameter];
    }
    //    验证身份证档案信息
    else if([type rangeOfString:@"CheckIDCFile"].location!=NSNotFound){
        sqlString=[NSString stringWithFormat:@"select FileNo from PersonalInfo where IDNumber='%@'",sqlParameter];
    }
    //    插入用户信息
    else if ([type rangeOfString:@"AddNewUser"].location!=NSNotFound){
        NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert or update",@"function":@"shopncMember",
                                           @"where":[NSString stringWithFormat:@"sIDCard='%@'",[[sqlParameter objectAtIndex:0] objectAtIndex:0]],
                                           @"update":@{
                                                   @"sLinkPhone":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:1]],
                                                   @"member_truename":[self generateTextDic:[[sqlParameter objectAtIndex:0]  objectAtIndex:2]],
                                                   @"member_birthday":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:3]],
                                                   @"member_sex":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:4]],
                                                   @"sFolk":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:5]],
                                                   @"sAddress":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:6]],
                                                   @"LOnlyCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:8]],
                                                   //@"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:9]]
                                                   },
                                           @"insert":@{
                                                   @"sIDCard":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:0]],
                                                   @"sLinkPhone":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:1]],
                                                   @"member_truename":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:2]],
                                                   @"member_birthday":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:3]],
                                                   @"member_sex":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:4]],
                                                   @"sFolk":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:5]],
                                                   @"sAddress":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:6]],
                                                   @"member_id":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
                                                   @"LOnlyCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:8]],
                                                   //@"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:9]]
                                                   }},
//                                @{@"action":@"insert or update",@"function":@"personalInfo",
//                                           @"where":[NSString stringWithFormat:@"FileNo='%@'",[[sqlParameter objectAtIndex:1] objectAtIndex:0]],
//                                           @"update":@{
//                                                   @"FileNoSub":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:1]],
//                                                   @"Sex":[self generateTextDic:[[sqlParameter objectAtIndex:1]  objectAtIndex:2]],
//                                                   @"Folk":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:3]],
//                                                   @"Birthday":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:4]],
//                                                   @"IDNumber":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:5]],
//                                                   @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:6]],
//                                                   @"member_id":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
//                                                   },
//                                           @"insert":@{
//                                                   @"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:0]],
//                                                   @"FileNoSub":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:1]],
//                                                   @"Sex":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:2]],
//                                                   @"Folk":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:3]],
//                                                   @"Birthday":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:4]],
//                                                   @"IDNumber":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:5]],
//                                                   @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:6]],
//                                                   @"member_id":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
//                                                   @"ID":[self generateFuncDic:@"newid()"],
//                                                   }},
//                                @{@"action":@"insert or update",@"function":@"healthFile",
//                                           @"where":[NSString stringWithFormat:@"FileNo='%@'",[[sqlParameter objectAtIndex:2] objectAtIndex:0]],
//                                           @"update":@{
//                                                   @"Name":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:1]],
//                                                   @"Address":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:3]],
//                                                   @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:6]],
//                                                   },
//                                           @"insert":@{
//                                                   @"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:0]],
//                                                   @"Name":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:1]],
//                                                   @"BuildPerson":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:2]],
//                                                   @"Address":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:3]],
//                                                   @"InputPersonID":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:5]],
//                                                   @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:6]],
//                                                   @"ResidenceAddress":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:7]],
//                                                   @"syncmsg":[self generateTextDic:@"健康档案待完善"]
//                                                   }}
                                         ]};
        sqlString=[jsonDic JSONString];
    }
    //    搜索签约申请
    else if([type isEqualToString:@"SearchApply"]){
        sqlString=[NSString stringWithFormat:@"select d.*, c.iAge, c.member_sex from( SELECT a.Lid, b.LOnlyCode, b.LCode, b.LName, b.LMobile, b.LHeadPic, b.LDeviceType, b.LMsgOnlineID, a.LBindTime, a.LDoctorName FROM APP_Doctor_Bind a, APP_RegUserInfo b WHERE a.LState = '线下申请' and a.LPeoper_OnlyCode = b.LOnlyCode AND b.LName LIKE '%%' AND LMobile = '%@') d left join shopnc_member c on d.LOnlyCode = c.LOnlyCode order by d.LBindTime DESC",sqlParameter];
    }
    //    搜索家庭医生团队
    else if([type isEqualToString:@"SearchSATeam"]){
        sqlString=[NSString stringWithFormat:@"select a.* from APP_HomeDoctorTeam a , APP_Community_Detail b where b.LName like '%%%@%%' and a.LOrgId=b.LOrgId",sqlParameter];
    }
    //    获取义诊活动医生
    else if([type isEqualToString:@"FDDoctor"]){
        sqlString=[NSString stringWithFormat:@"select * from v_FreeDiagnoseDoctor where sID='%@'",sqlParameter];
        
    }
    //    更新用户信息
    else if([type isEqualToString:@"UpdateUserInfo"]){
        NSDictionary *jsonDic=@{@"cmd": @[@{@"action": @"update",@"function": @"regUserInfo",
                                            @"data":@{@"LNickName":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:0]},
                                                      @"LName":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:1]},
                                                      @"LSex":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:2]},
                                                      @"LFolk":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:3]},
                                                      @"LIDAddr":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:4]},
                                                      @"LIdNum":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:5]},
                                                      @"LMaritalStatus":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:8]},
                                                      @"LPersonKind":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:9]},
                                                      @"LDiseaseType":@{@"type":@"text",@"value":[sqlParameter objectAtIndex:10]}},
                                            @"where":[NSString stringWithFormat:@"LOnlyCode='%@'",[sqlParameter objectAtIndex:7]]},
                                          @{@"action": @"update",@"function": @"shopncMember",
                                            @"where":[NSString stringWithFormat:@"sIDCard='%@'",[sqlParameter objectAtIndex:5]],
                                            @"data":@{@"member_birthday":[self generateTextDic:[sqlParameter objectAtIndex:6]]},
                                            }]};
        sqlString=[jsonDic JSONString];
    }
    //    插入预约用户信息
    else if ([type isEqualToString:@"AddFDOrderUser"]){
        NSDictionary *jsonDic=@{@"cmd":sqlParameter};
        sqlString=[jsonDic JSONString];
    }
    //    判断用户是否已签约
    else if([type isEqualToString:@"CheckUserIsSign"]){
        sqlString=[NSString stringWithFormat:@"select * from APP_Doctor_Bind where LPeoper_OnlyCode='%@' and LState='成功'",sqlParameter];
        
    }
    //    搜索病人信息
    else if([type isEqualToString:@"SearchPatientInfo"]){
        sqlString=[NSString stringWithFormat:@"select top 100 member_truename, sIDCard,member_sex,member_birthday,sAddress,sFolk from shopnc_member where member_truename='%@' or sIDCard='%@'",sqlParameter,sqlParameter];
        
    }
    //    统计相关
    //    义诊统计（健教专干）
    else if([type isEqualToString:@"Census_FD_1"]){
        sqlString=[NSString stringWithFormat:@"SELECT CONVERT(varchar(100), dTime, 23) as mText, count(*) as mValue FROM his_BespokeUserLst cc LEFT JOIN ( SELECT a.empkey, a.truename, a.workorgkey AS '机构id', b.orgname AS '机构名称', a.workplate AS '事业部id', c.[text] AS '事业部名称' , a.orgkey FROM empview a LEFT JOIN org_main b ON a.workorgkey = b.orgkey LEFT JOIN org_cod_propertyvalue c ON a.workplate = c.[key] ) dd ON cc.sAiderId = dd.empkey and dd.empkey = %@ WHERE dTime >= '%@ 00:00:00' AND dTime < '%@ 23:59:59' AND sprojtype = '%@' AND cc.sname NOT IN ( '测试', '测试0', '测试2', '测试3', '测试4', '测试6', '测试9', 'CESHI' ) AND ( dd.机构名称 IS NOT NULL OR dd.机构名称<>'') group by CONVERT(varchar(100), dTime, 23)",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]];
    }
    //    义诊统计（区域经理）
    else if([type isEqualToString:@"Census_FD_2"]){
        sqlString=[NSString stringWithFormat:@"SELECT dd.orgname as mText, count(*) as mValue FROM 	his_BespokeUserLst cc LEFT JOIN ( 	SELECT a.empkey, a.truename, a.workorgkey AS '机构id', b.orgname , a.workplate, c.[text] AS '事业部名称' , a.orgkey FROM 		empview a LEFT JOIN org_main b ON a.workorgkey = b.orgkey LEFT JOIN org_cod_propertyvalue c ON a.workplate = c.[key] ) dd ON cc.sAiderId = dd.empkey WHERE dTime >= '%@ 00:00:00' AND dTime < '%@ 23:59:59' AND sprojtype = '%@' AND cc.sname NOT IN ( '测试', '测试0', '测试2', '测试3', '测试4', '测试6', '测试9', 'CESHI' ) AND ( dd.orgname IS NOT NULL OR dd.orgname<> '') group by dd.orgname",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    义诊统计（社区负责人）
    else if([type isEqualToString:@"Census_FD_3"]){
        sqlString=[NSString stringWithFormat:@"SELECT dd.truename as mText, count(*) as mValue FROM his_BespokeUserLst cc LEFT JOIN (SELECT a.empkey, a.truename, a.workorgkey AS '机构id', b.orgname AS '机构名称', a.workplate AS '事业部id', c.[text] AS '事业部名称' , a.orgkey FROM empview a LEFT JOIN org_main b ON a.workorgkey = b.orgkey LEFT JOIN org_cod_propertyvalue c ON a.workplate = c.[key] ) dd ON cc.sAiderId = dd.empkey and dd.orgkey =%@  WHERE dTime >= '%@ 00:00:00' AND dTime < '%@ 23:59:59' AND sprojtype = '%@' AND cc.sname NOT IN ( '测试', '测试0', '测试2', '测试3', '测试4', '测试6', '测试9', 'CESHI' )  AND ( dd.机构名称 IS NOT NULL OR dd.机构名称<> '') group by dd.truename",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2],[sqlParameter objectAtIndex:3]];
    }
    //    义诊统计（健教专干负责人）
    else if([type isEqualToString:@"Census_FD_4"]){
        sqlString=[NSString stringWithFormat:@"SELECT dd.truename as mText, count(*) as mValue FROM his_BespokeUserLst cc LEFT JOIN ( 	SELECT a.empkey, a.truename, a.workorgkey AS '机构id', b.orgname AS '机构名称', a.workplate AS '事业部id', c.[text] AS '事业部名称' , a.orgkey FROM empview a LEFT JOIN org_main b ON a.workorgkey = b.orgkey LEFT JOIN org_cod_propertyvalue c ON a.workplate = c.[key] ) dd ON cc.sAiderId = dd.empkey WHERE dTime >= '%@ 00:00:00' AND dTime < '%@ 23:59:59'  AND sprojtype = '%@' AND cc.sname NOT IN ( '测试', '测试0', '测试2', '测试3', '测试4', '测试6', '测试9', 'CESHI' ) AND ( dd.机构名称 IS NOT NULL OR dd.机构名称<> '') group by dd.truename",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    签约统计（健教专干）
    else if([type isEqualToString:@"Census_Sign_1"]){
        sqlString=[NSString stringWithFormat:@"SELECT CONVERT(varchar(100), LBindTime, 23) as mText, 	count(*) as mValue FROM ( SELECT * FROM app_doctor_bind adb WHERE adb.LAiderId = '%@' AND LBindTime > '%@ 00:00:00' AND LBindTime < '%@ 23:59:59' ) a LEFT JOIN empview ev ON a.LAiderId = ev.empKey GROUP BY CONVERT(varchar(100), LBindTime, 23)",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    签约统计（区域经理）
    else if([type isEqualToString:@"Census_Sign_2"]){
        sqlString=[NSString stringWithFormat:@"SELECT count (*) as mValue, o.Name as mText FROM APP_View_Doctor_Bind_Detail a left join  APP_RegUserInfo b on a.lpeoper_onlycode=b.lonlycode and a.CommunityId=b.lorgid 	LEFT JOIN shopnc_member c ON c.lonlycode = a.lpeoper_onlycode LEFT JOIN Organization o ON a.LOrgId = o.ID WHERE a.lbindtime >= '%@ 00:00:00' AND a.lbindtime < '%@ 00:00:00' AND a.lstate = '成功' group by o.Name",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //    签约统计（社区负责人）
    else if([type isEqualToString:@"Census_Sign_3"]){
        sqlString=[NSString stringWithFormat:@"SELECT Case When ev.truename is null then '其他' else ev.truename end as mText, COUNT ( * ) as mValue FROM 	( SELECT a.*, ah.LOrgId  FROM ( SELECT * FROM app_doctor_bind adb WHERE adb.LBindTime > '%@ 00:00:00' AND adb.LBindTime < '%@ 23:59:59' ) a INNER JOIN APP_HomeDoctorTeam ah ON a.LDoctorTeamId = ah.LID 	) b LEFT JOIN empview ev ON b.LAiderId = ev.empKey where b.LOrgId =%@ GROUP BY ev.truename",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    签约统计（健教专干负责人）
    else if([type isEqualToString:@"Census_Sign_4"]){
        sqlString=[NSString stringWithFormat:@"SELECT Case When ev.truename is null then '其他' else ev.truename end as mText, COUNT ( * ) as mValue FROM ( SELECT * FROM app_doctor_bind adb WHERE LBindTime > '%@ 00:00:00' AND LBindTime < '%@ 23:59:59' ) a LEFT JOIN empview ev ON a.LAiderId = ev.empKey  GROUP BY ev.truename",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    
    //    建档统计（健教专干）
    else if([type isEqualToString:@"Census_HF_1"]){
        sqlString=[NSString stringWithFormat:@"SELECT CONVERT(varchar(100), a.InputDate, 23) as mText, COUNT ( * ) as mValue FROM healthfile a, sam_taxempcode b, Organization c  WHERE a.InputDate >= '%@ 00:00:00'  AND a.InputDate < '%@ 23:59:59' AND a.inputpersonid = '%@' AND ( a.sid IS NULL OR sid = '' )  AND a.inputpersonid = b.loginname  AND b.org_id = c.id  AND a.DistrictNumber is not null AND a.DistrictNumber <> '' GROUP BY b.username, CONVERT(varchar(100), a.InputDate, 23); ",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //    建档统计（社区负责人）
    else if([type isEqualToString:@"Census_HF_2"]){
        sqlString=[NSString stringWithFormat:@"SELECT b.username as mText, COUNT ( * ) as mValue FROM healthfile a, sam_taxempcode b, Organization c  WHERE a.InputDate >= '%@ 00:00:00'  AND a.InputDate < '%@ 23:59:59'  AND c.id =%@  AND ( a.sid IS NULL OR sid = '' )  AND a.inputpersonid = b.loginname  AND b.org_id = c.id  AND a.DistrictNumber is not null AND a.DistrictNumber <> ''GROUP BY b.username;",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1],[sqlParameter objectAtIndex:2]];
    }
    //   建档统计（健教专干负责人）
    else if([type isEqualToString:@"Census_HF_3"]){
        sqlString=[NSString stringWithFormat:@"SELECT b.username as mText, COUNT ( * ) as mValue FROM healthfile a, sam_taxempcode b, Organization c  WHERE a.InputDate >= '%@ 00:00:00'  AND a.InputDate < '%@ 23:59:59'  AND ( a.sid IS NULL OR sid = '' )  AND a.inputpersonid = b.loginname  AND b.org_id = c.id  AND a.DistrictNumber is not null AND a.DistrictNumber <> '' GROUP BY b.username;",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    
    else if([type isEqualToString:@"Census_HF_4"]){
        sqlString=[NSString stringWithFormat:@"SELECT Case When ev.truename is null then '其他' else ev.truename end as mText, COUNT ( * ) as mValue FROM ( SELECT * FROM app_doctor_bind adb WHERE LBindTime > '%@ 00:00:00' AND LBindTime < '%@ 23:59:59' ) a LEFT JOIN empview ev ON a.LAiderId = ev.empKey  GROUP BY ev.truename",[sqlParameter objectAtIndex:0],[sqlParameter objectAtIndex:1]];
    }
    //   获取人群分类
    else if([type isEqualToString:@"PersonnalType"]){
        sqlString=[NSString stringWithFormat:@"select LValue from APP_Dictionary_Info where LType='%@' and LIsPubLic='是' order by LSordId",sqlParameter];
    }
    return sqlString;
}

- (NSDictionary*)generateTextDic:(NSString *)value{
    NSDictionary *dic=@{@"type":@"TEXT",@"value":value};
    return dic;
}

- (NSDictionary*)generateIntDic:(NSString *)value{
    NSDictionary *dic=@{@"type":@"INT",@"value":value};
    return dic;
}

- (NSDictionary*)generateFuncDic:(NSString *)value{
    NSDictionary *dic=@{@"type":@"FUNC",@"value":value};
    return dic;
}

//- (void)generateSqlString:(NSString*)action:]

@end
