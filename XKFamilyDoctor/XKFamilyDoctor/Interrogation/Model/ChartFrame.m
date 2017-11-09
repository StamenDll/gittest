//
//  ChartFrame.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//
#import "ChartFrame.h"
#import <AVFoundation/AVAsset.h>
#import "ChatView.h"
@implementation ChartFrame

-(void)setChartMessage:(ChatItem *)chartMessage
{
    _chartMessage=chartMessage;
    
    UILabel *newsLabel=[UILabel new];
    newsLabel.frame=CGRectMake(10,10,SCREENWIDTH-140,0);
    newsLabel.text=chartMessage.content;
    newsLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    newsLabel.numberOfLines=0;
    [newsLabel sizeToFit];
    
    if ([chartMessage.from isEqualToString:CHATCODE]) {
        self.iconRect=CGRectMake(SCREENWIDTH-50,40,40,40);
        if ([chartMessage.type isEqualToString:@"chat"]||[chartMessage.type isEqualToString:@"单聊"]) {
            if ([chartMessage.contentType isEqualToString:@"文本"]||[chartMessage.contentType isEqualToString:@"txt"]) {
                self.chartViewRect=CGRectMake(SCREENWIDTH-newsLabel.frame.size.width-75,40,newsLabel.frame.size.width+20,newsLabel.frame.size.height+20);
            }else if ([chartMessage.contentType isEqualToString:@"图片"]||[chartMessage.contentType isEqualToString:@"img"]){
                UIImageView *newsImageView=[self setImage:chartMessage.content];
                self.chartViewRect=CGRectMake(SCREENWIDTH-newsImageView.frame.size.width-75,40,newsImageView.frame.size.width+25,newsImageView.frame.size.height);
            }else{
                if (self.chartMessage.yyLength<10) {
                    self.chartViewRect=CGRectMake(SCREENWIDTH-140,40,80,40);
                }else if (self.chartMessage.yyLength<20) {
                    self.chartViewRect=CGRectMake(SCREENWIDTH-(140+10*(self.chartMessage.yyLength-10)),40,80+10*(self.chartMessage.yyLength-10),40);
                }else{
                    self.chartViewRect=CGRectMake(SCREENWIDTH-220,40,160,40);
                }
            }
        }
        else{
            if ([chartMessage.contentType isEqualToString:@"文本"]||[chartMessage.contentType isEqualToString:@"txt"]) {
                self.chartViewRect=CGRectMake(SCREENWIDTH-newsLabel.frame.size.width-75,65,newsLabel.frame.size.width+20,newsLabel.frame.size.height+20);
            }else if ([chartMessage.contentType isEqualToString:@"图片"]||[chartMessage.contentType isEqualToString:@"img"]){
                UIImageView *newsImageView=[self setImage:chartMessage.content];
                self.chartViewRect=CGRectMake(SCREENWIDTH-newsImageView.frame.size.width-75,65,newsImageView.frame.size.width+25,newsImageView.frame.size.height+20);
            }
            else{
                if (self.chartMessage.yyLength<10) {
                    self.chartViewRect=CGRectMake(SCREENWIDTH-130,65,80,40);
                }else if (self.chartMessage.yyLength<20) {
                    self.chartViewRect=CGRectMake(SCREENWIDTH-(130+10*(self.chartMessage.yyLength-10)),65,80+10*(self.chartMessage.yyLength-10),40);
                }else{
                    self.chartViewRect=CGRectMake(SCREENWIDTH-230,65,180,40);
                }
            }
        }
    }
    else{
        self.iconRect=CGRectMake(15,40, 40, 40);
        if ([chartMessage.type isEqualToString:@"chat"]||[chartMessage.type isEqualToString:@"单聊"]) {
            if ([chartMessage.contentType isEqualToString:@"文本"]||[chartMessage.contentType isEqualToString:@"txt"]) {
                self.chartViewRect=CGRectMake(60,40,newsLabel.frame.origin.x+newsLabel.frame.size.width+10,newsLabel.frame.origin.y+newsLabel.frame.size.height+10);
            }else if ([chartMessage.contentType isEqualToString:@"图片"]||[chartMessage.contentType isEqualToString:@"img"]){
                UIImageView *newsImageView=[self setImage:chartMessage.content];
                self.chartViewRect=CGRectMake(60,40,newsImageView.frame.size.width+25,newsImageView.frame.size.height+20);
            }else{
                if (self.chartMessage.yyLength<10) {
                    self.chartViewRect=CGRectMake(60,40,80,40);
                }else if (self.chartMessage.yyLength<20) {
                    self.chartViewRect=CGRectMake(60,40,80+10*(self.chartMessage.yyLength-10),40);
                }else{
                    self.chartViewRect=CGRectMake(60,40,155,40);
                }
            }
            
        }else{
            if ([chartMessage.contentType isEqualToString:@"文本"]||[chartMessage.contentType isEqualToString:@"txt"]) {
                self.chartViewRect=CGRectMake(60,60,newsLabel.frame.origin.x+newsLabel.frame.size.width+10,newsLabel.frame.origin.y+newsLabel.frame.size.height+10);
            }else if ([chartMessage.contentType isEqualToString:@"图片"]||[chartMessage.contentType isEqualToString:@"img"]){
                UIImageView *newsImageView=[self setImage:chartMessage.content];
                self.chartViewRect=CGRectMake(60,60,newsImageView.frame.origin.x+newsImageView.frame.size.width+15,newsImageView.frame.origin.y+newsImageView.frame.size.height+10);
            }else{
                if (self.chartMessage.yyLength<10) {
                    self.chartViewRect=CGRectMake(60,60,80,40);
                }else if (self.chartMessage.yyLength<20) {
                    self.chartViewRect=CGRectMake(60,60,80+10*(self.chartMessage.yyLength-10),40);
                }else{
                    self.chartViewRect=CGRectMake(60,60,155,40);
                }
            }
        }
    }
    self.cellHeight=MAX(self.chartViewRect.origin.y+self.chartViewRect.size.height+5,self.iconRect.origin.y+self.iconRect.size.height+5);
}

- (UIImageView*)setImage:(NSString*)imageString{
    UIImageView *img = [[UIImageView alloc]init];
    //    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,imageString]];
    //    NSData *data=[NSData dataWithContentsOfURL:url];
    //    UIImage *imageName=[UIImage imageWithData:data];
    //    if (imageName.size.height/imageName.size.width>1&&imageName.size.height>200) {
    //        img.frame=CGRectMake(10, 10,imageName.size.width/(imageName.size.height/200), 200);
    //    }else if (img.image.size.height/imageName.size.width<1&&imageName.size.width>150){
    //        img.frame=CGRectMake(10, 10,150, imageName.size.height/(imageName.size.width/150));
    //    }else{
    //        img.frame=CGRectMake(10, 10,imageName.size.width,imageName.size.height);
    //    }
    img.frame=CGRectMake(10, 10, 150, 150);
    return img;
}

@end
