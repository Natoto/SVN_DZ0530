//
//  B3_PostView_Activity.h
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//

#import <UIKit/UIKit.h>
#import "postlist.h"
@class B3_PostView_Activity;
@protocol B3_PostView_ActivityDelegate <NSObject>
//- (void)B3_PostView_Activity:(B3_PostView_Activity *)view MaskViewDidTaped:(id)object;
- (void)B3_PostView_Activity:(B3_PostView_Activity *)view applyButtonTaped:(id)object;
@end

@interface B3_PostView_Activity : UIView
{
    UILabel *titlelabel;
}

@property(nonatomic,assign) NSObject <B3_PostView_ActivityDelegate> *ppboxdelegate;
@property(nonatomic,retain) UIView * contentView;
@property(nonatomic,retain) UIButton * applyButton;
//@property(nonatomic,retain) UIView * contentBGView;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,strong) content  * activityContent;
-(void)show;
-(void)hide;
+(float)heightOfView:(int)rows;
-(void)loadDatas:(NSMutableDictionary *)diction;

@end
