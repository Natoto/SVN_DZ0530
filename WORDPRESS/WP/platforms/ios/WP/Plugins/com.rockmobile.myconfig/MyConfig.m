//
//  MyConfig.m
//  HelloWorld
//
//  Created by Nonato on 14-9-1.
//
//

#import "MyConfig.h"

@implementation MyConfig

-(void)config:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* myarg = [command.arguments objectAtIndex:0];
    
    if (myarg != nil) {
        
        NSMutableString *stringToReturn =[NSMutableString stringWithString:@"{\"appcolor\":\"#0000ff\"}"];
        //[stringToReturn appendString:stringObtainedFromJavascript];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:stringToReturn ];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
