//
//  RightChoiceView.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RightChoiceView.h"

@implementation RightChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
//        self.backgroundColor=[UIColor blackColor];
//        self.alpha=0.5;
    }
    return self;
}

- (void)creatUI:(NSArray*)menuArray{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelChoiceView)];
    tap.numberOfTapsRequired=1;
    [self addGestureRecognizer:tap];
    
    subBGView=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80,70,70,120)];
    subBGView.backgroundColor=GREENCOLOR;
    [subBGView.layer setCornerRadius:5];
    [self.superview addSubview:subBGView];
    
    for (int i=0; i<menuArray.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(0, 40*i, 70,40) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(sureChoice:)];
        [subBGView addSubview:menuButton];
        
        UILabel *menuLabel=[self addLabel:CGRectMake(0, 10, 70, 20) andText:[menuArray objectAtIndex:i] andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
        [menuButton addSubview:menuLabel];
        
        [self addLineLabel:CGRectMake(5, 39.5, 60, 0.5) andColor:MAINWHITECOLOR andBackView:menuButton];
    }
}

- (void)sureChoice:(UIButton*)button{
    [self cancelChoiceView];
    if ([self.delegate respondsToSelector:@selector(sureChoiceMenu:)]) {
        UILabel *label=[[button subviews] firstObject];
        [self.delegate sureChoiceMenu:label.text];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
    [subBGView removeFromSuperview];
}

- (void)cancelChoiceView{
    [self removeFromSuperview];
    [subBGView removeFromSuperview];
}


@end
