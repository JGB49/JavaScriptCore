//
//  JSWebViewController.m
//  JavaScriptCoreDemo
//
//  Created by jinguangbi on 16/3/8.
//  Copyright © 2016年 jinguangbi. All rights reserved.
//

#import "JSWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)callObjectc;

-(void)getJson:(NSString *)jsStr;
-(void)getArray:(NSArray *)cararray;


@end


@interface JSWebViewController ()<UIWebViewDelegate,JSObjcDelegate>
{
    UIWebView *_webView;
    JSContext *_jsContext;

}
@end

@implementation JSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Web+Native";

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"html"];
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];

    //Native -> web
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 60, 100, 50);
    [btn setTitle:@"js" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callJs) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {

    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //	<input type="button" value="Objectc" onclick="gb.callObjectc()">
    _jsContext[@"gb"] = self;
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"error：%@", exceptionValue);
    };
    
}

#pragma mark - Native -> Web

-(void)callJs
{
    JSValue *picCallback = _jsContext[@"picCallp"];
    /**
     *  改变P标签
     */
    [picCallback callWithArguments:@[@"Call P"]];
}




#pragma mark - Web -> native

-(void)callObjectc
{
    NSLog(@"callObjectc");
}

-(void)getJson:(NSString *)jsStr
{
    NSLog(@"jsStr=%@",jsStr);
    NSData *jsonData  =[jsStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
    }
    NSLog(@"json=%@",dic);
}
-(void)getArray:(NSArray *)cararray
{
    NSLog(@"cararray=%@",cararray);
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
