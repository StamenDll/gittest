//
//  DataDisplayView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DataDisplayView.h"
#import "CommWriteItme.h"
@implementation DataDisplayView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)initSubViews:(NSMutableArray*)dataArray andController:(UIViewController *)vc{
    self.superController=vc;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [self addGestureRecognizer:tap];
    
    self.dataArray=dataArray;
    NSLog(@"============%@",dataArray);
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.frame.size.height)];
    [self addSubview:mainScrollView];
    
    UIView *whiteBGView=[[UIView alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 100)];
    whiteBGView.backgroundColor=[UIColor whiteColor];
    [mainScrollView addSubview:whiteBGView];
    
    NSMutableArray *viewArray=[NSMutableArray new];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    for (int i=0; i<dataArray.count; i++) {
        CommWriteItme *item=[dataArray objectAtIndex:i];
        
        
        UILabel *nameLabel=[self addLabel:CGRectMake(15,0,105,item.LHeight) andText:item.LCaption andFont:14 andColor:nil andAlignment:0];
        nameLabel.numberOfLines=0;
        [nameLabel sizeToFit];
        [mainScrollView addSubview:nameLabel];
        NSLog(@"========00=====%@",item.LIsKey);
        if ([item.LIsKey isEqualToString:@"否"]) {
        NSLog(@"========11=====%@",item.LCaption);
        
            if ([item.LValueType isEqualToString:@"时间"]) {
                UIButton *choiceDateBtn=[self addButton:CGRectMake(120,0,SCREENWIDTH-115,50) adnColor:[UIColor whiteColor] andTag:1001+i andSEL:nil];
                [mainScrollView addSubview:choiceDateBtn];
                
                if ([item.LCanEdit isEqualToString:@"是"]) {
                    [choiceDateBtn addTarget:self action:@selector(addDateChoiceView:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    choiceDateBtn.backgroundColor=BGGRAYCOLOR;
                }
                
                UILabel *dateLabel=[self addLabel:CGRectMake(10,15,200, 20) andText:@"" andFont:14 andColor:nil andAlignment:0];
                if ([self changeNullString:item.LDefaultValue].length>0) {
                    dateLabel.text=[self getSubTime:item.LDefaultValue andFormat:@"yyyy-MM-dd"];
                }
                [choiceDateBtn addSubview:dateLabel];
            }
            else if ([item.LValueType isEqualToString:@"单列表"]){
                UIButton *choiceDateBtn=[self addButton:CGRectMake(120,0,SCREENWIDTH-115,50) adnColor:[UIColor whiteColor] andTag:1001+i andSEL:nil];
                [mainScrollView addSubview:choiceDateBtn];
                if ([item.LCanEdit isEqualToString:@"是"]) {
                    [choiceDateBtn addTarget:self action:@selector(addMenuChoiceView:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    choiceDateBtn.backgroundColor=BGGRAYCOLOR;
                }
                
                UILabel *dateLabel=[self addLabel:CGRectMake(10,15,200, 20) andText:@"" andFont:14 andColor:nil andAlignment:0];
                if ([self changeNullString:item.LDefaultValue].length>0) {
                    dateLabel.text=item.LDefaultValue;
                }
                [choiceDateBtn addSubview:dateLabel];
            }
            else if ([item.LValueType isEqualToString:@"字符"]){
            
                if (item.LHeight<50) {
                    UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 50)];
                    textFieldBGView.tag=1001+i;
                    [mainScrollView addSubview:textFieldBGView];
                    
                    if ([item.LCanEdit isEqualToString:@"是"]) {
                        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10,15,SCREENWIDTH-120,20)];
                        if ([self changeNullString:item.LDefaultValue].length>0) {
                            textField.text=[self changeString:item.LDefaultValue andType:@"in"];
                            NSLog(@"==========222==%@",item.LDefaultValue);
                            if ([item.LDefaultValue isEqualToString:@"[User_Name]"]){
                                textField.text=[self changeNullString:[usd objectForKey:@"LName"]];
                            }else if ([item.LDefaultValue isEqualToString:@"[User_Code]"]){
                                textField.text=[self changeNullString:[usd objectForKey:@"LOnlyCode"]];
                            }
                        }
                        textField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
                        textField.textColor=TEXTCOLOR;
                        [textFieldBGView addSubview:textField];
                    }else{
                        textFieldBGView.backgroundColor=BGGRAYCOLOR;
                        UILabel *textLabel=[self addLabel:CGRectMake(10, 15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                        if ([self changeNullString:item.LDefaultValue].length>0) {
                            textLabel.text=[self changeString:item.LDefaultValue andType:@"in"];
                            if ([item.LDefaultValue isEqualToString:@"[User_Name]"]){
                                textLabel.text=[self changeNullString:[usd objectForKey:@"LName"]];
                            }else if ([item.LDefaultValue isEqualToString:@"[User_Code]"]){
                                textLabel.text=[self changeNullString:[usd objectForKey:@"LOnlyCode"]];
                            }
                        }
                        [textFieldBGView addSubview:textLabel];
                    }
                }else{
                    UIView *textViewBGView=[[UIView alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120,item.LHeight)];
                    textViewBGView.tag=1001+i;
                    [mainScrollView addSubview:textViewBGView];
                    
                    if ([item.LCanEdit isEqualToString:@"是"]) {
                        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(10,5,SCREENWIDTH-120,item.LHeight-10)];
                        if ([self changeNullString:item.LDefaultValue].length>0) {
                            textView.text=[self changeString:item.LDefaultValue andType:@"in"];
                            if ([item.LDefaultValue isEqualToString:@"[User_Name]"]){
                                textView.text=[self changeNullString:[usd objectForKey:@"LName"]];
                            }else if ([item.LDefaultValue isEqualToString:@"[User_Code]"]){
                                textView.text=[self changeNullString:[usd objectForKey:@"LOnlyCode"]];
                            }

                        }
                        textView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
                        textView.textColor=TEXTCOLOR;
                        [textViewBGView addSubview:textView];
                    }else{
                        textViewBGView.backgroundColor=BGGRAYCOLOR;
                        UILabel *textLabel=[self addLabel:CGRectMake(10, 5, SCREENWIDTH-120,item.LHeight-10) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                        if ([self changeNullString:item.LDefaultValue].length>0) {
                            textLabel.text=[self changeString:item.LDefaultValue andType:@"in"];
                            if ([item.LDefaultValue isEqualToString:@"[User_Name]"]){
                                textLabel.text=[self changeNullString:[usd objectForKey:@"LName"]];
                            }else if ([item.LDefaultValue isEqualToString:@"[User_Code]"]){
                                textLabel.text=[self changeNullString:[usd objectForKey:@"LOnlyCode"]];
                            }
                        }
                        [textViewBGView addSubview:textLabel];
                    }
                }
            }
            else if ([item.LValueType isEqualToString:@"浮点"]){
                UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 50)];
                textFieldBGView.tag=1001+i;
                [mainScrollView addSubview:textFieldBGView];
                
                if ([item.LCanEdit isEqualToString:@"是"]) {
                    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10,15,SCREENWIDTH-120,20)];
                    if ([[self changeNullString:item.LDefaultValue] floatValue]>0) {
                        textField.text=[NSString stringWithFormat:@"%.2f",[item.LDefaultValue floatValue]];
                    }
                    textField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
                    textField.textColor=TEXTCOLOR;
                    [textFieldBGView addSubview:textField];
                }else{
                    textFieldBGView.backgroundColor=BGGRAYCOLOR;
                    UILabel *textLabel=[self addLabel:CGRectMake(10, 15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                    if ([self changeNullString:item.LDefaultValue].length>0) {
                        textLabel.text=item.LDefaultValue;
                    }
                    [textFieldBGView addSubview:textLabel];
                }
            }
            //整型
            else if ([item.LValueType isEqualToString:@"整形"]){
                UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 50)];
                textFieldBGView.tag=1001+i;
                [mainScrollView addSubview:textFieldBGView];
                
                if ([item.LCanEdit isEqualToString:@"是"]) {
                    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10,15,SCREENWIDTH-120,20)];
                    if ([[self changeNullString:item.LDefaultValue] intValue]>0) {
                        textField.text=[NSString stringWithFormat:@"%d",[item.LDefaultValue intValue]];
                    }
                    textField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
                    textField.textColor=TEXTCOLOR;
                    [textFieldBGView addSubview:textField];
                }else{
                    textFieldBGView.backgroundColor=BGGRAYCOLOR;
                    UILabel *textLabel=[self addLabel:CGRectMake(10, 15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                    if ([self changeNullString:item.LDefaultValue].length>0) {
                        textLabel.text=item.LDefaultValue;
                    }
                    [textFieldBGView addSubview:textLabel];
                }
                
            }
            else if ([item.LValueType isEqualToString:@"code"]){
                UIView *textFieldBGView=[[UIView alloc]initWithFrame:CGRectMake(120, 0, SCREENWIDTH-120, 50)];
                textFieldBGView.tag=1001+i;
                [mainScrollView addSubview:textFieldBGView];
                
                codeField=[[UITextField alloc]initWithFrame:CGRectMake(10,15, SCREENWIDTH-220,20)];
                codeField.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
                codeField.textColor=TEXTCOLOR;
                codeField.keyboardType=UIKeyboardTypeNumberPad;
                [textFieldBGView addSubview:codeField];
                
                UIButton *getMemberNumButton=[self addSimpleButton:CGRectMake(textFieldBGView.frame.size.width-110,10,100, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(sendCode:) andText:@"获取验证码" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
                getMemberNumButton.layer.borderColor=LINECOLOR.CGColor;
                getMemberNumButton.layer.borderWidth=0.5;
                [getMemberNumButton.layer setCornerRadius:15];
                [textFieldBGView addSubview:getMemberNumButton];
            }
            else if ([item.LValueType isEqualToString:@"社区"]){
                UIButton *choiceCommunityBtn=[self addButton:CGRectMake(120,0,SCREENWIDTH-135,50) adnColor:[UIColor whiteColor] andTag:1001+i andSEL:@selector(choiceCommutyOnclick:)];
                [mainScrollView addSubview:choiceCommunityBtn];
                
                UILabel *communityLabel=[self addLabel:CGRectMake(10,15,choiceCommunityBtn.frame.size.width-20, 20) andText:@"" andFont:14 andColor:nil andAlignment:0];
                if ([self changeNullString:item.LDefaultValue].length>0) {
                    communityLabel.text=item.LDefaultValue;
                }
                [choiceCommunityBtn addSubview:communityLabel];
            }else{
                UIView *textViewBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100,0)];
                textViewBGView.tag=1001+i;
                [mainScrollView addSubview:textViewBGView];
                nameLabel.hidden=YES;
                textViewBGView.hidden=YES;
            }
        }
        else{
        NSLog(@"======22=======%@",item.LCaption);
            UIView *textViewBGView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREENWIDTH-100,0)];
            textViewBGView.tag=1001+i;
            [mainScrollView addSubview:textViewBGView];
            nameLabel.hidden=YES;
            textViewBGView.hidden=YES;
        }
        
        UIView *nowView=[self viewWithTag:1001+i];
        if (i>0) {
            UIView *beforView=[viewArray objectAtIndex:i-1];
            nowView.frame=CGRectMake(nowView.frame.origin.x, beforView.frame.origin.y+beforView.frame.size.height,nowView.frame.size.width, nowView.frame.size.height);
            if (item.LHeight>20&&nameLabel.frame.size.height+20>50) {
                nowView.frame=CGRectMake(nowView.frame.origin.x, beforView.frame.origin.y+beforView.frame.size.height,nowView.frame.size.width,nameLabel.frame.size.height+20);
            }
            nameLabel.center=CGPointMake(nameLabel.center.x, nowView.center.y);
        }
        
        [self addLineLabel:CGRectMake(0,nowView.frame.origin.y+nowView.frame.size.height-0.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        [viewArray addObject:nowView];
        whiteBGView.frame=CGRectMake(120, 0, SCREENWIDTH-120, nowView.frame.origin.y+nowView.frame.size.height);
    }
    [self addLineLabel:CGRectMake(120, 0, 0.5, whiteBGView.frame.size.height) andColor:LINECOLOR andBackView:mainScrollView];
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake(40,whiteBGView.frame.size.height+40, SCREENWIDTH-80, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(saveData) andText:@"完成" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureButton.layer setCornerRadius:20];
    [mainScrollView addSubview:sureButton];
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, sureButton.frame.origin.y+sureButton.frame.size.height+40);
}

