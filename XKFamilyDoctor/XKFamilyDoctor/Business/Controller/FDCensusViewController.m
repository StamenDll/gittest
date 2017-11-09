//
//  FDCensusViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FDCensusViewController.h"
#import "XKFamilyDoctor-Bridging-Header.h"
#import "CensusItem.h"
@interface FDCensusViewController ()<ChartViewDelegate>

@property(nonatomic,strong)BarChartView *barChartView;
@property(nonatomic,strong)PieChartView *pieChartView;

@end

@implementation FDCensusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:[NSString stringWithFormat:@"%@统计",self.whoPush]];
    self.view.backgroundColor=MAINWHITECOLOR;
    [self addLeftButtonItem];
    [self addRightButtonItem];
    mainDataArray=[NSMutableArray new];
    [self creatUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (rightMenuView) {
        [rightMenuView cancelChoiceView];
    }
}

- (void)addRightButtonItem{
    UIButton *rButton=[self addButton:CGRectMake(0, 0, 50, 30) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(addChangeView)];
    rightItemLabel=[self addLabel:CGRectMake(0, 5, 50, 20) andText:@"表格" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:2];
    [rButton addSubview:rightItemLabel];
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)addChangeView{
    rightMenuView=[[RightChoiceView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    rightMenuView.delegate=self;
    [self.navigationController.view addSubview:rightMenuView];
    [rightMenuView creatUI:@[@"表格",@"柱状图",@"饼图"]];
}

- (void)sureChoiceMenu:(NSString *)choiceMenu{
    if (![choiceMenu isEqualToString:rightItemLabel.text]) {
        
        CGContextRef context=UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        if ([choiceMenu isEqualToString:@"柱状图"]) {
            if (!barBGView) {
                barBGView=[self addSimpleBackView:CGRectMake(0, 230, SCREENWIDTH, SCREENHEIGHT-230) andColor:MAINWHITECOLOR];
                [self.view addSubview:barBGView];
                
                self.barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(10,0, SCREENWIDTH-20,SCREENHEIGHT-330)];
                self.barChartView.delegate = self;//设置代理
                self.barChartView.noDataText=@"暂无数据信息";
                [barBGView addSubview:self.barChartView];
                
                self.barChartView.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
                self.barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
                self.barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
                //    2.barChartView的交互设置
                
                self.barChartView.scaleYEnabled = NO;//取消Y轴缩放
                self.barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
                self.barChartView.dragEnabled = YES;//启用拖拽图表
                self.barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
                self.barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不
                self.barChartView.descriptionText = @"";
                
                
                ChartXAxis *xAxis = self.barChartView.xAxis;
                xAxis.axisLineWidth = 1;//设置X轴线宽
                xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
                xAxis.drawGridLinesEnabled = NO;//不绘制网格线
                xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
                xAxis.granularity = 1.0;
                self.barChartView.rightAxis.enabled = NO;
                
                ChartYAxis *leftAxis = self.barChartView.leftAxis;//获取左边Y轴
                leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
                leftAxis.inverted = NO;//是否将Y轴进行上下翻转
                leftAxis.axisLineWidth = 0.5;//Y轴线宽
                leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
                
                leftAxis.labelCount = 5;
                leftAxis.forceLabelsEnabled = NO;
                
                leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
                leftAxis.labelTextColor = [UIColor brownColor];//文字颜色
                leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
                
                
                leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
                leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
                leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
                
                UILabel *voiceLabel=[self addLabel:CGRectMake(10,self.barChartView.frame.origin.y+self.barChartView.frame.size.height+15,SCREENWIDTH-20, 20) andText:@"如数据重合,请双指缩放进行查看!" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:1];
                [barBGView addSubview:voiceLabel];
                
            }
            tableBGView.hidden=YES;
            piechartBGView.hidden=YES;
            barBGView.hidden=NO;
            self.barChartView.data=[self setData];
        }else if ([choiceMenu isEqualToString:@"表格"]){
            tableBGView.hidden=NO;
            piechartBGView.hidden=YES;
            barBGView.hidden=YES;
            [self addTableView:mainDataArray];
        }else if ([choiceMenu isEqualToString:@"饼图"]){
            if (!piechartBGView) {
                piechartBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 230, SCREENWIDTH, SCREENHEIGHT-230)];
                piechartBGView.backgroundColor=MAINWHITECOLOR;
                [self.view addSubview:piechartBGView];
                
                UILabel *totalCountLabel=[self addLabel:CGRectMake(10,0, SCREENWIDTH-20, 20) andText:@"" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:1];
                totalCountLabel.tag=101;
                [piechartBGView addSubview:totalCountLabel];
                
                self.pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake((SCREENWIDTH-250)/2,30, 250, 250)];
                self.pieChartView.backgroundColor = BGGRAYCOLOR;
                self.pieChartView.drawHoleEnabled = NO;
                self.pieChartView.delegate=self;
                self.pieChartView.backgroundColor=CLEARCOLOR;
                self.pieChartView.data=[self setPieChartViewData];
                self.pieChartView.descriptionText=@"";
                [piechartBGView addSubview:self.pieChartView];
                [self.pieChartView animateWithXAxisDuration:0.5 easingOption:0];
                
                UILabel *detailLabel=[self addLabel:CGRectMake(10,self.pieChartView.frame.origin.y+self.pieChartView.frame.size.height+20, SCREENWIDTH-20, 20) andText:@"" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:1];
                detailLabel.tag=102;
                [piechartBGView addSubview:detailLabel];
            }
            piechartBGView.hidden=NO;
            tableBGView.hidden=YES;
            barBGView.hidden=YES;
        }
        rightItemLabel.text=choiceMenu;
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
}


