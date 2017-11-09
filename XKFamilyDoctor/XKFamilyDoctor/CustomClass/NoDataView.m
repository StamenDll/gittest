//
//  NoDataView.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    UIImageView *noDataImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-47)/2, 0, 47, 47)];
    noDataImageView.image=[UIImage imageNamed:@"no-advise"];
    [self addSubview:noDataImageView];
    
    UILabel *noDataLabel=[self addLabel:CGRectMake(0,63, SCREENWIDTH, 20) andText:@"暂无数据信息" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
    [self addSubview:noDataLabel];
}

- (void)showNoDataView{
    self.hidden=NO;
}

- (void)hiddenNoDataView{
    self.hidden=YES;
}

@end
