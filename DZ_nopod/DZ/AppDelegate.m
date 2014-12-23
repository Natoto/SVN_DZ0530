//
//  AppDelegate.m
//  DZ
//
//  Created by Nonato on 14-3-31.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
//#import "bee.services.alipay.h"
//#import "bee.services.location.h"
#import "bee.services.share.tencentweibo.h"
#import "bee.services.wizard.h"
#import "bee.services.push.h"

#import "AppDelegate.h"
#import "model.h"
#import "AppBoard_iPhone.h"
#import "UIImage+Tint.h"
#import <CFNetwork/CFNetwork.h>
#import "DZ_SystemSetting.h"
#import "FaceBoard.h" 
#import "IDO_LogModel.h"
//#import "XHBaseNavigationController.h"
#import "UIImage+Bundle.h"
#import "MobClick.h"
#import "UncaughtExceptionHandler.h"
//最大号文字 34 导航
//30 导航右 文章标题
//22 灰
//table线 上30 下26灰
//记住密码页面26
//设置默认灰30 背景 按钮26 请登录22

static NSString *const ID_KEY = @"id";
#pragma mark -
#pragma mark Category 1
@interface AppDelegate()
{
    NSString  * UMENG_APPKEY;
    NSString  * UMENG_CHANNELID;
}
@end
@implementation AppDelegate 


- (void)umengTrack {
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:UMENG_CHANNELID];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
   BeeLog(@"online config has fininshed and note = %@", note.userInfo);
}

#pragma mark -

- (void)load
{ 
    
   BeeLog(@"hello dz");
	[UIApplication sharedApplication].statusBarHidden = NO;
	bee.ui.config.ASR = YES;
    if (IOS7_OR_LATER) {
        bee.ui.config.iOS7Mode = YES;
    }
    else
    {
        bee.ui.config.iOS6Mode = YES;
    }
    /*
     系统网络设置
     */
    DZ_SystemSetting *setting = [DZ_SystemSetting sharedInstance];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{       
            NSString *url4=  setting.websiteurl;
            if (!url4) {
                [self showalert:@"论坛URL为空"];
                return;
            }
            NSString *feedbackUrl = setting.feedbackurl;
            if (!feedbackUrl) {
                [self showalert:@"论坛反馈地址为空"];
            }
            [ServerConfig sharedInstance].url=url4;
            [ServerConfig sharedInstance].feedbackUrl = feedbackUrl;
            [ServerConfig sharedInstance].idowebsiteurl = setting.logurl;
    });
   /*
    启动画面
    */
//    [self configwizard];
    /*
     配置导航条
     */
    UIImage *imgnavigationbar=[UIImage bundleImageNamed:@"navigationbar.jpg"];
     imgnavigationbar =[imgnavigationbar imageWithTintColor:[setting navigationBarColor]];
    [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
    [BeeUINavigationBar setBackgroundImage:imgnavigationbar];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{ UITextAttributeFont: [UIFont systemFontOfSize:18.0], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]} forState:UIControlStateHighlighted];
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //隐藏边框
    /*[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];*/
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    BeeLog(@": = %@",[[NSBundle mainBundle] resourcePath]);
    [self observeNotification:BeeReachability.CHANGED];
    [self observeNotification:BeeReachability.UNREACHABLE];
    
    BeeLog(NSLocalizedString(@"NSLocalizedString", @"NSLocalizedString"));
    /*
     分享设置
     */
    //微信注册
//    [WXApi registerApp:setting.weixinappid withDescription:setting.appname];
    
    [WXApi registerApp:setting.weixinappid withDescription:setting.appname];
    //新浪微博注册
    [WeiboSDK registerApp:setting.sinaweiboappkey];
    self.window.rootViewController = [AppBoard_iPhone sharedInstance];
    
    UMENG_APPKEY = setting.umappkey;
    UMENG_CHANNELID = setting.umchannelid;
    [self umengTrack];
//    [self rewriteinfoplist];
}

