//
//  B3_Post_IWantApply.h
//  DZ
//
//  Created by Nonato on 14-8-20.
//
//

#import <UIKit/UIKit.h>
#define KEY_COSTTYPE @"payment"
#import "postlist.h"
@class B3_Post_IWantApply;
@protocol B3_Post_IWantApplyDelegate <NSObject>
- (void)B3_Post_IWantApply:(B3_Post_IWantApply *)view MaskViewDidTaped:(id)object;
- (void)B3_Post_IWantApply:(B3_Post_IWantApply *)view ConfirmButtonTaped:(id)object;
@end

@interface B3_Post_IWantApply : UIView
{
    UILabel *titlelabel;
}

@property(nonatomic,assign) NSObject <B3_Post_IWantApplyDelegate> *ppboxdelegate;
@property(nonatomic,retain) UIView * contentView;
@property(nonatomic,strong) NSMutableDictionary * iWantapplyDic;
@property(nonatomic,strong) NSMutableDictionary * iWantapplyTextFieldDic;
@property(nonatomic,strong) NSString            * defaultCost;
//@property(nonatomic,retain) UIView * contentBGView;
@property(nonatomic,strong) NSString            * title;
@property(nonatomic,strong) content             * acontent;
-(void)show;
-(void)hide;

-(void)loadDatas:(NSMutableDictionary *)diction;
@end
