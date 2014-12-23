//
//  PortalSlideModel.m
//  DZ
//
//  Created by PFei_He on 14-10-24.
//
//

#import "PortalSlideModel.h"
#import "portalslide.h"

#define KEY_PORTALSLIDE @"PORTALSLIDE"

@implementation PortalSlideModel

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
    [itemlist saveObject:self.shots forKey:KEY_PORTALSLIDE];
}

- (void)loadCache
{
    self.shots = [[PORTALSLIDE alloc] init];
    NSString *key = KEY_PORTALSLIDE;
    self.shots.itemlist = [itemlist readObjectForKey:key];
}

- (void)clearCache
{
    self.loaded = NO;
}

- (void)loadData
{
    [API_PORTALSLIDE_SHOTS cancel];
    API_PORTALSLIDE_SHOTS *api = [API_PORTALSLIDE_SHOTS api];

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
                    self.loaded = NO;
                    [self sendUISignal:self.FAILED];
                }
                else
                {
                    self.shots = api.resp;
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
