//
//  deal_activity.h
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//活动主题帖子处理动作接口
#import "Bee.h"
#import <Foundation/Foundation.h>

@interface DEAL_ACTIVITY : BeeActiveObject
@property (nonatomic, retain) NSNumber          *ecode;
@property (nonatomic, retain) NSString          *emsg;
@property (nonatomic, retain) NSString          * applyid;
@end

@interface API_DEAL_ACTIVITY_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString        * type;
@property (nonatomic, copy)     NSString        * uid;       //用户id
@property (nonatomic, copy)     NSString        * tid;
@property (nonatomic, copy)     NSString        * payment;
@property (nonatomic, copy)     NSString        * authorid;
@property (nonatomic, copy)     NSString        * message;
@property (nonatomic, copy)     NSString        * subject;
@property (nonatomic, strong)   DEAL_ACTIVITY   * resp;
@end