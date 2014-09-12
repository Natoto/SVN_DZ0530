//
//  PFTextView.m
//  PFTextView
//
//  Created by PFei_He on 14-9-10.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFTextView.h"

@interface PFTextView ()

@end

@implementation PFTextView

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - Rendering Methods

//绘图
- (void)drawRect:(CGRect)rect
{
    if (self.placeholder.length > 0)
    {
        if (_placeHolderLabel == nil)
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, self.bounds.size.width, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.textColor = [UIColor lightGrayColor];
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }

        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }

    if (self.text.length == 0 && self.placeholder.length > 0) [[self viewWithTag:999] setAlpha:1];

    [super drawRect:rect];
}

#pragma mark - Property Methods

//设置文本的setter方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

#pragma mark - Private Methods

//文本改变时
- (void)textChanged:(NSNotification *)notification
{
    if (self.placeholder.length == 0) return;

    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if (self.text.length == 0) [[self viewWithTag:999] setAlpha:1];
        else [[self viewWithTag:999] setAlpha:0];
    }];
}

#pragma mark - Memory Management

//内存释放
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [placeHolderLabel release], placeHolderLabel = nil;
    [placeholderColor release], placeholderColor = nil;
    [placeholder release], placeholder = nil;
    [super dealloc];
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
