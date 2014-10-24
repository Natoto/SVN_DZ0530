//
//  ToptenModel.m
//  DZ
//
//  Created by nonato on 14-10-20.
//
//

#import "ToptenModel.h"
#import "topten.h"
#import "bee.h"
#define INT2STR(TYPE) [NSString stringWithFormat:@"%d",TYPE]
#define TOPTENKEY(TYPE) MODELOBJECTKEY(NSStringFromClass([self class]),INT2STR(TYPE))

@implementation ToptenModel

- (void)load
{
    self.autoSave = YES;
    self.autoLoad = YES;
    self.shots = [NSMutableArray array];
    self.type = TOPTEN_VIEWMOST;
}

- (void)unload
{
    self.shots = nil;
}

#pragma mark -

- (void)loadCache
{
    [self.shots removeAllObjects];
    self.shots=[NSMutableArray arrayWithArray:[topics readObjectForKey:TOPTENKEY(self.type)]];
    
}

- (void)saveCache
{
    [topics saveObject:self.shots forKey:TOPTENKEY(self.type)];
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
    [API_TOPTEN_SHOTS cancel];
    API_TOPTEN_SHOTS * api = [API_TOPTEN_SHOTS api];
    
    @weakify(api);
    @weakify(self);
    
    api.type = INT2STR(self.type);
    api.req.page = @(page);
    api.req.per_page = @(PER_PAGE);
    
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
                        [self.shots addObjectsFromArray:api.resp.topics];
                    }
                    else
                    {
                        [self.shots addObjectsFromArray:api.resp.topics];
                    }
                    self.more = !api.resp.isEnd.intValue; //(self.shots.count >= api.resp.total.intValue) ? NO : YES;;
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