//
//  CommWriteItme.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommWriteItme : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *value;
@property(nonatomic,assign)BOOL isNeed;
///是否可编辑
@property(nonatomic,copy)NSString *LCanEdit;
///--是否是关键条件字段,值: 是，否
@property(nonatomic,copy)NSString *LIsKey;
/// 字符，整形，浮点，时间，单列表,多列表
@property(nonatomic,copy)NSString *LValueType;
@property(nonatomic,assign)int  LHeight;
@property(nonatomic,copy)NSString *LID;
/// 排序ID
@property(nonatomic,copy)NSString *LSortId;

@property(nonatomic,copy)NSString *LBoxValue_Parent_Field;

@property(nonatomic,copy)NSString *LBoxValue_ValueField;
@property(nonatomic,copy)NSString *LBoxValue_KeyField;

@property(nonatomic,copy)NSString *LBoxValue;
@property(nonatomic,copy)NSString *LBoxValue_Parent;
@property(nonatomic,copy)NSString *LBoxValue_table;
///表中where条件
@property(nonatomic,copy)NSString *LBoxValue_Where;
@property(nonatomic,copy)NSString *LWTime;
@property(nonatomic,copy)NSString *LTableName;
///显示出来的名称
@property(nonatomic,copy)NSString *LCaption;
@property(nonatomic,copy)NSString *LDefaultValue;
///当 LIsKey ='是' 时生效，此值是给 LFieldName 的赋值类型 值为：(onlycode ,对应登录返回中的 LOnlyCode值 peoplecode, 对应登录返回中的 管理或签约居民 LOnlyCode值 orgid, 对应对应登录返回中的 LOrgid值 mobile, 对应对应登录返回中的 LMobile值 memberid,对应对应登录返回中的 LCode值 idnumber,对应身份证号 mainkey,主键)
@property(nonatomic,copy)NSString *LKeyValue;
///是否允许为空,值： 是，否
@property(nonatomic,copy)NSString *LAllowEmpty;
@property(nonatomic,copy)NSString *LBoxValue_fields;
@property(nonatomic,copy)NSString *LFieldName;
@end
