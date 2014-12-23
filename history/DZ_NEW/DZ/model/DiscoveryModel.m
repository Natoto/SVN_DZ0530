//
//  DiscoveryModel.m
//  DZ
//
//  Created by nonato on 14-10-27.
//
//

#import "DiscoveryModel.h"
#import "discovery_dz.h"

#define INT2STR(TYPE) [NSString stringWithFormat:@"%d",TYPE]
#define TOPTENKEY(TYPE) MODELOBJECTKEY(NSStringFromClass([self class]),INT2STR(TYPE))


@implementation DiscoveryModel

- (void)load
{
    self.autoSave = YES;
    self.autoLoad = YES;
    self.shots = [NSMutableArray array];
}

- (void)unload
{
    self.shots = nil;
}

-(NSInteger)type
{
    return 1027;
}
#pragma mark -

- (void)loadCache
{
    [self.shots removeAllObjects];
     self.shots=[NSMutableArray arrayWithArray:[discovery readObjectForKey:TOPTENKEY(self.type)]];
}

- (void)saveCache
{
    [discovery saveObject:self.shots forKey:TOPTENKEY(self.type)];
    //    [topic saveObject:self.maintopic forKey:OBJECTMAINTOPKEY(self.tid, self.type)];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
}

#pragma mark -

- (void)firstPage
{
    [self gotoPage:1];
}

- (void)nextPage
{
    if ( self.shots.count )
    {
        [self gotoPage:((self.shots.count +1) / PER_PAGE + 1)];
    }
}

- (void)gotoPage:(NSUInteger)page
{
    [API_DISCOVERY_SHOTS cancel];
    API_DISCOVERY_SHOTS * api = [API_DISCOVERY_SHOTS api];
    
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
                    if ( page <= 1 )
                    {
                        [self.shots removeAllObjects];
                        [self.shots addObjectsFromArray:api.resp.discovery];
                    }
                    else
                    {
                        [self.shots addObjectsFromArray:api.resp.discovery];
                    }
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