//
//  PrintView.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootView.h"
#import "MQTTKit.h"
@protocol PrintViewDelegate <NSObject>
- (void)cancelPrinView;
- (void)printChoiceURL:(NSString*)url;
@end

@interface PrintView : RootView
{
    UIView *subBGView;
    MQTTClient *client;

}
@property(nonatomic,copy)NSString *printID;
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,assign)id<PrintViewDelegate>delegate;
- (void)creatUI:(NSArray *)btnNameArray andPrintID:(NSString *)projectID andTitle:(NSString*)titleString;
- (void)cancel;
@end
