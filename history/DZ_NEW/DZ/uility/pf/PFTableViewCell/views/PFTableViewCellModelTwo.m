//
//  PFTableViewCellModelTwo.m
//  PFTableViewCell
//
//  Created by PFei_He on 14-11-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFTableViewCellModelTwo.h"
#import "PFTableViewCell.h"

@interface PFTableViewCellModelTwo () <PFTableViewCellDelegate>
{
    PFTableViewCell *cell;
}

///代理
@property (nonatomic, weak) id<PFTableViewCellModelTwoDelegate> delegate;

@end

@implementation PFTableViewCellModelTwo

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PFTableViewCellModelTwoDelegate>)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (delegate) {//设置代理并初始化
            self.delegate = delegate;
//            cell = [[PFTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier delegate:self];

            //添加子视图
            [self loadSubviews];
        } else {//初始化
//            cell = [[PFTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier delegate:nil];
        }

        //添加视图
        [self addSubview:cell];

        //设置背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images.bundle/cell_even_background" ofType:@"jpg"]]];
    }
    return self;
}

#pragma mark - Property Methods

//设置序号的setter方法
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    cell.indexPath = indexPath;

    //打开手势
//    cell.useGestureRecognizer = YES;
}

//头像
- (UIImageView *)portraitView
{
    return cell.firstImageView;
}

//获取父系尺寸的getter方法
- (CGRect)frame
{
    return cell.frame;
}

//获取自身尺寸的getter方法
- (CGRect)bounds
{
    return cell.bounds;
}

//是否加载完成的getter方法
//- (BOOL)isLoaded
//{
//    return cell.isLoaded;
//}

//设置高度的setter方法
- (void)setHeight:(CGFloat)height
{
    cell.height = height;
}

- (UIView *)detailView
{
    return cell.firstContentView;
}

#pragma mark - Private Methods

//设置子视图（私人定制）
- (void)loadSubviews
{
    //设置图片
//    cell.firstImageViewUserInteractionEnabled = YES;

    //点赞按钮
    cell.firstButtonType = UIButtonTypeCustom;
//    cell.firstButtonImage = [UIImage bundleImageNamed:@"bianji"];

    //层
    if (!self.levelLabel) self.levelLabel = [[UILabel alloc] init];
    self.levelLabel.font = [UIFont systemFontOfSize:14];
    self.levelLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.levelLabel];

    //姓名
    if (!self.nameLabel) self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLabel];

    //发布时间
    if (!self.dateLabel) self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.dateLabel];
}

//加载子视图（私人定制）（系统方法）
//设置视图（此方法会被执行多次，当横竖屏切换时可通过此方法调整布局）
- (void)layoutSubviews
{
    //头像
//    if (self.portraitUrl) cell.firstImageViewUrl = self.portraitUrl;

    //层
    if (self.level) self.levelLabel.text = [NSString stringWithFormat:@"%@楼:", self.level];

    //姓名
    if (self.name) self.nameLabel.text = [NSString stringWithFormat:@"%@", self.name];

    //发布时间
    if (self.date) self.dateLabel.text = [NSString stringWithFormat:@"%@", self.date];
}

#pragma mark - Public Methods

- (void)tableViewCellWithImageViewFrame:(CGRect)imageViewFrame
                            buttonFrame:(CGRect)buttonFrame
                        levelLabelFrame:(CGRect)levelLabelFrame
                         dateLabelFrame:(CGRect)dateLabelFrame
                         nameLabelWidth:(CGFloat)nameLabelWidth;
{
//    cell.firstImageViewFrame = imageViewFrame;
//    cell.firstButtonFrame = buttonFrame;
    self.levelLabel.frame = levelLabelFrame;
    self.nameLabel.frame = CGRectMake(self.levelLabel.frame.origin.x + self.levelLabel.frame.size.width + 5, self.levelLabel.frame.origin.y, nameLabelWidth, self.levelLabel.frame.size.height);
    self.dateLabel.frame = dateLabelFrame;
}

#pragma mark - Callback Block

//设置尺寸
- (void)frameOfTableViewCellUsingBlock:(CGRect (^)(PFTableViewCellModelTwo *))block
{
    //监听块并回调
//    [cell frameOfTableViewCellUsingBlock:^CGRect(PFTableViewCell *tableViewCell) {
//        return block(self);
//    }];

    //添加子视图
    [self loadSubviews];
}

//点击
- (void)didSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCellModelTwo *, NSIndexPath *indexPath))block
{
    //监听块并回调
    [cell didSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath) {
        if (block) block(self, indexPath);
    }];
}

//头像点击
- (void)portraitDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCellModelTwo *, NSIndexPath *, NSInteger))block
{
    //监听块并回调
    [cell imageViewDidSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath, NSInteger number) {
        if (block) block(self, indexPath, number);
    }];
}

//按钮点击
- (void)moreButtonDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCellModelTwo *, NSIndexPath *, NSInteger))block
{
    //监听块并回调
    [cell buttonDidSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath, NSInteger number) {
        if (block) block(self, indexPath, number);
    }];
}

#pragma mark - Callback Delegate

//设置尺寸
- (CGRect)frameOfTableViewCell:(PFTableViewCell *)tableViewCell
{
    //监听代理并回调
    return [self.delegate frameOfTableViewCellModelTwo:self];
}

//点击
- (void)tableViewCell:(PFTableViewCell *)tableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //监听代理并回调
    if ([self.delegate respondsToSelector:@selector(tableViewCellModelTwo:didSelectRowAtIndexPath:)])
        [self.delegate tableViewCellModelTwo:self didSelectRowAtIndexPath:indexPath];
}

//头像点击
- (void)tableViewCell:(PFTableViewCell *)tableViewCell imageViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath controlNumber:(NSInteger)controlNumber
{
    //监听代理并回调
    if ([self.delegate respondsToSelector:@selector(tableViewCellModelTwo:portraitDidSelectRowAtIndexPath:controlNumber:)])
        [self.delegate tableViewCellModelTwo:self portraitDidSelectRowAtIndexPath:indexPath controlNumber:controlNumber];
}

//按钮点击
- (void)tableViewCell:(PFTableViewCell *)tableViewCell buttonDidSelectRowAtIndexPath:(NSIndexPath *)indexPath controlNumber:(NSInteger)controlNumber
{
    //监听代理并回调
    if ([self.delegate respondsToSelector:@selector(tableViewCellModelTwo:moreButtonDidSelectRowAtIndexPath:controlNumber:)])
        [self.delegate tableViewCellModelTwo:self moreButtonDidSelectRowAtIndexPath:indexPath controlNumber:controlNumber];
}

#pragma mark -

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
