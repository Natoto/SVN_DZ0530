//
//  PFRadioButton.h
//  PFRadioButton
//
//  Created by PFei_He on 14-9-3.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFRadioButtonDelegate <NSObject>

/**
 *  @brief 实现按钮点击事件
 *  @param title: 按钮的文本
 *  @param index: 序号
 */
- (void)radioButtonTitle:(NSString *)title didSelectItemAtIndex:(NSInteger)index;

@end

@interface PFRadioButton : UIView

///代理
@property (nonatomic, weak) id<PFRadioButtonDelegate> delegate;

/**
 *  @brief 初始化单选按钮
 *  @param number: 按钮个数
 *  @param textArray: 文本数组
 */
- (id)initWithFrame:(CGRect)frame number:(NSUInteger)number textArray:(NSArray *)textArray;

/**
 *  @brief 实现按钮点击事件
 *  @param title: 按钮的文本
 *  @param index: 序号
 */
- (void)didSelectItemAtIndexUsingBlock:(void (^)(NSString *title, NSUInteger index))block;

@end
