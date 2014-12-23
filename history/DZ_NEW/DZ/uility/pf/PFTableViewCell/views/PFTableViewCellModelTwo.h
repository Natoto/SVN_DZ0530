//
//  PFTableViewCellModelTwo.h
//  PFTableViewCell
//
//  Created by PFei_He on 14-11-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFTableViewCellModelTwo;

@protocol PFTableViewCellModelTwoDelegate <NSObject>

@required

/**
 *  @brief 设置尺寸
 *  @return 返回列表的尺寸
 */
- (CGRect)frameOfTableViewCellModelTwo:(PFTableViewCellModelTwo *)tableViewCell;

@optional

/**
 *  @brief 点击
 *  @param indexPath: 点击事件的序号
 */
- (void)tableViewCellModelTwo:(PFTableViewCellModelTwo *)tableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 头像点击
 *  @param indexPath: 头像点击事件的序号
 */
- (void)tableViewCellModelTwo:(PFTableViewCellModelTwo *)tableViewCell portraitDidSelectRowAtIndexPath:(NSIndexPath *)indexPath controlNumber:(NSInteger)controlNumber;

/**
 *  @brief 更多按钮点击
 *  @param indexPath: 更多按钮点击事件的序号
 */
- (void)tableViewCellModelTwo:(PFTableViewCellModelTwo *)tableViewCell moreButtonDidSelectRowAtIndexPath:(NSIndexPath *)indexPath controlNumber:(NSInteger)controlNumber;

@end

@interface PFTableViewCellModelTwo : UITableViewCell

#pragma mark - Base

///序号
@property (nonatomic, strong)           NSIndexPath *indexPath;

///是否加载完成
@property (nonatomic, assign, readonly) BOOL        isLoaded;

///高度
@property (nonatomic, assign)           CGFloat     height;

///内容
@property (nonatomic, strong)           UIView      *detailView;

#pragma mark - Button

///自定义按钮的图片
@property (nonatomic, strong)           UIImage     *customButtonImage;

#pragma mark - Image

///头像视图
@property (nonatomic, strong)           UIImageView *portraitView;

///头像图片
@property (nonatomic, copy)             NSString    *portraitUrl;

#pragma mark - Label

///层标签
@property (nonatomic, strong)           UILabel     *levelLabel;

///层
@property (nonatomic, copy)             NSString    *level;

///姓名标签
@property (nonatomic, strong)           UILabel     *nameLabel;

///姓名
@property (nonatomic, copy)             NSString    *name;

///发布时间标签
@property (nonatomic, strong)           UILabel     *dateLabel;

///发布时间
@property (nonatomic, copy)             NSString    *date;

#pragma mark - Methods

/**
 *  @brief 初始化
 *  @param delegate: 代理（使用块方法时设为nil）
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PFTableViewCellModelTwoDelegate>)delegate;

/**
 *
 */
- (void)tableViewCellWithImageViewFrame:(CGRect)imageViewFrame
                            buttonFrame:(CGRect)buttonFrame
                        levelLabelFrame:(CGRect)levelLabelFrame
                         dateLabelFrame:(CGRect)dateLabelFrame
                         nameLabelWidth:(CGFloat)nameLabelWidth;

/**
 *  @brief 设置尺寸（使用块方法时必须执行该方法）
 *  @return 返回列表的尺寸
 */
- (void)frameOfTableViewCellUsingBlock:(CGRect (^)(PFTableViewCellModelTwo *tableViewCell))block;

/**
 *  @brief 点击
 *  @param indexPath: 点击事件的序号
 */
- (void)didSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCellModelTwo *tableViewCell, NSIndexPath *indexPath))block;

/**
 *  @brief 头像点击
 *  @param indexPath: 头像点击事件的序号
 */
- (void)portraitDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCellModelTwo *tableViewCell, NSIndexPath *indexPath, NSInteger number))block;

/**
 *  @brief 更多按钮点击
 *  @param indexPath: 更多按钮点击事件的序号
 */
- (void)moreButtonDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCellModelTwo *tableViewCell, NSIndexPath *indexPath, NSInteger number))block;

@end
