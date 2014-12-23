//
//  PFTableViewCell.m
//  PFTableViewCell
//
//  Created by PFei_He on 14-11-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFTableViewCell.h"

typedef void(^touchBlock)(PFTableViewCell *, NSIndexPath *);
typedef void(^controlTouchBlock)(PFTableViewCell *, NSIndexPath *, NSInteger);
typedef void(^controlTouchBlock2)(PFTableViewCell *, NSIndexPath *, UIGestureRecognizer *, UIView *);
typedef void(^loadedBlock)(NSIndexPath *);

BOOL PFTableViewCellReload; //是否重新加载列表

@interface PFTableViewCell ()
{
    UIView                  *line;          //分割线
    UITapGestureRecognizer  *recognizer;    //点击手势
}

///点击事件
@property (nonatomic, copy) touchBlock                  touchBlock;

///自定义按钮点击事件
@property (nonatomic, copy) controlTouchBlock           buttonTouchBlock;

///自定义图片点击事件
@property (nonatomic, copy) controlTouchBlock           imageViewTouchBlock;

///自定义图片点击事件
@property (nonatomic, copy) controlTouchBlock2           textLabelTouchBlock;

///刷新完成
@property (nonatomic, copy) loadedBlock                 loadedBlock;

///代理
@property (nonatomic, weak) id<PFTableViewCellDelegate> delegate;

@end

@implementation PFTableViewCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PFTableViewCellDelegate>)delegate size:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置代理
        if (delegate) self.delegate = delegate, delegate = nil;

        //设置尺寸
        self.frame = CGRectMake(0, 0, size.width, size.height);
    }
    return self;
}

#pragma mark - Property Methods

/**
 * Base
 */
//序号的setter方法
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (PFTableViewCellReload && [self getHeightAtIndexPath:indexPath]) {//重设尺寸
        CGRect frame = self.frame;
        frame.size.height = [self getHeightAtIndexPath:indexPath];
        self.frame = frame;
    }
}

#pragma mark -

/**
 * View
 */
//是否显示内容页的setter方法
- (void)setFirstContentViewShow:(BOOL)firstContentViewShow
{
    _firstContentViewShow = firstContentViewShow;
    if (firstContentViewShow && !_firstContentView) {
        _firstContentView = [[UIView alloc] init];
        [self addSubview:_firstContentView];
    }
}

//是否显示内容页的setter方法
- (void)setSecondContentViewShow:(BOOL)secondContentViewShow
{
    _secondContentViewShow = secondContentViewShow;
    if (secondContentViewShow && !_secondContentView) {
        _secondContentView = [[UIView alloc] init];
        [self addSubview:_secondContentView];
    }
}

//是否显示分割线的setter方法
- (void)setLineShow:(BOOL)lineShow
{
    _lineShow = lineShow;
    if (lineShow && !line) {
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        [self addSubview:line];
    }
}

#pragma mark -

/**
 * Button
 */
//按钮类型的setter方法
- (void)setFirstButtonType:(UIButtonType)firstButtonType
{
    _firstButtonType = firstButtonType;
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:firstButtonType];
        _firstButton.tag = 1;
        [_firstButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_firstButton];
    }
}

//按钮类型的setter方法
- (void)setSecondButtonType:(UIButtonType)secondButtonType
{
    _secondButtonType = secondButtonType;
    if (!_secondButton) {
        _secondButton = [UIButton buttonWithType:secondButtonType];
        _secondButton.tag = 2;
        [_secondButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_secondButton];
    }
}

//按钮类型的setter方法
- (void)setThirdButtonType:(UIButtonType)thirdButtonType
{
    _thirdButtonType = thirdButtonType;
    if (!_thirdButton) {
        _thirdButton = [UIButton buttonWithType:thirdButtonType];
        _thirdButton.tag = 3;
        [_thirdButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_thirdButton];
    }
}

#pragma mark -

/**
 * Image
 */
//是否显示图片的setter方法
- (void)setFirstImageViewShow:(BOOL)firstImageViewShow
{
    _firstImageViewShow = firstImageViewShow;
    if (firstImageViewShow && !_firstImageView) {
        _firstImageView = [[BeeUIImageView alloc] init];
        _firstImageView.tag = 1;
        [self addSubview:_firstImageView];
    }
}

