//
//  ZMConfig.m
//  HelloWorld
//
//  Created by BooB on 14-8-30.
//
//

#import "ZMConfig.h"

@implementation ZMConfig


-(void)getZMConfigInfo:(CDVInvokedUrlCommand *)command
{
//    id level = [command.arguments objectAtIndex:0];
//    id message = [command.arguments objectAtIndex:1];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"tips" message:@"hello world " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
//    if ([level isEqualToString:@"LOG"]) {
//        NSLog(@"%@", message);
//    } else {
//        NSLog(@"%@: %@", level, message);
//    }
}
@end
