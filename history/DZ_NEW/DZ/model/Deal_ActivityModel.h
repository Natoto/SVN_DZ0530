//
//  Deal_ActivityModel.h
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//

#import "Bee_StreamViewModel.h"
#import "deal_activity.h"
@class DEAL_ACTIVITY;
@interface Deal_ActivityModel : BeeStreamViewModel

@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSString * uid;
@property(nonatomic,strong) NSString * tid;
@property(nonatomic,strong) NSString * payment;
@property(nonatomic,strong) NSString * authorid;
@property(nonatomic,strong) NSString * message;
@property(nonatomic,strong) NSString * subject;
@property (nonatomic, retain) DEAL_ACTIVITY  * shots;
@end
