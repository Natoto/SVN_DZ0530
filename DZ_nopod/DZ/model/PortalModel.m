//
//  PortalModel.m
//  DZ
//
//  Created by PFei_He on 14-10-24.
//
//

#import "PortalModel.h"
#import "portal.h"

#define KEY_PORTAL @"PORTAL"
#define KEY_ITEMS @"ITEMS"

@implementation PortalModel

- (void)load
{
    self.autoSave = YES;
    self.autoLoad = YES;
}

- (void)unload
{
    self.shots = nil;
}

- (void)saveCache
{
    [portal saveObject:self.shots forKey:KEY_PORTAL];
    [items saveObject:self forKey:KEY_ITEMS];
}

- (void)loadCache
{
    self.shots = [[NSArray alloc] init];
    self.shots =  [portal readObjectForKey:KEY_PORTAL];
}

- (void)clearCache
{
    self.loaded = NO;
}

- (void)loadData
{
    [API_PORTAL_SHOTS cancel];
    API_PORTAL_SHOTS *api = [API_PORTAL_SHOTS api];

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
                    self.shots = api.resp.portal;
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
