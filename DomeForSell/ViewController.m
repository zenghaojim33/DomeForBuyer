//
//  ViewController.m
//  DomeForSell
//
//  Created by BTW on 15/4/14.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ViewController.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIDownloadCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface ViewController ()
<
    UIWebViewDelegate
>
{
    BOOL isReload;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    isReload = NO;
    self.webView.delegate =self;
    self.webView.scrollView.bounces = NO;
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    NSString * path = [NSString stringWithFormat:@"http://m.dome123.com"];
    NSURL * url = [NSURL URLWithString:path];
    [self loadURL:url];

}
-(void)loadURL:(NSURL*)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(webPageFetchFailed:)];
    [request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
    //设置缓存
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setDownloadDestinationPath:[[ASIDownloadCache sharedCache]pathToStoreCachedResponseDataForRequest:request]];
    [request startAsynchronous];
}
- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
    NSLog(@"%@",[theRequest error]);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"error1.html" ofType:nil inDirectory:@"WebResources/Error"];
    NSURL  *url=[NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    NSString *response = [NSString stringWithContentsOfFile:
                          [theRequest downloadDestinationPath] encoding:[theRequest defaultResponseEncoding] error:nil];
    [self.webView loadHTMLString:response baseURL:[theRequest url]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (isReload == NO)
    {
        [webView reload];
        isReload = YES;
    }
    // 禁用长按事件
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
