//
//  CheckboxView.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CheckboxView.h"

@implementation CheckboxView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        self.alpha=0.6;
    }
    return self;
}

- (void)creatUI:(NSString*)title andOption:(NSArray*)option andConnect:(NSString*)connectString{
    choiceArray=[NSMutableArray new];
    subBGView=[[UIView alloc]initWithFrame:CGRectMake(40,0, SCREENWIDTH-80,100)];
    subBGView.backgroundColor=MAINWHITECOLOR;
    [self.superview addSubview:subBGView];
    
    UIView *titleBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-80, 40)];
    titleBGView.backgroundColor=GREENCOLOR;
    [subBGView addSubview:titleBGView];
    
    UILabel *titleLabel=[self addLabel:CGRectMake(0,10, titleBGView.frame.size.width, 20) andText:title andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [titleBGView  addSubview:titleLabel];
    
    NSMutableArray *btnArray=[NSMutableArray new];
    for (int i=0; i<option.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(20,60,0,30) adnColor:MAINWHITECOLOR andTag:101 andSEL:@selector(menuOnclick:)];
        [menuButton.layer setCornerRadius:15];
        menuButton.layer.borderColor=GREENCOLOR.CGColor;
        menuButton.layer.borderWidth=0.5;
        [subBGView addSubview:menuButton];
        
        UILabel *menunameLabel=[self addLabel:CGRectMake(20,5, menuButton.frame.size.width, 20) andText:[option objectAtIndex:i] andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
        menunameLabel.numberOfLines=0;
        [menunameLabel sizeToFit];
        [menuButton  addSubview:menunameLabel];
        
        menuButton.frame=CGRectMake(20, 60,menunameLabel.frame.size.width+40, 30);
        if (i>0) {
            UIButton *beforButton=[btnArray objectAtIndex:i-1];
            menuButton.frame=CGRectMake(beforButton.frame.origin.x+beforButton.frame.size.width+10,beforButton.frame.origin.y, menuButton.frame.size.width, menuButton.frame.size.height);
            if (menuButton.frame.origin.x+menuButton.frame.size.width>subBGView.frame.size.width-5) {
                menuButton.frame=CGRectMake(20,beforButton.frame.origin.y+beforButton.frame.size.height+10, menuButton.frame.size.width, menuButton.frame.size.height);
            }
        }
        [btnArray addObject:menuButton];
        subBGView.frame=CGRectMake(40, 0, SCREENWIDTH-80, menuButton.frame.origin.y+menuButton.frame.size.height+20);
        subBGView.center=self.superview.center;
    }
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake((subBGView.frame.size.width-220)/2, subBGView.frame.size.height, 100,30) andBColor:TEXTCOLORSDG andTag:0 andSEL:@selector(cancel) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [cancelButton.layer setCornerRadius:15];
    [subBGView addSubview:cancelButton];
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake((subBGView.frame.size.width-220)/2+120, subBGView.frame.size.height, 100,30) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureChoice) andText:@"确定" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureButton.layer setCornerRadius:15];
    [subBGView addSubview:sureButton];
    
    subBGView.frame=CGRectMake(40, 0, SCREENWIDTH-80, cancelButton.frame.origin.y+cancelButton.frame.size.height+20);
    subBGView.center=self.superview.center;

}

- (void)menuOnclick:(UIButton*)button{
    UILabel *label=[[button subviews]firstObject];
    if (button.selected==YES) {
        button.backgroundColor=MAINWHITECOLOR;
        label.textColor=GREENCOLOR;
        button.selected=NO;
        [choiceArray removeObject:label.text];
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [choiceArray addObject:label.text];
    }
}

- (void)cancel{
    [self removeFromSuperview];
    [subBGView removeFromSuperview];
    [self.delegate cancelCheckboxView];
}

- (void)sureChoice{
    if (choiceArray.count>0) {
        NSString *choiceString=@"";
        for (NSString *string in choiceArray) {
            if (choiceString.length==0) {
                choiceString=string;
            }else{
                choiceString=[NSString stringWithFormat:@"%@,%@",choiceString,string];
            }
        }
        [self.delegate sureBackOption:choiceString];
    }
    [self removeFromSuperview];
    [subBGView removeFromSuperview];
}

@end
