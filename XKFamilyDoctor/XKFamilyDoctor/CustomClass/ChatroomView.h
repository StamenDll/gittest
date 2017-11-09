//
//  ChatroomView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"

@interface ChatroomView : RootView<UITextViewDelegate>
{
    UIScrollView *mainScrollView;
    UIView *writeBAckView;
    UITextView *newsTextView;
}
- (void)addSubViews:(NSMutableArray*)dataArray;
@end
