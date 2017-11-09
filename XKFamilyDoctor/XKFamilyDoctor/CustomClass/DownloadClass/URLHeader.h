//
//  URLHeader.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#ifndef URLHeader_h
#define URLHeader_h

//116.52.164.58:9855
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define NAVHEIGHT self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

#define SCREENHEIGHT6 667.0

#define MAINWHITECOLOR [UIColor whiteColor]
#define MAINGRAYCOLOR [UIColor grayColor]
#define SUBGRAYCOLOR [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]
#define MAINBLACKCOLOR [UIColor blackColor]
#define CLEARCOLOR [UIColor clearColor]
//通用线条颜色
#define LINECOLOR [self colorWithHexString:@"dddddd"]
//通用绿色
#define GREENCOLOR [self colorWithHexString:@"1ccda9"]
//背景灰色
#define BGGRAYCOLOR [self colorWithHexString:@"f6f6f6"]

//黑色字体
#define TEXTCOLOR [self colorWithHexString:@"333333"]
//灰色字体
#define TEXTCOLORG [self colorWithHexString:@"666666"]
//淡灰色字体
#define TEXTCOLORDG [self colorWithHexString:@"999999"]
//超淡灰色字体
#define TEXTCOLORSDG [self colorWithHexString:@"bbbbbb"]
//搜索框背景色
#define BTNGRAYCOLOR [self colorWithHexString:@"f2f2f2"]
//价格颜色z
#define PRICECOLOR [self colorWithHexString:@"ff5926"]

//字体大小
#define SUPERFONT 18
#define BIGFONT 16
#define MIDDLEFONT 14
#define SMALLFONT 12

#define FONTTYPEME @"PingFang-SC-Regular"
#define FONTTYPERE @"PingFang-SC-Medium"
#define FONTTYPEBO @"PingFang-SC-Bold"

//#define MQTT_HOST @"116.52.164.59"
//#define MQTT_HOST @"101.201.113.84"
#define CHATCODE [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]
#define EMPKEY [[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"]
#define CHATNOWCODE [[NSUserDefaults standardUserDefaults] objectForKey:@"ChatNowCode"]
#define HEADPIC [[NSUserDefaults standardUserDefaults] objectForKey:@"LHeadPic"]
#define USERDEFAULTPIC [UIImage imageNamed:@"user_default"]
#define DOCDEFAULTPIC [UIImage imageNamed:@"doctor_default"]

#define URLSAVENAME @"linemainurl"
#define CHOICEURL [[NSUserDefaults standardUserDefaults] objectForKey:@"linemainurl"]

#define GETURLLISTTYPE @"getUrlListType"
#define GETURLLIST @"http://116.52.164.59:9902/config/hostcfg.txt"

//获取用户血压数据列表
#define GETBPTYPE @"getBPType"
#define GETBPURL @"/customer/customerBloodPressure"

//获取用户血糖数据列表
#define GETBSTYPE @"getBSType"
#define GETBSURL @"/customer/customerBloodSugar"

//获取用户血压数据列表
#define UPLOADBPTYPE @"uploadBPType"
#define UPLOADBPURL @"/customer/uploadBloodPressure"

//获取用户血糖数据列表
#define UPLOADBSTYPE @"uploadBSType"
#define UPLOADBSURL @"/customer/uploadBloodSugar"


//获取用户档案信息
#define GETUSERFILETYPE @"getUserFile"
#define GETUSERFILEURL @"/api-service/healthFile/getFile"

//更新用户档案信息
#define SETUSERFILETYPE @"setUserFile"
#define SETUSERFILEURL @"/api-service/healthFile/newOrUpdate"

//获取签约任务
#define GETSIGNTYPE @"getSignType"
#define GETSIGNURL @"http://fd-app.ynnewcare.net:9901/jtys_app/interface/sign/to_do"

//更新签约任务状态
#define CHANGESIGNTYPE @"changeSignType"
#define CHANGESIGNURL @"http://fd-app.ynnewcare.net:9901/jtys_app/interface/sign/done"



