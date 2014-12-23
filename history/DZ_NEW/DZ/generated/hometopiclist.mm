 
// author: unknown
// date:   2014-08-26 06:53:52 +0000
//

#import "hometopiclist.h"
#import "rmbdz.h"

#pragma mark - HOMETOPICLIST

@implementation HOMETOPICLIST

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize hometopiclist = _hometopiclist;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize totalPage = _totalPage;

CONVERT_RENAME_CLASS(hometopiclist, home)
CONVERT_PROPERTY_CLASS(home, hometopiclist)

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - home

@implementation hometopiclist

@synthesize authorname = _authorname;
@synthesize dateline = _dateline;
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

@implementation API_HOMETOPICLIST_SHOTS

@synthesize type = _type;

@synthesize resp = _resp;

- (id)init
{
    self = [super init];
    if (self) {
        self.resp = nil;
    }
    return self;
}

- (void)dealloc
{
    self.resp = nil;
}

- (void)routine
{
    if (self.sending)
    {
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=home_tpl_2_list&type=%@%@", [ServerConfig sharedInstance].url, self.type, [ServerConfig sharedInstance].urlpostfix];
       BeeLog(@"%@", requestURI);
        self.HTTP_POST(requestURI);
    }
    else if (self.succeed)
    {
        NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [HOMETOPICLIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
    }
    else if (self.failed)
	{
       BeeLog(@"self.description===%@",self.description);
		// TODO:
	}
	else if (self.cancelled)
	{
       BeeLog(@"self.description %@",self.description);
		// TODO:
	}
}

@end
