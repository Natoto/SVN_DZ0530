//
//  ActivityModel.m
//  DZ
//
//  Created by Nonato on 14-8-18.
//
//

#import "ActivityModel.h"
#import "activity.h"
@implementation ActivityModel
@synthesize type=_type,shots=_shots;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _type=nil;
    _shots=nil;
}

#pragma mark -

- (void)loadCache
{
    [self.shots removeAllObjects];
    NSString *myclass= NSStringFromClass([self class]);
    NSString *mytype=self.type?self.type:@"0";
    KEY_CLS_TYPE =  MODELOBJECTKEY(myclass,mytype);
    
    self.shots=[NSMutableArray arrayWithArray:[activity readObjectForKey:KEY_CLS_TYPE]];
}

- (void)saveCache
{
    [activity saveObject:self.shots forKey:KEY_CLS_TYPE];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    self.loaded=NO;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
    if ( self.shots.count )
	{
		[self gotoPage:(self.shots.count / PER_PAGE + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_ACTIVITY_SHOTS cancel];
	API_ACTIVITY_SHOTS * api = [API_ACTIVITY_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.type=_type;
	api.req.page = @(page);
	api.req.per_page = @(PER_PAGE);
	
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
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
                    if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.activity];
                         self.ACTY = api.resp;
					}
					else
					{
                        self.ACTY = api.resp;
						[self.shots addObjectsFromArray:api.resp.activity];
					}
					self.more = (api.resp.isEnd.intValue==0)?YES:NO;
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
