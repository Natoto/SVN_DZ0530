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
    self.shots = nil;
    self.autoSave = YES;
    self.autoLoad = YES;
}

- (void)unload
{
    self.shots = nil;
}

- (void)saveCache
{
    [slide saveObject:self.shots.slide forKey:KEY_HOMETOPICSLIDE];
}

- (void)loadCache
{
    self.shots = [[hometopicslide alloc] init];
    self.shots.slide = [slide readObjectForKey:KEY_HOMETOPICSLIDE];
}

- (void)clearCache
{
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
                    self.shots = api.resp.hometopicslide;
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
