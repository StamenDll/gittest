//
//  ChatTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatTableViewCell.h"
@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCell];
    }
    return self;
}

- (void)createCell{
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.timeLabel.textColor=TEXTCOLORDG;
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    self.userImageView=[UIImageView new];
    self.userImageView.layer.masksToBounds=YES;
    [self.userImageView.layer setCornerRadius:20];
    [self.contentView addSubview:self.userImageView];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.nameLabel.textColor=TEXTCOLORDG;
    [self.contentView addSubview:self.nameLabel];
    
    self.newsBackView = [UIImageView new];
    self.newsBackView.backgroundColor=MAINWHITECOLOR;
    self.newsBackView.userInteractionEnabled=YES;
    [self.contentView addSubview:self.newsBackView];
    
    self.messageVoiceStatusImageView=[UIImageView new];
    self.messageVoiceStatusImageView.userInteractionEnabled=YES;
    [self.newsBackView addSubview:self.messageVoiceStatusImageView];
    
    self.yyTimeLabel=[UILabel new];
    self.yyTimeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.yyTimeLabel.textColor=MAINWHITECOLOR;
    self.yyTimeLabel.textAlignment=0;
    [self.newsBackView addSubview:self.yyTimeLabel];
    
    self.newsLabel=[UILabel new];
    self.newsLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.newsLabel.textColor=TEXTCOLOR;
    [self.newsBackView addSubview:self.newsLabel];
    
    self.newsImageView = [UIImageView new];
    self.newsImageView.userInteractionEnabled=YES;
    self.newsImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.newsImageView.clipsToBounds =YES;
    [self.newsBackView addSubview:self.newsImageView];
}

