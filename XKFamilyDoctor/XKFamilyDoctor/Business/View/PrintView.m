//
//  PrintView.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PrintView.h"
#import "AppDelegate.h"
@implementation PrintView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        self.alpha=0.6;
    }
    return self;
}

- (void)creatUI:(NSArray *)btnNameArray andPrintID:(NSString *)projectID andTitle:(NSString*)titleString{
    self.titleString=titleString;
    self.printID=projectID;
    subBGView=[[UIView alloc]initWithFrame:CGRectMake(40,0, SCREENWIDTH-80,0)];
    subBGView.backgroundColor=MAINWHITECOLOR;
    [self.superview addSubview:subBGView];
    
    UIView *titleBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-80, 40)];
    titleBGView.backgroundColor=GREENCOLOR;
    [subBGView addSubview:titleBGView];
    
    UILabel *titleLabel=[self addLabel:CGRectMake(0,10, titleBGView.frame.size.width, 20) andText:titleString andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [titleBGView  addSubview:titleLabel];
    
    for (int i=0; i<btnNameArray.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(20,60+50*i,SCREENWIDTH-120,40) adnColor:GREENCOLOR andTag:101+i andSEL:@selector(menuOnclick:)];
        [menuButton.layer setCornerRadius:5];
        [subBGView addSubview:menuButton];
        
        UILabel *menunameLabel=[self addLabel:CGRectMake(0,10, menuButton.frame.size.width, 20) andText:[btnNameArray objectAtIndex:i] andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [menuButton  addSubview:menunameLabel];
        subBGView.frame=CGRectMake(40, 0, SCREENWIDTH-80, menuButton.frame.origin.y+menuButton.frame.size.height+20);
        subBGView.center=self.superview.center;
    }
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake((subBGView.frame.size.width-100)/2, subBGView.frame.size.height, 100,30) andBColor:TEXTCOLORSDG andTag:0 andSEL:@selector(cancel) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [cancelButton.layer setCornerRadius:15];
    [subBGView addSubview:cancelButton];
    
    subBGView.frame=CGRectMake(40, 0, SCREENWIDTH-80, cancelButton.frame.origin.y+cancelButton.frame.size.height+20);
    subBGView.center=self.superview.center;
    
}

- (void)cancel{
    [self removeFromSuperview];
    [subBGView removeFromSuperview];
    [self.delegate cancelPrinView];
}

- (void)menuOnclick:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if ([self.delegate respondsToSelector:@selector(printChoiceURL:)]) {
        [self.delegate printChoiceURL:label.text];
    }else{
        if (!client) {
            NSString *clientId =  [NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]];
            client = [[MQTTClient alloc] initWithClientId:clientId];
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            client.host =appDelegate.MQTT_HOST;
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
        
        NSDictionary *contentDic=nil;
        if (button.tag==101) {
            contentDic=@{@"action" :@"bindhomedoctor",@"orgid":[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"]intValue]],@"data":@[@{@"projid":self.printID,@"reporttemplet":@"first",@"print":@"yes"}]};
        }else if (button.tag==102) {
            contentDic=@{@"action" :@"bindhomedoctor",@"orgid":[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"]intValue]],@"data":@[@{@"projid":self.printID,@"reporttemplet":@"second",@"print":@"yes"}]};
        }else if (button.tag==103) {
            contentDic=@{@"action" :@"bindhomedoctor",@"orgid":[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"]intValue]],@"data":@[@{@"projid":self.printID,@"reporttemplet":@"third",@"print":@"yes"}]};
        }
        NSData *contentJson = [NSJSONSerialization dataWithJSONObject:contentDic options:0 error:NULL];
        NSString *content =  [[NSString alloc] initWithData:contentJson encoding:NSUTF8StringEncoding];
        
        NSLog(@"=================+%@",content);
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

        [client publishString:content
                      toTopic:appDelegate.MQTT_HOST_ID
                      withQos:AtMostOnce
                       retain:NO
            completionHandler:^(int mid) {
                NSLog(@"wwww--%d", mid);
            }];
        
        dispatch_semaphore_t received = dispatch_semaphore_create(0);
        [client setMessageHandler:^(MQTTMessage *message) {
            dispatch_semaphore_signal(received);
        }];
    }
    
}



@end
