//
//  HomeTopicListModel.m
//  DZ
//
//  Created by PFei_He on 14-8-26.
//
//

#import "HomeTopicListModel.h"
#import "hometopiclist.h"

#define KEY_HOMETOPICLIST @"HOMETOPICLIST"

@implementation HomeTopicListModel

@synthesize type = _type;
@synthesize shots = _shots;

- (void)load
{
    self.type = @"0";
    self.shots = [NSMutableArray array];
    self.autoSave = YES;
    self.autoLoad = YES;
}

- (void)unload
{
    self.type = nil;
    self.shots = nil;
}

- (void)saveCache
{
    [hometopiclist saveObject:self.shots forKey:KEY_HOMETOPICLIST];
}

- (void)loadCache
{
    [self.shots removeAllObjects];
    NSString *key = KEY_HOMETOPICLIST;
    self.shots = [NSMutableArray arrayWithArray:[hometopiclist readObjectForKey:key]];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    self.loaded = NO;
}

- (void)loadList
{
    [API_HOMETOPICLIST_SHOTS cancel];
    API_HOMETOPICLIST_SHOTS *api = [API_HOMETOPICLIST_SHOTS api];

    @weakify(api);
    @weakify(self);

    api.type = self.type;

    api.whenUpdate = ^{

        @normalize(api);
        @normalize(self);

        if (api.sending) {
            [self sendUISignal:self.RELOADING];
        }
        else
        {
            if (api.succeed)
            {
                if (nil == api.resp || api.resp.ecode.integerValue)
                {
                    api.failed = YES;
                    [self sendUISignal:self.FAILED];
                }
                else
                {
                    [self.shots removeAllObjects];
                    [self.shots addObjectsFromArray:api.resp.hometopiclist];
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