//图片缓存地址的setter方法
- (void)setFirstImageViewUrl:(NSString *)firstImageViewUrl
{
    if (![firstImageViewUrl isEqualToString:_firstImageViewUrl])
    {
        _firstImageViewUrl = firstImageViewUrl;
        [self.firstImageView GET:firstImageViewUrl useCache:YES];
    }
}

//是否显示图片的setter方法
- (void)setSecondImageViewShow:(BOOL)secondImageViewShow
{
    _secondImageViewShow = secondImageViewShow;
    if (secondImageViewShow && !_secondImageView) {
        _secondImageView = [[BeeUIImageView alloc] init];
        _secondImageView.tag = 2;
        [self addSubview:_secondImageView];
    }
}

//图片缓存地址的setter方法
- (void)setSecondImageViewUrl:(NSString *)secondImageViewUrl
{
    _secondImageViewUrl = secondImageViewUrl;
    [_secondImageView GET:secondImageViewUrl useCache:NO];
}

//是否显示图片的setter方法
- (void)setThirdImageViewShow:(BOOL)thirdImageViewShow
{
    _thirdImageViewShow = thirdImageViewShow;
    if (thirdImageViewShow && !_thirdImageView) {
        _thirdImageView = [[BeeUIImageView alloc] init];
        _thirdImageView.tag = 3;
        [self addSubview:_thirdImageView];
    }
}

//图片缓存地址的setter方法
- (void)setThirdImageViewUrl:(NSString *)thirdImageViewUrl
{
    _thirdImageViewUrl = thirdImageViewUrl;
    [_thirdImageView GET:thirdImageViewUrl useCache:NO];
}

#pragma mark -

/**
 * Label
 */
//是否显示文本的setter方法
- (void)setFirstTextLabelShow:(BOOL)firstTextLabelShow
{
    _firstTextLabelShow = firstTextLabelShow;
    if (firstTextLabelShow && !_firstTextLabel) {
        _firstTextLabel = [[UILabel alloc] init];
        [self addSubview:_firstTextLabel];
    }
}

//是否显示文本的setter方法
- (void)setSecondTextLabelShow:(BOOL)secondTextLabelShow
{
    _secondTextLabelShow = secondTextLabelShow;
    if (secondTextLabelShow && !_secondTextLabel) {
        _secondTextLabel = [[UILabel alloc] init];
        [self addSubview:_secondTextLabel];
    }
}

//是否显示文本的setter方法
- (void)setThirdTextLabelShow:(BOOL)thirdTextLabelShow
{
    _thirdTextLabelShow = thirdTextLabelShow;
    if (thirdTextLabelShow && !_thirdTextLabel) {
        _thirdTextLabel = [[UILabel alloc] init];
        [self addSubview:_thirdTextLabel];
    }
}

//是否显示文本的setter方法
- (void)setFourthTextLabelShow:(BOOL)fourthTextLabelShow
{
    _fourthTextLabelShow = fourthTextLabelShow;
    if (fourthTextLabelShow && !_fourthTextLabel) {
        _fourthTextLabel = [[UILabel alloc] init];
        [self addSubview:_fourthTextLabel];
    }
}

//是否显示文本的setter方法
- (void)setFifthTextLabelShow:(BOOL)fifthTextLabelShow
{
    _fifthTextLabelShow = fifthTextLabelShow;
    if (fifthTextLabelShow && !_fifthTextLabel) {
        _fifthTextLabel = [[UILabel alloc] init];
        [self addSubview:_fifthTextLabel];
    }
}

#pragma mark - Private Methods

