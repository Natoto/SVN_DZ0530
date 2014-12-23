//    												
//    												
//    	 ______    ______    ______					
//    	/\  __ \  /\  ___\  /\  ___\			
//    	\ \  __<  \ \  __\_ \ \  __\_		
//    	 \ \_____\ \ \_____\ \ \_____\		
//    	  \/_____/  \/_____/  \/_____/			
//    												
//    												
//    												
// title:  
// author: unknown
// date:   2014-11-04 09:02:55 +0000
//

#import "article.h"
#import "rmbdz.h"

#pragma mark - ARTICLE

@implementation ARTICLE

@synthesize commentlist = _commentlist;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize isfavorite = _isfavorite;
@synthesize favid = _favid;
@synthesize page = _page;
@synthesize portal_article = _portal_article;
@synthesize totalPage = _totalPage;
@synthesize weburl = _weburl;

CONVERT_PROPERTY_CLASS( commentlist, commentlist );
CONVERT_PROPERTY_CLASS(content, article_content);
CONVERT_RENAME_CLASS(article_content, content);

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - commentlist

@implementation commentlist

@synthesize avatar = _avatar;
@synthesize cid = _cid;
@synthesize dateline = _dateline;
@synthesize message = _message;
@synthesize position = _position;
@synthesize uid = _uid;
@synthesize username = _username;
@synthesize yinreply = _yinreply;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - content

@implementation article_content

@synthesize msg = _msg;
@synthesize type = _type;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - portal_article

@implementation portal_article

@synthesize avatar = _avatar;
@synthesize content = _content;
@synthesize dateline = _dateline;
@synthesize favid = _favid;
@synthesize summary = _summary;
@synthesize title = _title;
@synthesize uid = _uid;
@synthesize username = _username;

CONVERT_PROPERTY_CLASS( content, content );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - REQ_ARTICLE_SHOTS

@implementation REQ_ARTICLE_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - API_ARTICLE_SHOTS

@implementation API_ARTICLE_SHOTS

@synthesize uid = _uid;
@synthesize resp = _resp;
@synthesize req = _req;
@synthesize aid = _aid;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[ARTICLE alloc] init];
        self.req = [[REQ_ARTICLE_SHOTS alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
    self.req = nil;
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
		if ( NULL == self.aid )
		{
			self.failed = YES;
			return;
		}
		NSString *requestURI =[NSString stringWithFormat:@"%@?action=article%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
        [self setCached:NO];
        [self setUseCache:NO];
        
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"uid", self.uid).PARAM(@"aid", self.aid).TIMEOUT(300);

//        NSString *requestURI = @"http://114.215.178.111/amanmanceshi/dztoapp/status.php?action=article&aid=8&uid=OZDHIpO0O0O0&ostype=2&time=1415615960&tokenid=654321&token=f674881bfe4ef241787c300163e9d123";
//        self.HTTP_POST(requestURI);

	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [ARTICLE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
        BeeLog(@"self.description===%@",self.description);
		// TODO:
	}
	else if ( self.cancelled )
	{
        BeeLog(@"self.description %@",self.description);
		// TODO:
	}
}

@end
