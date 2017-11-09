//
//  AppDelegate.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
    BOOL isHaveChat;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,copy)NSString *MQTT_HOST;
@property(nonatomic,assign)int MQTT_PORT;
@property(nonatomic,copy)NSString *MQTT_HOST_ID;
@end

