 
// author: unknown
// date:   2014-12-01 02:16:27 +0000
//

#import "Bee.h"

#pragma mark - models

@class favoritearticle;

@interface favoritearticle : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			favid;
@end

@interface API_FAVORITEARTICLE_SHOTS : BeeAPI

@property (nonatomic, copy) NSString            *uid;
@property (nonatomic, copy) NSString            *aid;
@property (nonatomic, strong) favoritearticle   *resp;

@end
