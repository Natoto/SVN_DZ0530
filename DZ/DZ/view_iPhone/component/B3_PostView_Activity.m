//
//  B3_PostView_Activity.m
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//
#import "SettingModel.h"
#import "B3_PostView_Activity.h"
#import "CreateComponent.h"
#define CELL_START_TAG 190814
#define APPLYBTN_HEIGHT 45.0

@interface B3_PostView_Activity()
{
    UIScrollView *scrollview;
    UIButton * closebtn;
}
@end

@implementation B3_PostView_Activity
@synthesize activityContent = _activityContent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithWhite:0.2 alpha:0.7];
//        self.alpha = 1;[UIColor clearColor];//
        CGRect rect =frame;
        rect.origin.y = 0.0;
        self.contentView = [self checkinView:rect];
//        self.contentView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        [self addSubview:_contentView];
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGRect frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
    self.contentView.frame = frame;
    scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + APPLYBTN_HEIGHT);
}
-(IBAction)gestureTap:(id)sender
{
//    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(DZ_PopupBox:MaskViewDidTaped:)])
//    {
//        [self.ppboxdelegate DZ_PopupBox:self MaskViewDidTaped:self];
//    }
}

/*
 0：已参加，等待审核
 2：资料需完善 (暂未通过)
 1： 已批准
*/

-(void)setActivityContent:(content *)activityContent
{ 
    _activityContent = activityContent;
    if ([_activityContent.isclose isEqualToString:@"1"])
    {
        [_applyButton setBackgroundColor:[UIColor grayColor]];
        [_applyButton setTitle:@"已关闭" forState:UIControlStateNormal];
        _applyButton.enabled = NO;
    }
    else
    {
        _applyButton.enabled = YES;
        if ([_activityContent.applied isEqualToString:@"0"]) {
            UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
            [_applyButton setBackgroundColor:color];
            [_applyButton setTitle:@"等待审核..." forState:UIControlStateNormal];
        }
        else if ([_activityContent.applied isEqualToString:@"2"]) {
            UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
            [_applyButton setBackgroundColor:color];
            [_applyButton setTitle:@"资料需完善" forState:UIControlStateNormal];
        }
        else if ([_activityContent.applied isEqualToString:@"1"]) {
            UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
            [_applyButton setBackgroundColor:color];
            [_applyButton setTitle:@"已批准" forState:UIControlStateNormal];
        }
        else if ([_activityContent.applied isEqualToString:@""]) {
            UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
            [_applyButton setBackgroundColor:color];
            [_applyButton setTitle:@"我要报名" forState:UIControlStateNormal];
        }
    }
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    titlelabel.text =title;
}

-(UIView *)checkinView:(CGRect )frame
{
    if (!_contentView) {
        UIView *view=[[UIView alloc] initWithFrame:frame];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor whiteColor];
        titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titlelabel.backgroundColor =[UIColor clearColor];
        [view addSubview:titlelabel];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *line=[self line:CGRectMake(CGRectGetMinX(titlelabel.frame), CGRectGetMaxY(titlelabel.frame) - 1, CGRectGetWidth(titlelabel.frame), LINE_LAYERBOARDWIDTH)];
        [view addSubview:line];
        _contentView = view;
    }
    return _contentView;
}

-(UIButton *)applyButton
{
    if (!_applyButton)
    {
        _applyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_applyButton setTitle:@"我要报名" forState:UIControlStateNormal];
        _applyButton.frame = CGRectMake(0, 0, 280, APPLYBTN_HEIGHT);
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_applyButton.layer setCornerRadius:2.0];
        UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
        
        [_applyButton setBackgroundColor:color];
        [_applyButton addTarget:self action:@selector(applybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:_applyButton];
    }
    return _applyButton;
}

-(void)applybtnTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(B3_PostView_Activity:applyButtonTaped:)])
    {
        [self.ppboxdelegate B3_PostView_Activity:self applyButtonTaped:self.activityContent];
    }
}

-(UIView *)line:(CGRect)frame
{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = LINE_LAYERBOARD_NOTCGCOLOR;
    view.frame = frame;
    return view;
}
#pragma mark - 加载数据

-(void)loadDatas:(NSMutableDictionary *)diction
{
    scrollview = [self scrollview];
//    NSArray * allkeys = diction.allKeys;
    NSArray * allKeys =[NSArray arrayWithObjects:@"活动类型",@"活动时间",@"活动截止",@"活动地点",@"性别",@"每人花销",@"已报名人数",@"报名截止", nil];
    int  index =0;
    for ( NSString *key in allKeys) {
        NSString *value =[diction valueForKey:key];
        if (!value) {
            continue;
        }
        if ([key isEqualToString:@"性别"]) {
            if (!value || [value isEqualToString:@"0"]) {
                value = @"不限";
            }
            else if ([value isEqualToString:@"1"]) {
                value = @"男";
            }
            else if ([value isEqualToString:@"2"]) {
                value = @"女";
            }
        }
        [self createCell:key value:value index:index];
        index ++;
    }
    if (self.applyButton) {
        _applyButton.center = CGPointMake(320.0/2, (diction.allKeys.count)*40.+ APPLYBTN_HEIGHT/2 + 5);
        scrollview.contentSize = CGSizeMake(320, CGRectGetMaxY(_applyButton.frame));
    }
}

+(float)heightOfView:(int)rows
{
    return 40 * (rows) + APPLYBTN_HEIGHT + 10;
}

-(void)createCell:(NSString *)key value:(NSString *)value index:(int)index
{
    float HEIGHT =40;
    float WIDTH = _contentView.frame.size.width - 20;
    BeeUILabel *label =(BeeUILabel *)[scrollview viewWithTag: CELL_START_TAG + index];
    if (!label) {
        label = [[BeeUILabel alloc] initWithFrame:CGRectMake(10, index *HEIGHT -1, WIDTH , HEIGHT)];
        label.tag = CELL_START_TAG + index;
        [scrollview addSubview:label];
        scrollview.contentSize = CGSizeMake(WIDTH, (index +1) * HEIGHT);
        UIView *line=[self line:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) - 1, CGRectGetWidth(label.frame), LINE_LAYERBOARDWIDTH)];
        [scrollview addSubview:line];
        label.verticalAlignment = VerticalAlignmentMiddle;//垂直居中
        float fontsize=[SettingModel sharedInstance].fontsize;
        label.font = [UIFont systemFontOfSize:fontsize];
    }
    NSString *text=[NSString stringWithFormat:@"%@ : %@",key,value];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
    int LENGTH= key.length + 2;
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]
                        range:NSMakeRange(0, LENGTH)];
    //把后面的变为绿色
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(LENGTH, text.length - LENGTH)];
    
    label.attributedText = attriString;
}

-(UIScrollView *)scrollview
{
    if (!scrollview) {
        UIScrollView *scrview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame), CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + APPLYBTN_HEIGHT)];
        scrollview = scrview;
        [_contentView addSubview:scrview];
    }
    scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + APPLYBTN_HEIGHT);
    return scrollview;
}
- (void)show
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)hide
{
    [self removeFromSuperview];
}
@end
