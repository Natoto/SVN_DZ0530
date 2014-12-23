//
//  B3_Post_IWantApply.m
//  DZ
//
//  Created by Nonato on 14-8-20.
//
//
#import "CreateComponent.h"
#import "B3_Post_IWantApply.h"
#import "SettingModel.h"
#define CELL_START_TAG 140820
#define APPLYBTN_HEIGHT_IW 35.0
#define PAYMENTVIEW_HEIGHT 80.0
#define DIANXUANICON @"dianxuan"
#define WEIDIANXUAN  @"weidianxuan"

#define TAG_ZHIFU 115112
#define TAG_COSTSELF 115101


@interface B3_Post_IWantApply()
{
    UIScrollView *scrollview;
    UIButton * closebtn;
}
@property(nonatomic,strong) UIButton * applyButton;
@property(nonatomic,strong) UIView   * paymentView;
@property(nonatomic,strong) NSString * paycount;
@end

@implementation B3_Post_IWantApply

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(IBAction)gestureTap:(id)sender
{
    /*
     if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(B3_Post_IWantApply:MaskViewDidTaped:)])
    {
        [self.ppboxdelegate B3_Post_IWantApply:self MaskViewDidTaped:self];
    }*/
}

-(void)setTitle:(NSString *)title
{ 
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

-(void)dealloc
{
    [self removeObserver];
}
-(void)closebtnTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(B3_Post_IWantApply:MaskViewDidTaped:)])
    {
        [self.ppboxdelegate B3_Post_IWantApply:self MaskViewDidTaped:self];
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
    allkeys = [NSMutableArray arrayWithArray:diction.allKeys];
    float contentviewheight =(allkeys.count)*40.+ APPLYBTN_HEIGHT_IW + 5 + PAYMENTVIEW_HEIGHT + 10 + 60.0;
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
    int  index =0;
    for ( NSString *key in allkeys)
    {
        NSString *value =[diction valueForKey:key];
        [self createCell:key value:value index:index];
        index ++;
    }
    if (self.applyButton) {
        _applyButton.center = CGPointMake(CGRectGetWidth(scrollview.frame)/2, (allkeys.count)*40.+ APPLYBTN_HEIGHT_IW/2 + 5 + PAYMENTVIEW_HEIGHT);
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(scrollview.frame), CGRectGetMaxY(_applyButton.frame) + 10);
    }    
}

-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(UIButton *)applyButton
{
    if (!_applyButton)
    {
        _applyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_applyButton setTitle:@"确定" forState:UIControlStateNormal];
        _applyButton.frame = CGRectMake(0, 0, 60.0, APPLYBTN_HEIGHT_IW);
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        UIColor *color=[DZ_SystemSetting sharedInstance].navigationBarColor;
        [_applyButton setBackgroundColor:color];
        [_applyButton.layer setCornerRadius:2];
        [_applyButton addTarget:self action:@selector(applybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:_applyButton];
    }
    return _applyButton;
}
#pragma mark - 确定报名

-(void)applybtnTap:(id)sender
{
    if (self.ppboxdelegate &&[self.ppboxdelegate respondsToSelector:@selector(B3_Post_IWantApply:ConfirmButtonTaped:)])
    {
        BOOL confirm = YES;        
        NSString *paymentstype=[_iWantapplyDic valueForKey:KEY_COSTTYPE];
        NSArray *array =[NSArray arrayWithArray:_iWantapplyDic.allKeys];
//        for (int index = array.count -1 ;index >=0 ;index --) {
        for (int index = 0 ;index <array.count ;index++) {
            NSString *key = [array objectAtIndex:index];
            UITextField *textfield=[_iWantapplyTextFieldDic objectForKey:key];
            if (!textfield) {
                continue;
            }
            NSString * value=textfield.text;
            if (!value.length) {
                confirm = NO;
                [self presentMessageTips:[NSString stringWithFormat:@"请输入您的%@",__TEXT(key)]];
                break;
            }
            else
            {
                if ([self checkTextFieldText:textfield key:key]) {
                    [_iWantapplyDic setObject:value forKey:key];
                }
                else
                {
                   confirm = NO;
                   [self presentMessageTips:[NSString stringWithFormat:@"请输入正确的%@",__TEXT(key)]];
                    break;
                }
            }
        }
        if (confirm) {
            [self.ppboxdelegate B3_Post_IWantApply:self ConfirmButtonTaped:_iWantapplyDic];
        }
    }
}

