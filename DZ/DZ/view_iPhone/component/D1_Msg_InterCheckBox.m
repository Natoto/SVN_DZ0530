//
//  D1_Msg_InterCheckBox.m
//  DZ
//
//  Created by Nonato on 14-8-22.
//
//

#import "D1_Msg_InterCheckBox.h"
#import "CreateComponent.h"
#import "SettingModel.h"

#define CELL_START_TAG 140822
#define APPLYBTN_HEIGHT_IW 35.0
#define APPLYBTN_WIDTH_IW 60.0
//#define PAYMENTVIEW_HEIGHT 80.0
#define BELOWHEIGHT 60.0

#define DIANXUANICON @"dianxuan"
#define WEIDIANXUAN  @"weidianxuan"

#define TAG_ZHIFU 115112
#define TAG_COSTSELF 115101


@interface D1_Msg_InterCheckBox()
{
    UIScrollView *scrollview;
    UIButton * closebtn;
}
@property(nonatomic,strong) UIButton * agreeButton;
@property(nonatomic,strong) UIButton * refuseButton;
@property(nonatomic,strong) UIButton * needCompleteButton;
@property(nonatomic,strong) UIView   * paymentView;
@property(nonatomic,strong) NSString * paycount;
@end

@implementation D1_Msg_InterCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        self.alpha = 1;
        
        _iWantapplyDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _iWantapplyTextFieldDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        CGRect rect =[UIScreen mainScreen].bounds;
        self.contentView = [self checkinView:CGRectMake(0, 0, 290, 330)];
        self.contentView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        [self addSubview:_contentView];
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
        [self addGestureRecognizer:gesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(IBAction)gestureTap:(id)sender
{
    /*
     if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(B3_Post_IWantApply:MaskViewDidTaped:)])
     {
        [self.ppboxdelegate B3_Post_IWantApply:self MaskViewDidTaped:self];
     }
     */
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
        view.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:236.0/255. green:237.0/255. blue:244./255 alpha:1];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2.0;
        view.layer.borderColor =[UIColor clearColor].CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 5.0f;
        
        float MARGIN_TOP = 5.0;
        float MARGIN_LEFT = 10.0;
        float MARGIN_RIGHT = 10.0;
        float CLOSEWIDTH = 30;
        
        titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, frame.size.width - MARGIN_LEFT -MARGIN_RIGHT, 40)];
        titlelabel.backgroundColor =[UIColor clearColor];
        [view addSubview:titlelabel];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.textColor = [DZ_SystemSetting sharedInstance].navigationBarColor;
        
        UIView *line=[self line:CGRectMake(CGRectGetMinX(titlelabel.frame), CGRectGetMaxY(titlelabel.frame) - 1, CGRectGetWidth(titlelabel.frame), LINE_LAYERBOARDWIDTH)];
        [view addSubview:line];
        
        closebtn = [CreateComponent CreateButtonWithFrame:CGRectMake(CGRectGetWidth(frame)- CLOSEWIDTH - MARGIN_RIGHT, CGRectGetMinY(titlelabel.frame), CLOSEWIDTH, CLOSEWIDTH) andImage:@"qdguanbi" tag:1844];
        [closebtn addTarget:self action:@selector(closebtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:closebtn];
        
        _contentView = view;
    }
    return _contentView;
}

-(void)closebtnTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(D1_Msg_InterCheckBox:MaskViewDidTaped:)])
    {
        [self.ppboxdelegate D1_Msg_InterCheckBox:self MaskViewDidTaped:self];
    }
}

-(UIView *)line:(CGRect)frame
{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = LINE_LAYERBOARD_NOTCGCOLOR;
    view.frame = frame;
    return view;
}

