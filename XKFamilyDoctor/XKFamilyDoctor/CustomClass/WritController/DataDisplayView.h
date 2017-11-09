//
//  DataDisplayView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"
#import "DateChoiceView.h"
#import "PMenuChoiceView.h"
@protocol saveMessageDelegate <NSObject>
//保存成功后
-(void)saveSuccess:(NSMutableArray*)dataArray;

/**
 获取验证码

 @param button 获取验证码button
 @param array  手机号、验证码
 */
- (void)sendCode:(UIButton*)button andData:(NSArray*)array;

/**
 选择社区

 @param button 选择社区button
 */
- (void)choiceCommuty:(UIButton*)button;

/**
 获取单列表选项
 
 @param tableName 表名
 @param key 查询字段
 @param where 查询条件
 @param btn 选择的button
 */
- (void)getCommenList:(NSString*)tableName andKey:(NSString*)key andWhere:(NSString*)where andButton:(UIButton*)btn andType:(NSString *)type;

@end
@interface DataDisplayView : RootView<UITextFieldDelegate,DateChoiceDelegate,MenuChoiceDelegate>
{
    UIScrollView *mainScrollView;
    PMenuChoiceView *menuChoiceView;
    UIButton *lastTimeButton;
    UIButton *lastSexButton;
    
    UITextField *memberNumberField;
    UITextField *codeField;
    NSString *localCodeString;
    
    NSMutableDictionary *commenListDic;
}
- (void)initSubViews:(NSMutableArray*)dataArray andController:(UIViewController*)vc;
- (void)reloadView:(id)item;
- (void)saveParentArray;
- (void)addCommenListView;

@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *communityID;
@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *peopleMemberID;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSArray *commenListArray;
@property(nonatomic,strong)UIViewController *superController;
@property(nonatomic,assign)id<saveMessageDelegate>delegate;
@end
