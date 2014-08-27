//
//  D1_Msg_Inter_ActivityCell.m
//  DZ
//
//  Created by Nonato on 14-8-21.
//
//
#import "UIImage+Tint.h"
#import "D1_Msg_Inter_ActivityCell.h"
#import "CreateComponent.h"
@implementation D1_Msg_Inter_ActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

+(float)heightOfCell:(automatic *)amatic
{
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont systemFontOfSize:15.0];//[UIFont fontWithName:@"YOUR FONT's NAME" size:16];
    NSString *txt= [D1_Msg_Inter_ActivityCell NEWText:[NSString stringWithFormat:@"%@",amatic.note]];
    gettingSizeLabel.text = txt;
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(260, 9999);
    if (amatic.applyid) {
        maximumLabelSize = CGSizeMake(300, 9999);
    }
    CGSize expectSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    return expectSize.height + 10;
}
//Test4 申请加入您举办的活动 asfsafsf，请审核 &nbsp;  &rsaquo;
+(NSString *)NEWText:(NSString *)Txt
{
    NSRegularExpression * rgx=[[NSRegularExpression alloc] initWithPattern:@"(&nbsp;)|(&rsaquo;)" options:NSRegularExpressionCaseInsensitive error:nil];
    Txt = [rgx stringByReplacingMatchesInString:Txt options:NSMatchingReportProgress range:NSMakeRange(0, Txt.length) withTemplate:@""];
    return Txt;
}
-(UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [CreateComponent CreateLabelWithFrame:CGRectMake(10, 5, 250 , 30) andTxt:@""];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:15.0];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

-(UIButton *)OperationBtn
{
    if (!_OperationBtn) {
        _OperationBtn = [CreateComponent CreateButtonWithFrame:CGRectMake(250, 0, 60, 30) andTxt:@"审核" txtcolor:[UIColor whiteColor]];
        UIImage *btnimge=[UIImage bundleImageNamed:@"tianjiahaoyou"];
        UIColor *color =[DZ_SystemSetting sharedInstance].navigationBarColor;
        btnimge = [btnimge imageWithTintColor:color];
        [_OperationBtn setTitleColor:color forState:UIControlStateNormal];
        [_OperationBtn setBackgroundImage:btnimge forState:UIControlStateNormal];
        _OperationBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_OperationBtn];
        [_OperationBtn addTarget:self action:@selector(OperationBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    _OperationBtn.center = CGPointMake(CGRectGetWidth(self.frame) - 35, CGRectGetHeight(self.frame)/2);
    if ([_activityAutomatic.check isEqualToString:@"0"]) {
        [_OperationBtn setTitle:@"已审核" forState:UIControlStateNormal];
    }
    else
    {
        [_OperationBtn setTitle:@"审核" forState:UIControlStateNormal];
    }    
    return _OperationBtn;
}

-(IBAction)OperationBtnTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Msg_Inter_ActivityCell:checkBtnTap:)]) {
        [self.delegate D1_Msg_Inter_ActivityCell:self checkBtnTap:sender];
    }
}
-(void)setActivityAutomatic:(automatic *)activityAutomatic
{
    _activityAutomatic = activityAutomatic;
    
    if (self.OperationBtn) {
        self.OperationBtn.center = CGPointMake(CGRectGetMidX(_OperationBtn.frame), CGRectGetHeight(self.frame)/2);
    }
    if (self.messageLabel) {
        
        if ([_activityAutomatic.note rangeOfString:@"申请加入"].location !=NSNotFound) {
            _messageLabel.frame = CGRectMake(10, 5, 250 , 30);
            NSString *msg=[D1_Msg_Inter_ActivityCell NEWText:_activityAutomatic.note];
            self.messageLabel.text = msg;
            [self.messageLabel sizeToFit];
            self.OperationBtn.hidden = NO;
        }
        else
        {
            _messageLabel.frame = CGRectMake(10, 5, 320-20, 40);
             NSString *msg=[D1_Msg_Inter_ActivityCell NEWText:_activityAutomatic.note];
             self.messageLabel.text = msg;
            [self.messageLabel sizeToFit];
            self.OperationBtn.hidden = YES;
        }       
    }
   
}
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
