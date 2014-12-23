//
//  delfavoritearticleModel.m
//  DZ
//
//  Created by PFei_He on 14-12-1.
//
//

#import "delfavoritearticleModel.h"
#import "delfavoritearticle.h"
#import "UserModel.h"

@implementation delfavoritearticleModel

- (void)delcollection
{
    [API_DELFAVORITEARTICLE_SHOTS cancel];
    API_DELFAVORITEARTICLE_SHOTS *api = [API_DELFAVORITEARTICLE_SHOTS api];

    @weakify(api);
    @weakify(self);

    api.uid = self.uid;
    api.favid = self.favid;

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
