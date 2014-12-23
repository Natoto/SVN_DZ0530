//
//  ArticleReplyModel.m
//  DZ
//
//  Created by PFei_He on 14-12-2.
//
//

#import "ArticleReplyModel.h"

@implementation ArticleReplyModel

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _aid=nil;
    _uid=nil;
    _ip=nil;
    _message = nil;
}

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
    [self gotoPage:1];
}

- (void)gotoPage:(NSUInteger)page
{
    [API_ARTICLEREPLY_SHOTS cancel];

	API_ARTICLEREPLY_SHOTS * api = [API_ARTICLEREPLY_SHOTS api];

	@weakify(api);
	@weakify(self);
    api.aid=_aid;
    api.uid=_uid;
    api.ip=_ip;
    api.message=_message;

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
					self.more = NO;
					self.loaded = YES;
                    [self sendUISignal:self.RELOADED];
//					[self saveCache];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED];
            }
		}
	};

	[api send];
}

@end
