//
//  activitydata.m
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//获取活动主题帖子申请者数据接口

#import "activitydata.h"
#import "rmbdz.h"
@implementation ACTIVITYDATA

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
- (BOOL)validate
{
	return YES;
}
@end

@implementation API_ACTIVITYDATA_SHOTS

@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = [[ACTIVITYDATA alloc] init] ;
        
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
		if ( NULL == self.applyid )
		{
			self.failed = YES;
			return;
		}
		NSString * requestURI =[NSString stringWithFormat:@"%@?action=activitydata %@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"applyid",self.applyid);
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;
        
		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [ACTIVITYDATA objectFromDictionary:(NSDictionary *)result];
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