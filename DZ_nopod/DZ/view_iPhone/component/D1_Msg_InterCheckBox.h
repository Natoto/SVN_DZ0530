//
//  D1_Msg_InterCheckBox.h
//  DZ
//
//  Created by Nonato on 14-8-22.
//
//
#import "remind.h"
#import <UIKit/UIKit.h>

#define YOUR_WORDS @"您的附言"
@class D1_Msg_InterCheckBox;
@protocol D1_Msg_InterCheckBoxDelegate <NSObject>
- (void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view MaskViewDidTaped:(id)object;
- (void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view agreeButtonTap:(id)object;
- (void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view needCompleteButtonTap:(id)object;
- (void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view refuseButtonTap:(id)object;
@end

@interface D1_Msg_InterCheckBox : UIView
{
    UILabel *titlelabel;
}

@property(nonatomic,assign) NSObject <D1_Msg_InterCheckBoxDelegate> *ppboxdelegate;
@property(nonatomic,retain) UIView * contentView;
@property(nonatomic,strong) automatic * activityContent;
@property(nonatomic,strong) NSMutableDictionary * iWantapplyDic;
@property(nonatomic,strong) NSMutableDictionary * iWantapplyTextFieldDic;
//@property(nonatomic,retain) UIView * contentBGView;
@property(nonatomic,retain) NSString *title;
-(void)show;
-(void)hide;

-(void)loadDatas:(NSMutableDictionary *)diction;
@end
