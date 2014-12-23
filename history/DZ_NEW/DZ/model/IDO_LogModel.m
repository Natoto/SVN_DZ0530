//
//  IDO_LogModel.m
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//

#import "DZ_UIDevice_IOKit_Extensions.h"
#import "DZ_SystemSetting.h"
#import "IDO_LogModel.h"
#define IOSTYPE @"2"
@implementation IDO_LogModel
@synthesize  shots=_shots;
- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
}

- (void)unload
{
    _shots=nil;
}
#pragma mark -
- (void)loadCache
{
    
}

- (void)saveCache
{
}

- (void)clearCache
{
    
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

-(NSString *)ostype
{
    return IOSTYPE;
}

-(NSString *)appid
{
    return [DZ_SystemSetting sharedInstance].appid;
}

-(NSString *)appversion
{
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    return [DZ_SystemSetting sharedInstance].appversion;
}

-(NSString *)imei
{
    NSString *imei1= [UIDevice currentDevice].imei;
    if (!imei1) {
        /*为了上架 将udid用idfv代替
         或者adfa
         [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
         */
         imei1  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        imei1 = [NSString stringWithFormat:@"%@%@",imei1,[DZ_SystemSetting sharedInstance].appid];
//        imei1 = [OpenUDID value];
    }
    return imei1;
}

-(NSString *)mei
{
    return [UIDevice currentDevice].mei;
}

-(NSString *)ccid
{
    return nil; //[UIDevice currentDevice].ccid;
}

-(NSString *)device
{
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//   BeeLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
   BeeLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
   BeeLog(@"手机型号: %@",phoneModel );
    
    NSString * phonemodelversion=[NSString stringWithFormat:@"MODEL:%@\nV.R:%@",phoneModel,phoneVersion];
    return  phonemodelversion;
    //[OpenUDID value];
}


- (void)nextPage
{
    [self firstPage];
}

- (void)gotoPage:(NSUInteger)page
{
    
    [API_IDO_LOG_SHOTS cancel];
	API_IDO_LOG_SHOTS * api = [API_IDO_LOG_SHOTS api];
	@weakify(api);
	@weakify(self);
	
    
    if (!self.ostype || !self.appid || !self.appversion) {
        BeeLog(@" 统计的参数不完整。。。");
        return;
    }
    
    
    api.ostype = self.ostype;
    api.appid = self.appid;
    api.appviersion = self.appversion;
    api.imei = self.imei;
    api.mei = self.mei;
    api.ccid = self.ccid;
    api.device = self.device;
    
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
                    self.shots = api.resp;
					self.more = NO; //(api.resp.i.intValue==0)?YES:NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED withObject:api.description];
            }
		}
	};
	
	[api send];
}
@end
