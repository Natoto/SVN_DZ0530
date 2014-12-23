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
// date:   2014-10-24 09:50:09 +0000
//

#import "portalslide.h"
#import "rmbdz.h"

#pragma mark - PORTALSLIDE

@implementation PORTALSLIDE

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize itemlist = _itemlist;

CONVERT_PROPERTY_CLASS( itemlist, itemlist );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - itemlist

@implementation itemlist

@synthesize itemid = _itemid;
@synthesize pic = _pic;
@synthesize startdate = _startdate;
@synthesize tid = _tid;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PORTALSLIDE_SHOTS

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
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=portal_slide%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI);
    }
    else if (self.succeed)
    {
        NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [PORTALSLIDE objectFromDictionary:(NSDictionary *)result];
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
