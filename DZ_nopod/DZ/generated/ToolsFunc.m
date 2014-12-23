//
//  ToolsFunc.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "ToolsFunc.h" 
@implementation ToolsFunc
DEF_SINGLETON(ToolsFunc)

+ (NSString *)datefromstring:(NSString *)timestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr integerValue]];
    NSString *confromTimespStr =[confromTimesp timeAgo]; // [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstring2:(NSString *)timestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (BeeUIImageView *)LoadImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgurl tag:(int)tag superview:(UIView *)superview
{
    
    BeeUIImageView *imgView = (BeeUIImageView *)[superview viewWithTag:tag];
    if (!imgView) {
       imgView = [[BeeUIImageView alloc] initWithFrame:frame];
       imgView.contentMode=UIViewContentModeScaleAspectFit;
       imgView.tag = tag;
        [superview addSubview:imgView];
    }
    imgView.frame = frame;
    UIImage * image =[[BeeImageCache sharedInstance]  imageForURL:imgurl];
    imgView.image = image;
    return imgView;
}

+ (BeeUIImageView *)CreateImageViewWithFrame:(CGRect)frame andImgName:(NSString *)imgname
{
    BeeUIImageView *imgView=[[BeeUIImageView alloc] initWithFrame:frame];
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    //imgView.data=imgname;
    imgView.image=[UIImage bundleImageNamed:imgname];
    return imgView;
}

+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    return [ToolsFunc CreateLabelWithFrame:frame andTxt:TXT fontsize:15.0];
}

+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT fontsize:(NSUInteger)size
{
    UILabel *label=[[UILabel alloc] initWithFrame:frame];
    label.text=TXT;
    label.font=[UIFont systemFontOfSize:size];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}


+ (BeeUILabel *)CreateBeeLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    BeeUILabel *label=[[BeeUILabel alloc] initWithFrame:frame];
    label.text=TXT;
    label.font=[UIFont systemFontOfSize:15];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT txtcolor:(UIColor *)color
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame=frame;
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame=frame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame andimage:(NSString *)imagename
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    UIImage * image=[UIImage bundleImageNamed:imagename];
    [button setImage:image forState:UIControlStateNormal];
    button.frame=frame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

//selector传递多个参数
+ (SEL)hbselector:(SEL)oldselector target:(id)target firstArgument:(id)firstArgument , ...
{
    SEL theSelector = oldselector;
    NSMethodSignature * sig = [target methodSignatureForSelector:theSelector];
    NSInvocation * theInvocation = [NSInvocation
                                    invocationWithMethodSignature:sig];
    [theInvocation setTarget:target];
    [theInvocation setSelector:theSelector];
    [theInvocation setArgument:&firstArgument atIndex:2];
    va_list args;
    int index = 0;
    va_start( args, firstArgument);
    id argument = va_arg(args,id);
    [theInvocation setArgument:&argument atIndex:3 + index];
    index ++;
    va_end(args);
    [theInvocation retainArguments];
    return theSelector;
}




+(BOOL)isSelfWebSite:(NSString *)url
{
    NSString *regTags = @"http:\\/\\/.*\\/";
    NSError *error;
    NSRegularExpression *regex = [ NSRegularExpression regularExpressionWithPattern:regTags                                                                          options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                                                              error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    if (matches.count) {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        NSRange range = [match range];
        NSString * suburl = [url substringWithRange:range];
        NSString *selfurl=[DZ_SystemSetting sharedInstance].websiteurl;
        if ([selfurl rangeOfString:suburl].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)websiteArticleUrl:(NSString *)tid
{
    //http://www.weichengdx.com/dztoapp/status.php
    //http://114.215.178.111/amanmanceshi/forum.php?mod=viewthread&tid=460
    return [NSString stringWithFormat:@"%@?mod=viewthread&tid=%@",[DZ_SystemSetting sharedInstance].forumurl,tid];
}
+ (NSString *)articletid:(NSString *)url
{
    NSString *regTags = @"tid=(\\d+)";
    NSError *error;
    NSRegularExpression *regex = [ NSRegularExpression regularExpressionWithPattern:regTags                                                                          options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                                                              error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    if (matches.count) {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        NSRange range = [match range];
        NSString * substr = [url substringWithRange:range];
        NSArray *array = [substr componentsSeparatedByString:@"="];
        if (array.count == 2) {
            return [array objectAtIndex:1];
        }
    }
    return @"";
}



#import <sys/sysctl.h>

+ (NSString*)deviceType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iphone 1g";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iphone 3g";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iphone 3gs";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iphone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iphone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iphone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iphone 4s";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iphone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iphone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iphone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iphone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iphone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iphone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iphone 6plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iphone 6";
    if ([platform isEqualToString:@"iPod1,1"])      return @"ipod touch 1g";
    if ([platform isEqualToString:@"iPod2,1"])      return @"ipod touch 2g";
    if ([platform isEqualToString:@"iPod3,1"])      return @"ipod touch 3g";
    if ([platform isEqualToString:@"iPod4,1"])      return @"ipod touch 4g";
    if ([platform isEqualToString:@"iPod5,1"])      return @"ipod touch 5g";
    if ([platform isEqualToString:@"iPad1,1"])      return @"ipad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"ipad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"ipad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"ipad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return @"ipad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"ipad mini";
    if ([platform isEqualToString:@"iPad2,6"])      return @"ipad mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"ipad mini";
    if ([platform isEqualToString:@"iPad3,1"])      return @"ipad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return @"ipad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return @"ipad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"ipad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"ipad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"ipad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"ipad air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"ipad air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"ipad mini retina";
    if ([platform isEqualToString:@"iPad4,5"])      return @"ipad mini retina";
    if ([platform isEqualToString:@"i386"])         return @"simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"simulator";
    return @"new device";
}

@end


