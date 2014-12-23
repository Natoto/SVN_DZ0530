//
//  Switch_OnoffModel.m
//  DZ
//
//  Created by nonato on 14-10-30.
//
//

#import "Switch_OnoffModel.h"
#import "UserModel.h"
#import "homeModel.h"
#define INT2STR(TYPE) [NSString stringWithFormat:@"%d",TYPE]



@implementation Switch_OnoffModel

- (void)load
{
    self.autoSave = YES;
    self.autoLoad = YES;
}

- (void)unload
{
    
    self.shots = nil;
}

-(NSInteger)type
{
    return 1030;
}

#pragma mark -

- (void)loadCache
{
    self.shots= [onoff readObjectForKey:KEY_ONOFF];
}

- (void)saveCache
{
    [onoff saveObject:self.shots forKey:KEY_ONOFF];
    //    [topic saveObject:self.maintopic forKey:OBJECTMAINTOPKEY(self.tid, self.type)];
}

+(onoff *)readOnff
{
    return [homeModel readOnff];
}

- (void)clearCache
{
    [onoff removeObjectForKey:KEY_ONOFF];
}

#pragma mark -

- (void)firstPage
{
    [self gotoPage:1];
}

- (void)nextPage
{
    [self firstPage];
}

+(void)getSwitch_OnOff:(successBlock)successblock errorblock:(errorBlock)errorblock
{
    [API_SWITCH_ONOFF_SHOTS cancel];
    API_SWITCH_ONOFF_SHOTS * api = [API_SWITCH_ONOFF_SHOTS api];
    @weakify(api);
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            
        }
        else
        {
            if ( api.succeed )
            {
                if ( nil == api.resp)
                {
                    api.failed = YES;
                    errorblock(@"error");
                }
                else
                {
                    if (api.resp.ecode.integerValue) {
                        errorblock(api.resp.emsg);
                        return ;
                    }
                    [onoff saveObject:api.resp.onoff forKey:KEY_ONOFF];
                    successblock(api.resp.onoff);
                }
            }
            else
            {
                errorblock(nil);
            }
        }
    };
    
    [api send];
}


- (void)gotoPage:(NSUInteger)page
{
    [API_SWITCH_ONOFF_SHOTS cancel];
    API_SWITCH_ONOFF_SHOTS * api = [API_SWITCH_ONOFF_SHOTS api];
    
    @weakify(api);
    @weakify(self);
    
    
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
                    self.shots = api.resp.onoff;
                     
                    self.more = YES;
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