//
//  ZMConfig.h
//  HelloWorld
//
//  Created by BooB on 14-8-30.
//
//

#import <Cordova/CDVPlugin.h>

@interface ZMConfig : CDVPlugin

- (void)getZMConfigInfo:(CDVInvokedUrlCommand *)command;
@end
