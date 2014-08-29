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
// date:   2014-05-14 01:51:04 +0000
//

#import "collection.h"
#import "rmbdz.h"
#pragma mark - COLLECTION

@implementation COLLECTION

@synthesize collection = _collection;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( collection, collection );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - collection

@implementation collection

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize dateline = _dateline;
@synthesize favid = _favid;
@synthesize img = _img;
@synthesize message = _message;
@synthesize replies = _replies;
@synthesize subject = _subject;
@synthesize tid = _tid;
@synthesize views = _views;

- (BOOL)validate
{
	return YES;
}

@end

@implementation REQ_COLLECTION_SHOTS
@synthesize page=_page,per_page=_per_page;

- (BOOL)validate
{
	return YES;
}
@end



@implementation API_COLLECTION_SHOTS

@synthesize uid = _uid;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[REQ_COLLECTION_SHOTS alloc] init] ;
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
    //	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}
        
		if ( NULL == self.uid )
		{
			self.failed = YES;
			return;
		}
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=collection%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];         
        self.HTTP_POST(requestURI).PARAM([self.req objectToDictionary]).PARAM(@"uid",self.uid);;
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [COLLECTION objectFromDictionary:(NSDictionary *)result];
		}
        
		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
        NSLog(@"self.description===%@",self.description);
		// TODO:
	}
	else if ( self.cancelled )
	{
        NSLog(@"self.description %@",self.description);
		// TODO:
	}
}

@end