//加载子视图（私人定制）（系统方法）
//设置视图（此方法会被执行多次，当横竖屏切换时可通过此方法调整布局）
- (void)layoutSubviews
{
    if (!self.indexPath) {//若序号为空，则返回
        NSLog(@"property 'indexPath' is nil");
        return;
    }

//    if (canLoadSubviews) {

    //内容页
    if (!_firstContentView) [_firstContentView removeFromSuperview], _firstContentView = nil;
    if (!_secondContentView) [_secondContentView removeFromSuperview], _secondContentView = nil;

    //分割线
    if (line) {
        line.frame = _lineFrame;
        if (_lineColor) line.backgroundColor = _lineColor;
    } else [line removeFromSuperview], line = nil;

    //按钮
    if (!_firstButton) [_firstButton removeFromSuperview], _firstButton = nil;
    if (!_secondButton) [_secondButton removeFromSuperview], _secondButton = nil;
    if (!_thirdButton) [_thirdButton removeFromSuperview], _thirdButton = nil;

    //图片
    if (!_firstImageView) [_firstImageView removeFromSuperview], _firstImageView = nil;
    if (!_secondImageView) [_secondImageView removeFromSuperview], _secondImageView = nil;
    if (!_thirdImageView) [_thirdImageView removeFromSuperview], _thirdImageView = nil;

    //文本
    if (!_firstTextLabel) [_firstTextLabel removeFromSuperview], _firstTextLabel = nil;
    if (!_secondTextLabel) [_secondTextLabel removeFromSuperview], _secondTextLabel = nil;
    if (!_thirdTextLabel) [_thirdTextLabel removeFromSuperview], _thirdTextLabel = nil;
    if (!_fourthTextLabel) [_fourthTextLabel removeFromSuperview], _fourthTextLabel = nil;
    if (!_fifthTextLabel) [_fifthTextLabel removeFromSuperview], _fifthTextLabel = nil;

    if (self.secondTextLabel.userInteractionEnabled) {
        UILongPressGestureRecognizer *lo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(textLabelTouch:)];
        [self.secondTextLabel addGestureRecognizer:lo];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textLabelTouch:)];
        tap.numberOfTapsRequired = 2;
        [self.secondTextLabel addGestureRecognizer:tap];
    }

    //手势
    if (!recognizer) recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
    if (self.useTapGestureRecognizer) [self addGestureRecognizer:recognizer];
    recognizer = nil;
    if (!recognizer) recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouch:)];
    if (_firstImageView.userInteractionEnabled) [_firstImageView addGestureRecognizer:recognizer];
    recognizer = nil;
    if (!recognizer) recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouch:)];
    if (_secondImageView.userInteractionEnabled) [_secondImageView addGestureRecognizer:recognizer];
    recognizer = nil;
    if (!recognizer) recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouch:)];
    if (_thirdImageView.userInteractionEnabled) [_thirdImageView addGestureRecognizer:recognizer];
    recognizer = nil;
//    }

    //加载完成
    if ([self.delegate respondsToSelector:@selector(tableViewCellLoadedAtIndexPath:)]) {//监听代理并回调
        [self.delegate tableViewCellLoadedAtIndexPath:self.indexPath];
    } else if (self.loadedBlock) {//监听块并回调
        self.loadedBlock(self.indexPath);
    }
}

//获取指定列表的高度
- (CGFloat)getHeightAtIndexPath:(NSIndexPath *)indexPath
{
    //提取高度
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.index.%d", indexPath.row]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter numberFromString:string];
    CGFloat height = number.floatValue;

    //释放对象
    userDefaults = nil, string = nil, formatter = nil, number = nil;

    //返回高度
    return height;
}
/*
- (CGFloat)getOnsetHeightAtIndexPath:(NSIndexPath *)indexPath
{
    //提取高度
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.onset.index.%d", indexPath.row]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter numberFromString:string];
    CGFloat onsetHeight = number.floatValue;

    //释放对象
    userDefaults = nil, string = nil, formatter = nil, number = nil;

    //返回高度
    return onsetHeight;
}

//获取指定列表的重置高度
- (CGFloat)getResetHeightAtIndexPath:(NSIndexPath *)indexPath
{
    //提取高度
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.reset.index.%d", indexPath.row]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter numberFromString:string];
    CGFloat resetHeight = number.floatValue;

    //释放对象
    userDefaults = nil, string = nil, formatter = nil, number = nil;

    //返回高度
    return resetHeight;
}
*/
#pragma mark - Public Methods

//设置总数
+ (void)heightSettingsCount:(NSInteger)count
{
    //保存总数
    NSNumber *number = [NSNumber numberWithInteger:count];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:number forKey:@"PFLib.PFTableViewCell.height.index.sum"];

    //释放对象
    number = nil, userDefaults = nil;
}

