//
//  Remind_ActivityModel.h
//  DZ
//
//  Created by Nonato on 14-8-21.
//
//

#import "Bee_StreamViewModel.h"
#import "RemindModel.h"
@interface Remind_ActivityModel : BeeStreamViewModel
AS_SINGLETON(Remind_ActivityModel)
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic, retain) NSMutableArray    *    activityautomatic;
@property (nonatomic, retain) NSMutableArray    *    dialog;
@property (nonatomic, retain) NSNumber          *    nowdate;
@property (nonatomic, assign) MSG_TYPE_REMIND        msg_type;
- (void)clearCache:(MSG_TYPE_REMIND)msg_type;
+(int)newmessagecount;
+(int)systemmessagecount;
+(int)innermessagecount;
+(int)friendmessagecount;
@end
