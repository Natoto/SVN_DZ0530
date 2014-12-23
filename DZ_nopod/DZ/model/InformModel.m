//
//  InformModel.m
//  DZ
//
//  Created by PFei_He on 14-9-4.
//
//

#import "InformModel.h"
#import "UserModel.h"

@implementation InformModel

- (void)inform
{
    [API_INFORM_SHOTS cancel];
    API_INFORM_SHOTS *api = [API_INFORM_SHOTS api];

    @weakify(api);
	@weakify(self);

    api.ruid = self.ruid;
    api.message = self.message;
    api.uid = self.uid;

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
                    self.shots = api.resp;
                    api.failed = YES;
                    [self sendUISignal:self.FAILED];
                }
                else
                {
                    self.shots = api.resp;
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
