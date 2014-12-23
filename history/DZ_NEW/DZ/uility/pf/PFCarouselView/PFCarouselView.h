//
//  PFCarouselView.h
//  PFCarouselView
//
//  Created by PFei_He on 14-10-24.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFCarouselView;

@protocol PFCarouselViewDelegate <NSObject>

/**
 *  @brief 滚动视图总页数
 *  @return 总页数
 */
- (NSInteger)numberOfPagesInCarouselView:(PFCarouselView *)carouselView;

/**
 *  @brief 添加内容视图
 *  @param index: 视图序号
 *  @return 内容视图
 */
- (UIView *)carouselView:(PFCarouselView *)carouselView contentViewAtIndex:(NSInteger)index;

@optional

/**
 *  @brief 设置页控制器（白点）
 *  @param pageControl: 页控制器（白点）
 *  @param index: 页控制器（白点）序号
 */
- (void)carouselView:(PFCarouselView *)carouselView pageControl:(UIPageControl *)pageControl atIndex:(NSInteger)index;

/**
 *  @brief 设置文本
 *  @param textLabel: 文本
 *  @param index: 文本序号
 */
- (void)carouselView:(PFCarouselView *)carouselView textLabel:(UILabel *)textLabel atIndex:(NSInteger)index;

/**
 *  @brief 实现点击事件
 *  @param index: 点击事件序号
 */
- (void)carouselView:(PFCarouselView *)carouselView didSelectViewAtIndex:(NSInteger)index;

@end

@interface PFCarouselView : UIView

///是否显示页控制器（白点），默认为显示
@property (nonatomic, assign)               BOOL            pageControlShow;

///页控制器（白点）
@property (nonatomic, strong, readonly)     UIPageControl   *pageControl;

///是否显示文本，默认为显示
@property (nonatomic, assign)               BOOL            textLabelShow;

///文本
@property (nonatomic, strong, readonly)     UILabel         *textLabel;

/**
 *  初始化滚动视图
 *  @param animationDuration: 自动滚动的间隔时长。如果<=0，不自动滚动
 *  @param delegate: 代理（不使用代理方法时设为nil）
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration delegate:(id<PFCarouselViewDelegate>)delegate;

/**
 *  @brief 停止滚动
 */
- (void)stop;

/**
 *  @brief 恢复滚动
 */
- (void)resume;

/**
 *  @brief 刷新
 */
- (void)refresh;

#pragma mark -

/**
 *  @brief 滚动视图总页数（使用块方法时必须执行该方法）
 *  @return 总页数
 */
- (void)numberOfPagesInCarouselViewUsingBlock:(NSInteger (^)(PFCarouselView *carouselView))block;

/**
 *  @brief 添加内容视图（使用块方法时必须执行该方法）
 *  @param index: 视图序号
 *  @return 内容视图
 */
- (void)contentViewAtIndexUsingBlock:(UIView *(^)(PFCarouselView *carouselView, NSInteger index))block;

/**
 *  @brief 设置页控制器（白点）
 *  @param pageControl: 页控制器（白点）
 *  @param index: 页控制器（白点）序号
 */
- (void)pageControlAtIndexUsingBlock:(void (^)(PFCarouselView *carouselView, UIPageControl *pageControl, NSInteger index))block;

/**
 *  @brief 设置文本
 *  @param textLabel: 文本
 *  @param index: 文本序号
 */
- (void)textLabelAtIndexUsingBlock:(void (^)(PFCarouselView *carouselView, UILabel *textLabel, NSInteger index))block;

/**
 *  @brief 实现点击事件
 *  @param index: 点击事件序号
 */
- (void)didSelectViewAtIndexUsingBlock:(void (^)(PFCarouselView *carouselView, NSInteger index))block;

@end
