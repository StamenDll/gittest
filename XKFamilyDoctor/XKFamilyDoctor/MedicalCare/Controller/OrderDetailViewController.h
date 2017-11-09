//
//  OrderDetailViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "OrderItem.h"

@interface OrderDetailViewController : RootViewController<UITextFieldDelegate,selfRequestDelegate>
{
    UIScrollView *mainBGScrollView;
    
    UIButton *payByCashButton;
    UIButton *payOnlineButton;
    
    UITextField *codeTextField;
    UIButton *sureFinishButton;
    
    NSMutableArray *goodsArray;
    CGFloat totleMoney;
    
    UIButton *getCodeButton;
    
    NSTimer *timer;
    NSInteger maCount;

}

@property(nonatomic,strong)OrderItem *orderItem;
@property(nonatomic,copy)NSString *codeString;
@property(nonatomic,copy)NSString *userCode;
@property(nonatomic,copy)NSString *orderNumber;
@property(nonatomic,copy)NSString *orderUserName;
@property(nonatomic,copy)NSString *orderUserPhone;
@property(nonatomic,copy)NSString *isPaySuccess;
@property(nonatomic,copy)NSString *VCode;

@property(nonatomic,copy)NSString *whoPush;

@property(nonatomic,copy)NSString *payIsSuccess;
@end