-(BOOL)checkTextFieldText:(UITextField *)textfield key:(NSString *)key
{
    BOOL passcheck =YES;
    if (textfield.text.length) {
        if ([key isEqualToString:@"qq"]) {
            return [textfield.text isQQ];
        }
        else if ([key isEqualToString:@"mobile"]) {
            return [textfield.text isTelephone];
        }
    }
    return passcheck;
}
-(void)addGenderItem:(UIView *)bgview btnframe:(CGRect)btnframe andlabelframe:(CGRect)labelframe imgname:(NSString *)imgname gender:(NSString *)gender tag:(int)tag target:(SEL)target
{
    UIButton *malebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [malebtn setImage:[UIImage bundleImageNamed:imgname] forState:UIControlStateNormal];
    //    [malebtn setBackgroundImage:[UIImage bundleImageNamed:imgname] forState:UIControlStateNormal];
    malebtn.frame=btnframe;
    malebtn.tag=tag;
    [bgview addSubview:malebtn];
    
    UIButton *label=[UIButton buttonWithType:UIButtonTypeCustom];
    [label setTitle:gender forState:UIControlStateNormal];
    [label setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    label.frame=labelframe;
    label.tag=tag+1;
    [bgview addSubview:label];
    
    [malebtn addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    [label addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
}

-(UIView *)paymentView
{
    if (!_paymentView) {
        _paymentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width , PAYMENTVIEW_HEIGHT-1)];
        UILabel *label=[CreateComponent CreateLabelWithFrame:CGRectMake(10, 0, 100, 30) andTxt:@"支付方式 : "];
        [label sizeToFit];
        label.center = CGPointMake(CGRectGetMidX(label.frame), PAYMENTVIEW_HEIGHT/2);
        [_paymentView addSubview:label];
        
        [self addGenderItem:_paymentView btnframe:CGRectMake(CGRectGetMaxX(label.frame), 0, 20, 40) andlabelframe:CGRectMake(CGRectGetMaxX(label.frame) + 25, 0, 140, 40) imgname:DIANXUANICON gender:@"承担自己的花费" tag:TAG_COSTSELF target:@selector(genderBtnTap:)];
        
         [self addGenderItem:_paymentView btnframe:CGRectMake(CGRectGetMaxX(label.frame), 30, 20, 40) andlabelframe:CGRectMake(CGRectGetMaxX(label.frame) + 25, 30, 60, 40) imgname:WEIDIANXUAN gender:@"支付￥" tag:TAG_ZHIFU target:@selector(genderBtnTap:)];
        UIButton *button=(UIButton *)[_paymentView viewWithTag:TAG_ZHIFU +1];
        BeeUITextField *paytextfield= [CreateComponent CreateBeeTextFieldWithFrame:CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame), 50, 30) andplaceholder:@""];
        paytextfield.TEXT_INSET_LEFT = 0;
        paytextfield.keyboardType = UIKeyboardTypeNumberPad;
        paytextfield.center = CGPointMake(CGRectGetMidX(paytextfield.frame), CGRectGetMinY(button.frame)+ 20);
        paytextfield.tag = TAG_ZHIFU +2;
        [_iWantapplyTextFieldDic setObject:paytextfield forKey:KEY_COSTTYPE];
        [_paymentView addSubview:paytextfield];
        
        [scrollview addSubview:_paymentView];
        UIView *line=[self line:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(_paymentView.frame) - 1, CGRectGetWidth(_paymentView.frame) - 2 *CGRectGetMinX(label.frame), LINE_LAYERBOARDWIDTH)];
        [scrollview addSubview:line];
    }
    BeeUITextField *paytextfield = [_iWantapplyTextFieldDic valueForKey:KEY_COSTTYPE];
    paytextfield.text = [_iWantapplyDic valueForKey:KEY_COSTTYPE];
    return _paymentView;
}
#pragma mark - 输入框事件
ON_SIGNAL3(BeeUITextField, WILL_ACTIVE, signal)
{
    BeeUITextField *textfield=(BeeUITextField *)signal.sourceView;
    if (textfield.tag == TAG_ZHIFU + 2) {
        UIButton * selfpay =(UIButton *)[_paymentView viewWithTag:TAG_ZHIFU];
        [self genderBtnTap:selfpay];
    }
}
ON_SIGNAL3(BeeUITextField, RETURN, signal)
{
    BeeUITextField *textfield=(BeeUITextField *)signal.sourceView;
    if (textfield.tag >= 2*CELL_START_TAG) {
         BeeUITextField *nextfield=(BeeUITextField *)[scrollview viewWithTag:(textfield.tag +1)];
        if (nextfield) {
            [nextfield becomeFirstResponder];
        }
        else
        {
            [self applybtnTap:nil];
        }
    }
}


