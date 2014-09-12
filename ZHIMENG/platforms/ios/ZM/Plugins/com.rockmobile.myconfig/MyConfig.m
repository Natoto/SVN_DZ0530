//
//  MyConfig.m
//  HelloWorld
//
//  Created by Nonato on 14-9-1.
//
//

#import "MyConfig.h"
#define IOSTYPE @"2"
@implementation MyConfig

-(void)config:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* myarg = [command.arguments objectAtIndex:0];
    ZM_SystemSetting * setting=[ZM_SystemSetting sharedInstance];
    
    if (myarg != nil) {
        
//        NSMutableString *stringToReturn =[NSMutableString stringWithString:@"{\"appcolor\":\"#00ff00\"}"];
        NSMutableString *stringToReturn =[NSMutableString stringWithFormat:@"{\
                          \"ostype\":\"%@\",\
                          \"appid\":\"%@\",\
                          \"apname\":\"%@\",\
                          \"appversion\":\"%@\",\
                          \"apptemplate\":\"%@\",\
                          \"appcolor\":\"%@\",\
                          \"clientVersion\":\"%@\"}"\
                          ,IOSTYPE,\
                          setting.appid,\
                          setting.appname,\
                          setting.appversion,\
                          setting.apptemplate,\
                          setting.appcolor,\
                          setting.clientVersion];
        
        //[stringToReturn appendString:stringObtainedFromJavascript];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:stringToReturn ];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