- (void)setMessageFrame:(ChartFrame*)model{
    self.timeLabel.frame=CGRectMake(0,10,SCREENWIDTH,20);
    self.timeLabel.text=model.chartMessage.timestamp;
    
    self.messageVoiceStatusImageView.frame=CGRectMake(model.chartViewRect.size.width-25,8,15,23);
    self.messageVoiceStatusImageView.image=[UIImage imageNamed:@"voice_w"];
    
    self.yyTimeLabel.text=[NSString stringWithFormat:@"%d″",model.chartMessage.yyLength];
    self.yyTimeLabel.frame=CGRectMake(5, 10, 30, 20);
    
    self.newsLabel.frame=CGRectMake(10,10,SCREENWIDTH-140,0);
    self.newsLabel.text=model.chartMessage.content;
    self.newsLabel.numberOfLines=0;
    [self.newsLabel sizeToFit];
    
    self.newsImageView.frame=CGRectMake(10,10,model.chartViewRect.size.width-25,model.chartViewRect.size.height-20);
    if ([model.chartMessage.contentType isEqualToString:@"文本"]||[model.chartMessage.contentType isEqualToString:@"txt"]) {
        self.newsImageView.hidden=YES;
        self.messageVoiceStatusImageView.hidden=YES;
        self.yyTimeLabel.hidden=YES;
        self.newsLabel.hidden=NO;
    }else if ([model.chartMessage.contentType isEqualToString:@"图片"]||[model.chartMessage.contentType isEqualToString:@"img"]){
        self.newsImageView.hidden=NO;
        self.messageVoiceStatusImageView.hidden=YES;
        self.yyTimeLabel.hidden=YES;
        self.newsLabel.hidden=YES;
        
    }else{
        self.newsImageView.hidden=YES;
        self.messageVoiceStatusImageView.hidden=NO;
        self.yyTimeLabel.hidden=NO;
        self.newsLabel.hidden=YES;
    }
    
    if (![model.chartMessage.from isEqualToString:CHATCODE]) {
        if ([model.chartMessage.contentType isEqualToString:@"文本"]||[model.chartMessage.contentType isEqualToString:@"txt"]) {
            self.newsLabel.frame=CGRectMake(13, 10, self.newsLabel.frame.size.width, self.newsLabel.frame.size.height);
        }else if ([model.chartMessage.contentType isEqualToString:@"图片"]||[model.chartMessage.contentType isEqualToString:@"img"]){
            self.newsImageView.frame=CGRectMake(15,10,model.chartViewRect.size.width-25,model.chartViewRect.size.height-20);
        }else if ([model.chartMessage.contentType isEqualToString:@"语音"]||[model.chartMessage.contentType isEqualToString:@"audio"]){
            self.messageVoiceStatusImageView.frame=CGRectMake(10,8,15,23);
            self.messageVoiceStatusImageView.image=[UIImage imageNamed:@"voice_g"];
            self.yyTimeLabel.frame=CGRectMake(model.chartViewRect.size.width-40, 10, 30, 20);
            self.yyTimeLabel.textColor=GREENCOLOR;
            self.yyTimeLabel.textAlignment=2;
        }
        self.userImageView.frame=CGRectMake(15,40, 40, 40);
//        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.chartMessage.fromFace]] placeholderImage:[UIImage imageNamed:@"user_default"]];
        
        UIImage* image =[UIImage imageNamed:@"chat_L"];
        [self.newsBackView setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(38, 20, 3, 20) resizingMode:UIImageResizingModeStretch]];
        self.nameLabel.text=model.chartMessage.fromName;
        if (![model.chartMessage.type isEqualToString:@"chat"]&&![model.chartMessage.type isEqualToString:@"单聊"]) {
            self.nameLabel.frame=CGRectMake(60, 40, SCREENWIDTH-70, 20);
            self.nameLabel.textAlignment=0;
        }
    }
    else{
        if ([model.chartMessage.contentType isEqualToString:@"文本"]||[model.chartMessage.contentType isEqualToString:@"txt"]) {
            self.newsLabel.frame=CGRectMake(7, 10, self.newsLabel.frame.size.width, self.newsLabel.frame.size.height);
        }else if ([model.chartMessage.contentType isEqualToString:@"语音"]||[model.chartMessage.contentType isEqualToString:@"audio"]){
            self.yyTimeLabel.textColor=MAINWHITECOLOR;
            self.yyTimeLabel.textAlignment=0;
        }
        self.userImageView.frame=CGRectMake(SCREENWIDTH-50,40,40,40);
//        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,HEADPIC]] placeholderImage:[UIImage imageNamed:@"user_default"]];
        UIImage* image =[UIImage imageNamed:@"chat_R"];
        [self.newsBackView setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(38, 20, 3, 20) resizingMode:UIImageResizingModeStretch]];
        self.nameLabel.text=model.chartMessage.fromName;
        
        if (![model.chartMessage.type isEqualToString:@"chat"]&&![model.chartMessage.type isEqualToString:@"单聊"]) {
            self.nameLabel.frame=CGRectMake(10, 40, SCREENWIDTH-70, 20);
            self.nameLabel.textAlignment=2;
        }
    }
    if (self.nameLabel.text.length==0) {
        self.nameLabel.text=@"新康用户";
    }
    self.newsBackView.frame=model.chartViewRect;
}

#pragma mark 时间戳转换
- (NSString*)setTime:(NSString*)timeSing{
    NSTimeInterval _interval=[timeSing doubleValue]/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate: date];
}

- (UIImageView *)messageVoiceStatusImageView {
    if (!_messageVoiceStatusImageView) {
        _messageVoiceStatusImageView = [[UIImageView alloc] init];
        _messageVoiceStatusImageView.image = [UIImage imageNamed:@"icon_voice_sender_3"] ;
        UIImage *image1 = [UIImage imageNamed:@"icon_voice_sender_1"];
        UIImage *image2 = [UIImage imageNamed:@"icon_voice_sender_2"];
        UIImage *image3 = [UIImage imageNamed:@"icon_voice_sender_3"];
        _messageVoiceStatusImageView.highlightedAnimationImages = @[image1,image2,image3];
        _messageVoiceStatusImageView.animationDuration = 1.5f;
        _messageVoiceStatusImageView.animationRepeatCount = NSUIntegerMax;
    }
    return _messageVoiceStatusImageView;
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

@end
