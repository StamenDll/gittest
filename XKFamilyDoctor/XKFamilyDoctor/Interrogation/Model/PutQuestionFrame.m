//
//  PutQuestionFrame.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PutQuestionFrame.h"

@implementation PutQuestionFrame

-(void)setQuestionMessage:(PutQuestionItem *)questionMessage{
    _questionMessage=questionMessage;
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 65, SCREENWIDTH-30, 20)];
    contentLabel.text=questionMessage.LDetail;
    contentLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    contentLabel.numberOfLines=3;
    [contentLabel sizeToFit];
    if (questionMessage.LPic1.length==0) {
        self.cellHeight=contentLabel.frame.origin.y+contentLabel.frame.size.height+50;
    }else{
        self.cellHeight=contentLabel.frame.origin.y+contentLabel.frame.size.height+60+(SCREENWIDTH-40)/2;
    }
}
@end
