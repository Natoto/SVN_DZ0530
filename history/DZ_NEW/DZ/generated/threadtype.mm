 
// author: unknown
// date:   2014-09-28 03:52:07 +0000
//
#import "rmbdz.h"
#import "threadtype.h"

#pragma mark - threadtype

@implementation threadtype

@synthesize count = _count;
@synthesize id = _id;
@synthesize name = _name;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - threadtype

@implementation threadtype2

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize threadtype = _threadtype;

CONVERT_PROPERTY_CLASS( threadtype, threadtype);

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_THREADTYPE_SHOTS

@synthesize fid = _fid;
@synthesize resp = _resp;

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
    self.fid = nil;
    self.resp = nil;
    //	[super dealloc];
}

- (void)routine
{
    if ( self.sending )
    {
        if ( nil == self.fid )
        {
            self.failed = YES;
            return;
        }
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=threadtype%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"fid",self.fid);
    }
    else if ( self.succeed )
    {
        NSObject * result = self.responseJSON;
        
        if ( result && [result isKindOfClass:[NSDictionary class]] )
        {
            self.resp = [threadtype2 objectFromDictionary:(NSDictionary *)result];
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
