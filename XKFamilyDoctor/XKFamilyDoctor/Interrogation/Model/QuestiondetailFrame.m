//
//  QuestiondetailFrame.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "QuestiondetailFrame.h"

@implementation QuestiondetailFrame
- (void)setQuestionAnswer:(QuestionDetailIItem *)questionAnswer{
    _questionAnswer=questionAnswer;
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,50, SCREENWIDTH-30, 20)];
    contentLabel.text=[self changeString:questionAnswer.LDetail andType:@"in"];
    contentLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    contentLabel.numberOfLines=0;
    [contentLabel sizeToFit];
    if (questionAnswer.LPic1.length>0) {
        self.cellHeight=contentLabel.frame.origin.y+contentLabel.frame.size.height+159;
    }else{
        self.cellHeight=contentLabel.frame.origin.y+contentLabel.frame.size.height+49;
    }
}

- (NSString*)changeString:(NSString*)string andType:(NSString*)type{
    NSString *returnString=nil;
    if ([type isEqualToString:@"in"]) {
        returnString=[string stringByReplacingOccurrencesOfString:@"[@HC@]" withString:@"\n"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@HH@]" withString:@"\n"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@YH@]" withString:@"'"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@BH@]" withString:@"%"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@ZJH@]" withString:@"<"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@YJH@]" withString:@">"];
    }else{
        returnString=[string stringByReplacingOccurrencesOfString:@"\n" withString:@"[@HH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"'" withString:@"[@YH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"%" withString:@"[@BH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"<" withString:@"[@ZJH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@">" withString:@"[@YJH@]"];
    }
    return returnString;
}

@end
