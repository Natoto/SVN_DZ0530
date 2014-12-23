//
//  Allpm_StrangerModel.m
//  DZ
//
//  Created by Nonato on 14-8-15.
//
//

#import "Allpm_StrangerModel.h"
#define KEY_STRANGER @"STRANGER "
#define KEY_STRANGER_NAME @"STRANGER _name"
#define KEY_NEWMESSAGE_STRANGERNAMENAME @"newmessage_STRANGER _name"

@implementation Allpm_StrangerModel
DEF_SINGLETON(Allpm_StrangerModel)
#pragma mark -
- (void)load
{
	self.autoSave = NO;
	self.autoLoad = NO;
}

- (void)unload
{
    _strangermsDic = nil;
    _uid=nil;
    //    _strangerms=nil;
}
-(NSString *)msgtype
{
    return [NSString stringWithFormat:@"%d",MSG_HAOYOU];
}

#pragma mark - 好友消息保存获取
-(void)loadCache
{
    //    _strangerms=[[NSMutableArray alloc] initWithCapacity:0];
    //    _agoodstrangerms=[[NSMutableArray alloc] initWithCapacity:1];
    _newstrangermsDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    _strangermsDic=[[NSMutableDictionary alloc] initWithCapacity:0];

    //    [self.agoodstrangerms removeAllObjects];
    //    [self.strangerms removeAllObjects];
    [_strangermsDic removeAllObjects];
    self.uid=[UserModel sharedInstance].session.uid;
    if (self.uid) {
        NSString *myclass= NSStringFromClass([self class]);
        KEY_CLS_UID_TYPE =  MODELOBJECTKEY(myclass,self.uid,self.msgtype,KEY_STRANGER);
        self.nowdate=[LASFLASHDATA readObjectForKey:KEY_CLS_UID_TYPE];
        [self loadstrangermsCache];
    }
}


-(void)loadstrangermsCache//:(NSString *)frienduid agoodstrangerms:(NSMutableArray *)onegoodstrangerms
{
    NSMutableArray *frdnameAry=[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_STRANGER_NAME];
    
    NSMutableArray *mtfriendsms = [[NSMutableArray alloc] initWithCapacity:0];
    for (int index=0;index < frdnameAry.count;index++ ) {
        const ALLPMMODEFRIENDSLIST * frdname = [frdnameAry objectAtIndex:index];
        if (!frdname || !frdname.fromid) {
            continue;
        }
        NSString *mykey = MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid);
        NSArray *afriendAry = nil;
        if (![self.strangermsDic objectForKey:mykey]) {
            afriendAry=[NSArray arrayWithArray:[strangerms readObjectForKey:mykey]];
            [self.strangermsDic setObject:afriendAry forKey:frdname.fromid];
        }
        else
        {
            [self.strangermsDic setObject:afriendAry forKey:frdname.fromid];
            afriendAry = [self.strangermsDic objectForKey:frdname.fromid];
        }
        [mtfriendsms addObject:afriendAry];
    }
    //    return mtfriendsms;//返回的是所有的消息
}


-(void)clearfriendsms
{
    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_STRANGER_NAME]];
    for (int index=0;index < frdnameAry.count;index++ ) {
        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
        NSString *mykey=MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid);
        [strangerms removeObjectForKey:mykey];
    }
    [ALLPMMODEFRIENDSLIST removeObjectForKey:KEY_STRANGER_NAME];
}
-(void)savefriendsms
{
    NSArray *nameAry=_strangermsDic.allKeys;
    NSMutableArray *namelist=[[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in nameAry) {
        ALLPMMODEFRIENDSLIST *friendname = [[ALLPMMODEFRIENDSLIST alloc] init];
        friendname.fromid = key;
        [namelist addObject:friendname];
        NSArray *array = [_strangermsDic objectForKey:key];
        if (!array.count) {
            continue;
        }
        NSString  *frienduid = MODELOBJECTKEY(KEY_CLS_UID_TYPE,key);
        [strangerms saveObject:array forKey:frienduid];
    }
    if (namelist.count) {
        [ALLPMMODEFRIENDSLIST saveObject:namelist forKey:KEY_STRANGER_NAME];
    }
}

#pragma mark - 清空保存陌生人信息
-(void)clearStrangersms
{
    NSString *myuidkey=MODELOBJECTKEY(self.uid);
    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:myuidkey]];
    for (int index=0;index < frdnameAry.count;index++ ) {
        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
        NSString *mykey=MODELOBJECTKEY(frdname.fromid,myuidkey);
        [strangerms removeObjectForKey:mykey];
    }
    [ALLPMMODEFRIENDSLIST removeObjectForKey:myuidkey];
    //    [self.strangerms removeAllObjects];
}


- (void)saveCache
{
    [LASFLASHDATA saveObject:self.nowdate forKey:KEY_CLS_UID_TYPE];
    [self savefriendsms];
}

