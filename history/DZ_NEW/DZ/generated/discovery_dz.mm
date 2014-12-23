 
// author: unknown
// date:   2014-10-27 08:24:58 +0000
//

#import "discovery_dz.h"
#import "rmbdz.h"
#pragma mark - discovery

@implementation discovery

@synthesize description = _description;
@synthesize link = _link;
@synthesize name = _name;
@synthesize order = _order;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - discovery

@implementation DISCOVERY

@synthesize discovery = _discovery;
@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

CONVERT_PROPERTY_CLASS( discovery, discovery );

- (BOOL)validate
{
	return YES;
}

@end



@implementation API_DISCOVERY_SHOTS
@synthesize resp=_resp;
- (id)init
{
    self = [super init];
    if ( self )
    {
        self.resp = nil;
    }
    return self;
}

- (void)dealloc
{
    self.resp = nil;
    //	[super dealloc];
}

- (void)routine
{
    if ( self.sending )
    {
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=discovery%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        [self setUseCache:YES];
        self.POST(requestURI);
    }
    else if ( self.succeed )
    {
        NSObject * result = self.responseJSON;
        if ( result && [result isKindOfClass:[NSDictionary class]] )
        {
            self.resp = [DISCOVERY objectFromDictionary:(NSDictionary *)result];
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


