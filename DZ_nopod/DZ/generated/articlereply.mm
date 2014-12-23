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
// date:   2014-12-02 09:20:28 +0000
//

#import "articlereply.h"
#import "rmbdz.h"

#pragma mark - ArticleReply

@implementation ArticleReply

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ARTICLEREPLY_SHOTS

- (BOOL)validate
{
    return YES;
}

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
    if ( self.sending )
	{
		if ( NULL == self.uid ||  NULL == self.aid ||  NULL == self.ip)
		{
			self.failed = YES;
			return;
		}

        NSString *contentbase64=[NSData base64encode:self.message];
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=portalcp_comment%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        requestURI= [requestURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.HTTP_POST(requestURI).HEADER(@"ContentType", @"application/x-www-form-urlencoded; charset=utf-8").PARAM(@"message", contentbase64).PARAM(@"aid", self.aid).PARAM(@"uid",self.uid).PARAM(@"ip", self.ip);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [ArticleReply objectFromDictionary:(NSDictionary *)result];
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