#pragma mark - 新消息提醒 独立使用
-(void)saveNewMessage
{
    NSArray *nameAry=_newstrangermsDic.allKeys;
    NSMutableArray *namelist=[[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in nameAry) {
        ALLPMMODEFRIENDSLIST *friendname = [[ALLPMMODEFRIENDSLIST alloc] init];
        friendname.fromid = key;
        [namelist addObject:friendname];
        NSArray *array = [_newstrangermsDic objectForKey:key];
        if (!array.count) {
            continue;
        }
        NSString  *frienduid = MODELOBJECTKEY(KEY_CLS_UID_TYPE,key,KEY_NEWMESSAGE_STRANGERNAMENAME);
        [strangerms saveObject:array forKey:frienduid];
    }
    if (namelist.count) {
        [ALLPMMODEFRIENDSLIST saveObject:namelist forKey:KEY_NEWMESSAGE_STRANGERNAMENAME];
    }
}

-(void)loadNewMessageCashe
{
    NSMutableArray *frdnameAry=[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_NEWMESSAGE_STRANGERNAMENAME];
    
    NSMutableArray *mtfriendsms = [[NSMutableArray alloc] initWithCapacity:0];
    for (int index=0;index < frdnameAry.count;index++ ) {
        const ALLPMMODEFRIENDSLIST * frdname = [frdnameAry objectAtIndex:index];
        if (!frdname || !frdname.fromid) {
            continue;
        }
        NSString *mykey = MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid,KEY_NEWMESSAGE_STRANGERNAMENAME);
        NSArray *afriendAry = nil;
        if (![self.newstrangermsDic objectForKey:mykey]) {
            afriendAry=[NSArray arrayWithArray:[strangerms readObjectForKey:mykey]];
            [self.newstrangermsDic setObject:afriendAry forKey:frdname.fromid];
        }
        else
        {
            [self.newstrangermsDic setObject:afriendAry forKey:frdname.fromid];
            afriendAry = [self.newstrangermsDic objectForKey:frdname.fromid];
        }
        [mtfriendsms addObject:afriendAry];
    }
    [self clearNewMessageCache];
}
-(void)clearNewMessageCache
{
    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:KEY_NEWMESSAGE_STRANGERNAMENAME]];
    for (int index=0;index < frdnameAry.count;index++ ) {
        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
        NSString *mykey=MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid,KEY_NEWMESSAGE_STRANGERNAMENAME);
        [strangerms removeObjectForKey:mykey];
    }
    [ALLPMMODEFRIENDSLIST removeObjectForKey:KEY_NEWMESSAGE_STRANGERNAMENAME];
}

// 清除一个新消息
-(void)clearOnewNewMessage:(NSString *)onefrienduid
{
    [self.newstrangermsDic removeObjectForKey:onefrienduid];
}


- (void)clearCache
{
    [ALLPMMODEFRIENDSLIST removeObjectForKey:KEY_STRANGER_NAME];
    [LASFLASHDATA removeObjectForKey:KEY_CLS_UID_TYPE];
    [NSDictionary removeObjectForKey:KEY_CLS_UID_TYPE];
    [allpm_public removeObjectForKey:KEY_CLS_UID_TYPE];
    [strangerms removeObjectForKey:KEY_CLS_UID_TYPE];
    
    //    [self.strangerms removeAllObjects];
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
                    if (api.resp.strangerms.count) {
                        //获得新消息 随时可以变化的 顺便把总消息也加入到字典中去了
                        NSMutableDictionary *dic =[self analysisfriendsms:api.resp.strangerms];
                        if (dic.count) {
                            self.newstrangermsDic = dic;
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

-(NSString *)readfrienduidFromstrangerms:(strangerms *)astrangerms
{
    if (![astrangerms.authorid isEqualToString:self.uid]) {
        return astrangerms.authorid;
    }
    return astrangerms.touid;
}


-(NSMutableDictionary *)analysisfriendsms:(NSArray *)selffriendsms
{
    NSMutableDictionary *newfriendsmsDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSArray *array in selffriendsms) {
        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
        
        for ( strangerms *strangermscls in array) {
            //            strangerms *strangermscls=[strangerms objectFromDictionary:afriend];
            [subfriendsms addObject:strangermscls];
            //                continue;
        }
        if (subfriendsms.count) {
            NSMutableArray *myfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
            
            [myfriendsms addObjectsFromArray:subfriendsms];
            NSString *frienduid = [self readfrienduidFromstrangerms:[subfriendsms objectAtIndex:0]];
            //新消息提醒用得到
            NSMutableArray *newmsgary =[NSMutableArray arrayWithArray:[_newstrangermsDic objectForKey:frienduid]];
            newmsgary = (NSMutableArray *)[newmsgary arrayByAddingObjectsFromArray:myfriendsms];
            [newfriendsmsDic setObject:myfriendsms forKey:frienduid];
            //加入到消息队列中去
            NSMutableArray *array =[NSMutableArray arrayWithArray:[_strangermsDic objectForKey:frienduid]];
            if (array) {
                array = (NSMutableArray *)[array arrayByAddingObjectsFromArray:subfriendsms];
                [_strangermsDic setObject:array forKey:frienduid];
            }
            else
            {
                [_strangermsDic setObject:myfriendsms forKey:frienduid];
            }
        }
    }
    return newfriendsmsDic;
}

@end
