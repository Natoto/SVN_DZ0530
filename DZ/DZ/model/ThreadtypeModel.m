//
//  ThreadtypeModel.m
//  DZ
//
//  Created by nonato on 14-9-28.
//
//

#import "ThreadtypeModel.h"

@implementation ThreadtypeModel
@synthesize fid=_fid,shots=_shots;
- (void)load
{
    self.autoSave = NO;
    self.autoLoad = NO;
    self.shots=[[NSMutableArray alloc] initWithCapacity:0];
}

- (void)unload
{
    _fid=nil;
    _shots=nil;
}

#pragma mark -

- (void)loadCache
{
    NSArray * array = [threadtype readObjectForKey:self.KEY_CLS_TYPE];
    if (array.count) {
        self.shots=[NSMutableArray arrayWithArray:array];
    }
}

+(void)readthreadtype:(NSString *)fid block:(resultThreadBlock)block
{
    NSString *myclass= NSStringFromClass([self class]);
    NSString * key= MODELOBJECTKEY(myclass,fid);
    NSArray * array = [threadtype readObjectForKey:key];
    if (array) {
        block(array);
    }
    else
    {
        [API_THREADTYPE_SHOTS cancel];
        API_THREADTYPE_SHOTS * api = [API_THREADTYPE_SHOTS api];
        @weakify(api);
        api.fid=fid;
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
                    if ( nil == api.resp || api.resp.ecode.integerValue)
                    {
                        api.failed = YES;
                        block(nil);
                    }
                    else
                    {
                        NSArray * array = api.resp.threadtype;
                        [threadtype saveObject:array forKey:fid];
                        block(array);
                    }
                }
                else
                {
                    block(nil);
                }
            }
        };
        
        [api send];
    }

}

-(NSString *)KEY_CLS_TYPE
{
    if (!_KEY_CLS_TYPE) {
        NSString *myclass= NSStringFromClass([self class]);
        _KEY_CLS_TYPE = MODELOBJECTKEY(myclass,_fid);
    }
    return _KEY_CLS_TYPE;
}
- (void)saveCache
{
    [threadtype saveObject:self.shots forKey:self.KEY_CLS_TYPE];
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    self.loaded=NO;
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
        [self gotoPage:(self.shots.count / PER_PAGE + 1)];
    }
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_THREADTYPE_SHOTS cancel];
    API_THREADTYPE_SHOTS * api = [API_THREADTYPE_SHOTS api];
    @weakify(api);
    @weakify(self);
    api.fid=_fid;
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
                if ( nil == api.resp || api.resp.ecode.integerValue)
                {
                    api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
                }
                else
                {
                    [self.shots removeAllObjects];
                    [self.shots addObjectsFromArray:api.resp.threadtype];
                    self.more = NO;
                    self.loaded = YES;
                    [self saveCache];
                    [self sendUISignal:self.RELOADED];
                }
            }
            else
            {
                [self sendUISignal:self.FAILED withObject:api.resp.emsg];
            }
        }
    };
    
    [api send];
}
@end
