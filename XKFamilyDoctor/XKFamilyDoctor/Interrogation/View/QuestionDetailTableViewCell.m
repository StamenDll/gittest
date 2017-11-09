//
//  QuestionDetailTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "QuestionDetailTableViewCell.h"

@implementation QuestionDetailTableViewCell

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
    self.contentView.backgroundColor=BGGRAYCOLOR;
    
    self.BGView=[UIView new];
    self.BGView.backgroundColor=MAINWHITECOLOR;
    [self.contentView addSubview:self.BGView];
    
    self.mainImageView=[UIImageView new];
    [self.BGView addSubview:self.mainImageView];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.nameLabel.textColor=TEXTCOLORG;
    [self.BGView addSubview:self.nameLabel];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.timeLabel.textColor=TEXTCOLORG;
    self.timeLabel.textAlignment=2;
    [self.BGView addSubview:self.timeLabel];
    
    self.contentLabel=[UILabel new];
    self.contentLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.contentLabel.textColor=TEXTCOLORDG;
    [self.BGView addSubview:self.contentLabel];
    
    self.commentImageView=[UIImageView new];
    self.commentImageView.userInteractionEnabled=YES;
    [self.BGView addSubview:self.commentImageView];
    
    self.replyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.BGView addSubview:self.replyButton];
    
    self.replyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.replyLabel.text=@"回复";
    self.replyLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.replyLabel.textColor=TEXTCOLORSDG;
    self.replyLabel.numberOfLines=0;
    [self.replyLabel sizeToFit];
    [self.replyButton addSubview:self.replyLabel];
    
    self.lineLabelO=[UILabel new];
    self.lineLabelO.backgroundColor=LINECOLOR;
    [self.BGView addSubview:self.lineLabelO];
    
    self.lineLabelT=[UILabel new];
    self.lineLabelT.backgroundColor=LINECOLOR;
    [self.BGView addSubview:self.lineLabelT];
    
}

- (void)setAnswerViewFrame:(QuestiondetailFrame *)model{
    self.BGView.frame=CGRectMake(0, 10, SCREENWIDTH, model.cellHeight-10);
    
    self.lineLabelO.frame=CGRectMake(0, 0, SCREENWIDTH, 0.5);
    self.lineLabelT.frame=CGRectMake(0, self.BGView.frame.size.height, SCREENWIDTH, 0.5);
    
    self.mainImageView.frame=CGRectMake(15, 10, 30, 30);
    self.mainImageView.clipsToBounds=YES;
    [self.mainImageView.layer setCornerRadius:15];
//    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.questionAnswer.LHeadPic]] placeholderImage:USERDEFAULTPIC];

    self.nameLabel.text=[NSString stringWithFormat:@"%@(%d楼)",model.questionAnswer.LNickname,model.questionAnswer.rowid];
    self.nameLabel.frame=CGRectMake(52, 15, SCREENWIDTH-120, 20);
    
    self.timeLabel.text=[self getSubTime:model.questionAnswer.LWTime andFormat:@"yyyy-MM-dd"];
    self.timeLabel.frame=CGRectMake(SCREENWIDTH-115, 15, 100, 20);
    
    self.contentLabel.frame=CGRectMake(15, 50, SCREENWIDTH-30,0);
    self.contentLabel.text=[self changeString:model.questionAnswer.LDetail andType:@"in"];
    self.contentLabel.numberOfLines=0;
    [self.contentLabel sizeToFit];
    
    if (model.questionAnswer.LPic1.length>0) {
        self.commentImageView.frame=CGRectMake(15, self.contentLabel.frame.size.height+60, 100, 100);
        self.commentImageView.hidden=NO;
//        [self.commentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.questionAnswer.LPic1]] placeholderImage:[UIImage imageNamed:@""]];
    }else{
       self.commentImageView.hidden=YES;
    }
    
    self.replyLabel.frame=CGRectMake(100-self.replyLabel.frame.size.width, 10, self.replyLabel.frame.size.width, 20);
    
    self.replyButton.frame=CGRectMake(SCREENWIDTH-115, self.BGView.frame.size.height-40, 100, 40);
    [self.replyButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.replyButton.imageEdgeInsets=UIEdgeInsetsMake(13,100-self.replyLabel.frame.size.width-20, 12, self.replyLabel.frame.size.width+5);
}

@end
