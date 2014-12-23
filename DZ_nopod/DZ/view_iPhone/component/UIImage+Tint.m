//
//  UIImage+Tint.m
//  DZ
//
//  Created by Nonato on 14-5-20.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage(Tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    return tintedImage;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    return [self imageWithTintColor:tintColor blendMode:blendMode alpha:alpha opaque:NO scale:0.0f];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha opaque:(BOOL)opaque scale:(CGFloat)scale
{
    /** 开始重绘
     *  第一个参数为图像大小，第二个参数为获取图像是否透明（NO为透明），第三个参数为缩放比例（retina屏为1.0，普通屏为2.0，设置为0.0f的时候，系统会自动获取屏幕的类型）
     *  该方法保持图像通道
     */
    UIGraphicsBeginImageContextWithOptions(self.size, opaque, scale);

    //设置填充区域
    [tintColor setFill];

    //获取图片尺寸
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);

    //填充
    UIRectFill(bounds);

    //重新对图片进行着色
    [self drawInRect:bounds blendMode:blendMode alpha:alpha];

    if (blendMode != kCGBlendModeDestinationIn)
        //再次着色以取出反色调
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:alpha];

    //保持重绘后的图片
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();

    //结束重绘
    UIGraphicsEndImageContext();

    return tintedImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}


@end
