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
// date:   2014-09-04 07:00:47 +0000
//

#import "inform.h"
#import "rmbdz.h"

#pragma mark - INFORM

@implementation INFORM

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INFORM_SHOTS

- (BOOL)validate
{
	return YES;
}

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
    self.uid = nil;
    self.ruid = nil;
    self.message = nil;
	self.resp = nil;
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.uid)
		{
			self.failed = YES;
			return;
		}
       BeeLog(@"%@", self.message);
        NSString * requestURI =[NSString stringWithFormat:@"%@?action=report&type=2%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid", self.uid).PARAM(@"ruid", self.ruid).PARAM(@"message", self.message);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [INFORM objectFromDictionary:(NSDictionary *)result];
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
