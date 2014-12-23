//
//  D1_Msg_Inter_ActivityCell.h
//  DZ
//
//  Created by Nonato on 14-8-21.
//
//

#import <UIKit/UIKit.h>
#import "remind.h"
#import "RCLabel.h"
@class D1_Msg_Inter_ActivityCell;
@protocol D1_Msg_Inter_ActivityCellDelegate <NSObject>
-(void)D1_Msg_Inter_ActivityCell:(D1_Msg_Inter_ActivityCell *)cell checkBtnTap:(id)sender;
@end

@interface D1_Msg_Inter_ActivityCell : UITableViewCell
@property(nonatomic, assign) NSObject <D1_Msg_Inter_ActivityCellDelegate> * delegate;
@property(nonatomic, strong) automatic * activityAutomatic;
@property(nonatomic,retain) UILabel * messageLabel;
@property(nonatomic,retain) UIButton * OperationBtn;
+(float)heightOfCell:(automatic *)amatic;
@end
