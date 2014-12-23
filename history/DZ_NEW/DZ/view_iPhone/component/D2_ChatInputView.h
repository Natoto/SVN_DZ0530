//
//  D2_ChatInputView.h
//  DZ
//
//  Created by Nonato on 14-6-3.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "FaceBoard.h"
@class D2_ChatInputView;
@protocol D2_ChatInputViewDelegate <NSObject>
- (void)D2_ChatInputdShouldSendMessage:(UITextView *)textField;
@optional
-(void)D2_ChatInputdresignFirstResponder:(UITextView *)textField;
- (void)D2_ChatInputView:(D2_ChatInputView *)view textView:(UITextView *)textView ShouldBeginEditing:(BOOL)canedit;
@end
@class FaceBoard;
@interface D2_ChatInputView : UIView<UITextViewDelegate,FaceBoardDelegate>
{
    UIButton    * sendbtn;
    UITextView  * replayField;
    FaceBoard   * facialView;
    UIButton    *_btnFacial;
}
@property (nonatomic, strong) UIButton *btnFacial;
@property(nonatomic,strong) NSString *sentTxt;
@property(nonatomic,assign) NSObject<D2_ChatInputViewDelegate> *delegate;
@property(nonatomic,retain) UITextView *replayField;
-(void)resignFirstReponder;
-(BOOL)becomeFirstResponder;
+ (NSMutableArray *)spliteFacialandText:(NSString *)text;
@end
