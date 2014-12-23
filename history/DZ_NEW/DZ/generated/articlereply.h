 
// author: unknown
// date:   2014-12-02 09:20:28 +0000
//

#import "Bee.h"

#pragma mark - models

@class ArticleReply;

@interface ArticleReply : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface API_ARTICLEREPLY_SHOTS : BeeAPI

@property (nonatomic, copy) NSString    *aid;
@property (nonatomic, copy) NSString    *uid;
@property (nonatomic, copy) NSString    *ip;
@property (nonatomic, copy) NSString    *op;
@property (nonatomic, copy) NSString    *cid;
@property (nonatomic, copy) NSString    *message;
@property (nonatomic, strong) ArticleReply *resp;

@end
