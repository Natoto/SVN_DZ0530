//
//  PFPopupBox.h
//  PFPopupBox
//
//  Created by PFei_He on 14-9-5.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFPopupBox;

@protocol PFPopupBoxDelegate <NSObject>

/**
 *  @brief 点击弹出框
 */
- (void)popupBoxDidTapped;

@end

@interface PFPopupBox : UIView

///标题
@property (nonatomic, copy)     NSString                *title;

///内容视图
@property (nonatomic, strong)   UIView                  *contentView;

///代理
@property (nonatomic, weak)     id<PFPopupBoxDelegate>  delegate;

/**
 *  @brief 初始化内容视图
 *  @param 内容视图宽度
 *  @param 内容视图高度
 */
- (id)initWithFrame:(CGRect)frame contentViewWidth:(CGFloat)width contentViewHeight:(CGFloat)height;

/**
 *  @brief 显示弹出框
 */
- (void)show;

/**
 *  @brief 隐藏弹出框
 */
- (void)hide;

/**
 *  @brief 点击弹出框
 */
- (void)popupBoxDidTappedUsingBlock:(void (^)())block;

@end