////检查更新接口
//#define CHECKUPDATATYPE  @"CheckUpdataType"
//#define CHECKUPDATAURL @"http://116.52.164.59:7700/upgrade/XKAssistant.txt"
//
////检查更新接口
//#define CHECKUPDATATYPE  @"CheckUpdataType"
//#define CHECKUPDATAURL @"http://116.52.164.59:7700/upgrade/XKAssistant.txt"
//
//#endif
//
////上传文件
//#define UPLOADFILE @"http://116.52.164.59:7701/api/FileUpload"
//
//
////插入、更新接口
//#define insetOrUpdataURL @"" mainURL"/home_doctor_main/sql/excute"
////查询接口
//#define queryURL @"" mainURL"/home_doctor_main/sql/query"
//
////无返回查询接口
//#define queryWithoutURL @"" mainURL"/home_doctor_main/sql/queryWithout"
//
//#define excuteURL @"" mainURL"/home_doctor_main/sql/excute"
//
////获取聊天记录
//#define getNewsHistory @"http://218.244.145.92:8881/wap/history"
//
//
////用户登录
//#define USERLOGINTYPE @"UserLogin"
//#define USERLOGIN @"" MAINURL"/apps/manager/interface/checkAuth"
//
////获取短信验证码接口
//#define GETVCTYPE @"GetVCode"
//#define getVCode @"" MAINURL"/home_doctor_main/user/verification"
//
////获取事业部列表
//#define BDLISTTYPE @"BDListType"
//#define BDLISTURL @"" MAINURL"/apps/manager/interface/getPlate"
//
////获取科室列表
//#define DEPLISTTYPE @"DepListType"
//#define DEPLISTURL @"" MAINURL"/apps/manager/interface/getDepartment"
//
////获取科室医生信息
//#define DEPDOCLISTTYPE @"DepDocListType"
//#define DEPDOCLISTURL @"" MAINURL"/apps/manager/interface/getEmp"
//
////获取机构列表
//#define MECLISTTYPE @"MecListType"
//#define MECLISTURL @"" MAINURL"/apps/manager/interface/getOrg"
//
////获取岗位列表
//#define POSTLISTTYPE @"PostListType"
//#define POSTLISTURL @"" MAINURL"/apps/manager/interface/getPost"
//
////获取调岗记录
//#define CHANGEHISTTYPE @"ChangeHisType"
//#define CHANGEHISURL @"" MAINURL"/apps/manager/interface/getLog"
//
////保存数据
//#define SAVEDATATYPE @"SaveDataType"
//#define SAVEDATAURL @"" MAINURL"/apps/manager/interface/saveEmp"
//
////修改密码
//#define CHANGEPWTYPE @"ChangePWType"
//#define CHANGEPWTAURL @"" MAINURL"/apps/manager/interface/changePassword"
//
////获取申请列表
//#define AUDITLISTTYPE @"AuditlistType"
//#define AUDITLISTAURL @"" MAINURL"/apps/manager/interface/getCheckEmp"
//
////修改申请
////获取申请列表
//#define CHANGEATYPE @"ChangeAType"
//#define CHANGEAURL @"" MAINURL"/apps/manager/interface/checkEmp"
//
////调换岗位
//#define CHANGEPROTYPE @"ChangeProType"
//#define CHANGEPROAURL @"" MAINURL"/apps/manager/interface/editProperty"
//
//
////登录注册接口
//#define LoginType @"Login"
//#define Login @""mainURL"/home_doctor_main/user/loginCustomer"
//
////绑定公卫账号
//#define BINDINGTYPE @"BindingType"
//#define BINDINGURL @""MAINURL"/apps/manager/interface/bandGw"
//
////登录公卫账号
//#define LOGINGWTYPE @"LoginGWType"
//#define LOGINGWGURL @""MAINURL"/apps/manager/interface/checkGw"
//
////重置密码
//#define RESETPWTYPE @"ResetType"
//#define RESETPWGURL @""MAINURL"/apps/manager/interface/resetPassword"
//

#endif /* URLHeader_h */
