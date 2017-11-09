//
//  PutQuestionTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PutQuestionTableViewCell.h"

@implementation PutQuestionTableViewCell

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
    self.mainImageView.backgroundColor=GREENCOLOR;
     [self.contentView addSubview:self.mainImageView];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.nameLabel.textColor=TEXTCOLORG;
     [self.contentView addSubview:self.nameLabel];

    
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.timeLabel.textColor=TEXTCOLORG;
    self.timeLabel.textAlignment=2;
     [self.contentView addSubview:self.timeLabel];

    self.titleLabel=[UILabel new];
    self.titleLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.titleLabel.textColor=TEXTCOLOR;
     [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel=[UILabel new];
    self.contentLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.contentLabel.textColor=TEXTCOLORDG;
     [self.contentView addSubview:self.contentLabel];
    
    self.contentImageView1=[UIImageView new];
    self.contentImageView1.contentMode=UIViewContentModeScaleAspectFill;
    self.contentImageView1.clipsToBounds =YES;
    [self.contentView addSubview:self.contentImageView1];
    
    self.contentImageView2=[UIImageView new];
    self.contentImageView2.contentMode=UIViewContentModeScaleAspectFill;
    self.contentImageView2.clipsToBounds =YES;
    [self.contentView addSubview:self.contentImageView2];
    
    self.commentButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.commentButton];
    
    self.cCountLabel=[UILabel new];
    self.cCountLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.cCountLabel.textColor=TEXTCOLORDG;
    self.cCountLabel.textAlignment=2;
    [self.commentButton addSubview:self.cCountLabel];
    
    self.praiseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.praiseButton];
    
    self.pCountLabel=[UILabel new];
    self.pCountLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.pCountLabel.textColor=TEXTCOLORDG;
    self.pCountLabel.textAlignment=2;
    [self.praiseButton addSubview:self.pCountLabel];
}

- (void)setMessageFrame:(PutQuestionFrame*)model{
    [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    
    UILabel *lineLabelO=[UILabel new];
    lineLabelO.backgroundColor=LINECOLOR;
    [self.BGView addSubview:lineLabelO];
    [lineLabelO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.BGView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *lineLabelT=[UILabel new];
    lineLabelT.backgroundColor=LINECOLOR;
    [self.BGView addSubview:lineLabelT];
    [lineLabelT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.BGView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.width.mas_equalTo(30);
    }];
    [self.mainImageView.layer setCornerRadius:15];
    self.mainImageView.clipsToBounds=YES;
//    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.questionMessage.LHeadPic]] placeholderImage:USERDEFAULTPIC];
    
    self.nameLabel.text=model.questionMessage.LSenderName;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.mainImageView.mas_right).offset(7);
        make.right.equalTo(self.contentView.mas_right).offset(-125);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLabel.text=[self getSubTime:model.questionMessage.LWTime andFormat:@"yyyy-MM-dd"];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];

    self.titleLabel.text=[self changeString:model.questionMessage.LTitle andType:@"in"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainImageView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.contentLabel.text=[self changeString:model.questionMessage.LDetail andType:@"in"];
    self.contentLabel.numberOfLines=3;
    [self.contentLabel sizeToFit];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    

    if (model.questionMessage.LPic1.length==0) {
        self.contentImageView1.hidden=YES;
    }else{
        self.contentImageView1.hidden=NO;
//        [self.contentImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.questionMessage.LPic1]] placeholderImage:[UIImage imageNamed:@""]];
        [self.contentImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentLabel);
            make.height.width.mas_equalTo((SCREENWIDTH-40)/2);
        }];
    }
    
    if (model.questionMessage.LPic1.length==0) {
        self.contentImageView1.hidden=YES;
    }else{
        self.contentImageView1.hidden=NO;
//        [self.contentImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.questionMessage.LPic1]] placeholderImage:[UIImage imageNamed:@""]];
        [self.contentImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentLabel);
            make.height.width.mas_equalTo((SCREENWIDTH-40)/2);
        }];
    }
    
    if (model.questionMessage.LPic2.length==0) {
        self.contentImageView2.hidden=YES;
    }else{
        self.contentImageView2.hidden=NO;
//        [self.contentImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,model.questionMessage.LPic2]] placeholderImage:[UIImage imageNamed:@""]];
        [self.contentImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentImageView1.mas_right).offset(10);
            make.height.width.mas_equalTo((SCREENWIDTH-40)/2);
        }];
    }
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView.mas_bottom).offset(-40);
        make.left.equalTo(self.contentLabel);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(70);
    }];
    [self.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.commentButton.imageEdgeInsets=UIEdgeInsetsMake(13, 55, 12, 0);
    
    [self.cCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentButton.mas_top).offset(10);
        make.left.equalTo(self.commentButton);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    self.cCountLabel.text=[NSString stringWithFormat:@"%d",model.questionMessage.LAnswerNum];


    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView.mas_bottom).offset(-40);
        make.left.equalTo(self.commentButton.mas_right);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(70);
    }];
    [self.praiseButton setImage:[UIImage imageNamed:@"collect_q"] forState:UIControlStateNormal];
    self.praiseButton.imageEdgeInsets=UIEdgeInsetsMake(13, 55, 12, 0);
    
    [self.pCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.praiseButton.mas_top).offset(10);
        make.left.equalTo(self.praiseButton);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    self.pCountLabel.text=[NSString stringWithFormat:@"%d",model.questionMessage.LStoreNum];
    
    
}
@end
