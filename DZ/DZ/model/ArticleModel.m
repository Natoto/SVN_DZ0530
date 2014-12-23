//
//  ArticleModel.m
//  DZ
//
//  Created by PFei_He on 14-11-4.
//
//

#import "ArticleModel.h"
#import "UserModel.h"

#undef	PER_PAGE
#define PER_PAGE	(20)
#define OBJECTKEY(aid) [NSString stringWithFormat:@"ArticleModel.tid.%@", aid]
#define OBJECTMAINARTICLEKEY(aid) [NSString stringWithFormat:@"ArticleModel.mainarticle.%@", aid]

@implementation ArticleModel

- (void)load
{
    self.shots = [NSMutableArray array];
    self.aid = @"0";
    self.autoSave = YES;
    self.autoLoad = YES;
}

- (void)unload
{
    self.shots = nil;
    self.aid = nil;
}

- (void)saveCache
{
    [commentlist saveObject:self.shots forKey:OBJECTKEY(self.aid)];
    [portal_article saveObject:self.mainArcticle forKey:OBJECTMAINARTICLEKEY(self.aid)];
}

- (void)loadCache
{
    [self.shots removeAllObjects];
    NSString *key = OBJECTKEY(self.aid);
    self.shots = [NSMutableArray arrayWithArray:[commentlist readObjectForKey:key]];

    self.mainArcticle = nil;
    NSString *articleKey = OBJECTMAINARTICLEKEY(self.aid);
    self.mainArcticle = [portal_article readObjectForKey:articleKey];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    [commentlist removeObjectForKey:OBJECTKEY(self.aid)];

    self.mainArcticle = nil;
    [portal_article removeObjectForKey:OBJECTMAINARTICLEKEY(self.aid)];
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
		[self gotoPage:((self.shots.count +1) / PER_PAGE + 1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    [API_ARTICLE_SHOTS cancel];
	API_ARTICLE_SHOTS * api = [API_ARTICLE_SHOTS api];

	@weakify(api);
	@weakify(self);

    self.uid = [UserModel sharedInstance].session.uid;
    api.uid = self.uid;
	api.aid = self.aid;
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
				if ( nil == api.resp)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:@"ERROR!"];
				}
				else
				{
                    if (api.resp.ecode.integerValue) {
                        [self sendUISignal:self.FAILED withObject:api.resp.emsg];
                        return ;
                    }
					if ( page <= 1 )
					{
						[self.shots removeAllObjects];
						[self.shots addObjectsFromArray:api.resp.commentlist];
                        self.mainArcticle = api.resp.portal_article;
                        self.article = api.resp;
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.commentlist];
					}
					self.more = !api.resp.isEnd.intValue;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
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
