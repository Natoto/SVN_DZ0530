//
//  MyConfig.h
//  HelloWorld
//
//  Created by Nonato on 14-9-1.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
@interface MyConfig : CDVPlugin
- (void)config:(CDVInvokedUrlCommand*)command;
@end
