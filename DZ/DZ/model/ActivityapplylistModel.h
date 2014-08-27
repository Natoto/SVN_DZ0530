//
//  ActivityapplylistModel.h
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//
#import "activityapplylist.h"
#import "Bee_StreamViewModel.h"
#define TYPE_AGREE @"1"
#define TYPE_NEEDCOMPLETE @"2"
#define TYPE_REFUSE @"3"

@class ACTIVITYAPPLIST;
@interface ActivityapplylistModel : BeeStreamViewModel

@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSString * uid;
@property(nonatomic,strong) NSString * tid;
@property(nonatomic,strong) NSString * applyid;
@property(nonatomic,strong) NSString * authorid;
@property(nonatomic,strong) NSString * reason;
@property(nonatomic,strong) NSString * subject;
@property (nonatomic, retain) ACTIVITYAPPLIST  * shots;
@end
