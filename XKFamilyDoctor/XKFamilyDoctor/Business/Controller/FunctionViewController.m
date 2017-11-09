//
//  FunctionViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FunctionViewController.h"

@interface FunctionViewController ()

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//验证身份证号
- (void)searchIDCard:(NSString *)IDCard{
    [self sendRequest:@"IDCardIsHave" andPath:queryURL andSqlParameter:IDCard and:self];
}

//生成会员卡号
- (void)returnMemberID{
    [self sendRequest:@"MemberCode" andPath:queryURL andSqlParameter:nil and:self];
}

//注册家庭医生账号
- (void)regFamilyDoctorAccount:(NSString *)phone andMember:(NSString*)memberID andLonlyCode:(NSString *)LOnlyCode andName:(NSString*)name andSex:(NSString*)sex andBir:(NSString*)birthday andIDCard:(NSString*)IDCard andAddress:(NSString*)address{
    [self sendRequest:@"AddUser" andPath:queryWithoutURL andSqlParameter:@[phone,memberID,LOnlyCode,name,sex,birthday,IDCard,address,@"000000",@"iOS",[NSString stringWithFormat:@"iOS(Version %@)",[[UIDevice currentDevice] systemVersion]],@"",@""] and:self];
}

//登录家庭医生
- (void)loginFamilyDoctor:(NSString*)phone{
    [self sendRequest:@"Login" andPath:queryURL andSqlParameter:@[phone,@"居民"] and:self];
}

//生成档案号
- (void)retureFileNo:(NSString*)districtString{
    [self sendRequest:@"GenerateFileNO" andPath:queryURL andSqlParameter:districtString and:self];
}

- (void)healthFileFace:(NSString*)IDCard andName:(NSString*)name andSex:(NSString*)sex andBir:(NSString*)birthday andNatoin:(NSString*)nation andAddress:(NSString*)address andPhone:(NSString *)phone andLonlyCode:(NSString *)LOnlyCode andFileNo:(NSString *)FileNo andMember_id:(NSString*)member_id andBuildPerson:(NSString*)BuildPerson{
//    NSDictionary *jsonDic=@{@"cmd":@[@{@"action":@"insert or update",@"function":@"shopncMember",
//                                       @"where":[NSString stringWithFormat:@"sIDCard='%@'",[[sqlParameter objectAtIndex:0] objectAtIndex:0]],
//                                       @"update":@{
//                                               @"sLinkPhone":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:1]],
//                                               @"member_truename":[self generateTextDic:[[sqlParameter objectAtIndex:0]  objectAtIndex:2]],
//                                               @"member_birthday":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:3]],
//                                               @"member_sex":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:4]],
//                                               @"sFolk":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:5]],
//                                               @"sAddress":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:6]],
//                                               @"LOnlyCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:8]],
//                                               @"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:9]]
//                                               },
//                                       @"insert":@{
//                                               @"sIDCard":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:0]],
//                                               @"sLinkPhone":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:1]],
//                                               @"member_truename":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:2]],
//                                               @"member_birthday":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:3]],
//                                               @"member_sex":[self generateIntDic:[[sqlParameter objectAtIndex:0] objectAtIndex:4]],
//                                               @"sFolk":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:5]],
//                                               @"sAddress":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:6]],
//                                               @"member_id":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
//                                               @"LOnlyCode":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:8]],
//                                               @"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:9]]
//                                               }},
//                                     @{@"action":@"insert or update",@"function":@"personalInfo",
//                                       @"where":[NSString stringWithFormat:@"FileNo='%@'",[[sqlParameter objectAtIndex:1] objectAtIndex:0]],
//                                       @"update":@{
//                                               @"FileNoSub":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:1]],
//                                               @"Sex":[self generateTextDic:[[sqlParameter objectAtIndex:1]  objectAtIndex:2]],
//                                               @"Folk":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:3]],
//                                               @"Birthday":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:4]],
//                                               @"IDNumber":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:5]],
//                                               @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:6]],
//                                               @"member_id":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
//                                               },
//                                       @"insert":@{
//                                               @"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:0]],
//                                               @"FileNoSub":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:1]],
//                                               @"Sex":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:2]],
//                                               @"Folk":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:3]],
//                                               @"Birthday":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:4]],
//                                               @"IDNumber":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:5]],
//                                               @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:1] objectAtIndex:6]],
//                                               @"member_id":[self generateTextDic:[[sqlParameter objectAtIndex:0] objectAtIndex:7]],
//                                               }},
//                                     @{@"action":@"insert or update",@"function":@"healthFile",
//                                       @"where":[NSString stringWithFormat:@"FileNo='%@'",[[sqlParameter objectAtIndex:2] objectAtIndex:0]],
//                                       @"update":@{
//                                               @"Name":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:1]],
//                                               @"Address":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:3]],
//                                               @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:6]],
//                                               },
//                                       @"insert":@{
//                                               @"FileNo":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:0]],
//                                               @"Name":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:1]],
//                                               @"BuildPerson":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:2]],
//                                               @"Address":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:3]],
//                                               @"InputPersonID":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:5]],
//                                               @"TEL":[self generateTextDic:[[sqlParameter objectAtIndex:2] objectAtIndex:6]],
//                                               @"syncmsg":[self generateTextDic:@"快速建档,详细信息需后期完善"]
//                                               }}]};
//    

}

- (void)isNewHealthFile:(BOOL)newFile andFileDic:(NSDictionary*)IDCardDic {
    if (newFile) {
        self.IDCardDic=[[NSMutableDictionary alloc]initWithDictionary:IDCardDic];
        [self searchIDCard:[self.IDCardDic objectForKey:@"IDCard"]];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if ([type isEqualToString:@"IDCardIsHave_"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.memberID=[self changeNullString:[dic objectForKey:@"member_id"]];
                self.lOnlyString=[self changeNullString:[dic objectForKey:@"LOnlyCode"]];
                self.fileNo=[self changeNullString:[dic objectForKey:@"FileNo"]];
                if (self.memberID.length==0) {
                    [self returnMemberID];
                }else if([self changeNullString:[self.IDCardDic objectForKey:@"phone"]].length>0&&self.lOnlyString.length==0){
                    self.lOnlyString=[self getUniqueStrByUUID];
                    [self regFamilyDoctorAccount:[self.IDCardDic objectForKey:@"phone"] andMember:self.memberID andLonlyCode:self.lOnlyString andName:[self.IDCardDic objectForKey:@"userName"] andSex:[self.IDCardDic objectForKey:@"sex"] andBir:[self.IDCardDic objectForKey:@"birthday"] andIDCard:[self.IDCardDic objectForKey:@"IDCard"] andAddress:[self.IDCardDic objectForKey:@"address"]];
                }
            }
            else{
                [self returnMemberID];
            }
            
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
