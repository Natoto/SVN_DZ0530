 
// author: unknown
// date:   2014-11-04 09:02:55 +0000
//

#import "Bee.h"

#pragma mark - models

@class ARTICLE;
@class commentlist;
@class content;
@class portal_article;

@interface ARTICLE : BeeActiveObject
@property (nonatomic, retain) NSArray *				commentlist;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			isfavorite;
@property (nonatomic, retain) NSNumber *            favid;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) portal_article *			portal_article;
@property (nonatomic, retain) NSNumber *			totalPage;
@property (nonatomic, retain) NSString *			weburl;
@end

@interface commentlist : BeeActiveObject
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSString *			cid;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			position;
@property (nonatomic, retain) NSString *			uid;
@property (nonatomic, retain) NSString *			username;
@property (nonatomic, retain) NSString *			yinreply;
@end

@interface article_content : BeeActiveObject
@property (nonatomic, retain) NSString *			msg;
@property (nonatomic, retain) NSNumber *			type;
@end

@interface portal_article : BeeActiveObject
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) NSArray *				content;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSObject *			favid;
@property (nonatomic, retain) NSString *			summary;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			uid;
@property (nonatomic, retain) NSString *			username;
@end

@interface REQ_ARTICLE_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_ARTICLE_SHOTS : BeeAPI

@property (nonatomic, strong) REQ_ARTICLE_SHOTS     *req;
@property (nonatomic, strong) ARTICLE               *resp;
@property (nonatomic, strong) NSString              *uid;
@property (nonatomic, strong) NSString              *aid;

@end