- (void)choiceCommutyOnclick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(choiceCommuty:)]) {
        [self.delegate choiceCommuty:button];
    }
}

#pragma mark 获取验证码
- (void)getCode:(UIButton*)button{
    if (button.selected==NO) {
        for (int i=0; i<self.dataArray.count; i++) {
            CommWriteItme *item=[self.dataArray objectAtIndex:i];
            if ([item.type isEqualToString:@"phone"]) {
                UIView *subView=[self viewWithTag:1001+i];
                UITextField *phoneField=(UITextField *)[[subView subviews] firstObject];
                if ([self checkPhoneNumber:phoneField.text]==NO) {
                    [self showSimplePromptBox:self.superController andMesage:@"请输入正确的手机号码"];
                }else{
                    int code = (arc4random() % 1000) + 1000;
                    localCodeString=[NSString stringWithFormat:@"%d",code];
                    NSArray *sqlParameter=@[phoneField.text,[NSString stringWithFormat:@"%d",code]];
                    if ([self.delegate respondsToSelector:@selector(sendCode:andData:)]) {
                        [self.delegate sendCode:button andData:sqlParameter];
                    }
                    button.selected=YES;
                }
            }
        }
    }
}

- (void)saveData{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    NSMutableArray *overArray=[NSMutableArray new];
    NSMutableDictionary *dataDic=[NSMutableDictionary new];
    for (int i=0; i<self.dataArray.count; i++) {
        CommWriteItme *item=[self.dataArray objectAtIndex:i];
        UIView *subView=[self viewWithTag:1001+i];
        UIView *sSubView=[[subView subviews] firstObject];
        if ([sSubView isKindOfClass:[UITextField class]]) {
            UITextField *newSubView=(UITextField *)sSubView;
            item.LDefaultValue=newSubView.text;
        }else if ([sSubView isKindOfClass:[UITextView class]]) {
            UITextView *newSubView=(UITextView *)sSubView;
            item.LDefaultValue=newSubView.text;
        }else if ([sSubView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)sSubView;
            item.LDefaultValue=label.text;
        }
        
        
        if ([item.LIsKey isEqualToString:@"否"]) {
            if ([item.LAllowEmpty isEqualToString:@"否"]&&[self changeNullString:item.LDefaultValue].length==0) {
                [self showSimplePromptBox:self.superController andMesage:[NSString stringWithFormat:@"%@不能为空",item.LCaption]];
                return;
            }
        }else{
            if ([item.LKeyValue isEqualToString:@"onlycode"]) {
                item.LDefaultValue=CHATCODE;
            }else if ([item.LKeyValue isEqualToString:@"peoplecode"]){
                if ([self changeNullString:item.LDefaultValue]==0&&self.peopleOnlyID) {
                    item.LDefaultValue=self.peopleOnlyID;
                }
            }else if ([item.LKeyValue isEqualToString:@"orgid"]||[item.LKeyValue isEqualToString:@"OrgId"]){
                if ([self changeNullString:item.LDefaultValue].length==0&&[usd objectForKey:@"LOrgid"]) {
                    item.LDefaultValue=[NSString stringWithFormat:@"%d",[[usd objectForKey:@"LOrgid"] intValue]];
                }
            }else if ([item.LKeyValue isEqualToString:@"mobile"]){
                if ([self changeNullString:item.LDefaultValue].length==0&&[usd objectForKey:@"LMobile"]) {
                    item.LDefaultValue=[usd objectForKey:@"LMobile"];
                }
            }else if ([item.LKeyValue isEqualToString:@"OrgName"]){
                if ([self changeNullString:item.LDefaultValue].length==0&&[usd objectForKey:@"CommunityName"]) {
                    item.LDefaultValue=[usd objectForKey:@"CommunityName"];
                }
            }else if ([item.LKeyValue isEqualToString:@"memberid"]){
                if ([self changeNullString:item.LDefaultValue].length==0&&self.peopleMemberID) {
                    item.LDefaultValue=self.peopleMemberID;
                }
            }
        }
        NSString *typeString=@"text";
        if ([item.LValueType isEqualToString:@"浮点"]) {
            typeString=@"int";
        }else if([item.LValueType isEqualToString:@"整型"]){
            typeString=@"int";
        }
        if ([item.LIsKey isEqualToString:@"是"]&&[item.LKeyValue isEqualToString:@"mainkey"]) {
            [overArray addObject:[NSString stringWithFormat:@"%@='%@'",item.LFieldName,item.LDefaultValue]];
        }else{
            [dataDic setObject:@{@"type":typeString,@"value":item.LDefaultValue} forKey:item.LFieldName];
        }
    }
    if (overArray.count==0) {
        [overArray addObject:[NSString stringWithFormat:@"LID='%@'",[self changeNullString:self.LID]]];
    }
    [overArray addObject:dataDic];
    if ([self.delegate respondsToSelector:@selector(saveSuccess:)]) {
        [self.delegate saveSuccess:overArray];
    }
}

