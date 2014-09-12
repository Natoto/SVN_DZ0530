//
//  PFRadioButton.m
//  PFRadioButton
//
//  Created by PFei_He on 14-9-3.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFRadioButton.h"

static const NSUInteger kRadioButtonHeight = 22;

static const NSMutableArray *radioButtonCount;
static const NSMutableArray *titleCount;

typedef void (^tapBlock)(NSString *, NSUInteger);

@interface PFRadioButton ()
{
    UIButton *radioButton;  //单选按钮
}

///点击事件
@property (nonatomic, copy) tapBlock tapBlock;

@end

@implementation PFRadioButton

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame number:(NSUInteger)number textArray:(NSArray *)textArray
{
    self = [super initWithFrame:frame];
    if (self) {
        radioButtonCount = [[NSMutableArray alloc] init];
        titleCount = [[NSMutableArray alloc] init];

        for (int i = 0; i < number; i++) {//创建按钮和文本
            radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
            radioButton.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + i * 25, frame.size.width, kRadioButtonHeight);

            //正常
            [radioButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dzimages.bundle/weidianxuan@2x" ofType:@"png"]] forState:UIControlStateNormal];
            [radioButton setTitle:textArray[i] forState:UIControlStateNormal];
            [radioButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            //选中
            [radioButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dzimages.bundle/dianxuan@2x" ofType:@"png"]] forState:UIControlStateSelected];
            [radioButton setTitle:textArray[i] forState:UIControlStateSelected];
            [radioButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

            //按钮内容居左显示（默认为居中）
            radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            radioButton.titleLabel.font = [UIFont systemFontOfSize:15];
            radioButton.tag = i;
            [radioButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [radioButtonCount addObject:radioButton];
            [titleCount addObject:textArray[i]];
            [self addSubview:radioButton];
        }
    }
    return self;
}

#pragma mark - Events Methods

//按钮点击事件
- (void)buttonTap:(UIButton *)button
{
    if (!self.delegate && self.tapBlock) {//监听块并回调
        self.tapBlock(titleCount[button.tag], button.tag);
    } else if ([self.delegate respondsToSelector:@selector(radioButtonTitle:didSelectItemAtIndex:)]) {//监听代理并回调
        [self.delegate radioButtonTitle:titleCount[button.tag] didSelectItemAtIndex:button.tag];
    }

    for (int i = 0; i < radioButtonCount.count; i++) {//获取被点击的按钮
        UIButton *button = [radioButtonCount objectAtIndex:i];
        button.selected = NO;
    }
    button.selected = YES;
}

#pragma mark - Public Methods

//获取按钮点击
- (void)didSelectItemAtIndexUsingBlock:(void (^)(NSString *, NSUInteger))block
{
    if (block) self.tapBlock = block, block = nil;
}

#pragma mark - Memory Management

- (void)dealloc
{
#if __has_feature(objc_arc)
#else
    [radioButton removeFromSuperview], radioButton = nil;
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
