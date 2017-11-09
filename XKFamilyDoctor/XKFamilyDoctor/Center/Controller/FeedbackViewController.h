//
//  FeedbackViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface FeedbackViewController : RootViewController<UITextViewDelegate>
{
    UITextView *feedbackTextView;
    UILabel *adviceLabel;
}
@end
