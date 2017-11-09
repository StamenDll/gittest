//
//  FeedbackViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"意见反馈"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self creatUI];
}

- (void)addLeftButtonItem{
    UIButton *lButton=[UIButton buttonWithType:UIButtonTypeCustom];
    lButton.frame=CGRectMake(0, 0,40,44);
    [lButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    lButton.imageEdgeInsets=UIEdgeInsetsMake(13,0,13,22);
    
    UILabel *cancelLabel=[self addLabel:CGRectMake(0,12, 40, 20) andText:@"取消" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:0];
    [lButton addSubview:cancelLabel];
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
    self.navigationItem.leftBarButtonItem=lItem;
    
}

- (void)addRightButtonItem{
    UIButton *lButton=[UIButton buttonWithType:UIButtonTypeCustom];
    lButton.frame=CGRectMake(0, 0,40,44);
    [lButton addTarget:self action:@selector(sureSend) forControlEvents:UIControlEventTouchUpInside];
    lButton.imageEdgeInsets=UIEdgeInsetsMake(13,0,13,22);
    
    UILabel *cancelLabel=[self addLabel:CGRectMake(0,12, 40, 20) andText:@"发送" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:2];
    [lButton addSubview:cancelLabel];
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
    self.navigationItem.rightBarButtonItem=lItem;
    
}

- (void)sureSend{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *pwString = [feedbackTextView.text stringByTrimmingCharactersInSet:set];
    if (pwString.length==0) {
        [self showSimplePromptBox:self andMesage:@"反馈内容不能为空!"];
    }else{
        [self sendRequest:@"Feedback" andPath:excuteURL andSqlParameter:[self changeString:feedbackTextView.text andType:@"out"] and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        [self showPromptBox:self andMesage:@"提交成功，感谢您的反馈，您的建议是我们改进的最大动力！" andSel:@selector(popViewController)];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    feedbackTextView=[[UITextView alloc]initWithFrame:CGRectMake(10,75, SCREENWIDTH-30,300)];
    feedbackTextView.font=[UIFont systemFontOfSize:MIDDLEFONT];
    feedbackTextView.delegate=self;
    [self.view addSubview:feedbackTextView];
    
    adviceLabel=[self addLabel:CGRectMake(15,80, SCREENWIDTH-30, 20) andText:@"感谢使用新康家庭医生，欢迎您留言给我们" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
    [self.view addSubview:adviceLabel];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        adviceLabel.hidden=YES;
    }else{
        adviceLabel.hidden=NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