//获取高度
+ (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath
{
    if (PFTableViewCellReload) {//重新加载
        PFTableViewCell *cell = [[PFTableViewCell alloc] init];
        if ([cell getHeightAtIndexPath:indexPath]) return [cell getHeightAtIndexPath:indexPath];
        else return 0;
    } else return 0;
}

//重设高度
+ (void)setHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    //保存高度
    NSNumber *number = [NSNumber numberWithFloat:height];
    NSString *string = [NSString stringWithFormat:@"%@", number];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.index.%d", indexPath.row]];

    //释放对象
    number = nil, string = nil, userDefaults = nil;
}
/*
//重设高度
+ (void)onsetHeight:(CGFloat)onsetHeight resetHeight:(CGFloat)resetHeight atIndexPath:(NSIndexPath *)indexPath;
{
    //保存起始高度
    NSNumber *number = [NSNumber numberWithFloat:onsetHeight];
    NSString *string = [NSString stringWithFormat:@"%@", number];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.onset.index.%d", indexPath.row]];

    //保存重置高度
    number = [NSNumber numberWithFloat:resetHeight];
    string = [NSString stringWithFormat:@"%@", number];
    [userDefaults setObject:string forKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.reset.index.%d", indexPath.row]];

    //释放对象
    number = nil, string = nil, userDefaults = nil;
}
*/
//移除高度
+ (void)removeAllHeightSettings
{
    //提取总数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"PFLib.PFTableViewCell.height.index.sum"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter numberFromString:[NSString stringWithFormat:@"%@", string]];
    NSInteger sum = number.integerValue;

    //移除
    for (int index = 0; index < sum; index++) {
        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.index.%d", index]];
//        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.onset.index.%d", index]];
//        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.reset.index.%d", index]];
    } [userDefaults removeObjectForKey:@"PFLib.PFTableViewCell.height.index.sum"];

    //释放对象
    userDefaults = nil, string = nil, formatter = nil, number = nil;
}

//设置圆形图片
- (void)setRoundedImageView:(UIImageView *)imageView
{
    [self setRoundedImageView:imageView borderWidth:1 borderColor:[UIColor whiteColor]];
}

//设置圆形图片
- (void)setRoundedImageView:(UIImageView *)imageView borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.bounds) / 2;
    imageView.layer.borderWidth = borderWidth;
    imageView.layer.borderColor = borderColor.CGColor;
}

#pragma mark -

//加载完成
- (void)tableViewCellLoadedAtIndexPathUsingBlock:(void (^)(NSIndexPath *))block
{
    if (block) self.loadedBlock = block, block = nil;
}

//点击
- (void)didSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *))block
{
    if (block) self.touchBlock = block, block = nil;
}

//按钮点击
- (void)buttonDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *, NSInteger))block
{
    if (block) self.buttonTouchBlock = block, block = nil;
}

//图片点击
- (void)imageViewDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *, NSInteger))block
{
    if (block) self.imageViewTouchBlock = block, block = nil;
}

- (void)textLabelDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *, UIGestureRecognizer *, UIView *))block
{
    if (block) self.textLabelTouchBlock = block, block = nil;
}

#pragma mark - Events Management

//点击事件
- (void)touch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didSelectRowAtIndexPath:)]) {//监听代理并回调
        [self.delegate tableViewCell:self didSelectRowAtIndexPath:self.indexPath];
    } else if (self.touchBlock) {//监听块并回调
        self.touchBlock(self, self.indexPath);
    }
}

//按钮点击事件
- (void)buttonTouch:(UIControl *)control
{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:buttonDidSelectRowAtIndexPath:controlIndex:)]) {//监听代理并回调
        [self.delegate tableViewCell:self buttonDidSelectRowAtIndexPath:self.indexPath controlIndex:control.tag];
    } else if (self.buttonTouchBlock) {//监听块并回调
        self.buttonTouchBlock(self, self.indexPath, control.tag);
    }
}

//图片点击事件
- (void)imageViewTouch:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:imageViewDidSelectRowAtIndexPath:controlIndex:)]) {//监听代理并回调
        [self.delegate tableViewCell:self imageViewDidSelectRowAtIndexPath:self.indexPath controlIndex:tapGestureRecognizer.view.tag];
    } else if (self.imageViewTouchBlock) {//监听块并回调
        self.imageViewTouchBlock(self, self.indexPath, tapGestureRecognizer.view.tag);
    }
}

- (void)textLabelTouch:(UIGestureRecognizer *)tapGestureRecognizer
{
    if (self.textLabelTouchBlock) {
        self.textLabelTouchBlock(self, _indexPath, tapGestureRecognizer, tapGestureRecognizer.view);
    }
}

#pragma mark - Memory Management

- (void)dealloc
{
#if __has_feature(objc_arc)
    self.touchBlock             = nil;
    self.buttonTouchBlock       = nil;
    self.imageViewTouchBlock    = nil;

    self.delegate               = nil;
#else
#endif
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
