//
//  Remind_ActivityModel.m
//  DZ
//
//  Created by Nonato on 14-8-21.
//
//

#import "Remind_ActivityModel.h"
#import "UserModel.h"
#import "rmbdz.h"

@implementation Remind_ActivityModel
DEF_SINGLETON(Remind_ActivityModel)
@synthesize uid=_uid,shots=_shots;

- (void)load
{
    FRIENDSMESSAGE = 0;
    SYSTEMMESSAGE = 0;
	self.autoSave = NO;
	self.autoLoad = NO;
    _friendsautomatic = [[NSMutableArray alloc] init];
    _sysautomatic = [[NSMutableArray alloc] init];
    _activityautomatic = [[NSMutableArray alloc] init];
}

- (void)unload
{
    _uid = nil;
    _shots = nil;
    _dialog = nil;
    _friendsautomatic = nil;
    _sysautomatic = nil;
    _activityautomatic = nil;
    //    _automatic=nil;
}

+(int)newmessagecount
{
    return FRIENDSMESSAGE + INNERMESSAGE + SYSTEMMESSAGE;
}

+(int)friendmessagecount
{
    return FRIENDSMESSAGE;
}

+(int)innermessagecount
{
    return INNERMESSAGE;
}
+(int)systemmessagecount
{
    return SYSTEMMESSAGE;
}
#pragma mark -

-(void)loadCache
{
    self.uid = [UserModel sharedInstance].session.uid;
    if (!self.uid) {
        self.uid = [[UserModel sharedInstance] defaultSession].uid;
    }
    NSString * myclass= NSStringFromClass([self class]);
    NSString * myuid=self.uid;
    NSString * key=  MODELOBJECTKEY(myclass,myuid);
    
    self.dialog  =[NSMutableArray arrayWithArray:[dialog readObjectForKey:key]];
    NSString * syskey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_SYSTEM_REMAIND]);
    NSString * activitykey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_ACTIVITY_REMIND]);
    
    self.sysautomatic=[NSMutableArray arrayWithArray:[automatic readObjectForKey:syskey]];
    
    self.activityautomatic=[NSMutableArray arrayWithArray:[automatic readObjectForKey:activitykey]];
    
    NSString * friendkey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_GOODFREIND]);
    self.friendsautomatic =[NSMutableArray arrayWithArray: [automatic readObjectForKey:friendkey]];
}
- (void)saveCache
{
    NSString * myclass= NSStringFromClass([self class]);
    NSString * myuid=self.uid?self.uid:[UserModel sharedInstance].session.uid;
    NSString * key=  MODELOBJECTKEY(myclass,myuid);
    
    if (self.shots.count) {
        [REMIND saveObject:self.shots forKey:key];
    }
    if (self.dialog.count) {
        [dialog saveObject:self.dialog forKey:key];
    }
    
    if (self.sysautomatic.count) {
        NSString * syskey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_SYSTEM_REMAIND]);
        [automatic saveObject:self.sysautomatic forKey:syskey];
    }
    if (self.activityautomatic.count) {
        NSString * actkey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_ACTIVITY_REMIND]);
        [automatic saveObject:self.activityautomatic forKey:actkey];
    }
    
    if (self.friendsautomatic.count) {
        NSString * friendkey=  MODELOBJECTKEY(key,[NSString stringWithFormat:@"%d",MSG_GOODFREIND]);
        [automatic saveObject:self.friendsautomatic forKey:friendkey];
    }
    
}

- (void)clearCache:(MSG_TYPE_REMIND)msg_type
{
    if (msg_type == MSG_SYSTEM_REMAIND) {
        [self.sysautomatic removeAllObjects];
    }
    else if (msg_type == MSG_ACTIVITY_REMIND) {
        [self.activityautomatic removeAllObjects];
    }
    else if (msg_type == MSG_GOODFREIND)
    {
        [self.friendsautomatic removeAllObjects];
    }
    else if (msg_type == MSG_ZHANNEIXIN)
    {
        
    }
}

- (void)clearCache
{
    [self.shots removeAllObjects];
    [self.dialog removeAllObjects];
    [self.sysautomatic removeAllObjects];
    [self.activityautomatic removeAllObjects];
    [self.friendsautomatic removeAllObjects];
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
    
    [API_REMIND_SHOTS cancel];
	API_REMIND_SHOTS * api = [API_REMIND_SHOTS api];
	@weakify(api);
	@weakify(self);
    api.uid=[UserModel sharedInstance].session.uid;
	
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
                    [self sendUISignal:self.FAILED withObject:[STATUS errmessage:ERR_FRESHERROR]];
				}
				else
				{
                    if ( page <= 1 )
					{
                        //                        [self.shots removeAllObjects];
                        [self.dialog removeAllObjects];//0813 不保留之前记录
                        //                        [self.friendsautomatic removeAllObjects];
                        //                        [self.sysautomatic removeAllObjects];
                        if (api.resp.public2.count) {
                            [self.shots addObjectsFromArray:api.resp.public2];
                        }
                        if (api.resp.automatic) {
                            [self splitAutomotic:api.resp.automatic];
                        }
                        if (api.resp.dialog.count) {
                            [self.dialog addObjectsFromArray:api.resp.dialog];
                        }
                        self.nowdate = api.resp.nowdate;
					}
					else
					{
						[self.shots addObjectsFromArray:api.resp.public2];
					}
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED withObject:[STATUS errmessage:ERR_FRESHERROR]];
            }
		}
	};
	[api send];
}

-(void)splitAutomotic:(NSArray *)array
{
    //    [self.friendsautomatic removeAllObjects];
    //    [self.sysautomatic removeAllObjects];
    FRIENDSMESSAGE = 0;
    SYSTEMMESSAGE = 0;
    for ( automatic *obj in array) {
        if ([obj.interactivems isEqualToString:@"friend"]) {
            [self.friendsautomatic addObject:obj];
            FRIENDSMESSAGE ++;
            BeeLog(@"----%d 有好友消息",SYSTEMMESSAGE);
        }
        else if([obj.interactivems isEqualToString:@"system"])
        {
            [self.sysautomatic addObject:obj];
            SYSTEMMESSAGE ++;
            BeeLog(@"----%d 有系统消息",SYSTEMMESSAGE);
        }
        else if([obj.interactivems isEqualToString:@"activity"])
        {
            [self.activityautomatic addObject:obj];
            ACTVMESSAGE ++;
            BeeLog(@"----%d 有您有新的活动消息",ACTVMESSAGE);
        }
    }
}
@end
