//
//  CustomProgressView.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomProgressView.h"

@implementation CustomProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.alpha=0.6;
    }
    return self;
}

- (void)creatUI:(NSArray*)nameArray andCount:(int)count{
    for (int i=0; i<nameArray.count; i++) {
        UILabel *nameLabel=[self addLabel:CGRectMake(20+(SCREENWIDTH-40)/nameArray.count*i,40, (SCREENWIDTH-40)/nameArray.count, 20) andText:[nameArray objectAtIndex:i] andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
        [self addSubview:nameLabel];
        
        if (i<nameArray.count-1) {
            if (i<count) {
                [self addLineLabel:CGRectMake(nameLabel.center.x, 26,(SCREENWIDTH-40)/nameArray.count,1) andColor:GREENCOLOR andBackView:self];
            }else{
                [self addLineLabel:CGRectMake(nameLabel.center.x, 26,(SCREENWIDTH-40)/nameArray.count,1) andColor:LINECOLOR andBackView:self];
            }
        }
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,20, 14, 14)];
        imageView.image=[UIImage imageNamed:@"plan_finish"];
        if (i>count) {
            nameLabel.textColor=TEXTCOLORG;
            imageView.frame=CGRectMake(0, 23, 8, 8);
            imageView.image=[UIImage imageNamed:@"plan_done"];
        }
        imageView.center=CGPointMake(nameLabel.center.x, imageView.center.y);
        [self addSubview:imageView];
        
    }
    
    [self addLineLabel:CGRectMake(0,self.frame.size.height-0.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self];
}

@end
