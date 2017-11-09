//
//  SearchViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "MemberInfoViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=MAINWHITECOLOR;
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)creatUI{
    self.view.backgroundColor=MAINWHITECOLOR;
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 64) andColor:GREENCOLOR];
    [self.view addSubview:titleBGView];
    
    UIView *searchBGView=[self addSimpleBackView:CGRectMake(10,27, SCREENWIDTH-70,30) andColor:MAINWHITECOLOR];
    [searchBGView.layer setCornerRadius:15];
    [titleBGView addSubview:searchBGView];
    
    UIImageView *searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,9, 12,12)];
    searchImageView.image=[UIImage imageNamed:@"search"];
    [searchBGView addSubview:searchImageView];
    
    searchField=[[UITextField alloc]initWithFrame:CGRectMake(26,5, SCREENWIDTH-80, 20)];
    searchField.placeholder=@"搜索";
    searchField.font=[UIFont systemFontOfSize:MIDDLEFONT];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    [searchBGView addSubview:searchField];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-50,28, 40, 30) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(cancelSearch) andText:@"取消" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:cancelButton];
    
    [self creatHistoryView];
    
}

- (void)creatHistoryView{
    historyView=[[UIView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-64)];
    [self.view addSubview:historyView];
    
    NSString * fileName = @"memberhistory.txt";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *array =[NSArray arrayWithContentsOfFile:path];
    
    if (array.count==0) {
        UILabel *hTitleLabel=[self addLabel:CGRectMake(0,20,SCREENWIDTH, 20) andText:@"暂无搜索纪录" andFont:BIGFONT andColor:TEXTCOLORDG andAlignment:1];
        [historyView addSubview:hTitleLabel];
    }else{
        
        UILabel *hTitleLabel=[self addLabel:CGRectMake(15,12.5, 100, 20) andText:@"搜索历史" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [historyView addSubview:hTitleLabel];
        
        [self addLineLabel:CGRectMake(0,44.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:historyView];
        
        for (int i=0; i<array.count; i++) {
            UIButton *hButton=[self addButton:CGRectMake(0,45+55*i,SCREENWIDTH,55) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(sureChoice:)];
            [historyView addSubview:hButton];
            
            UIImageView *userImageView=[self addImageView:CGRectMake(15,7, 41, 41) andName:@"ell_3"];
            [hButton addSubview:userImageView];
            
            UIImageView *vipImageView=[self addImageView:CGRectMake(44, 36, 12, 12) andName:@"v_2"];
            [hButton addSubview:vipImageView];
            
            UILabel *hNameLabel=[self addLabel:CGRectMake(65,17.5,SCREENWIDTH-30,20) andText:[array objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
            [hButton addSubview:hNameLabel];
            
            UIButton *delButton=[self addButton:CGRectMake(SCREENWIDTH-40, 0, 40, 55) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
            [delButton setImage:[UIImage imageNamed:@"delect"] forState:UIControlStateNormal];
            delButton.imageEdgeInsets=UIEdgeInsetsMake(21, 11, 20, 15);
            [delButton addTarget:self action:@selector(deleteSHistory:) forControlEvents:UIControlEventTouchUpInside];
            [hButton addSubview:delButton];
            
            [self addLineLabel:CGRectMake(0,54.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:hButton];
            historyView.frame=CGRectMake(0, 64, SCREENWIDTH, hButton.frame.origin.y+hButton.frame.size.height);
        }
        
        UIButton *clearButton=[self addSimpleButton:CGRectMake(0, historyView.frame.size.height, SCREENWIDTH, 55) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(deleteHistory) andText:@"清空历史纪录" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
        [historyView addSubview:clearButton];
        
         historyView.frame=CGRectMake(0, 64, SCREENWIDTH, clearButton.frame.origin.y+clearButton.frame.size.height);
        
        [self addLineLabel:CGRectMake(0,historyView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:historyView];
        [self addLineLabel:CGRectMake(0,historyView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:historyView];
    }
}

- (void)deleteSHistory:(UIButton*)button{
    lastDelSButton=(UIButton*)button.superview;
   [self showPromptBox:self andMesage:@"确定要删除该条搜索记录吗？" andSel:@selector(sureDelS)];
}

- (void)sureDelS{
    NSString * fileName=@"memberhistory.txt";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *array =[NSArray arrayWithContentsOfFile:path];
    for (UIView *subView in [lastDelSButton subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *lastDelSlabel=(UILabel*)subView;
            [array removeObject:lastDelSlabel.text];
            [array writeToFile:path atomically:YES];
        }
    }
    if (array.count>0) {
        [lastDelSButton removeFromSuperview];
        for (UIView *view in historyView.subviews) {
            if (view.frame.origin.y>=lastDelSButton.frame.origin.y+lastDelSButton.frame.size.height) {
                view.frame=CGRectMake(0, view.frame.origin.y-55, SCREENWIDTH, view.frame.size.height);
            }
        }
    }else{
        for (UIView *view in historyView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *noLabel=[self addLabel:CGRectMake(0,20,SCREENWIDTH, 20) andText:@"暂无搜索记录" andFont:BIGFONT andColor:TEXTCOLORDG andAlignment:1];
        [historyView addSubview:noLabel];
    }
}


- (void)deleteHistory{
    [self showPromptBox:self andMesage:@"确定要清空搜索记录吗？" andSel:@selector(sureDel)];
}

- (void)sureDel{
    NSString * fileName=@"memberhistory.txt";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *array =[NSArray arrayWithContentsOfFile:path];
    [array removeAllObjects];
    [array writeToFile:path atomically:YES];
    for (UIView *view in historyView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *noLabel=[self addLabel:CGRectMake(0,20,SCREENWIDTH, 20) andText:@"暂无搜索记录" andFont:BIGFONT andColor:TEXTCOLORDG andAlignment:1];
    [historyView addSubview:noLabel];
}

- (void)sureChoice:(UIButton*)button{
    
    for (UIView *subView in [button subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)subView;
            searchField.text=label.text;
            [searchField resignFirstResponder];
            [historyView removeFromSuperview];
        }
    }
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, mainWidth, mainHeight-64) style:UITableViewStylePlain];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)deleteHistory:(UIButton*)button{
    NSString * fileName=@"memberhistory.txt";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *array =[NSArray arrayWithContentsOfFile:path];
    [array removeAllObjects];
    [array writeToFile:path atomically:YES];
    for (UIView *view in historyView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *noLabel=[self addLabel:CGRectMake(0,20,SCREENWIDTH, 20) andText:@"暂无搜索记录" andFont:18 andColor:MAINGRAYCOLOR andAlignment:1];
    [historyView addSubview:noLabel];
}

- (void)cancelSearch{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]&&textField.text.length>0) {
        NSMutableArray *array;
        NSString * fileName = @"memberhistory.txt";
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                           , NSUserDomainMask
                                                           , YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
        array=[NSArray arrayWithContentsOfFile:path];
        BOOL isHave=NO;
        if (array.count>0) {
            for (NSString *str in array) {
                if ([searchField.text isEqualToString:str]) {
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                if (array.count>5) {
                    [array removeObjectAtIndex:0];
                    [array addObject:searchField.text];
                    [array writeToFile:path atomically:YES];
                }else{
                    [array addObject:searchField.text];
                    [array writeToFile:path atomically:YES];
                    
                }
            }
        }else{
            array=[[NSMutableArray alloc]init];
            [array addObject:searchField.text];
            [array writeToFile:path atomically:YES];
        }
        [textField resignFirstResponder];
        [historyView removeFromSuperview];
        
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70, mainWidth, mainHeight-70) style:UITableViewStylePlain];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        [self.view addSubview:mainTableView];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchTableViewCell";
    SearchTableViewCell *cell = (SearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
    if (!cell) {
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.mainImageView.image=[UIImage imageNamed:@"ell_1"];
    cell.nameLabel.text=@"测试用户";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberInfoViewController *mvc=[MemberInfoViewController new];
    mvc.titleString=@"测试测试";
    mvc.whoPush=@"SERCH";
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:mvc animated:YES];
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
