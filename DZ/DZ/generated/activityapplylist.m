//
//  activityapplylist.m
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//
#import "rmbdz.h"
#import "activityapplylist.h"
//#import "bee.h"
@implementation ACTIVITYAPPLIST

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
- (BOOL)validate
{
	return YES;
}
@end

@implementation API_ACTIVITYAPPLIST_SHOTS

@synthesize uid = _uid;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[ACTIVITYAPPLIST alloc] init] ;
        
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
		if ( NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
		if ( NULL == self.uid )
		{
			self.failed = YES;
			return;
		}
        self.subject = [NSData base64encode:self.subject];
        self.reason = [NSData base64encode:self.reason];
        
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=activityapplylist%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"tid",self.tid).PARAM(@"applyid",self.applyid).PARAM(@"authorid",self.authorid).PARAM(@"reason",self.reason).PARAM(@"subject",self.subject).PARAM(@"type",self.type);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [ACTIVITYAPPLIST objectFromDictionary:(NSDictionary *)result];
		}
        
		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
        NSLog(@"self.description===%@",self.description);
		// TODO:
	}
	else if ( self.cancelled )
	{
        NSLog(@"self.description %@",self.description);
		// TODO:
	}
}
@end