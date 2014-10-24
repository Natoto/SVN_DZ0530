//
//  WaterFCell.m
//  CollectionView
//
//  Created by d2space on 14-2-26.
//  Copyright (c) 2014年 D2space. All rights reserved.
//
#import "E0_AblumWaterFLayout.h"
#import "E0_AblumWaterFCell.h"
#import "ToolsFunc.h"

@interface E0_AblumWaterFCell()
@property(nonatomic,retain)UILabel *line;
@property(nonatomic,retain)UIButton * replyicon;
@property(nonatomic,retain)UIButton * viewicon;
@end

@implementation E0_AblumWaterFCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
//        self.layer.cornerRadius = 0.0;
//        self.layer.borderWidth = 0.5f;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}
#pragma mark - Setup
- (void)setup
{
    [self setupView];
    [self setupTextView];
}

- (void)setupView
{
    self.imageView =  [[BeeUIImageView alloc]  initWithFrame:CGRectMake(0,0,0,0)]; 
    self.imageView.layer.cornerRadius = 0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 0;
    self.imageView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.imageView];
}

- (void)setupTextView
{
    [self textView];
//    self.textView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
//    self.textView.layer.cornerRadius = 0;
//    self.textView.layer.masksToBounds = YES;
//    self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.textView.layer.borderWidth = 0;
//    self.textView.textColor = [UIColor blackColor];
//    self.textView.backgroundColor = [UIColor clearColor];
//    self.textView.font = [UIFont systemFontOfSize:14.0];
//    [self addSubview:self.textView];
}

-(BeeUILabel *)textView
{
    if (!_textView) {
        _textView = [ToolsFunc CreateBeeLabelWithFrame:CGRectZero andTxt:@""];
        _textView.verticalAlignment = VerticalAlignmentMiddle;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_textView];
    }
    return _textView;
}

+(float)heightOfBottom:(NSString *)TXT
{
    float width = [E0_AblumWaterFLayout cellwidth];
    UILabel *LABEL = [ToolsFunc CreateLabelWithFrame:CGRectZero andTxt:@""];
    LABEL.frame = CGRectMake(0, 0, width, 30);
    LABEL.numberOfLines = 0;
    LABEL.lineBreakMode = NSLineBreakByWordWrapping;
    LABEL.text = TXT;
    [LABEL sizeToFit];
    return LABEL.frame.size.height + 1 + 20;
}
-(UILabel *)lbllouzhu
{
    if (!_lbllouzhu) {
        _lbllouzhu =[ToolsFunc CreateLabelWithFrame:CGRectZero andTxt:@"楼主" fontsize:12];
        [self addSubview:_lbllouzhu];
        _lbllouzhu.textColor = [UIColor grayColor];
    }
    return _lbllouzhu;
}
-(UILabel *)lblreply
{
    if (!_lblreply) {
        _lblreply = [ToolsFunc CreateLabelWithFrame:CGRectZero andTxt:@"回复" fontsize:12];
        _lblreply.textAlignment = NSTextAlignmentRight;
        _lblreply.textColor = [UIColor grayColor];
        [self addSubview:_lblreply];
    }
    return _lblreply;
}

-(UILabel *)lblview
{
    if (!_lblview) {
        _lblview = [ToolsFunc CreateLabelWithFrame:CGRectZero andTxt:@"查看" fontsize:12];
        _lblview.textAlignment = NSTextAlignmentRight;
        _lblview.textColor = [UIColor grayColor];
        [self addSubview:_lblview];
    }
    return _lblview;
}

-(UIButton *)replyicon
{
    if (!_replyicon) {
        _replyicon =[ToolsFunc CreateButtonWithFrame:CGRectZero andimage:@"huitei"];
        //[ToolsFunc CreateImageViewWithFrame:CGRectZero andImgName:@"huitei"];
        [self addSubview:_replyicon];
    }
    return _replyicon;
}

-(UIButton *)viewicon
{
    if (!_viewicon) {
        _viewicon = [ToolsFunc CreateButtonWithFrame:CGRectZero andimage:@"chakan"];
        [self addSubview:_viewicon];
    }
    return _viewicon;
}

-(UILabel *)line
{
    if (!_line) {
        _line = [ToolsFunc CreateLabelWithFrame:CGRectMake(0, self.height-30, self.width, 0.5) andTxt:@""];
        _line.backgroundColor = [UIColor clearColor];
        [self addSubview:_line];
    }
    return _line;
}

-(void)layoutSubviews
{
    [self line];
    [self viewicon];
    [self replyicon];
    [self lblview];
    [self lbllouzhu];
    [self lblreply];
    float LEFT = 5.0;    
    self.line.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 21, self.width, 0.5);
    self.textView.frame = CGRectMake(LEFT, CGRectGetMinY(self.line.frame) - 40, self.width-2*LEFT, 40);
//    [self.textView sizeToFit];
    
    self.lbllouzhu.frame = CGRectMake(LEFT, CGRectGetMaxY(self.line.frame), 60, 20);
//    [self.lbllouzhu sizeToFit];
    
    //真实的长度，并且右对齐
    self.lblreply.frame = CGRectMake(self.width - LEFT - 20, CGRectGetMaxY(self.line.frame), 25, 20);
    [self.lblreply sizeToFit];
    float realwidth = self.lblreply.frame.size.width;
    float weidiaox = self.width - LEFT - realwidth;
    self.lblreply.frame = CGRectMake(weidiaox, CGRectGetMaxY(self.line.frame), realwidth, 20);
    
    self.replyicon.frame = CGRectMake(CGRectGetMinX(self.lblreply.frame)-20, CGRectGetMaxY(self.line.frame), 20, 20);
    
    self.lblview.frame = CGRectMake(CGRectGetMinX(self.replyicon.frame) - 25, CGRectGetMaxY(self.line.frame), 25, 20);
    [self.lblview sizeToFit];
    realwidth = self.lblview.frame.size.width;
    weidiaox =CGRectGetMinX(self.replyicon.frame) - realwidth;
    self.lblview.frame = CGRectMake(weidiaox, CGRectGetMaxY(self.line.frame), realwidth, 20);
    
    self.viewicon.frame = CGRectMake(CGRectGetMinX(self.lblview.frame)-20, CGRectGetMaxY(self.line.frame), 20, 20);
    
    if (self.lblreply.text.integerValue > 999) {
        self.lblreply.text = @"999+";
    }
    if (self.lblview.text.integerValue > 999) {
        self.lblview.text = @"999+";
    }
    if ([self.lbllouzhu.text isEqualToString:@"(null)"]) {
        self.lbllouzhu.text = @"匿名";
    }
}

//#pragma mark - Configure
//- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
//{
//    self.textView.text = [NSString stringWithFormat:@"Cell %ld", (long)(indexPath.row + 1)];
//}

@end
