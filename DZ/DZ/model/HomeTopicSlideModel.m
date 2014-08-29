//
//  HomeTopicSlideModel.m
//  DZ
//
//  Created by PFei_He on 14-8-27.
//
//

#import "HomeTopicSlideModel.h"
#import "hometopicslide.h"

#define KEY_HOMETOPICSLIDE @"HOMETOPICSLIDE"

@implementation HomeTopicSlideModel

- (void)load
{
    self.shots = [NSMutableArray array];
}

- (void)unload
{
    self.shots = nil;
}

- (void)saveCache
{
    [slide saveObject:self.shots forKey:KEY_HOMETOPICSLIDE];
}

- (void)loadCache
{
    [self.shots removeAllObjects];
    NSString  *key= KEY_HOMETOPICSLIDE;
    self.shots=[NSMutableArray arrayWithArray:[slide readObjectForKey:key]];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    self.loaded = NO;
}

- (void)loadSlide
{
    [API_HOMETOPICSLIDE_SHOTS cancel];
    API_HOMETOPICSLIDE_SHOTS *api = [API_HOMETOPICSLIDE_SHOTS api];

    @weakify(api);
    @weakify(self);

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
                    [self.shots addObjectsFromArray:api.resp.hometopicslide.slide];
                    [self saveCache];
                    self.loaded = YES;
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
