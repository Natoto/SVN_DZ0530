 
// author: unknown
// date:   2014-10-24 08:15:48 +0000
//

#import "portal.h"
#import "rmbdz.h"

#pragma mark - PORTAL

@implementation PORTAL

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize portal = _portal;

CONVERT_PROPERTY_CLASS( portal, portal );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - items

@implementation items

@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize dateline = _dateline;
@synthesize img = _img;
@synthesize message = _message;
@synthesize recommends = _recommends;
@synthesize tid = _tid;
@synthesize aid = _aid;
@synthesize idtype = _idtype;
@synthesize title = _title;
@synthesize views = _views;

CONVERT_RENAME_CLASS(aid, id);

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - portal

@implementation portal

@synthesize fid = _fid;
@synthesize bid = _bid;
@synthesize items = _items;
@synthesize name = _name;
@synthesize title = _title;
@synthesize type = _type;

CONVERT_PROPERTY_CLASS( items, items );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PORTAL_SHOTS

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
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=portal&type=1%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI);
    }
    else if (self.succeed)
    {
        NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [PORTAL objectFromDictionary:(NSDictionary *)result];
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

