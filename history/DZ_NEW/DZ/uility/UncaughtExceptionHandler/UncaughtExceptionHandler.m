//
//  UncaughtExceptionHandler.m
//  ZhiZhi
//
//  Created by Danny on 13-6-9.
//  Copyright (c) 2013年 nonato. All rights reserved.
//
#import "DZ_SystemSetting.h"
#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;


@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


- (void)handleException:(NSException *)exception
{
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception Reason: %@\n\n  userInfo: %@ callStackSymbols:%@", [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey],[exception callStackSymbols]];
   //添加崩溃日子统计 可以上传服务器
    
    //上传到邮件NOTE
//#if IQUAPP_DEBUG == 1
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
     NSLog(@"ExceptionInfo BEGIN:<*><*><*><*><*><*><*><*><*><*><*><*><*><*>\nExceptionInfo:\n%@\nExceptionInfo END:<*><*><*><*><*><*><*><*><*><*><*><*><*><*>", exceptionInfo);
    NSString * appinfo = [self AppInfo];
    NSString *urlStr = [NSString stringWithFormat:@"mailto:787486160@qq.com?subject=iquapp Bug Report &body=Oh Crashed! <br> Please send the email to me in order to better service for you! <br>Thanks for your coorperation!<br><br>---------------------<br>"
                        "AppName: %@<br>"\
                        "Type: %@<br>"\
                        "Reason:<br>%@<br>"\
                        "UserInfo:<br>%@<br>"\
                        "Detail:<br>%@<br>--------------------------<br>"\
                        "appInfo:<br>%@><br>",
                        [DZ_SystemSetting sharedInstance].appname,
                        name,
                        reason,
                        [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey],
                        [arr componentsJoinedByString:@"<br>"],
                        appinfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
//#endif
    
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

-(NSString *)AppInfo
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUUID :%@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                          [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    //[NSUserDefaults standardUserDefaults] objectForKey: @"open_UDID"]
    NSLog(@"appInfo->Crash!>>>: %@", appInfo);
    return appInfo;
}

@end

NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUUID :%@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSLog(@"appInfo->Crash!>>>: %@", appInfo);
    return appInfo;
}

void CustomSignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) { return; }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    [userInfo setObject:[UncaughtExceptionHandler backtrace] forKey:UncaughtExceptionHandlerAddressesKey];
    NSString *reason = [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.\n" @"%@", nil), signal, getAppInfo()];
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                     reason:reason
                                                   userInfo:userInfo];
    
    __autoreleasing UncaughtExceptionHandler *ueh = [[UncaughtExceptionHandler alloc] init];
    [ueh performSelectorOnMainThread:@selector(handleException:)
                          withObject:exception
                       waitUntilDone:YES];
}

#pragma mark - uncaughtExceptionHandler
void uncaughtExceptionHandlerNotForSignal(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[[UncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:)
                                                              withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo]
                                                           waitUntilDone:YES];
}

void installUncaughtExceptionHandler()
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandlerNotForSignal);
    signal(SIGABRT, CustomSignalHandler);
    signal(SIGILL, CustomSignalHandler);
    signal(SIGSEGV, CustomSignalHandler);
    signal(SIGFPE, CustomSignalHandler);
    signal(SIGBUS, CustomSignalHandler);
    signal(SIGPIPE, CustomSignalHandler);
}

