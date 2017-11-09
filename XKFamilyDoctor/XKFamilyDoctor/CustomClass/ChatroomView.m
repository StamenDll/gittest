//
//  ChatroomView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatroomView.h"

@implementation ChatroomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-50)];
    mainScrollView.delegate=self;
    [self addSubview:mainScrollView];
    
    writeBAckView=[[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-49, self.frame.size.width, 49)];
    writeBAckView.backgroundColor=[UIColor whiteColor];
    [self addSubview:writeBAckView];
    
    [self addLineLabel:CGRectMake(0, 0, self.frame.size.width, 0.5) andColor:[UIColor grayColor] andBackView:writeBAckView];
    
    UIButton *yyButton=[self addButton:CGRectMake(15,7, 34, 34) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    [yyButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [writeBAckView addSubview:yyButton];
    
    newsTextView=[UITextView new];
    newsTextView.font=[UIFont systemFontOfSize:16];
    newsTextView.delegate=self;
    newsTextView.returnKeyType=UIReturnKeySend;
    [writeBAckView addSubview:newsTextView];
    
    [newsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(62);
        make.bottom.mas_equalTo(-6);
        make.width.mas_equalTo(SCREENWIDTH-156);
    }];
    
    UIImageView *lineImageView=[UIImageView new];
    lineImageView.image=[UIImage imageNamed:@"rec_8"];
    [writeBAckView addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(writeBAckView.mas_bottom).offset(-8);
        make.left.equalTo(writeBAckView.mas_left).offset(62);
        make.right.equalTo(writeBAckView.mas_right).offset(-62);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *bqButton=[self addButton:CGRectMake(SCREENWIDTH-94,12, 24, 24) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    [bqButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [writeBAckView addSubview:bqButton];
    
    UIButton *addButton=[self addButton:CGRectMake(SCREENWIDTH-49,7,34,34) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [writeBAckView addSubview:addButton];
}

- (void)addSubViews:(NSMutableArray*)dataArray{
    NSMutableArray  *chatViewArray=[[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *newsDic=[dataArray objectAtIndex:i];
        NSString *userID=[newsDic objectForKey:@"id"];
        NSString *userName=[newsDic objectForKey:@"name"];
        NSString *userNews=[newsDic objectForKey:@"news"];
        NSString *userTime=[newsDic objectForKey:@"time"];
        
        UIView *chatBackView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width,100)];
        [mainScrollView addSubview:chatBackView];
        
        if (![userID isEqualToString:@"1"]) {
            UILabel *timeLabel=[self addLabel:CGRectMake((self.frame.size.width-130)/2, 5, 110, 20) andText:userTime andFont:12 andColor:[UIColor grayColor] andAlignment:1];
            timeLabel.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            [timeLabel.layer setCornerRadius:10];
            timeLabel.layer.masksToBounds=YES;
            [chatBackView addSubview:timeLabel];
            
            UIImageView *userImageView=[[UIImageView alloc]init];
            userImageView.frame=CGRectMake(10,30,40,40);
            userImageView.image=[UIImage imageNamed:@"1.jpg"];
            userImageView.layer.masksToBounds=YES;
            [userImageView.layer setCornerRadius:20];
            [chatBackView addSubview:userImageView];
            
            UILabel *nameLabel=[self addLabel:CGRectMake(60,30,self.frame.size.width-70, 20) andText:userName andFont:12 andColor:[UIColor grayColor] andAlignment:0];
            [chatBackView addSubview:nameLabel];
            
            UIImage* image =[UIImage imageNamed:@"newsBackImage1"];
            UIImageView* newsBackView = [[UIImageView alloc]initWithFrame:CGRectMake(60,60,50,150)];
            [newsBackView setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch]];
            newsBackView.userInteractionEnabled=YES;
            [chatBackView addSubview:newsBackView];
            
            UILabel *newsLabel=[self addLabel:CGRectMake(15,10,self.frame.size.width-95,0) andText:userNews andFont:12 andColor:nil andAlignment:0];
            newsLabel.numberOfLines=0;
            [newsLabel sizeToFit];
            [newsBackView addSubview:newsLabel];
            
            newsBackView.frame=CGRectMake(55,50, newsLabel.frame.size.width+25,newsLabel.frame.size.height+20);
            chatBackView.frame=CGRectMake(0,0,self.frame.size.width,newsBackView.frame.size.height+70);
        }else{
            UILabel *timeLabel=[self addLabel:CGRectMake((self.frame.size.width-130)/2, 5, 110, 20) andText:userTime andFont:12  andColor:[UIColor grayColor] andAlignment:1];
            timeLabel.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            [timeLabel.layer setCornerRadius:10];
            timeLabel.layer.masksToBounds=YES;
            [chatBackView addSubview:timeLabel];
            
            UIImageView *userImageView=[[UIImageView alloc]init];
            userImageView.frame=CGRectMake(self.frame.size.width-50, 30,40,40);
            userImageView.image=[UIImage imageNamed:@"2.jpg"];
            userImageView.layer.masksToBounds=YES;
            [userImageView.layer setCornerRadius:20];
            [chatBackView addSubview:userImageView];
            
            UILabel *nameLabel=[self addLabel:CGRectMake(10,30,self.frame.size.width-60, 20) andText:userName andFont:12 andColor:[UIColor grayColor] andAlignment:2];
            [chatBackView addSubview:nameLabel];
            
            UIImage* image =[UIImage imageNamed:@"newsBackImage2"];
            UIImageView* newsBackView = [[UIImageView alloc]initWithFrame:CGRectMake(80,50,0,0)];
            [newsBackView setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch]];
            [chatBackView addSubview:newsBackView];
            
            UILabel *newsLabel=[self addLabel:CGRectMake(10,10,self.frame.size.width-95,0) andText:userNews andFont:12 andColor:nil andAlignment:0];
            newsLabel.numberOfLines=0;
            [newsLabel sizeToFit];
            [newsBackView addSubview:newsLabel];
            
            newsBackView.frame=CGRectMake(self.frame.size.width-newsLabel.frame.size.width-75,50, newsLabel.frame.size.width+25, newsLabel.frame.size.height+20);
            chatBackView.frame=CGRectMake(0,0,self.frame.size.width,newsBackView.frame.size.height+70);
        }
        [chatViewArray addObject:chatBackView];
        if (i>0) {
            UIView *upChatView=[chatViewArray objectAtIndex:i-1];
            chatBackView.frame=CGRectMake(0, upChatView.frame.origin.y+upChatView.frame.size.height+20,self.frame.size.width , chatBackView.frame.size.height);
        }
        
        mainScrollView.contentSize=CGSizeMake(self.frame.size.width,chatBackView.frame.origin.y+chatBackView.frame.size.height+10);
    }
    
    if (mainScrollView.contentSize.height>self.frame.size.height-50) {
        mainScrollView.contentOffset=CGPointMake(0,mainScrollView.contentSize.height-mainScrollView.frame.size.height);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self sendNews];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(self.frame.size.width-20, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(writeBAckView.frame);
    if (textView.contentSize.height<49) {
        writeBAckView.frame = CGRectMake(0, y-49,self.frame.size.width,49);
    }else if(curheight <40){
        writeBAckView.frame = CGRectMake(0, y-textView.contentSize.height-10, self.frame.size.width,textView.contentSize.height+10);
    }else{
        return;
    }
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)sendNews{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newsString = [newsTextView.text stringByTrimmingCharactersInSet:set];
    if (newsString.length==0) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }else{
        UIView *chatBackView=[[UIView alloc]initWithFrame:CGRectMake(0,mainScrollView.contentSize.height, self.frame.size.width,100)];
        [mainScrollView addSubview:chatBackView];
        
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        UILabel *timeLabel=[self addLabel:CGRectMake((self.frame.size.width-130)/2, 5, 110, 20) andText:locationString andFont:12  andColor:[UIColor grayColor] andAlignment:1];
        timeLabel.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [timeLabel.layer setCornerRadius:10];
        timeLabel.layer.masksToBounds=YES;
        [chatBackView addSubview:timeLabel];
        
        UIImageView *userImageView=[[UIImageView alloc]init];
        userImageView.frame=CGRectMake(self.frame.size.width-50, 30,40,40);
        userImageView.image=[UIImage imageNamed:@"2.jpg"];
        userImageView.layer.masksToBounds=YES;
        [userImageView.layer setCornerRadius:20];
        [chatBackView addSubview:userImageView];
        
        //        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10,30,self.frame.size.width-60, 20) andText:@"我" andFont:12 andColor:[UIColor grayColor] andAlignment:2];
        [chatBackView addSubview:nameLabel];
        
        UIImage* image =[UIImage imageNamed:@"newsBackImage2"];
        UIImageView* newsBackView = [[UIImageView alloc]initWithFrame:CGRectMake(80,50,0,0)];
        [newsBackView setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch]];
        [chatBackView addSubview:newsBackView];
        
        UILabel *newsLabel=[self addLabel:CGRectMake(10,10,self.frame.size.width-95,0) andText:newsTextView.text andFont:12 andColor:nil andAlignment:0];
        newsLabel.numberOfLines=0;
        [newsLabel sizeToFit];
        [newsBackView addSubview:newsLabel];
        
        newsBackView.frame=CGRectMake(self.frame.size.width-newsLabel.frame.size.width-75,50, newsLabel.frame.size.width+25, newsLabel.frame.size.height+20);
        chatBackView.frame=CGRectMake(0,mainScrollView.contentSize.height,self.frame.size.width,newsBackView.frame.size.height+70);
        
        mainScrollView.contentSize=CGSizeMake(self.frame.size.width, chatBackView.frame.origin.y+chatBackView.frame.size.height+10);
        if (mainScrollView.contentSize.height>writeBAckView.frame.origin.y) {
            mainScrollView.contentOffset=CGPointMake(0,mainScrollView.contentSize.height-mainScrollView.frame.size.height);
        }
        newsTextView.text=nil;
        CGFloat y = CGRectGetMaxY(writeBAckView.frame);
        writeBAckView.frame = CGRectMake(0, y-newsTextView.contentSize.height-10, self.frame.size.width,newsTextView.contentSize.height+10);
    }
}
//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    writeBAckView.frame=CGRectMake(0,self.frame.size.height-size.height-writeBAckView.frame.size.height, self.frame.size.width, writeBAckView.frame.size.height);
    mainScrollView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height-size.height-50);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    writeBAckView.frame=CGRectMake(0,self.frame.size.height-writeBAckView.frame.size.height, self.frame.size.width,writeBAckView.frame.size.height);
    mainScrollView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height-50);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView==mainScrollView) {
        [newsTextView resignFirstResponder];
    }
}


@end