- (void)addTableView:(NSMutableArray*)array{
    if (array==mainDataArray) {
        UIButton *button=(UIButton*)[self.view viewWithTag:1002];
        [button setImage:[UIImage imageNamed:@"sortDefault"] forState:UIControlStateNormal];
        button.selected=NO;
    }
    for (UIView *subView in [tableBGView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            [subView removeFromSuperview];
        }
    }
    UIScrollView *BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,100,SCREENWIDTH, tableBGView.frame.size.height-100)];
    [tableBGView addSubview:BGScrollView];
    
    int sum=0;
    [self addLineLabel:CGRectMake(10,0, SCREENWIDTH-20,0.5) andColor:LINECOLOR andBackView:BGScrollView];
    for (int i=0; i<array.count; i++) {
        CensusItem *item=[array objectAtIndex:i];
        
        UILabel *subTextLabel=[self addLabel:CGRectMake(10,10+40*i, (SCREENWIDTH-20)/2, 20) andText:item.mText andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [BGScrollView addSubview:subTextLabel];
        
        UILabel *subValueLabel=[self addLabel:CGRectMake(10+(SCREENWIDTH-20)/2,10+40*i, (SCREENWIDTH-20)/2, 20) andText:[NSString stringWithFormat:@"%d",[item.mValue intValue]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [BGScrollView addSubview:subValueLabel];
        
        [self addLineLabel:CGRectMake(10, subTextLabel.frame.origin.y+30, SCREENWIDTH-20, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
        
        if (i==mainDataArray.count-1) {
            [self addLineLabel:CGRectMake(10,0, 0.5,subTextLabel.frame.origin.y+30) andColor:LINECOLOR andBackView:BGScrollView];
            [self addLineLabel:CGRectMake(10+(SCREENWIDTH-20)/2, 0,0.5,subTextLabel.frame.origin.y+30) andColor:LINECOLOR andBackView:BGScrollView];
            [self addLineLabel:CGRectMake(SCREENWIDTH-10,0, 0.5,subTextLabel.frame.origin.y+30) andColor:LINECOLOR andBackView:BGScrollView];
            
        }
        sum+=[item.mValue intValue];
        
        BGScrollView.contentSize=CGSizeMake(0,subTextLabel.frame.origin.y+70);
    }
    UILabel *totalCountLabel=(UILabel*)[self.view viewWithTag:1001];
    totalCountLabel.text=[NSString stringWithFormat:@"%d",sum];
}


- (void)choiceURL{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    NSArray *auth=[usd objectForKey:@"auth"];
    for (NSDictionary *dic in auth) {
        int auth=[[dic objectForKey:@"auth"] intValue];
        NSLog(@"=%@==========%@",[dic objectForKey:@"authname"],self.whoPush);
        if ([[dic objectForKey:@"authname"] rangeOfString:self.whoPush].location!=NSNotFound) {
            if ([self.whoPush isEqualToString:@"义诊"]||[self.whoPush isEqualToString:@"导诊"]) {
                switch (auth) {
                    case 1:
                        [self sendRequest:@"Census_FD_1" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"empkey"],self.bTime,self.eTime,self.whoPush] and:self];
                        break;
                    case 2:
                        [self sendRequest:@"Census_FD_2" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime,self.whoPush] and:self];
                        break;
                    case 3:
                        [self sendRequest:@"Census_FD_3" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"workorgkey"],self.bTime,self.eTime,self.whoPush] and:self];
                        break;
                    case 4:
                        [self sendRequest:@"Census_FD_4" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime,self.whoPush] and:self];
                        break;
                    default:
                        [self showSimplePromptBox:self andMesage:@"无法查询当前权限统计数据！"];
                        break;
                }
            }else if ([self.whoPush isEqualToString:@"家庭医生签约"]){
                switch (auth) {
                    case 1:
                        [self sendRequest:@"Census_Sign_1" andPath:queryURL andSqlParameter:@[[usd objectForKey:@"empkey"],self.bTime,self.eTime,] and:self];
                        break;
                    case 2:
                        [self sendRequest:@"Census_Sign_2" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime,] and:self];
                        break;
                    case 3:
                        [self sendRequest:@"Census_Sign_3" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime,[usd objectForKey:@"workorgkey"]] and:self];
                        break;
                    case 4:
                        [self sendRequest:@"Census_Sign_4" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime] and:self];
                        break;
                    default:
                        [self showSimplePromptBox:self andMesage:@"无法查询当前权限统计数据！"];
                        break;
                }
            }else if ([self.whoPush isEqualToString:@"建档"]){
                switch (auth) {
                    case 1:
                        [self sendRequest:@"Census_HF_1" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime,[usd objectForKey:@"gwuser"]] and:self];
                        break;
                    case 2:
                        [self sendRequest:@"Census_HF_2" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime,[usd objectForKey:@"workorgkey"]] and:self];
                        break;
                    case 3:
                        [self sendRequest:@"Census_HF_3" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime] and:self];
                        break;
                    case 4:
                        [self sendRequest:@"Census_HF_4" andPath:queryURL andSqlParameter:@[self.bTime,self.eTime] and:self];
                        break;
                    default:
                        [self showSimplePromptBox:self andMesage:@"无法查询当前权限统计数据！"];
                        break;
                }
            }
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if (dataArray.count>0) {
            [mainDataArray removeAllObjects];
            for (NSDictionary *dic in dataArray) {
                CensusItem *item=[RMMapper objectWithClass:[CensusItem class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
            if ([rightItemLabel.text isEqualToString:@"柱状图"]) {
                self.barChartView.data=[self setData];
            }else if ([rightItemLabel.text isEqualToString:@"表格"]){
                [self addTableView:mainDataArray];
            }else{
                self.pieChartView.data=[self setPieChartViewData];
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"暂无对应的数据信息！"];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    UILabel *qxLabel=[self addLabel:CGRectMake(10, NAVHEIGHT+15, SCREENWIDTH-20, 20) andText:@"" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:0];
    [self.view addSubview:qxLabel];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    NSArray *auth=[usd objectForKey:@"auth"];
    for (NSDictionary *dic in auth) {
        int auth=[[dic objectForKey:@"auth"] intValue];
        if ([[dic objectForKey:@"authname"] rangeOfString:self.whoPush].location!=NSNotFound) {
            if ([self.whoPush isEqualToString:@"建档"]){
                switch (auth) {
                    case 1:
                        qxLabel.attributedText=[self setString:@"当前统计权限：健教专干" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];
                        break;
                    case 2:
                        qxLabel.attributedText=[self setString:@"当前统计权限：社区负责人" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];
                        break;
                    case 3:
                        qxLabel.attributedText=[self setString:@"当前统计权限：健教专干负责人" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];                                                break;
                    default:
                        qxLabel.attributedText=[self setString:@"当前统计权限：其他" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];                                                break;
                }
            }else{
                switch (auth) {
                    case 1:
                        qxLabel.attributedText=[self setString:@"当前统计权限：健教专干" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];
                        break;
                    case 2:
                        qxLabel.attributedText=[self setString:@"当前统计权限：区域经理" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];                        break;
                    case 3:
                        qxLabel.attributedText=[self setString:@"当前统计权限：社区负责人" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];
                        break;
                    case 4:
                        qxLabel.attributedText=[self setString:@"当前统计权限：健教专干负责人" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];                                                break;
                    default:
                        qxLabel.attributedText=[self setString:@"当前统计权限：其他" andSubString:@"当前统计权限：" andDifColor:TEXTCOLOR];                                                break;
                }
            }
        }
    }
    
    UILabel *bTimeLabel=[self addLabel:CGRectMake(15, 120,70,20) andText:@"开始日期:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [self.view addSubview:bTimeLabel];
    
    bTimeButton=[self addButton:CGRectMake(90, 110,130, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceDate:)];
    bTimeButton.layer.borderColor=LINECOLOR.CGColor;
    bTimeButton.layer.borderWidth=0.5;
    [self.view addSubview:bTimeButton];
    
    UILabel *bTimeNLabel=[self addLabel:CGRectMake(0,10,130,20) andText:@"2017-06-01" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [bTimeButton addSubview:bTimeNLabel];
    self.bTime=@"2017-06-01";
    
    UILabel *eTimeLabel=[self addLabel:CGRectMake(15,170,70,20) andText:@"截止日期:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [self.view addSubview:eTimeLabel];
    
    eTimeButton=[self addButton:CGRectMake(90,160,130, 40) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceDate:)];
    eTimeButton.layer.borderColor=LINECOLOR.CGColor;
    eTimeButton.layer.borderWidth=0.5;
    [self.view addSubview:eTimeButton];
    
    UILabel *eTimeNLabel=[self addLabel:CGRectMake(0,10,130,20) andText:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [eTimeButton addSubview:eTimeNLabel];
    self.eTime=[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"];
    
    sureButton=[self addSimpleButton:CGRectMake(240, 137, 50, 35) andBColor:GREENCOLOR andTag:0 andSEL:@selector(choiceURL) andText:@"确定" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureButton.layer setCornerRadius:5];
    [self.view addSubview:sureButton];
    
    tableBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 230, SCREENWIDTH, SCREENHEIGHT-230)];
    tableBGView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:tableBGView];
    
    [self addLineLabel:CGRectMake(10, 20, SCREENWIDTH-20, 0.5) andColor:LINECOLOR andBackView:tableBGView];
    
    UILabel *textLabel=[self addLabel:CGRectMake(10,30, (SCREENWIDTH-20)/2, 20) andText:@"参数" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [tableBGView addSubview:textLabel];
    
    [self addLineLabel:CGRectMake(10,60, SCREENWIDTH-20, 0.5) andColor:LINECOLOR andBackView:tableBGView];
    
    UIButton *pxButton=[self addButton:CGRectMake(10+(SCREENWIDTH-20)/2, 20, 40, 40) adnColor:CLEARCOLOR andTag:1002 andSEL:@selector(px:)];
    [pxButton setImage:[UIImage imageNamed:@"sortDefault"] forState:UIControlStateNormal];
    pxButton.imageEdgeInsets=UIEdgeInsetsMake(12, 12, 12, 12);
    [tableBGView addSubview:pxButton];
    
    UILabel *valueLabel=[self addLabel:CGRectMake(10+(SCREENWIDTH-20)/2,30, (SCREENWIDTH-20)/2, 20) andText:@"数量" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [tableBGView addSubview:valueLabel];
    
    UILabel *totalLabel=[self addLabel:CGRectMake(10,70, (SCREENWIDTH-20)/2, 20) andText:@"总计" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [tableBGView addSubview:totalLabel];
    
    UILabel *totalCountLabel=[self addLabel:CGRectMake(10+(SCREENWIDTH-20)/2,70, (SCREENWIDTH-20)/2, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    totalCountLabel.tag=1001;
    [tableBGView addSubview:totalCountLabel];
    
    [self addLineLabel:CGRectMake(10,100, SCREENWIDTH-20, 0.5) andColor:LINECOLOR andBackView:tableBGView];
    [self addLineLabel:CGRectMake(10, 20, 0.5,80) andColor:LINECOLOR andBackView:tableBGView];
    [self addLineLabel:CGRectMake(10+(SCREENWIDTH-20)/2,20,0.5,80) andColor:LINECOLOR andBackView:tableBGView];
    [self addLineLabel:CGRectMake(SCREENWIDTH-10, 20, 0.5,80) andColor:LINECOLOR andBackView:tableBGView];
    
    [self choiceURL];
    
}

- (void)px:(UIButton*)button{
    if (mainDataArray.count>0) {
        NSArray *newArray=nil;
        if (button.selected==NO) {
            newArray=[mainDataArray sortedArrayUsingComparator:^NSComparisonResult(CensusItem *obj1, CensusItem *obj2){
                if ([obj1.mValue intValue]>[obj2.mValue intValue]) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }];
            [button setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
            button.selected=YES;
        }
        else{
            newArray=[mainDataArray sortedArrayUsingComparator:^NSComparisonResult(CensusItem *obj1, CensusItem *obj2){
                if ([obj1.mValue intValue]<[obj2.mValue intValue]) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }];
            [button setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
            button.selected=NO;
        }
        [self addTableView:newArray];
    }
    
}


//为柱形图设置数据
- (BarChartData *)setData{
    // 开始设值
    NSMutableArray *xValues =[NSMutableArray new];
    NSMutableArray *yVals = [NSMutableArray array];
    [xValues addObject:@"总计"];
    double sum=0;
    for (int i = 0; i < mainDataArray.count; i++) {
        CensusItem *item=[mainDataArray objectAtIndex:i];
        [xValues addObject:[self changeNullString:item.mText]];
        double value = [item.mValue doubleValue];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i+1 y:[[NSString stringWithFormat:@"%.0f",value] doubleValue]]];
        sum+=value;
    }
    [yVals insertObject:[[BarChartDataEntry alloc] initWithX:0 y:sum] atIndex:0];
    // 设置柱形数值
    BarChartDataSet *set1 = nil;
    set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
    set1.highlightEnabled = NO;
    [set1 setColors:ChartColorTemplates.material];//设置柱形图颜色
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    data.barWidth = 0.25f;
    
    // 设置X轴数据
    if (xValues.count > 0) {
        _barChartView.xAxis.axisMaxValue = xValues.count - 1 + 0.8;
        _barChartView.xAxis.labelCount = xValues.count;
        _barChartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
    }
    return data;
}

- (PieChartData *)setPieChartViewData{
    //    int count = 10;//饼状图总共有几块组成
    //每个区块的数据
    int sum=0;
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < mainDataArray.count; i++) {
        CensusItem *item=[mainDataArray objectAtIndex:i];
        double value = [item.mValue doubleValue];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:value];
        [yVals addObject:entry];
        sum+=value;
    }
    UILabel *totalLabel=[self.view viewWithTag:101];
    totalLabel.text=[NSString stringWithFormat:@"总计:%d",sum];
    //dataSet
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:yVals label:nil];
    dataSet.drawValuesEnabled = YES;//是否绘制显示数据
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    dataSet.colors = colors;//区块颜色
    dataSet.sliceSpace = 0;//相邻区块之间的间距
    dataSet.selectionShift = 8;//选中区块时, 放大的半径
    dataSet.xValuePosition = PieChartValuePositionInsideSlice;//名称位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
    //数据与区块之间的用于指示的折线样式
    dataSet.valueLinePart1OffsetPercentage = 0.85;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1Length = 0.4;//折线中第一段长度占比
    dataSet.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
    dataSet.valueLineWidth = 1;//折线的粗细
    dataSet.valueLineColor = [UIColor brownColor];//折线颜色
    //data
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" ";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    return data;
}



- (void)choiceDate:(UIButton *)button{
    [self.view endEditing:YES];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
        dateChoiceView=nil;
    }
    UILabel *label=[[button subviews] firstObject];
    dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
    if (button==bTimeButton) {
        [dateChoiceView initDateChoiceView:[NSString stringWithFormat:@"%@NO",label.text]];
    }else{
        [dateChoiceView initDateChoiceView:label.text];
    }
    dateChoiceView.delegate=self;
    [self.view addSubview:dateChoiceView];
    
    lastButton=button;
}

- (void)sureChoiceDate:(NSDate *)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    UILabel *label=[[lastButton subviews] firstObject];
    label.text=s1;
    if (lastButton==bTimeButton) {
        self.bTime=s1;
    }else{
        self.eTime=s1;
    }
}

- (void)cancelChoiceDate{}


- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight{
    CensusItem *item=[mainDataArray objectAtIndex:entry.x];
    UILabel *detailLabel=[self.view viewWithTag:102];
    detailLabel.text=[NSString stringWithFormat:@"%@   数量:%d",item.mText,[item.mValue intValue]];
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
