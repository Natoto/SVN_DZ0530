//
//  PFTableViewCell.m
//  PFTableViewCell
//
//  Created by PFei_He on 14-11-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFTableViewCell.h"

#define kSetupContentView(view, BACKGROUNDCOLOR)\
view = [[UIView alloc] init];\
view.backgroundColor = BACKGROUNDCOLOR;\
[self addSubview:view];\

#define kSetupButton(button, TAG)\
button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.tag = TAG;\
[self addSubview:button];

#define kSetupImageView(imageView, TAG)\
imageView = [[BeeUIImageView alloc] init];\
imageView.tag = TAG;\
[self addSubview:imageView];

#define kSetupTextLabel(textLabel)\
textLabel = [[UILabel alloc] init];\
[self addSubview:textLabel];

#define kSetupGestureRecognizer(recognizer, METHOD, view)\
recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(METHOD)];\
[view addGestureRecognizer:recognizer];\
recognizer = nil;

#define kRemoveComponent(view)\
[view removeFromSuperview], view = nil;

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
@property (nonatomic, copy) controlTouchBlock           buttonBlock;

///自定义图片点击事件
@property (nonatomic, copy) controlTouchBlock           imageViewBlock;

///自定义图片点击事件
@property (nonatomic, copy) controlTouchBlock2          textLabelBlock;

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

        //设置组件
        [self setupComponent];
    }
    return self;
}

#pragma mark - Property Methods

//序号的setter方法
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (PFTableViewCellReload && [PFTableViewCell getHeightAtIndexPath:indexPath]) {//重设尺寸
        CGRect frame = self.frame;
        frame.size.height = [PFTableViewCell getHeightAtIndexPath:indexPath];
        self.frame = frame;
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

//图片缓存地址的setter方法
//- (void)setSecondImageViewUrl:(NSString *)secondImageViewUrl
//{
//    _secondImageViewUrl = secondImageViewUrl;
//    [_secondImageView GET:secondImageViewUrl useCache:NO];
//}

#pragma mark - Private Methods

//加载子视图（私人定制）（系统方法）
//设置视图（此方法会被执行多次，当横竖屏切换时可通过此方法调整布局）
- (void)layoutSubviews
{
    if (!self.indexPath) {//若序号为空，则返回
        NSLog(@"property 'indexPath' is nil");
        return;
    }

    //移除组件
    [self removeComponent];

    //设置手势
    [self setupGestureRecognizer];

    //加载完成
    if ([self.delegate respondsToSelector:@selector(tableViewCellLoadedAtIndexPath:)]) {//监听代理并回调
        [self.delegate tableViewCellLoadedAtIndexPath:self.indexPath];
    } else if (self.loadedBlock) {//监听块并回调
        self.loadedBlock(self.indexPath);
    }
}

//设置组件
- (void)setupComponent
{
    kSetupContentView(line, [UIColor colorWithWhite:0.8f alpha:1.0f])
    kSetupContentView(_firstContentView, nil)
    kSetupContentView(_secondContentView, nil)
    kSetupButton(_firstButton, 1)
    kSetupButton(_secondButton, 2)
    kSetupImageView(_firstImageView, 1)
    kSetupImageView(_secondImageView, 2)
    kSetupTextLabel(_firstTextLabel)
    kSetupTextLabel(_secondTextLabel)
    kSetupTextLabel(_thirdTextLabel)
    kSetupTextLabel(_fourthTextLabel)
    kSetupTextLabel(_fifthTextLabel)
}

//移除组件
- (void)removeComponent
{
    if (!_lineShow) {//分割线
        kRemoveComponent(line)
    } else {
        line.frame = _lineFrame;
        if (_lineColor) line.backgroundColor = _lineColor;
    }
    if (!_firstContentViewShow)     kRemoveComponent(_firstContentView)
    if (!_secondContentViewShow)    kRemoveComponent(_secondContentView)

    if (!_firstButtonShow)          kRemoveComponent(_firstButton)
    else [_firstButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    if (!_secondButtonShow)         kRemoveComponent(_secondButton)
    else [_secondButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];

    if (!_firstImageViewShow)       kRemoveComponent(_firstImageView)
    if (!_secondImageViewShow)      kRemoveComponent(_secondImageView)

    if (!_firstTextLabelShow)       kRemoveComponent(_firstTextLabel)
    if (!_secondTextLabelShow)      kRemoveComponent(_secondTextLabel)
    if (!_thirdTextLabelShow)       kRemoveComponent(_thirdTextLabel)
    if (!_fourthTextLabel)          kRemoveComponent(_fourthTextLabel)
    if (!_fifthTextLabel)           kRemoveComponent(_fifthTextLabel)
}

//设置手势
- (void)setupGestureRecognizer
{
    if (self.useTapGestureRecognizer)            {kSetupGestureRecognizer(recognizer, touch:, self)}
    if (_firstImageView.userInteractionEnabled)  {kSetupGestureRecognizer(recognizer, imageViewTouch:, _firstImageView)}
    if (_secondImageView.userInteractionEnabled) {kSetupGestureRecognizer(recognizer, imageViewTouch:, _secondImageView)}
//    if (_firstTextLabel.userInteractionEnabled)     kSetupGestureRecognizer(recognizer, textLabelTouch:, _firstTextLabel)
//    if (_secondTextLabel.userInteractionEnabled)    kSetupGestureRecognizer(recognizer, textLabelTouch:, _secondTextLabel)

//    if (self.secondTextLabel.userInteractionEnabled) {
//        UILongPressGestureRecognizer *lo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(textLabelTouch:)];
//        [self.secondTextLabel addGestureRecognizer:lo];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textLabelTouch:)];
//        tap.numberOfTapsRequired = 2;
//        [self.secondTextLabel addGestureRecognizer:tap];
//    }
}

//获取指定列表的高度
+ (CGFloat)getHeightAtIndexPath:(NSIndexPath *)indexPath
{
    //提取高度
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:[NSString stringWithFormat:@"PFLib.PFTableViewCell.height.index.%d", indexPath.row]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter numberFromString:string];
    CGFloat height = number.floatValue;

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
}

//获取高度
+ (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath
{
    if (PFTableViewCellReload) {//重新加载
        if ([PFTableViewCell getHeightAtIndexPath:indexPath]) return [PFTableViewCell getHeightAtIndexPath:indexPath];
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
- (void)tableViewCellLoadedUsingBlock:(void (^)(NSIndexPath *))block
{
    if (block) self.loadedBlock = block, block = nil;
}

//点击
- (void)didSelectRowUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *))block
{
    if (block) self.touchBlock = block, block = nil;
}

//按钮点击
- (void)buttonTouchUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *, NSInteger))block
{
    if (block) self.buttonBlock = block, block = nil;
}

