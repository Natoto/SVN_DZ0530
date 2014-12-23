//
//  E1_RankViewController.h
//  DZ
//
//  Created by nonato on 14-10-16.
//
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "E2_SubRankViewController.h"

@class E2_SubRankViewController;
@interface E1_RankViewController : UIViewController <QCSlideSwitchViewDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    E2_SubRankViewController  *_vc1;
    E2_SubRankViewController *_vc2;
    E2_SubRankViewController *_vc3;
}
@property (nonatomic, strong) QCSlideSwitchView    *slideSwitchView;
@property (nonatomic, strong) E2_SubRankViewController  * vc1;
@property (nonatomic, strong) E2_SubRankViewController  * vc2;
@property (nonatomic, strong) E2_SubRankViewController  * vc3;
@property (nonatomic, strong) NSArray                  * childAry;
@property(nonatomic,strong) NSString *forum_fid;
@property(nonatomic,strong) NSString * forum_name;
@property(nonatomic,assign) NSInteger currentIndex;

@end
