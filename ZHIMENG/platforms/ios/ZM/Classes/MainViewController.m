/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  ZM
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.wwwFolderName = @"";//@"www";
        self.zm_syssetting =[ZM_SystemSetting sharedInstance];
        self.startPage = self.zm_syssetting.websiteurl;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //    if (self.zm_syssetting.navigationbarcolor) {
    //        self.view.backgroundColor = self.zm_syssetting.navigationbarcolor;
    //    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    label.text = @"由IDO提供技术支持";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.center = CGPointMake(320./2, 20);
    [self.webView insertSubview:label atIndex:0];
    self.webView.backgroundColor = [UIColor colorWithRed:35./255. green:37./255. blue:38./255. alpha:1];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    [swipeGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [swipeGestureRecognizer setNumberOfTouchesRequired:1];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)gestureRecognizerHandle:(UIGestureRecognizer *)gesture
{
    [self.webView goBack];
}
- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect viewBounds = [self.webView bounds];
        viewBounds.origin.y = 20;
        viewBounds.size.height = viewBounds.size.height - 20;
        self.webView.frame = viewBounds;
    }
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
 - (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
 {
 return[super newCordovaViewWithFrame:bounds];
 }
 */

#pragma mark UIWebDelegate implementation



-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    if (!self.indicatorview) {
        MBProgressHUD * indicatorview =[MBProgressHUD showHUDAddedTo:self.webView animated:YES];
        self.indicatorview = indicatorview;
        self.indicatorview.labelText =@"加载中...";
    }
    [self.indicatorview show:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indicatorview hide:NO];
    [self showAlert:@"网络错误!"];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    [self.indicatorview hide:YES];
    return [super webViewDidFinishLoad:theWebView];
}
-(void)showAlert:(NSString *)message
{
    MBProgressHUD *showlog =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    showlog.labelText = message;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end

@implementation MainCommandDelegate


#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}


@end
