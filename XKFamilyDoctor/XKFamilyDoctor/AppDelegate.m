//
//  AppDelegate.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+SetNews.h"
#import "LoginViewController.h"
#import "UncaughtExceptionHandler.h"
#import "MyUncaughtExceptionHandler.h"
#import "AlipaySDK/AlipaySDK.h"
#import "WXApi.h"
#import "MyTabBarController.h"
#import "ConsultantViewController.h"
#import "InterrogationViewController.h"
#import "CNewsViewController.h"
#import "CRNewsViewController.h"
#import "MedicalCareViewController.h"
#import "BusinessViewController.h"
#import "CenterViewController.h"
#import "OrderDetailViewController.h"
#import "ArchiveClass.h"

BMKMapManager *mapManager;
#define mapAppKey @"XWvVocGzaIxpRq0GRmH5x1phw9MxRXOH"
#define wxAppId @"wxf3aebb36fd9bf92c"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "StaffCenterViewController.h"
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (void)installUncaughtExceptionHandler

{
   
   InstallUncaughtExceptionHandler();
   
}

- (void)creatTabBarController{
   BusinessViewController *bvc=[BusinessViewController new];
   UINavigationController *nbvc=[[UINavigationController alloc]initWithRootViewController:bvc];
   
   CenterViewController *cvc=[[CenterViewController alloc]init];
   UINavigationController *ncvc=[[UINavigationController alloc]initWithRootViewController:cvc];
   
   MyTabBarController *tabVC=[[MyTabBarController alloc]init];
   NSArray *nvcAry=[NSArray arrayWithObjects:nbvc,ncvc,nil];
   tabVC.viewControllers=nvcAry;
   self.window.rootViewController=tabVC;
}

- (void)JPUSH:(NSDictionary *)launchOptions {
   NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   //Required
   if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      //可以添加自定义categories
      [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound |
                                                        UIUserNotificationTypeAlert)
                                            categories:nil];
   } else {
      //categories 必须为nil
      [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
                                            categories:nil];
   }
   //Required
   [JPUSHService setupWithOption:launchOptions
                          appKey:@"41b6e303665e280983735828"
                         channel:@"Publish channel"
                apsForProduction:NO
           advertisingIdentifier:advertisingId];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   // Override point for customization after application launch.
   self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
   self.window.backgroundColor=[UIColor whiteColor];
   [self.window makeKeyAndVisible];
   
   if ([[NSUserDefaults standardUserDefaults] objectForKey:@"id"]) {
      [self creatTabBarController];
   }else{
      LoginViewController *lvc=[[LoginViewController alloc]init];
      UINavigationController *nlvc=[[UINavigationController alloc]initWithRootViewController:lvc];
      self.window.rootViewController=nlvc;
   }
   
   UITextView *firstTextView=[UITextView new];
   firstTextView=nil;
   
   NSDictionary *urlDic=[[ArchiveClass new] getLocalUrl];
   NSArray *host=[urlDic objectForKey:@"host"];
   for (NSDictionary *dic in host) {
      if ([CHOICEURL isEqualToString:[dic objectForKey:@"orgName"]]) {
         self.MQTT_HOST=[dic objectForKey:@"mqtt_host"];
         self.MQTT_HOST_ID=[dic objectForKey:@"mqtt_host_id"];
         self.MQTT_PORT=[[dic objectForKey:@"mqtt_port"] intValue];
      }
   }
//   [self connectMQTT];
   //加载百度地图
   [self initBDMap];
   //    加载微信
   [self initWechatPay];
   
//   [self JPUSH:launchOptions];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

   return YES;
}

-(void)initWechatPay{
   [WXApi registerApp:wxAppId withDescription:@"wechatPay"];
   
}

- (void) onResp:(BaseResp*)resp
{
   NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
   
   NSString *strTitle;
   UIViewController *vc=[self topViewController];
   if([resp isKindOfClass:[PayResp class]]){
      //支付返回结果，实际支付结果需要去微信服务器端查询
      strTitle = [NSString stringWithFormat:@"支付结果"];
      
      switch (resp.errCode) {
         case WXSuccess:
         {
            strMsg = @"亲，支付已成功！";
            if ([vc isKindOfClass:[OrderDetailViewController class]]) {
               OrderDetailViewController *ovc=(OrderDetailViewController*)vc;
               ovc.payIsSuccess=@"Y";
               [ovc viewDidAppear:YES];
            }
         }
            break;
         default:
            if ( resp.errCode==-2) {
               strMsg=@"您取消了本次操作！";
   
            }else{
               strMsg=@"支付失败！";
            }
            break;
      }
      UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:strMsg preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
      [av addAction:cancelAC];
      [vc presentViewController:av animated:YES completion:nil];
   }
}

#pragma mark 获取当前控制器
- (UIViewController *)topViewController {
   UIViewController *resultVC;
   resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
   while (resultVC.presentedViewController) {
      resultVC = [self _topViewController:resultVC.presentedViewController];
   }
   return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
   if ([vc isKindOfClass:[UINavigationController class]]) {
      return [self _topViewController:[(UINavigationController *)vc topViewController]];
   } else if ([vc isKindOfClass:[UITabBarController class]]) {
      return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
   } else {
      return vc;
   }
   return nil;
}



#pragma mark  初始化百度地图
- (void)initBDMap{
   mapManager = [[BMKMapManager alloc]init];
   BOOL ret = [mapManager start:mapAppKey generalDelegate:self];
   if (!ret) {
      NSLog(@"manager start failed!");
   }
}

- (void)applicationWillResignActive:(UIApplication *)application {
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   int badge = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
   if (badge>0) {
      [UIApplication sharedApplication].applicationIconBadgeNumber =0;
   }
   [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
   /// Required - 注册 DeviceToken
   [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
   //Optional
   NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
   [JPUSHService handleRemoteNotification:userInfo];
   completionHandler(UIBackgroundFetchResultNewData);
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   if ([url.host isEqualToString:@"safepay"]) {
      // 支付跳转支付宝钱包进行支付，处理支付结果
      [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         NSLog(@"result 11111111111111= %@",resultDic);
         if ([resultDic[@"resultStatus"] integerValue] == 9000 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
         }
         else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
         }
      }];
   }else{
      return [WXApi handleOpenURL:url delegate:self];
   }
   return YES;
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
   if ([url.host isEqualToString:@"safepay"]) {
      // 支付跳转支付宝钱包进行支付，处理支付结果
      [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         NSLog(@"result 000000000= %@",resultDic);
         if ([resultDic[@"resultStatus"] integerValue] == 9000 ) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
         }
         else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
         }
      }];
   }else{
      return [WXApi handleOpenURL:url delegate:self];
   }
   return YES;
}

@end
