//
//  PFMixButton.h
//  PFRadioButton
//
//  Created by PFei_He on 14-10-23.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PFMixButtonStateNormal,    //普通状态
    PFMixButtonStateSelected,  //选中状态
}PFMixButtonState;

@class PFMixButton;

@protocol PFMixButtonDelegate <NSObject>

/**
 *  @brief 点击事件
 */
- (void)didSelect:(PFMixButton *)button;

@end

@interface PFMixButton : UIView

///按钮文字
@property (nonatomic, copy)     NSString                *text;

///按钮是否被选中
@property (nonatomic, assign)   BOOL                    selected;

///按钮状态
@property (nonatomic, assign)   PFMixButtonState        state;

///代理
@property (nonatomic, weak)     id<PFMixButtonDelegate> delegate;

/**
 *  @brief 设置按钮的尺寸
 *  @param imageFrame: 图片尺寸
 *  @param textFrame: 文字尺寸
 */
- (id)initWithFrame:(CGRect)frame imageFrame:(CGRect)imageFrame textFrame:(CGRect)textFrame;

/**
 * @brief 点击事件
 */
- (void)didSelect:(void (^)(PFMixButton *button))block;

@end