#pragma mark 选择时间
- (void)addDateChoiceView:(UIButton *)button{
    [self cancelKeyboard];
    if (button.selected==NO) {
        UILabel *label=[[button subviews] lastObject];
        DateChoiceView *dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-200, self.frame.size.width, 200)];
        if (label.text.length==0) {
            [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
        }else{
            [dateChoiceView initDateChoiceView:label.text];
        }
        dateChoiceView.delegate=self;
        [self addSubview:dateChoiceView];
        button.selected=YES;
    }
    lastTimeButton=button;
}

- (void)addMenuChoiceView:(UIButton *)button{
    [self cancelKeyboard];
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    if (button.selected==NO) {
        CommWriteItme *item=[self.dataArray objectAtIndex:button.tag-1001];
        if([commenListDic objectForKey:item.LFieldName]){
            self.commenListArray=[commenListDic objectForKey:item.LFieldName];
            NSMutableArray *keyArray=[NSMutableArray new];
            for (NSDictionary *dic in self.commenListArray) {
                [keyArray addObject:[dic objectForKey:item.LBoxValue_ValueField]];
            }
            UILabel *label=[[button subviews] lastObject];
            if (menuChoiceView) {
                [menuChoiceView removeFromSuperview];
            }
            menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-200, self.frame.size.width, 200)];
            if ([keyArray containsObject:label.text]) {
                [menuChoiceView initMenuChoiceView:keyArray andFirst:label.text];
            }else{
                [menuChoiceView initMenuChoiceView:keyArray andFirst:[keyArray objectAtIndex:0]];
            }
            menuChoiceView.delegate=self;
            [self addSubview:menuChoiceView];
        }else{
            if (item.LBoxValue.length>0){
                NSArray *array=[item.LBoxValue componentsSeparatedByString:@";"];
                UILabel *label=[[button subviews] lastObject];
                if (menuChoiceView) {
                    [menuChoiceView removeFromSuperview];
                }
                menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-200, self.frame.size.width, 200)];
                if ([array containsObject:label.text]) {
                    [menuChoiceView initMenuChoiceView:array andFirst:label.text];
                }else{
                    [menuChoiceView initMenuChoiceView:array andFirst:[array objectAtIndex:0]];
                }
                
                menuChoiceView.delegate=self;
                [self addSubview:menuChoiceView];
            }
            else{
                if (item.LBoxValue_Parent.length>0&&[item.LBoxValue_Where rangeOfString:@"[@value@]"].location!=NSNotFound) {
                    for (CommWriteItme *nItem in self.dataArray) {
                        if ([nItem.LID isEqualToString:item.LBoxValue_Parent]) {
                            if (nItem.LDefaultValue.length>0) {
                                NSString *whereString=@"";
                                if ([self changeString:nItem.LBoxValue_Where andType:@"in"].length>0) {
                                    whereString=[NSString stringWithFormat:@"where %@",[self changeString:nItem.LBoxValue_Where andType:@"in"]];
                                }
                                [self.delegate getCommenList:nItem.LBoxValue_table andKey:nItem.LBoxValue_fields andWhere:whereString andButton:button andType:@"Y"];
                            }else if ([item.LBoxValue_Where rangeOfString:@"[@value@]"].location!=NSNotFound) {
                                [self showSimplePromptBox:self.superController andMesage:[NSString stringWithFormat:@"请先选择%@",nItem.LCaption]];
                            }
                        }
                    }
                }else if ([self.delegate respondsToSelector:@selector(getCommenList:andKey:andWhere:andButton:andType:)]) {
                    NSString *whereString=@"";
                    if ([self changeString:item.LBoxValue_Where andType:@"in"].length>0) {
                        whereString=[NSString stringWithFormat:@"where %@",[self changeString:item.LBoxValue_Where andType:@"in"]];
                    }
                    [self.delegate getCommenList:item.LBoxValue_table andKey:item.LBoxValue_fields andWhere:whereString andButton:button andType:nil];
                }
            }
        }
        button.selected=YES;
    }
    lastSexButton.selected=NO;
    lastSexButton=button;
}

