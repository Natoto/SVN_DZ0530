 
// author: unknown
// date:   2014-10-30 01:34:04 +0000
//
#import "rmbdz.h"
#import "switch_onoff.h"

#pragma mark - onoff

@implementation onoff

@synthesize isactivity = _isactivity;
@synthesize iscommand = _iscommand;
@synthesize isportal = _isportal;
@synthesize isregist = _isregist;

- (BOOL)validate
{
	return YES;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"isactivity=%@ iscommand=%@ isportal=%@  isregist=%@",_isactivity,_iscommand,_isportal,_isregist];
}

@end

#pragma mark - switch_onoff

@implementation SWITCH_ONOFF

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize onoff = _onoff;

- (BOOL)validate
{
	return YES;
}

@end


@implementation API_SWITCH_ONOFF_SHOTS
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
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=onoff%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        [self setUseCache:YES];
        self.POST(requestURI);
    }
    else if ( self.succeed )
    {
        NSObject * result = self.responseJSON;
        if ( result && [result isKindOfClass:[NSDictionary class]] )
        {
            self.resp = [SWITCH_ONOFF objectFromDictionary:(NSDictionary *)result];
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

