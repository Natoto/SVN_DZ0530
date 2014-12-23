//
//  deal_activity.m
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//
#import "rmbdz.h"
#import "deal_activity.h"
@implementation DEAL_ACTIVITY

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize applyid = _applyid;
- (BOOL)validate
{
	return YES;
}
@end

@implementation API_DEAL_ACTIVITY_SHOTS

@synthesize uid = _uid;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[DEAL_ACTIVITY alloc] init] ;
        
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
        
        self.message =[NSData base64encode:self.message];
        self.subject = [NSData base64encode:self.subject];
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=deal_activity%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid",self.uid).PARAM(@"tid",self.tid).PARAM(@"payment",self.payment).PARAM(@"authorid",self.authorid).PARAM(@"message",self.message).PARAM(@"subject",self.subject).PARAM(@"type",self.type);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [DEAL_ACTIVITY objectFromDictionary:(NSDictionary *)result];
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