- (void)saveParentArray{
    CommWriteItme *item=[self.dataArray objectAtIndex:lastSexButton.tag-1001];
    for (CommWriteItme *nItem in self.dataArray) {
        if ([nItem.LID isEqualToString:item.LBoxValue_Parent]) {
            for (NSDictionary *dic in self.commenListArray) {
                if ([[dic objectForKey:nItem.LBoxValue_ValueField] isEqualToString:nItem.LDefaultValue]) {
                    nItem.LDefaultValue=[dic objectForKey:nItem.LBoxValue_ValueField];
                    item.LBoxValue_Where=[item.LBoxValue_Where stringByReplacingOccurrencesOfString:@"[@value@]" withString:[dic objectForKey:nItem.LBoxValue_KeyField]];
                    [self addMenuChoiceView:lastSexButton];
                }
            }
        }
    }
    [self addMenuChoiceView:lastSexButton];
}


- (void)addCommenListView{
    CommWriteItme *item=[self.dataArray objectAtIndex:lastSexButton.tag-1001];
    if (!commenListDic) {
        commenListDic=[NSMutableDictionary new];
    }
    [commenListDic setObject:self.commenListArray forKey:item.LFieldName];
    
    NSMutableArray *keyArray=[NSMutableArray new];
    for (NSDictionary *dic in self.commenListArray) {
        [keyArray addObject:[dic objectForKey:item.LBoxValue_ValueField]];
    }
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    UILabel *label=[[lastSexButton subviews] lastObject];
    menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-200, self.frame.size.width, 200)];
    if ([keyArray containsObject:label.text]) {
        [menuChoiceView initMenuChoiceView:keyArray andFirst:label.text];
    }else{
        [menuChoiceView initMenuChoiceView:keyArray andFirst:[keyArray objectAtIndex:0]];
    }
    menuChoiceView.delegate=self;
    [self addSubview:menuChoiceView];
}