//图片点击
- (void)imageViewTouchUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *, NSInteger))block
{
    if (block) self.imageViewBlock = block, block = nil;
}

- (void)textLabelDidSelectRowAtIndexPathUsingBlock:(void (^)(PFTableViewCell *, NSIndexPath *, UIGestureRecognizer *, UIView *))block
{
    if (block) self.textLabelBlock = block, block = nil;
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
    if ([self.delegate respondsToSelector:@selector(tableViewCell:buttonTouchAtIndexPath:controlIndex:)]) {//监听代理并回调
        [self.delegate tableViewCell:self buttonTouchAtIndexPath:self.indexPath controlIndex:control.tag];
    } else if (self.buttonBlock) {//监听块并回调
        self.buttonBlock(self, self.indexPath, control.tag);
    }
}

//图片点击事件
- (void)imageViewTouch:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:imageViewTouchAtIndexPath:controlIndex:)]) {//监听代理并回调
        [self.delegate tableViewCell:self imageViewTouchAtIndexPath:self.indexPath controlIndex:tapGestureRecognizer.view.tag];
    } else if (self.imageViewBlock) {//监听块并回调
        self.imageViewBlock(self, self.indexPath, tapGestureRecognizer.view.tag);
    }
}

- (void)textLabelTouch:(UIGestureRecognizer *)tapGestureRecognizer
{
    if (self.textLabelBlock) {
        self.textLabelBlock(self, _indexPath, tapGestureRecognizer, tapGestureRecognizer.view);
    }
}

#pragma mark - Memory Management

- (void)dealloc
{
#if __has_feature(objc_arc)
    self.touchBlock = nil, self.buttonBlock = nil, self.imageViewBlock = nil, self.delegate = nil;
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
