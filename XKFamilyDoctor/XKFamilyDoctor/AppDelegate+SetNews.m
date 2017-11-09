//
//  AppDelegate+SetNews.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AppDelegate+SetNews.h"
#import "VPKCClientManager.h"
#import "ChatItem.h"
#import "ArchiveClass.h"
@implementation AppDelegate (SetNews)

- (void)connectMQTT{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if ([usd objectForKey:@"id"]) {
        [usd removeObjectForKey:@"ChatNowCode"];
        VPKCClientManager *clientManager=[VPKCClientManager sharedClient];
        [clientManager subscribeMessageWithMessageHandler:^(id dict){
            NSLog(@"＝＝＝＝＝＝＝＝%@＝＝＝＝＝＝＝＝＝",dict);
            if ([dict isKindOfClass:[NSArray class]]){
                if (((NSArray*)dict).count>0) {
                    [self performSelectorOnMainThread:@selector(setNewNews:) withObject:dict waitUntilDone:NO];
                }
            }else if([[dict objectForKey:@"type"] isEqualToString:@"home"]||[[dict objectForKey:@"type"] isEqualToString:@"chat"]||[[dict objectForKey:@"type"] isEqualToString:@"group"]){
                NSLog(@"＝＝＝＝＝＝＝＝%@＝\n%@＝%@＝＝＝＝＝＝＝",[dict objectForKey:@"type"],[dict objectForKey:@"to"],CHATNOWCODE);
                if ((CHATNOWCODE&&(([[dict objectForKey:@"type"] isEqualToString:@"home"]&&![[dict objectForKey:@"to"] isEqualToString:CHATNOWCODE])||([[dict objectForKey:@"type"] isEqualToString:@"chat"]&&![[dict objectForKey:@"from"] isEqualToString:CHATNOWCODE])))||(!CHATNOWCODE&&![[dict objectForKey:@"type"] isEqualToString:@"group"])) {
                    [self performSelectorOnMainThread:@selector(setNewNews:) withObject:dict waitUntilDone:NO];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"HaveNews" object:dict]];
                }
            }
        }];
    }
}

- (void)setNewNews:(id)object{
    NSMutableArray *newNewsArray=[[ArchiveClass new] getLocalNews];
    if (!newNewsArray) {
        newNewsArray=[NSMutableArray new];
    }
    MyTabBarController *tbc=[self topViewController].myTabBarController;
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=object;
        int newsCount=0;
        if (newNewsArray.count>0) {
           for (ChatItem *item in newNewsArray) {
               newsCount+=item.unsend;
           }
        }
        NSLog(@"========%d",newsCount);
        if (dataArray.count>0) {
            for (NSDictionary *newsDic in dataArray) {
                newsCount+=[[newsDic objectForKey:@"unsend"] intValue];
                NSLog(@"=====11===%d",newsCount);
                ChatItem *Item=[RMMapper objectWithClass:[ChatItem class] fromDictionary:newsDic];
                for (ChatItem *item in newNewsArray) {
                    if ([item.type isEqualToString:@"home"]&&[Item.to isEqualToString:item.to]) {
                        isHaveChat=YES;
                        if (item.unsend) {
                            item.unsend+=Item.unsend;
                        }
                        item.content=Item.content;
                        item.timestamp=Item.timestamp;
                    }else if ([item.type isEqualToString:@"chat"]&&[Item.from isEqualToString:item.from]&&[Item.to isEqualToString:item.to]) {
                        isHaveChat=YES;
                        if (item.unsend) {
                            item.unsend+=Item.unsend;
                        }
                        item.content=Item.content;
                        item.timestamp=Item.timestamp;
                    }
                }
                if (isHaveChat==NO) {
                    [newNewsArray addObject:Item];
                }else{
                    isHaveChat=NO;
                }
            }
            tbc.newsLabel.hidden=NO;
            tbc.newsLabel.text=[NSString stringWithFormat:@"%d",newsCount];
            NSLog(@"============%d==========%@",newsCount,tbc.newsLabel.text);
        }
    }
    else{
        ChatItem *Item=[RMMapper objectWithClass:[ChatItem class] fromDictionary:object];
        Item.unsend=1;
        if (newNewsArray.count>0) {
            for (ChatItem *item in newNewsArray) {
                if ([item.type isEqualToString:@"home"]&&[Item.to isEqualToString:item.to]) {
                    isHaveChat=YES;
                    if (item.unsend) {
                        item.unsend+=1;
                    }
                    item.content=Item.content;
                    item.timestamp=Item.timestamp;
                }else if ([item.type isEqualToString:@"chat"]&&[Item.from isEqualToString:item.from]&&[Item.to isEqualToString:item.to]) {
                    isHaveChat=YES;
                    if (item.unsend) {
                        item.unsend+=1;
                    }
                    item.content=Item.content;
                    item.timestamp=Item.timestamp;
                }
            }
            if (isHaveChat==NO) {
                [newNewsArray addObject:Item];
            }else{
                isHaveChat=NO;
            }
        }else{
            [newNewsArray addObject:Item];
        }
        int newsCount=[tbc.newsLabel.text intValue]+1;
        tbc.newsLabel.hidden=NO;
        tbc.newsLabel.text=[NSString stringWithFormat:@"%d",newsCount];
        NSLog(@"============%d==========%@",newsCount,tbc.newsLabel.text);
    }
    [[ArchiveClass new] saveNewsToLocal:newNewsArray];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"OfflineHaveNews" object:newNewsArray]];
    
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


@end
