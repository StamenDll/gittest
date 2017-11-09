//
//  MyTabBarController.m
//  CH999
//
//  Created by LIUSHAO WEN on 14-6-23.
//  Copyright (c) 2014年 ch999.com. All rights reserved.
//

#import "MyTabBarController.h"
//#import "LogViewController.h"
#define kTabBarHeight 49.0f
static MyTabBarController *myTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (MyTabBarController *)myTabBarController
{
    return myTabBarController;
}

@end
@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myTabBarController=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.hidden=YES;
    
    self.mainBackView=[[UIView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-50, SCREENWIDTH,50)];
    self.mainBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.mainBackView];
    
    NSArray *tempArray=nil;
    NSArray *selecteArray=nil;
    NSArray *nameArray=nil;
    tempArray=[NSArray arrayWithObjects:@"business",@"personal",nil];
    selecteArray=[NSArray arrayWithObjects:@"business_",@"personal_",nil];
    nameArray=[[NSArray alloc]initWithObjects:@"业务入口",@"个人信息",nil];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setExclusiveTouch :YES];
        [button setImage:[UIImage imageNamed:[tempArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.imageEdgeInsets=UIEdgeInsetsMake(5,(SCREENWIDTH/2-25)/2,20,(SCREENWIDTH/2-25)/2);
        button.tag=10000+i;
        [button setImage:[UIImage imageNamed:[selecteArray objectAtIndex:i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:[selecteArray objectAtIndex:i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(self.view.bounds.size.width/2*i, 0,self.view.bounds.size.width/2,50);
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, button.frame.size.width, 20)];
        nameLabel.text=[nameArray objectAtIndex:i];
        nameLabel.textColor=TEXTCOLOR;
        nameLabel.font=[UIFont fontWithName:FONTTYPEME size:10];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [button addSubview:nameLabel];
        [self.mainBackView addSubview:button];
        if (i==0) {
            button.selected=YES;
            nameLabel.textColor=GREENCOLOR;
            lastButton=button;
        }
    }
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.mainBackView addSubview:lineLabel];
}



- (void)btnClick:(UIButton*)button{
    if (lastButton!=button) {
        UILabel *label=[[button subviews] lastObject];
        label.textColor=GREENCOLOR;
        
        UILabel *lastLabel=[[lastButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
        
        self.selectedIndex=button.tag-10000;
        self.lastSelect=button.tag-10000;
        lastButton.selected=NO;
        lastButton=button;
        button.selected=YES;
    }
}

- (UILabel*)makeLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)ali{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.font=[UIFont systemFontOfSize:font];
    label.textColor=color;
    label.textAlignment=ali;
    return label;
}

- (void)hidesTabBar{
    [UIView beginAnimations:@"pop" context:nil];
    [UIView setAnimationDuration:0.1];
    self.mainBackView.frame=CGRectMake(0, SCREENHEIGHT,SCREENWIDTH, 50);
    [UIView commitAnimations];
}

- (void)showTabBar{
    [UIView beginAnimations:@"pop" context:nil];
    [UIView setAnimationDuration:0.1];
    self.mainBackView.frame=CGRectMake(0,SCREENHEIGHT-50,SCREENWIDTH, 50);
    [UIView commitAnimations];
}

- (void)makeButtonTextColor:(NSInteger)count{
    UIButton *button=(UIButton*)[self.view viewWithTag:10000+count];
    self.selectedIndex=count;
    self.lastSelect=count;
    lastButton.backgroundColor=[UIColor blackColor];
    lastButton.selected=NO;
    button.backgroundColor=[UIColor colorWithRed:9.0/255.0 green:157.0/255.0 blue:228.0/255.0 alpha:1];
    button.selected=YES;
    lastButton=button;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
