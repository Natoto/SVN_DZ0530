//
//  D2_ChatInputView.m
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_ChatInputView.h"
#import "FaceBoard.h"
#import "UserModel.h"
#import "reply.h"
#import "ToolsFunc.h"
@implementation D2_ChatInputView
@synthesize replayField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIView *replayArea=[[UIView alloc] initWithFrame:frame];
        self.backgroundColor=[UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1];        
       
        _btnFacial=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFacial setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        _btnFacial.frame=CGRectMake(5, 5, 30, 30);
        _btnFacial.tag = 1414;
        [self addSubview:_btnFacial];
        [_btnFacial addTarget:self action:@selector(facailBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        sendbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sendbtn setTitle:@"发送" forState:UIControlStateNormal];        
         sendbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sendbtn.frame=CGRectMake(frame.size.width-55, 5, 50, frame.size.height-10);
        [sendbtn addTarget:self action:@selector(replybtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendbtn];
        
        UITextView *txtfld=[[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnFacial.frame), 5,CGRectGetMinX(sendbtn.frame)- CGRectGetMaxX(_btnFacial.frame), frame.size.height-10)];
//        txtfld.placeholder=@"说点什么吧...";
        txtfld.delegate=self;
        txtfld.font = [UIFont systemFontOfSize:16];
        txtfld.backgroundColor=[UIColor whiteColor];
        KT_CORNER_RADIUS(txtfld, 4);
        [self addSubview:txtfld];
        replayField=txtfld;
        
        facialView = [[FaceBoard alloc] init];
        facialView.delegate = self;
        facialView.inputTextView = replayField;
    }
    return self;
}
-(void)setSentTxt:(NSString *)sentTxt
{
    if (sentTxt) {
        [sendbtn setTitle:sentTxt forState:UIControlStateNormal];
    }
    _sentTxt = sentTxt;
}
-(IBAction)facailBtnTap:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if (button.tag == 1414) {
        button.tag = 1415;
        [button setImage:[UIImage bundleImageNamed:@"jianpan"] forState:UIControlStateNormal];
        replayField.inputView =facialView;
    }
    else
    {
        button.tag = 1414;
        [button setImage:[UIImage bundleImageNamed:@"biaoqing"] forState:UIControlStateNormal];
        replayField.inputView = nil;
    }
    [replayField reloadInputViews];
    [replayField becomeFirstResponder];
}

-(void)faceboardBackface
{
    if (replayField.text.length) {
        NSString *edittext = replayField.text;
        float length=edittext.length;
        edittext=[edittext substringToIndex:length-1];
        replayField.text = edittext;
    }
}

-(void)facebuttonTap:(id)sender andName:(NSString *)name
{
//    UIButton *button = sender;
//    UIImage *stampImage = [button imageForState:UIControlStateNormal];
//    if (stampImage) {
      replayField.text = [replayField.text stringByAppendingString:[NSString stringWithFormat:@"%@",name]];
//    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (![UserModel sharedInstance].session.uid) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(D2_ChatInputView:textView:ShouldBeginEditing:)]) {
            [self.delegate D2_ChatInputView:self textView:textView ShouldBeginEditing:NO];
        }
        return NO;
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(D2_ChatInputView:textView:ShouldBeginEditing:)]) {
            [self.delegate D2_ChatInputView:self textView:textView ShouldBeginEditing:YES];
        }
        [sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

-(void)resignFirstReponder
{
    [replayField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(D2_ChatInputdresignFirstResponder:)]) {
        [self.delegate D2_ChatInputdresignFirstResponder:replayField];
    }
}

-(IBAction)replybtnTap:(id)sender
{
//    [self resignFirstReponder]; 
    if (self.delegate && [ self.delegate respondsToSelector:@selector(D2_ChatInputdShouldSendMessage:) ]) {
        [self.delegate D2_ChatInputdShouldSendMessage:replayField];
    }
}

#pragma mark - 发布标签
+(replyContent *)pushDeviceMark
{
    replyContent *acont1=[[replyContent alloc] init];
    NSString * device = [ToolsFunc   deviceType];
    acont1.msg= TL_PUSTMAK(device);
    acont1.type=[NSNumber numberWithInt:0];
    return acont1;
}

+ (NSMutableArray *)spliteFacialandText:(NSString *)text
{
    NSArray *compants=[text componentsSeparatedByString:@" "];
    NSMutableArray *contentTextAry=[[NSMutableArray alloc] initWithCapacity:0];
    
    if (compants.count==0) {
        replyContent *acont1=[[replyContent alloc] init];
        acont1.msg=text;
        acont1.type=[NSNumber numberWithInt:0];
        [contentTextAry addObject:acont1];
    }
    for (int index2 = 0; index2 < compants.count; index2 ++) {
        NSString *key=[compants objectAtIndex:index2];
        NSString *isfacion=[FaceBoard isExistFacail:key];
        if (!isfacion) {//不是表情
            replyContent *acont1=[[replyContent alloc] init];
            acont1.msg=key;
            acont1.type=[NSNumber numberWithInt:0];
            [contentTextAry addObject:acont1];
        }
        else//是表情
        {
            replyContent *acont1=[[replyContent alloc] init];
            acont1.msg=isfacion;
            acont1.type=[NSNumber numberWithInt:0];
            [contentTextAry addObject:acont1];
        }
    }
    [contentTextAry addObject:[D2_ChatInputView pushDeviceMark]];
    return contentTextAry;
}
@end