#pragma mark - 加载数据...
-(void)loadDatas:(NSMutableDictionary *)diction
{
    self.iWantapplyDic = diction;
    NSMutableArray * allkeys = nil;
    //    allkeys = [NSMutableArray arrayWithArray:diction.allKeys];
    allkeys =[NSMutableArray arrayWithObjects:@"申请人",@"申请时间",@"申请状态",@"留言",@"您的附言", nil];
    
    float contentviewheight =(allkeys.count)*40.+ APPLYBTN_HEIGHT_IW + 5  + 10 + APPLYBTN_HEIGHT_IW + CGRectGetMaxY(titlelabel.frame);
    CGRect rect = [UIScreen mainScreen].bounds;
    if ((contentviewheight > rect.size.height - 100)) {
        self.contentView.frame = CGRectMake(0, 0, 280, contentviewheight - 100);
    }
    else
    {
        self.contentView.frame = CGRectMake(0, 0, 280, contentviewheight);
    }
    self.contentView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    scrollview = [self scrollview];
    if (self.paymentView) {
        
    }

//    int  index =0;
    for (int index = 0; index < allkeys.count-1 ;index ++)
    {
        NSString *key = [allkeys objectAtIndex:index];
        NSString *value =[diction valueForKey:key];
        [self createCell:key value:value index:index];
    }
    int index = allkeys.count -1;
    NSString *key = [allkeys objectAtIndex:index];
    NSString *value =[diction valueForKey:key];
    [self createCell:key textvalue:value index:index];
    
    if (self.needCompleteButton) {
        _needCompleteButton.center = CGPointMake(CGRectGetWidth(_contentView.frame)/2, CGRectGetMaxY(scrollview.frame) + 10 + APPLYBTN_HEIGHT_IW/2);
    }
    
    if (self.agreeButton) {
        _agreeButton.center = CGPointMake(10 + APPLYBTN_WIDTH_IW/2, CGRectGetMaxY(scrollview.frame) + APPLYBTN_HEIGHT_IW/2 + 10);
    }
    if (self.refuseButton) {
        _refuseButton.center = CGPointMake(CGRectGetWidth(scrollview.frame)-  APPLYBTN_WIDTH_IW/2 - 10, CGRectGetMaxY(scrollview.frame) + APPLYBTN_HEIGHT_IW/2 + 10);
    }
    // 改变状态
    if ([self.activityContent.check isEqualToString:@"0"]) {
        UIColor *color = [UIColor grayColor];
        [_needCompleteButton setBackgroundColor:color];
        [_agreeButton setBackgroundColor:color];
        [_refuseButton setBackgroundColor:color];
        _needCompleteButton.enabled = NO;
        _agreeButton.enabled = NO;
        _refuseButton.enabled =NO;
        BeeUITextField *textfield = [_iWantapplyTextFieldDic valueForKey:YOUR_WORDS];
        textfield.enabled =NO;
    }
    else
    {
        UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
        [_needCompleteButton setBackgroundColor:color];
        [_agreeButton setBackgroundColor:color];
        [_refuseButton setBackgroundColor:color];
        _needCompleteButton.enabled = YES;
        _agreeButton.enabled = YES;
        _refuseButton.enabled = YES;
        BeeUITextField *textfield = [_iWantapplyTextFieldDic valueForKey:YOUR_WORDS];
        textfield.enabled = YES;
    }
}


#pragma mark - 拒绝
-(UIButton *)refuseButton
{
    if (!_refuseButton) {
        _refuseButton = [self newButton: CGRectMake(0, 0, APPLYBTN_WIDTH_IW, APPLYBTN_HEIGHT_IW) text:@"拒绝" action:@selector(refuseButtonTap:)];
        [_contentView addSubview:_refuseButton];
    }
    return _refuseButton;
}

-(IBAction)refuseButtonTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(D1_Msg_InterCheckBox:refuseButtonTap:)])
    {
        [self.ppboxdelegate D1_Msg_InterCheckBox:self refuseButtonTap:sender];
    }
}


#pragma mark - 同意
-(UIButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = [self newButton: CGRectMake(0, 0,APPLYBTN_WIDTH_IW , APPLYBTN_HEIGHT_IW) text:@"同意" action:@selector(agreeButtonTap:)];
        [_contentView addSubview:_agreeButton];
    }
    return _agreeButton;
}

-(IBAction)agreeButtonTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(D1_Msg_InterCheckBox:agreeButtonTap:)])
    {
        [self.ppboxdelegate D1_Msg_InterCheckBox:self agreeButtonTap:sender];
    }
}

#pragma mark - 需完善
-(UIButton *)needCompleteButton
{
    if (!_needCompleteButton)
    {
        _needCompleteButton = [self newButton:CGRectMake(0, 0, APPLYBTN_WIDTH_IW, APPLYBTN_HEIGHT_IW) text:@"需完善" action: @selector(needCompleteButtonTap:)];
        [_contentView addSubview:_needCompleteButton];
    }
    return _needCompleteButton;
}

-(IBAction)needCompleteButtonTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(D1_Msg_InterCheckBox:needCompleteButtonTap:)])
    {
        [self.ppboxdelegate D1_Msg_InterCheckBox:self needCompleteButtonTap:sender];
    }
}

-(void)createCell:(NSString *)key value:(NSString *)value index:(int)index
{
    float HEIGHT =40;
    float WIDTH = _contentView.frame.size.width - 20;
    UILabel *label =(UILabel *)[scrollview viewWithTag: CELL_START_TAG + index];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, index *HEIGHT -1, WIDTH , HEIGHT)];
        label.tag = CELL_START_TAG + index;
        [scrollview addSubview:label];
        scrollview.contentSize = CGSizeMake(WIDTH, (index +1) * HEIGHT);
        UIView *line=[self line:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) - 1, CGRectGetWidth(label.frame), LINE_LAYERBOARDWIDTH)];
        [scrollview addSubview:line];
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

