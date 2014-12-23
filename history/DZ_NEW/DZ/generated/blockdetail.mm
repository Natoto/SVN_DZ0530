 
// author: unknown
// date:   2014-10-29 10:13:34 +0000
//

#import "blockdetail.h"
#import "rmbdz.h"

#pragma mark - BLOCKDETAIL

@implementation BLOCKDETAIL

CONVERT_PROPERTY_CLASS(items, blockdetail_items);
CONVERT_RENAME_CLASS(blockdetail_items, items);

@synthesize blockitem = _blockitem;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - blockitem

@implementation blockitem

@synthesize bid = _bid;
@synthesize items = items;
@synthesize name = _name;
@synthesize title = _title;
@synthesize type = _type;

//CONVERT_PROPERTY_CLASS( items, items );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - items

@implementation blockdetail_items

@synthesize aid = _aid;
@synthesize author = _author;
@synthesize authorid = _authorid;
@synthesize dateline = _dateline;
@synthesize img = _img;
@synthesize message = _message;
@synthesize recommends = _recommends;
@synthesize title = _title;
@synthesize views = _views;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_BLOCKDETAIL_SHOTS

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
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=blockdetail%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"bid", self.bid);
    }
    else if (self.succeed)
    {
        NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [BLOCKDETAIL objectFromDictionary:(NSDictionary *)result];
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
