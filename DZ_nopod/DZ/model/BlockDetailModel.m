//
//  BlockDetailModel.m
//  DZ
//
//  Created by PFei_He on 14-10-29.
//
//

#import "BlockDetailModel.h"
#import "blockdetail.h"

@implementation BlockDetailModel

- (void)loadData
{
    [API_BLOCKDETAIL_SHOTS cancel];
    API_BLOCKDETAIL_SHOTS *api = [API_BLOCKDETAIL_SHOTS api];

    @weakify(api);
    @weakify(self);

    api.bid = self.bid;

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
                    self.shots = api.resp.blockitem.items;
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
