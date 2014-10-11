//
//  B1_ATopicViewController.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//


#import "rmbdz.h"
#import "SubForumsModel.h"
#import "PostlistModel.h"
#import "TopiclistModel.h"
#import "Bee_UIBoard.h"
#import "forumlist.h" 

#import "QCSlideSwitchView.h"
#import "B2_QCListViewController.h"
#import "QCViewController.h"
#import "TopiclistModel.h"
#import "B2_TopicViewController2.h"
#import "B3_PostViewController.h"
#import "B0_ForumPlates_iphone.h"

@class B0_ForumPlates_iphone;
@class B2_QCListViewController;
@class B2_TopicViewController2;
typedef enum : NSUInteger {
    TOPIC_TYPE_ALL = 0,
    TOPIC_TYPE_DEGIST = 1,
    TOPIC_TYPE_TOP = 2,
    TOPIC_TYPE_HOT = 3,
    TOPIC_TYPE_SUBTOPIC = 4
} TOPIC_TYPE;
#define TOPIC_TYPESTR(type) [NSString stringWithFormat:@"%d",type]

@interface B1_ATopicViewController : UIViewController <QCSlideSwitchViewDelegate,QCListViewControllerDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    B2_TopicViewController2  *_vc1;
    B2_TopicViewController2 *_vc2;
    B2_TopicViewController2 *_vc3;
    B2_TopicViewController2 *_vc4;
    B2_QCListViewController *_vc5;
//    QCListViewController *_vc6;
}
AS_NOTIFICATION(catalogselect)
@property (nonatomic, strong) QCSlideSwitchView    *slideSwitchView;
@property (nonatomic, strong) B2_TopicViewController2  * vc1;
@property (nonatomic, strong) B2_TopicViewController2  * vc2;
@property (nonatomic, strong) B2_TopicViewController2  * vc3;
@property (nonatomic, strong) B2_TopicViewController2  * vc4;
@property (nonatomic, strong) B2_QCListViewController    * vc5;
@property (nonatomic, assign) BOOL                   haveSubForums;
@property (nonatomic, strong) NSArray                  * childAry;

@property (nonatomic, strong) NSMutableDictionary      * threadtypesDic;
@property (nonatomic, strong) NSMutableArray           * threadtypes;
//@property (nonatomic, strong) QCListViewController *vc6;

@property(nonatomic,strong) TopiclistModel *tpclistModel;
@property(nonatomic,strong) NSString *forum_fid;
@property(nonatomic,strong) NSString * forum_name;
@property(nonatomic,assign) NSInteger currentIndex;
//-(void)selideSwitchTofirst;

@end