/**
 时间选择回调
 */
- (void)sureChoiceDate:(NSDate*)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    UILabel *label=[[lastTimeButton subviews] lastObject];
    label.text=s1;
    lastTimeButton.selected=NO;
}

- (void)cancelChoiceDate{
    lastTimeButton.selected=NO;
}

/**
 性别选择回调
 */
- (void)sureChoiceMenu:(NSString *)menuString{
    UILabel *label=[[lastSexButton subviews] lastObject];
    label.text=menuString;
    lastSexButton.selected=NO;
    CommWriteItme *nItem=[self.dataArray objectAtIndex:lastSexButton.tag-1001];
    for (NSDictionary *dic in self.commenListArray) {
        if ([[dic objectForKey:nItem.LBoxValue_ValueField] isEqualToString:menuString]) {
            nItem.LDefaultValue=[dic objectForKey:nItem.LBoxValue_ValueField];
            for (int i=0; i<self.dataArray.count; i++) {
                CommWriteItme *item=[self.dataArray objectAtIndex:i];
                if ([item.LBoxValue_Parent isEqualToString:nItem.LID]) {
                    UIButton *button=(UIButton*)[self viewWithTag:1001+i];
                    UILabel *subLabel=[[button subviews]firstObject];
                    subLabel.text=@"";
                    [commenListDic removeObjectForKey:item.LFieldName];
                    item.LBoxValue_Where=[item.LBoxValue_Where stringByReplacingOccurrencesOfString:@"[@value@]" withString:[dic objectForKey:nItem.LBoxValue_KeyField]];
                }
            }
        }
    }
}

- (void)cancelChoiceMenu{
    lastSexButton.selected=NO;
}

- (void)cancelKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainScrollView.frame=CGRectMake(0, 0, SCREENWIDTH,self.frame.size.height-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainScrollView.frame=CGRectMake(0, 0, SCREENWIDTH,self.frame.size.height);
}

@end