//-(void)rewriteinfoplist
//{
//     NSString *path2 = [[NSBundle mainBundle] pathForResource:@"DefaultConfigure" ofType:@"xml"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"DZ-Info" ofType:@"plist"];
//    NSLog(@"%@",path);
//    NSMutableDictionary *dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:path];
//    NSLog(@"%@",dict);
//    NSArray *str = [dict objectForKey:@"CFBundleURLTypes"];
//    
//    NSLog(@"%@",str);
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];    
//    installUncaughtExceptionHandler();
    BeeLog(@"---------didFinishLaunchingWithOptions------------");
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }
    //消息推送注册
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive ) {
        // 程序在运行过程中受到推送通知
       BeeLog(@"%@", [[userInfo objectForKey: @"aps"] objectForKey: @"alert"]);
        NSString *msg= [[userInfo objectForKey: @"aps"] objectForKey: @"alert"];
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"推送" message:msg delegate:self cancelButtonTitle:@"查看" otherButtonTitles:@"关闭", nil];
        [alertview show ];
    } else {
        //程序为在运行状态受到推送通知
    }
}

-(void)configwizard
{
    // 配置闪屏
	bee.services.wizard.config.showBackground = YES;
	bee.services.wizard.config.showPageControl = YES;
	bee.services.wizard.config.backgroundImage = [UIImage imageNamed:@"Default@2x"];
	bee.services.wizard.config.pageDotSize = CGSizeMake( 11.0f, 11.0f );
	bee.services.wizard.config.pageDotNormal = [UIImage imageNamed:@"tuitional-carousel-active-btn.png"];
	bee.services.wizard.config.pageDotHighlighted = [UIImage imageNamed:@"tuitional-carousel-btn.png"];
	bee.services.wizard.config.pageDotLast = [UIImage imageNamed:@"tuitional-carousel-btn-last.png"];
  
	bee.services.wizard.config.splashes[0] = @"wizard_1.xml";
	bee.services.wizard.config.splashes[1] = @"wizard_2.xml";
	bee.services.wizard.config.splashes[2] = @"wizard_3.xml";
	bee.services.wizard.config.splashes[3] = @"wizard_4.xml";
	bee.services.wizard.config.splashes[4] = @"wizard_5.xml";
    
// 配置提示框
//	{
//		[BeeUITipsCenter setDefaultContainerView:self.window];
//		[BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
//		[BeeUITipsCenter setDefaultMessageIcon:[UIImage imageNamed:@"icon.png"]];
//		[BeeUITipsCenter setDefaultSuccessIcon:[UIImage imageNamed:@"icon.png"]];
//		[BeeUITipsCenter setDefaultFailureIcon:[UIImage imageNamed:@"icon.png"]];
//	}
    
}
 

-(void)showalert:(NSString *)message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

- (void)unload
{
	[self unobserveAllNotifications];
}

ON_NOTIFICATION3(BeeReachability, CHANGED, notify)
{
    if ([BeeReachability isReachableViaWIFI] ) {
//        [self presentMessageTips:@"已切换至WIFI状态"];
    }
    else if ([BeeReachability isReachableViaWLAN])
    {
//         [self presentMessageTips:@"已切换至数据网络,请注意流量"];
    }
}

ON_NOTIFICATION3(BeeReachability, UNREACHABLE, notify)
{
    [self presentMessageTips:@"网络出问题了额"];
}

#pragma mark -

- (void)updateConfig
{
    
}

#pragma mark - share

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self], /*[self.wbapi handleOpenURL:url],*/ [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"分享结果"];
        NSString *strMsg;
        if (resp.errCode == 0) {
            strMsg = [NSString stringWithFormat:@"发送成功"];
        } else {
            strMsg = [NSString stringWithFormat:@"发送失败"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
}

- (BOOL)checkWeChat
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (BOOL)checkSinaWeibo
{
    return [WeiboSDK isWeiboAppInstalled];
}


@end