-(void)createCell:(NSString *)key textvalue:(NSString *)value index:(int)index
{
    float HEIGHT =40;
    float WIDTH = _contentView.frame.size.width - 20;
    BeeUILabel *label =(BeeUILabel *)[scrollview viewWithTag: CELL_START_TAG + index];
    if (!label) {
        label = [[BeeUILabel alloc] initWithFrame:CGRectMake(10, index *HEIGHT -1, WIDTH , HEIGHT)];
        label.tag = CELL_START_TAG + index;
        [scrollview addSubview:label];
        scrollview.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(label.frame));
        UIView *line=[self line:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) - 1, CGRectGetWidth(label.frame), LINE_LAYERBOARDWIDTH)];
        [scrollview addSubview:line];
        label.verticalAlignment = VerticalAlignmentMiddle;
        label.textColor = [UIColor blackColor];
        float fontsize = [SettingModel sharedInstance].fontsize;
        label.font = [UIFont systemFontOfSize:fontsize];
    }
    NSString *localkey=key;
    NSString *text=[NSString stringWithFormat:@"%@ :",localkey];
    label.text = text;
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(label.frame), index *HEIGHT + HEIGHT/2);
    BeeUITextField *textField =(BeeUITextField *)[scrollview viewWithTag: 2*CELL_START_TAG + index];
    if (!textField) {
        textField = [[BeeUITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), index *HEIGHT -1, WIDTH - CGRectGetMaxX(label.frame)-1, HEIGHT)];
        textField.tag = 2*CELL_START_TAG + index;
        textField.placeholder = @"必填";
        UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
        textField.textColor =color;
        textField.returnKeyType = UIReturnKeyNext;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [scrollview addSubview:textField];
    }
    BeeUITextField *tempfield=[_iWantapplyTextFieldDic objectForKey:key];
    if (tempfield) {
        textField.text = tempfield.text;
    }
    else
        textField.text = value;
    [_iWantapplyTextFieldDic setObject:textField forKey:key];
    textField.center = CGPointMake(CGRectGetMidX(textField.frame), index *HEIGHT + HEIGHT/2);
    scrollview.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(textField.frame));
    
}

ON_SIGNAL3(BeeUITextField, WILL_DEACTIVE, signal)
{
   BeeUITextField *textfield = [_iWantapplyTextFieldDic objectForKey:YOUR_WORDS];
   [_iWantapplyDic setObject:textfield.text forKey:YOUR_WORDS];
}
-(UIScrollView *)scrollview
{
    if (!scrollview) {
        UIScrollView *scrview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame), CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) - CGRectGetMaxY(titlelabel.frame) - BELOWHEIGHT)];
        scrollview = scrview;
        [_contentView addSubview:scrview];
    }
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

//-(float)heightOftextviewTowView
//{
//    CGRect  frame = CGRectZero;
//    frame.origin.x = CGRectGetMaxX(_contentView.frame);
//    frame.origin.y = CGRectGetMaxY(_contentView.frame);
//    float height = CGRectGetHeight(self.frame) - frame.origin.y;
//    return height;
//}

-(UIButton *)newButton:(CGRect )frame text:(NSString *)text action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:text forState:UIControlStateNormal];
    button.frame = frame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
    [button setBackgroundColor:color];
    [button.layer setCornerRadius:2];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)dealloc
{
    [self.iWantapplyTextFieldDic removeAllObjects];
    [self RemoveObserver];
}
-(void)RemoveObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(float)heightOftextviewTowView
{
    CGRect  frame = CGRectZero;
    frame.origin.x = CGRectGetMaxX(_contentView.frame);
    frame.origin.y = CGRectGetMaxY(_contentView.frame);
    float height = CGRectGetHeight(self.frame) - frame.origin.y;
    return height;
}

-(void)keybordWillAppear:(NSNotification *)notify
{
    NSDictionary* info  =  [notify userInfo];
    CGSize keyBoardSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    float textview2viewheight =[self heightOftextviewTowView];
    if (textview2viewheight < keyBoardSize.height) {
        self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2 , CGRectGetHeight(self.frame) - keyBoardSize.height - CGRectGetHeight(self.contentView.frame)/2);
    }
    [UIView commitAnimations];
}
//-(void)resignAll:(UIGestureRecognizer *)gesture
//{
//      bgtransparencyView.hidden=YES;
//    bgtransparencyView=nil;
//}

-(void)keybordWillDisAppear:(NSNotification *)notify
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    [UIView commitAnimations];
}

@end
