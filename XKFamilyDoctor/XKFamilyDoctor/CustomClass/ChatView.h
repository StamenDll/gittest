//
//  ChatView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"
#import "ChatItem.h"
#import "ChatRoomPeopleItem.h"
#import "YYView.h"
@protocol chatViewDelegate <NSObject>

/**
 发送处方
 
 @param recipe 处方信息
 */
- (void)seeRecipeDetail:(id)recipe;

/**
 提交聊天信息
 
 @param chatItem 聊天信息
 */
- (void)saveMessage:(ChatItem*)chatItem;

/**
 获取历史消息
 */
- (void)getHistoryNews;

/**
 弹出提示框
 
 @param message 提示信息
 */
- (void)showMessage:(NSString*)message;

/**
 获取用户状态
 
 */
- (void)getUserState;

/**
 选择图片
 
 @param whoChoice 选择方式
 */
- (void)choiceImageView:(NSString*)whoChoice;

@end

@interface ChatView : RootView<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,YYDelegate>
{
    UIView *writeBAckView;
    UIView *moreMenuBGView;
    YYView *yyBGView;
    NSDictionary *chatCellDic;
    UITextView *newsTextView;
    NSMutableArray *chatArray;
    NSMutableArray *imageArray;
}

@property(nonatomic,copy)NSString *toName;
@property(nonatomic,copy)NSString *toTopc;
@property(nonatomic,copy)NSString *toFace;
@property(nonatomic,copy)NSString *chatType;
@property(nonatomic,copy)NSString *owerID;
@property(nonatomic,copy)NSString *isCanSend;
@property(nonatomic,strong)ChatRoomPeopleItem *peopleItem;
@property(nonatomic,assign)CGFloat lastContentOffset;
@property(nonatomic,copy)NSString *lastTimeString;
@property(nonatomic,assign)id<chatViewDelegate>delegate;
@property(nonatomic,strong)UITableView *mainTableView;


/**
 获取到消息列表后刷新消息界面
 
 @param array 消息数组
 */
- (void)relaodMainTableView:(NSMutableArray*)array;

/**
 创建聊天界面
 
 @param topc 聊天对象
 @param name 对象名称
 @param face 对象头像
 @param type 聊天方式
 @param owerID 群组聊天管理员ID
 @param BGVC 控制器
 */
- (void)creatUI:(NSString*)topc andName:(NSString*)name andFace:(NSString*)face andType:(NSString*)type andOwer:(NSString*)owerID;

/**
 发送处方信息
 
 @param recipe 处方
 */
- (void)sendRecipe:(id)recipe;

/**
 发送消息
 */
- (void)sendNews;


/**
 发送图片消息
 
 @param image 图片地址
 */
- (void)sendPicNews:(NSString*)imageString;

@end

