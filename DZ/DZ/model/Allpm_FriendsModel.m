//
//  FriendsPM.m
//  DZ
//
//  Created by Nonato on 14-8-14.
//
//

#import "Allpm_FriendsModel.h"
#define KEY_FRIENDS @"friends"
#define KEY_FRIENDS_NAME @"friends_name"
#define KEY_NEWMESSAGE_NAME @"newmessage_friends_name"

@implementation Allpm_FriendsModel
DEF_SINGLETON(Allpm_FriendsModel)
#pragma mark -
- (void)load·
{
	self.autoSave = NO;
	self.autoLoad = NO;
}

- (void)unload
{
    _friendmsDic = nil;
    _uid=nil;
//    _friendms=nil;
}
-(NSString *)msgtype
{
    return [NSString stringWithFormat:@"%d",MSG_HAOYOU];
}

#pragma mark - 好友消息保存获取
-(void)loadCache
{
//    _friendms=[[NSMutableArray alloc] initWithCapacity:0];
//    _agoodfriendms=[[NSMutableArray alloc] initWithCapacity:1];
    _newfriendmsDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    _friendmsDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    
//    [self.agoodfriendms removeAllObjects];
//    [self.friendms removeAllObjects];
     [_friendmsDic removeAllObjects];
     self.uid=[UserModel sharedInstance].session.uid;
     if (self.uid) {
        NSString *myclass= NSStringFromClass([self class]);
        KEY_CLS_UID_TYPE =  MODELOBJECTKEY(myclass,self.uid,self.msgtype);
        self.nowdate=[LASFLASHDATA readObjectForKey:KEY_CLS_UID_TYPE];
        [self loadfriendmsCache];
    }
}

-(void)loadfriendmsCache//:(NSString *)frienduid agoodfriendms:(NSMutableArray *)onegoodfriendms
{
    NSMutableArray *frdnameAry=[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_FRIENDS_NAME];
  
    NSMutableArray *mtfriendsms = [[NSMutableArray alloc] initWithCapacity:0];
    for (int index=0;index < frdnameAry.count;index++ ) {
        const ALLPMMODEFRIENDSLIST * frdname = [frdnameAry objectAtIndex:index];
        if (!frdname || !frdname.fromid) {
            continue;
        }
        NSString *mykey = MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid);
        NSArray *afriendAry = nil;
        if (![self.friendmsDic objectForKey:mykey]) {
            afriendAry=[NSArray arrayWithArray:[friendms readObjectForKey:mykey]];
            [self.friendmsDic setObject:afriendAry forKey:frdname.fromid];
        }
        else
        {
            [self.friendmsDic setObject:afriendAry forKey:frdname.fromid];
            afriendAry = [self.friendmsDic objectForKey:frdname.fromid];
        }
        [mtfriendsms addObject:afriendAry];
    }
//    return mtfriendsms;//返回的是所有的消息
}


-(void)clearfriendsms
{
    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_FRIENDS_NAME]];
    for (int index=0;index < frdnameAry.count;index++ ) {
        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
        NSString *mykey=MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid);
        [friendms removeObjectForKey:mykey];
    }
    [ALLPMMODEFRIENDSLIST removeObjectForKey:KEY_FRIENDS_NAME];
}
-(void)savefriendsms
{
    NSArray *nameAry=_friendmsDic.allKeys;
    NSMutableArray *namelist=[[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in nameAry) {
        ALLPMMODEFRIENDSLIST *friendname = [[ALLPMMODEFRIENDSLIST alloc] init];
        friendname.fromid = key;
        [namelist addObject:friendname];
        NSArray *array = [_friendmsDic objectForKey:key];
        if (!array.count) {
            continue;
        }
        NSString  *frienduid = MODELOBJECTKEY(KEY_CLS_UID_TYPE,key);
       [friendms saveObject:array forKey:frienduid];
    }
    if (namelist.count) {
        [ALLPMMODEFRIENDSLIST saveObject:namelist forKey:KEY_FRIENDS_NAME];
    }
}

#pragma mark - 清空保存陌生人信息
 

- (void)saveCache
{
    [LASFLASHDATA saveObject:self.nowdate forKey:KEY_CLS_UID_TYPE];
    [self savefriendsms];
}

#pragma mark - 新消息提醒 独立使用
-(void)saveNewMessage
{
    NSArray *nameAry=_newfriendmsDic.allKeys;
    NSMutableArray *namelist=[[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in nameAry) {
        ALLPMMODEFRIENDSLIST *friendname = [[ALLPMMODEFRIENDSLIST alloc] init];
        friendname.fromid = key;
        [namelist addObject:friendname];
        NSArray *array = [_newfriendmsDic objectForKey:key];
        if (!array.count) {
            continue;
        }
        NSString *frienduid = MODELOBJECTKEY(KEY_CLS_UID_TYPE,key,KEY_NEWMESSAGE_NAME);
        [friendms saveObject:array forKey:frienduid];
    }
    if (namelist.count) {
        [ALLPMMODEFRIENDSLIST saveObject:namelist forKey:KEY_NEWMESSAGE_NAME];
    }
}

-(void)loadNewMessageCashe
{
    NSMutableArray *frdnameAry=[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_NEWMESSAGE_NAME];
    
    NSMutableArray *mtfriendsms = [[NSMutableArray alloc] initWithCapacity:0];
    for (int index=0;index < frdnameAry.count;index++ ) {
        const ALLPMMODEFRIENDSLIST * frdname = [frdnameAry objectAtIndex:index];
        if (!frdname || !frdname.fromid) {
            continue;
        }
        NSString *mykey = MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid,KEY_NEWMESSAGE_NAME);
        NSArray *afriendAry = nil;
        if (![self.newfriendmsDic objectForKey:mykey]) {
            afriendAry=[NSArray arrayWithArray:[friendms readObjectForKey:mykey]];
            [self.newfriendmsDic setObject:afriendAry forKey:frdname.fromid];
        }
        else
        {
            [self.newfriendmsDic setObject:afriendAry forKey:frdname.fromid];
            afriendAry = [self.newfriendmsDic objectForKey:frdname.fromid];
        }
        [mtfriendsms addObject:afriendAry];
    }
    [self clearNewMessageCache];
}
-(void)clearNewMessageCache
{
    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_NEWMESSAGE_NAME]];
    for (int index=0;index < frdnameAry.count;index++ ) {
        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
        NSString *mykey=MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid,KEY_NEWMESSAGE_NAME);
        [friendms removeObjectForKey:mykey];
    }
    [ALLPMMODEFRIENDSLIST removeObjectForKey:KEY_NEWMESSAGE_NAME];
}
// 清除一个新消息

