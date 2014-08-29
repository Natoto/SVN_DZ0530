//
//  homeModel2.m
//  DZ
//
//  Created by PFei_He on 14-8-21.
//
//

#import "homeModel2.h"
#import "home2.h"

@implementation homeModel2

DEF_SINGLETON(homeModel2)

- (void)loadImage
{
    [API_HOME2_SHOTS cancel];
    API_HOME2_SHOTS *api = [API_HOME2_SHOTS api];

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
                if (nil == api.resp || api.resp.ecode.integerValue) {
                    api.failed = YES;
                    [self sendUISignal:self.FAILED];
                }
                else
                {
                    [self.shots removeAllObjects];
                    [self.shots addObjectsFromArray:api.resp.home.slide];
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
