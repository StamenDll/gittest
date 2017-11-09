//
//  RightChoiceView.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootView.h"
@protocol RightChoiceViewDelegate <NSObject>
- (void)sureChoiceMenu:(NSString*)choiceMenu;
@end
@interface RightChoiceView : RootView
{
    UIView *subBGView;
}
- (void)creatUI:(NSArray*)menuArray;
- (void)cancelChoiceView;
@property(nonatomic,assign)id<RightChoiceViewDelegate>delegate;
@end
