//
//  activityapplylist.h
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//活动主题帖子管理员处理动作接口

#import <Foundation/Foundation.h>
#import "Bee.h"

@interface ACTIVITYAPPLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber          *ecode;
@property (nonatomic, retain) NSString          *emsg;
@end

@interface API_ACTIVITYAPPLIST_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString        * uid;       //用户id
@property (nonatomic, copy)     NSString        * tid;
@property (nonatomic, copy)     NSString        * type;
@property (nonatomic, copy)     NSString        * applyid;
@property (nonatomic, copy)     NSString        * authorid;
@property (nonatomic, copy)     NSString        * reason;
@property (nonatomic, copy)     NSString        * subject;
@property (nonatomic, strong)   ACTIVITYAPPLIST   * resp;
@end