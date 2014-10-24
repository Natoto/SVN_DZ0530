//
//  E2_SubRankViewController.h
//  DZ
//
//  Created by nonato on 14-10-16.
//
//

#import <UIKit/UIKit.h>
#import "E1_RankViewController.h"
#import "ToptenModel.h"
#import "Base_TableviewController.h"
@class E2_SubRankViewController;

@protocol E2_SubRankViewControllerDelegate <NSObject>
- (void)E2_SubRankViewController:(E2_SubRankViewController *)controller topicViewControllerCellSelectedWithTid:(NSString *)tid;
@end


@class E1_RankViewController;
@interface E2_SubRankViewController : Base_TableviewController
@property (nonatomic, assign) TOPTENTYPE tptType; 
@property (nonatomic, assign) E1_RankViewController * superdelegate;

@property (nonatomic, assign) NSObject <E2_SubRankViewControllerDelegate> * topicvcdelegate;
@property(nonatomic,strong) ToptenModel *tpclistModel;
@end