#pragma mark - 选择支付方式
-(IBAction)genderBtnTap:(id)sender
{
    UIButton *button =(UIButton *)sender;
    if (button.tag == TAG_COSTSELF || button.tag == TAG_COSTSELF +1) {//承担自己花费
        UIButton * selfpay =(UIButton *)[_paymentView viewWithTag:TAG_ZHIFU];
        [selfpay setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
         UIButton * otherpay =(UIButton *)[_paymentView viewWithTag:TAG_COSTSELF];
        [otherpay setImage:[UIImage bundleImageNamed:DIANXUANICON] forState:UIControlStateNormal];
        
//        BeeUITextField *textfld= (BeeUITextField *)[_paymentView viewWithTag:TAG_ZHIFU +1];
        
        [self.iWantapplyDic setObject:self.acontent.cos forKey:KEY_COSTTYPE];
    }
    else if (button.tag == TAG_ZHIFU || button.tag == TAG_ZHIFU +1)//支付***
    {
        UIButton * selfpay =(UIButton *)[_paymentView viewWithTag:TAG_COSTSELF];
        [selfpay setImage:[UIImage bundleImageNamed:WEIDIANXUAN] forState:UIControlStateNormal];
        UIButton * otherpay =(UIButton *)[_paymentView viewWithTag:TAG_ZHIFU];
        [otherpay setImage:[UIImage bundleImageNamed:DIANXUANICON] forState:UIControlStateNormal];
        BeeUITextField *textfld= (BeeUITextField *)[_paymentView viewWithTag:TAG_ZHIFU + 2];
        [self.iWantapplyDic setObject:textfld.text forKey:KEY_COSTTYPE];
    }
}

-(void)createCell:(NSString *)key value:(NSString *)value index:(int)index
{
    float HEIGHT =40;
    float WIDTH = _contentView.frame.size.width - 20;
    BeeUILabel *label =(BeeUILabel *)[scrollview viewWithTag: CELL_START_TAG + index];
    if (!label) {
        label = [[BeeUILabel alloc] initWithFrame:CGRectMake(10, PAYMENTVIEW_HEIGHT + index *HEIGHT -1, WIDTH , HEIGHT)];
        
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
    NSString *localkey=__TEXT(key);
    NSString *text=[NSString stringWithFormat:@"%@ : ",localkey];
    label.text = text;
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(label.frame), PAYMENTVIEW_HEIGHT + index *HEIGHT + HEIGHT/2);
    BeeUITextField *textField =(BeeUITextField *)[scrollview viewWithTag: 2*CELL_START_TAG + index];
    if (!textField) {
        textField = [[BeeUITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), index *HEIGHT -1, WIDTH - CGRectGetMaxX(label.frame)-1, HEIGHT)];
        textField.tag = 2*CELL_START_TAG + index;
        textField.placeholder = @"必填";
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
    textField.center = CGPointMake(CGRectGetMidX(textField.frame), PAYMENTVIEW_HEIGHT + index *HEIGHT + HEIGHT/2);
    scrollview.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(textField.frame));
    
}

-(UIScrollView *)scrollview
{
    if (!scrollview) {
        UIScrollView *scrview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame), CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) - CGRectGetMaxY(titlelabel.frame))];
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
