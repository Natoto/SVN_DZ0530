 
// author: unknown
// date:   2014-10-20 02:31:43 +0000
//

#import "topten.h"
#import "rmbdz.h"
#pragma mark - topics
/*
@implementation topics

@synthesize authorid = _authorid;
@synthesize authorname = _authorname;
@synthesize digest = _digest;
@synthesize fid = _fid;
@synthesize heats = _heats;
@synthesize img = _img;
@synthesize lastpost = _lastpost;
@synthesize message = _message;
@synthesize recommends = _recommends;
@synthesize replies = _replies;
@synthesize stickreply = _stickreply;
@synthesize subject = _subject;
@synthesize tid = _tid;
@synthesize views = _views;

- (BOOL)validate
{
	return YES;
}

@end*/

#pragma mark - topten

@implementation topten

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize isEnd = _isEnd;
@synthesize page = _page;
@synthesize topics = _topics;
@synthesize totalPage = _totalPage;

CONVERT_PROPERTY_CLASS( topics, topics );

- (BOOL)validate
{
	return YES;
}

@end



@implementation REQ_TOPTEN_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
    return YES;
}

@end

#pragma mark - API_POSTLIST_SHOTS



@implementation API_TOPTEN_SHOTS
@synthesize type = _type;
@synthesize req = _req;
@synthesize resp=_resp;
- (id)init
{
    self = [super init];
    if ( self )
    {
        self.req = [[REQ_TOPTEN_SHOTS alloc] init] ;
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
        if ( NULL == self.type )
        {
            self.failed = YES;
            return;
        }
        
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=topten&type=%@%@", [ServerConfig sharedInstance].url,self.type,[ServerConfig sharedInstance].urlpostfix];
        [self setUseCache:YES];
        self.POST(requestURI).PARAM([self.req objectToDictionary]).TIMEOUT(300);
    }
    else if ( self.succeed )
    {
        NSObject * result = self.responseJSON;
        if ( result && [result isKindOfClass:[NSDictionary class]] )
        {
            self.resp = [topten objectFromDictionary:(NSDictionary *)result];
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


