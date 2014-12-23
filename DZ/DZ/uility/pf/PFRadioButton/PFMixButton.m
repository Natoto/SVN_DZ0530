//
//  PFMixButton.m
//  PFRadioButton
//
//  Created by PFei_He on 14-10-23.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFMixButton.h"

typedef void(^tapBlock)(PFMixButton *);

@interface PFMixButton ()
{
    UIView          *background;    //背景
    UILabel         *textLabel;     //文字

    CAShapeLayer    *circleBorder;  //圆的边框
}

///内部圆形
@property (nonatomic, strong) CAShapeLayer *circleLayer;

///点击事件
@property (nonatomic, copy) tapBlock tapBlock;

@end

@implementation PFMixButton

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame imageFrame:(CGRect)imageFrame textFrame:(CGRect)textFrame
{
    self = [super initWithFrame:frame];
    if (self) {

        //背景
        background = [[UIView alloc] initWithFrame:imageFrame];
        background.backgroundColor = [UIColor clearColor];
        [self addSubview:background];

        //圆的边框
        circleBorder = [CAShapeLayer layer];
        circleBorder.frame = background.bounds;
        circleBorder.borderWidth = 1;
        circleBorder.borderColor = [UIColor darkGrayColor].CGColor;
        circleBorder.cornerRadius = background.frame.size.width / 2;
        [background.layer addSublayer:circleBorder];

        //内部圆形
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = CGRectMake(2, 2, background.frame.size.width - 2 * 2, background.frame.size.height - 2 * 2);
        _circleLayer.cornerRadius = _circleLayer.frame.size.width / 2;
        _circleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [background.layer addSublayer:_circleLayer];

        //文字
        textLabel = [[UILabel alloc] initWithFrame:textFrame];
        textLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:textLabel];

        //设置选择状态为普通
        _state = PFMixButtonStateNormal;
    }
    return self;
}

#pragma mark - Property Methods

//文本的setter方法
- (void)setText:(NSString *)text
{
    //设置文本
    textLabel.text = text;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) self.state = PFMixButtonStateSelected;
    else self.state = PFMixButtonStateNormal;
}

//按钮状态的setter方法
- (void)setState:(PFMixButtonState)state
{
    if(_state != state)
    {
        //利用动画画一个圆
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        CABasicAnimation *animationBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.duration = animationBounds.duration = 0.2f;
        animation.fromValue = @(_circleLayer.cornerRadius);
        CGRect bounds = background.bounds;
        animationBounds.fromValue = [NSValue valueWithCGRect:bounds];
        bounds.size.width = background.frame.size.width - 2 * 2 * 0.9;
        bounds.size.height = background.frame.size.height - 2 * 2 * 0.9;
        animationBounds.toValue = [NSValue valueWithCGRect:bounds];
        animation.toValue = @(bounds.size.width / 2);
        _circleLayer.cornerRadius = bounds.size.width / 2;
        _circleLayer.bounds = bounds;

        //设置选择状态
        if(state == PFMixButtonStateNormal) {//普通
            _circleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        } else if (state == PFMixButtonStateSelected){//选中
            _circleLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        }

        //添加动画
        [_circleLayer addAnimation:animation forKey:@"cornerRadius"];
        [_circleLayer addAnimation:animationBounds forKey:@"bounds"];
    }
    _state = state;
}

#pragma mark - Public Methods

//点击事件
- (void)didSelect:(void (^)(PFMixButton *))block
{
    if (block) self.tapBlock = block, block = nil;
}

#pragma mark - Events Management

//点击开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //设置不透明度
    _circleLayer.opacity = 0.5f;
}

//点击结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //设置不透明度
    _circleLayer.opacity = 1.0f;

    //回调点击事件
    if (!self.delegate && self.tapBlock) {//监听块并回调
        self.tapBlock(self);
    } else if ([self.delegate respondsToSelector:@selector(didSelect:)]) {//监听代理并回调
        [self.delegate didSelect:self];
    }
}

//点击取消
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
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
