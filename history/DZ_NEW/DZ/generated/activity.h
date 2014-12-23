 
// author: unknown
// date:   2014-08-01 02:19:42 +0000
//

#import "Bee.h"

#pragma mark - models

@class activity;
@class ACTIVITY;

@interface activity : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@property (nonatomic, retain) NSString *            message;
@end

@interface ACTIVITY : BeeActiveObject
@property (nonatomic, retain) NSArray *				activity;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			totalPage;
@end


@interface REQ_ACTIVITY_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_ACTIVITY_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   type;
@property (nonatomic, retain) REQ_ACTIVITY_SHOTS    *   req;
@property (nonatomic, retain) ACTIVITY              *   resp;
@end


