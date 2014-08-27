//
//  ActivityapplylistModel.m
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//

#import "ActivityapplylistModel.h"
#import "rmbdz.h"
#import "UserModel.h"
#import "activityapplylist.h"
@implementation ActivityapplylistModel
@synthesize  shots=_shots;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _shots=nil;
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
    
}

- (void)clearCache
{
    
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
    [self firstPage];
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_ACTIVITYAPPLIST_SHOTS cancel];
	API_ACTIVITYAPPLIST_SHOTS * api = [API_ACTIVITYAPPLIST_SHOTS api];
	@weakify(api);
	@weakify(self);
	
    self.uid = [UserModel sharedInstance].session.uid;
    if (!self.applyid) {
        self.applyid = @"0";
    }
    if (!self.type || !self.uid || !self.tid || !self.authorid || !self.reason || !self.subject || !self.applyid) {
        BeeLog(@"活动主题帖子管理员处理动作接口参数不完整。。。");
        return;
    }
    api.type = self.type;
    api.tid = self.tid;
    api.uid = self.uid;
    api.applyid = self.applyid;
    api.authorid = self.authorid;
    api.reason = self.reason;
    api.subject = self.subject;
    
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp || api.resp.ecode.integerValue)
				{
                    self.shots = api.resp;
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
					self.more = YES; //(api.resp.i.intValue==0)?YES:NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED withObject:api.resp.emsg];
            }
		}
	};
	
	[api send];
}
@end