-(void)clearOnewNewMessage:(NSString *)onefrienduid
{
    [self.newfriendmsDic removeObjectForKey:onefrienduid];
}


- (void)clearCache
{
    [ALLPMMODEFRIENDSLIST removeObjectForKey:KEY_FRIENDS_NAME];
    [LASFLASHDATA removeObjectForKey:KEY_CLS_UID_TYPE];
    [NSDictionary removeObjectForKey:KEY_CLS_UID_TYPE];
    [allpm_public removeObjectForKey:KEY_CLS_UID_TYPE];
    [strangerms removeObjectForKey:KEY_CLS_UID_TYPE];
    
//    [self.friendms removeAllObjects];
     self.loaded=NO;
}

#pragma mark -

- (void)firstPage
{
   [self getMessageWithtype:self.msgtype date:self.nowdate.nowdate];
}


- (void)nextPage
{
    [self firstPage];
}


-(void )getMessageWithtype:(NSString *)type date:(NSNumber *)date
{
    //    [self clearCache];
    [API_ALLPM_SHOTS cancel];
	API_ALLPM_SHOTS * api = [API_ALLPM_SHOTS api];
    self.msgtype=type;
	@weakify(api);
	@weakify(self);
    
    self.uid=[UserModel sharedInstance].session.uid;
    api.uid=self.uid;
    api.date=date;
    api.style=type;
    date= date?date:[NSNumber numberWithInt:0];
    if (!date || !type) {
        BeeLog(@"allpm 条件不足!");
        return;
    }
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
            _loading=YES;
		}
		else
		{
            _loading=NO;
			if ( api.succeed )
			{
                _loading=NO;
				if ( nil == api.resp || api.resp.ecode.integerValue)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{ 
                        if (api.resp.friendms.count) {
                        //获得新消息 随时可以变化的 顺便把总消息也加入到字典中去了
                        NSMutableDictionary *dic =[self analysisfriendsms:api.resp.friendms];
                        if (dic.count) {
                            self.newfriendmsDic = dic;
                        }
                    }
                    LASFLASHDATA *adate=[[LASFLASHDATA alloc] init];
                    adate.nowdate=api.resp.nowdate;
                    self.nowdate=adate;
                    
					self.more =  NO;
					self.loaded = YES;
  				    [self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                [self sendUISignal:self.FAILED ];
            }
		}
	};
	[api send];
    //    return allpm;
}
/*
-(NSMutableArray *)analysisfriendsms:(NSArray *)selffriendsms
{
    NSMutableArray *myfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSArray *array in selffriendsms) {
        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
        for ( NSDictionary *afriend in array) {
            friendms *friendmscls=[friendms objectFromDictionary:afriend];
            [subfriendsms addObject:friendmscls];
        }
        if (subfriendsms.count) {
            [myfriendsms addObject:subfriendsms];
        }
    }
    return myfriendsms;
}*/

-(NSString *)readfrienduidFromfriendms:(friendms *)afriendms
{
    if (![afriendms.authorid isEqualToString:self.uid]) {
        return afriendms.authorid;
    }
    return afriendms.touid;
}

-(NSMutableDictionary *)analysisfriendsms:(NSArray *)selffriendsms
{
   NSMutableDictionary *newfriendsmsDic=[[NSMutableDictionary alloc] initWithCapacity:0];
 
    for (NSArray *array in selffriendsms) {
        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
     
        for ( NSDictionary *afriend in array) {
            friendms *friendmscls=[friendms objectFromDictionary:afriend];
            [subfriendsms addObject:friendmscls];
                //                continue;
        }
        if (subfriendsms.count) {
            NSMutableArray *myfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
   
            [myfriendsms addObjectsFromArray:subfriendsms];
            NSString *frienduid = [self readfrienduidFromfriendms:[subfriendsms objectAtIndex:0]];
            //新消息提醒用得到
            NSMutableArray *newmsgary =[NSMutableArray arrayWithArray:[_newfriendmsDic objectForKey:frienduid]];
            newmsgary = (NSMutableArray *)[newmsgary arrayByAddingObjectsFromArray:myfriendsms];
            [newfriendsmsDic setObject:myfriendsms forKey:frienduid];
            //加入到消息队列中去
            NSMutableArray *array =[NSMutableArray arrayWithArray:[_friendmsDic objectForKey:frienduid]];
            if (array) {
                 array = (NSMutableArray *)[array arrayByAddingObjectsFromArray:subfriendsms];
                [_friendmsDic setObject:array forKey:frienduid];
            }
            else
            {
                [_friendmsDic setObject:myfriendsms forKey:frienduid];
            }
        }
    }
    return newfriendsmsDic;
}



@end
