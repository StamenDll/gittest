//
//  CommenWebViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CommenWebViewController.h"

@interface CommenWebViewController ()

@end

@implementation CommenWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![self.whopush isEqualToString:@"Health"]) {
        [self addTitleView:@""];
    }
    [self addLeftButtonItem];
    [self addWebView];
}

- (void)popViewController{
    if ([self.whopush isEqualToString:@"Health"]) {
        [self.myTabBarController showTabBar];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addWebView{
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH, SCREENHEIGHT-64)];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.mainUrl]];
    mainWebView.delegate=self;
    [mainWebView loadRequest:request];
    [self.view addSubview:mainWebView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"========%@",request.URL.absoluteString);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
    NSLog(@"2wqe");
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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
