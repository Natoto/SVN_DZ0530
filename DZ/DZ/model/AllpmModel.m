//
//  AllpmModel.m
//  DZ
//
//  Created by Nonato on 14-6-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "AllpmModel.h"
#define KEY_STRANGER @"stranger"
#define KEY_FRIENDS @"friends"

@implementation ALLPMMODEFRIENDSLIST
@end
@implementation LASFLASHDATA
@end
//@implementation ALLPMSTRANGERLIST
//@end

@implementation AllpmModel
DEF_SINGLETON(AllpmModel)
#pragma mark -
- (void)load·
{
	self.autoSave = NO;
	self.autoLoad = NO;
}

- (void)unload
{
//    _friendmsDic = nil;
    _uid=nil;
//    _friendms=nil;
    _systemms=nil;
//    _strangerms=nil;
}

-(void)loadCache:(MSG_TYPE)msgtype
{
//    [self.astrangermessages removeAllObjects];
//    [self.agoodfriendms removeAllObjects];
//    [self.friendms removeAllObjects];
    [self.systemms removeAllObjects];
//    [self.strangerms removeAllObjects];
//    [_friendmsDic removeAllObjects];
    
    self.msgtype=[NSString stringWithFormat:@"%d",msgtype];
    self.uid=[UserModel sharedInstance].session.uid;
    if (!self.uid) {
        self.uid = [[UserModel sharedInstance] defaultSession].uid;
    }
    NSString *myclass= NSStringFromClass([self class]);
    NSString *myuid=self.uid?self.uid:@"NULL";
    NSString *type=@"3";
    KEY_CLS_UID_TYPE =  MODELOBJECTKEY(myclass,myuid,type);
    
//    self.friendms =[NSMutableArray arrayWithArray: [self loadfriendmsCache:msgtype frienduid:_frienduid agoodfriendms:self.agoodfriendms]];
    self.systemms =[NSMutableArray arrayWithArray:[allpm_public readObjectForKey:KEY_CLS_UID_TYPE]];
//    self.strangerms = [NSMutableArray arrayWithArray:[self loadstrangermsCache:self.uid]];
//    self.astrangermessages =[NSMutableArray arrayWithArray:[self loadstrangersCache:msgtype frienduid:_frienduid]];
    self.nowdate=[LASFLASHDATA readObjectForKey:KEY_CLS_UID_TYPE];
} 
//- (NSMutableArray *)loadfriendmsCache:(MSG_TYPE) msgtype frienduid:(NSString *)frienduid agoodfriendms:(NSMutableArray *)onegoodfriendms
//{
//    NSMutableArray *frdnameAry=[NSMutableArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:FRDNAMEKEY]];
//    [frdnameAry unique:^NSComparisonResult(id left, id right) {
//        return [((ALLPMSTRANGERLIST *)left).authorid compare:((ALLPMSTRANGERLIST *)right).authorid];
//    }];
//    NSMutableArray *mtfriendsms = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (int index=0;index < frdnameAry.count;index++ ) {
//        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
//        NSString *mykey=MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid);
//        NSArray *afriendAry = nil;
//        if (![self.friendmsDic valueForKey:mykey]) {
//            afriendAry=[NSArray arrayWithArray:[friendms readObjectForKey:mykey]];
//            [self.friendmsDic setObject:afriendAry forKey:mykey];
//        }
//        else
//        {
//            afriendAry = [self.friendmsDic valueForKey:mykey];
//        }
//        if (msgtype == MSG_HAOYOU) {
//            if ([frdname.fromid isEqual:frienduid]) {
//                [onegoodfriendms addObject:afriendAry];
//            }
//        }
//        [mtfriendsms addObject:afriendAry];
//    }
//    return mtfriendsms;//返回的是所有的消息
//}

//- (NSMutableArray *)loadstrangersCache:(MSG_TYPE) msgtype frienduid:(NSString *)frienduid
//{
//    NSMutableArray *mtfriendsms = [[NSMutableArray alloc] initWithCapacity:0];
//    for ( NSArray *array in self.strangerms) {
//        for (strangerms *astranger in array) {
//            /*0812 新接口 authorid  老接口 touid */
//            if ([astranger.authorid isEqualToString:frienduid]) {
//                mtfriendsms = [NSMutableArray  arrayWithArray:array];
//                break;
//            }
//        }
//    }
//    return mtfriendsms;
//}

-(void)loadFriendmsCashe:(NSString *)frienduid
{
    self.frienduid=frienduid;
    [self loadCache:MSG_HAOYOU];
}

- (void)loadCache
{
//    _strangerms = [[NSMutableArray alloc] init];
//    _friendms=[[NSMutableArray alloc] initWithCapacity:0];
//    _agoodfriendms=[[NSMutableArray alloc] initWithCapacity:1];
//    _newfriendms =[[NSMutableArray alloc] initWithCapacity:1];
//    _newstrangerms =[[NSMutableArray alloc] initWithCapacity:1];
//    _astrangermessages=[[NSMutableArray alloc] initWithCapacity:1];
//    _friendmsDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    [self loadCache:MSG_ALL];
}

-(void)setMsgtype:(NSString *)msgtype
{
//    _msgtype=msgtype;
    NSString *myclass= NSStringFromClass([self class]);
    NSString *myuid=self.uid?self.uid:@"NULL";
    KEY_CLS_UID_TYPE =  MODELOBJECTKEY(myclass,myuid,msgtype);
}
-(NSString *)msgtype
{
    return [NSString stringWithFormat:@"%d",MSG_ALL];
}
-(void)setUid:(NSString *)uid
{
    _uid=uid;
    NSString *myclass= NSStringFromClass([self class]);
    NSString *myuid=self.uid?self.uid:@"NULL";
    NSString *type=self.msgtype?self.msgtype:@"0";
    KEY_CLS_UID_TYPE=  MODELOBJECTKEY(myclass,myuid,type);
}

//-(void)clearfriendsms
//{
//    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMMODEFRIENDSLIST readObjectForKey:FRDNAMEKEY]];
//    for (int index=0;index < frdnameAry.count;index++ ) {
//        ALLPMMODEFRIENDSLIST *frdname = [frdnameAry objectAtIndex:index];
//        NSString *mykey=MODELOBJECTKEY(KEY_CLS_UID_TYPE,frdname.fromid);
//        [friendms removeObjectForKey:mykey];
//    }
//    [ALLPMSTRANGERLIST removeObjectForKey:FRDNAMEKEY];
//}
/*
-(void)savefriendsms:(NSArray *)selffriendms
{
    NSMutableArray *nameAry=[[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *array in selffriendms) {
        NSMutableArray *subfriendms=[[NSMutableArray alloc] initWithCapacity:0];
       NSString *mykey = @"22222";
        for ( friendms *afriend in array) {
            ALLPMMODEFRIENDSLIST *afrdname=[[ALLPMMODEFRIENDSLIST alloc] init];
 
            afrdname.fromid=afriend.authorid;
            if (![self arraycontainsObject:nameAry obj2:afrdname]) {//分别保存某个好友信息
                [nameAry addObject:afrdname];
                mykey=MODELOBJECTKEY(mykey,afrdname.fromid);
            }
            [subfriendms addObject:afriend];
        }
        if (![mykey isEqual:@"22222"]) {
            [friendms saveObject:array forKey:mykey];
        }
    }
    [nameAry unique:^NSComparisonResult(id left, id right)
         {
             return [((ALLPMMODEFRIENDSLIST *)left).fromid compare:((ALLPMMODEFRIENDSLIST *)right).fromid];
        }];    
    [ALLPMMODEFRIENDSLIST saveObject:nameAry forKey:FRDNAMEKEY];
}*/

//-(void)savefriendsms
//{
//    NSArray *nameAry=_friendmsDic.allKeys;
//    for (NSString *key in nameAry) {
//        NSArray *array = [_friendmsDic objectForKey:key];
//        NSMutableArray *subfriendms=[[NSMutableArray alloc] initWithCapacity:0];
//        NSString *mykey = @"22222";
//        for ( friendms *afriend in array) {
//            ALLPMMODEFRIENDSLIST *afrdname=[[ALLPMMODEFRIENDSLIST alloc] init];
//            /*0812 需要更新？ */
//            afrdname.fromid=afriend.authorid;
//            if (![self arraycontainsObject:nameAry obj2:afrdname]) {//分别保存某个好友信息
//                mykey=MODELOBJECTKEY(mykey,afrdname.fromid);
//            }
//            [subfriendms addObject:afriend];
//        }
//        if (![mykey isEqual:@"22222"]) {
//            [friendms saveObject:array forKey:mykey];
//        }
//    }
//    [ALLPMMODEFRIENDSLIST saveObject:nameAry forKey:FRDNAMEKEY];
//}



//#pragma mark - 清空保存陌生人信息
//-(void)clearStrangersms
//{
//    NSString *myuidkey=MODELOBJECTKEY(self.uid);
//    NSArray *frdnameAry=[NSArray arrayWithArray:[ALLPMSTRANGERLIST readObjectForKey:myuidkey]];
//    for (int index=0;index < frdnameAry.count;index++ ) {
//        ALLPMSTRANGERLIST *frdname = [frdnameAry objectAtIndex:index];
//        NSString *mykey=MODELOBJECTKEY(frdname.authorid,myuidkey);
//        [strangerms removeObjectForKey:mykey];
//    }
//    [ALLPMSTRANGERLIST removeObjectForKey:myuidkey];
////    [self.strangerms removeAllObjects];
//}

////保存陌生人消息
//-(void)savestrangersms:(NSArray *)selfstrangerms
//{
//    // 二级的数组
//    /* 先清除  [self clearStrangersms];   */
//    NSMutableArray *nameAry = [[NSMutableArray alloc] initWithCapacity:0];
//    for (int index= 0 ; index < selfstrangerms.count; index ++) {
//        //每个陌生人的消息分别保存起来
//        NSArray * array = [selfstrangerms objectAtIndex:index];
//        if (array.count) {
//            ALLPMSTRANGERLIST * astrangername=[[ALLPMSTRANGERLIST alloc] init];
//            strangerms *astrangerms = [array objectAtIndex:0];
//            astrangername.authorid = astrangerms.authorid;
//            /*0812 新接口 authorid  老接口 touid */
//            NSString *mykey=MODELOBJECTKEY(astrangerms.authorid,self.uid);
//            [strangerms saveObject:array forKey:mykey];
//            [nameAry addObject:astrangername];
//            
//        }
//    }
//    [nameAry unique:^NSComparisonResult(id left, id right)
//     {
//        return [((ALLPMSTRANGERLIST *)left).authorid compare:((ALLPMSTRANGERLIST *)right).authorid];
//    }];
//    if (nameAry.count) {
//        NSString *myuidkey=MODELOBJECTKEY(self.uid,KEY_STRANGER);
//        [ALLPMSTRANGERLIST saveObject:nameAry forKey:myuidkey];
//    }
//}

- (void)saveCache
{
//    [ALLPMMODEFRIENDSLIST removeObjectForKey:FRDNAMEKEY];
//    if (self.friendms.count) {
//        [self savefriendsms];
//    }
//    if (self.strangerms.count) {
//        [self savestrangersms:self.strangerms];
//    }
    [LASFLASHDATA saveObject:self.nowdate forKey:KEY_CLS_UID_TYPE];
    if (self.systemms.count) {
        [allpm_public saveObject:self.systemms forKey:KEY_CLS_UID_TYPE];
    }
}

-(BOOL)arraycontainsObject:(NSArray *)array obj2:(ALLPMMODEFRIENDSLIST *)obj2
{
    NSString *selfuid=[UserModel sharedInstance].session.uid;
    if ([obj2.fromid isEqual:selfuid]) {//如果是自己说的话就不加入到消息表里面去
        return YES;
    }
    for (int index=0; index<array.count; index++) {
        ALLPMMODEFRIENDSLIST *obj1=[array objectAtIndex:index];
        if ([obj1.fromid isEqual:obj2.fromid]) {
            return YES;
        }
    }
    return NO;
}

- (void)clearCache
{
    [ALLPMMODEFRIENDSLIST removeObjectForKey:FRDNAMEKEY];
    [LASFLASHDATA removeObjectForKey:KEY_CLS_UID_TYPE];
    [NSDictionary removeObjectForKey:KEY_CLS_UID_TYPE];
    [allpm_public removeObjectForKey:KEY_CLS_UID_TYPE];
    [strangerms removeObjectForKey:KEY_CLS_UID_TYPE];
    
//    [self.friendms removeAllObjects];
    [self.systemms removeAllObjects];
//    [self.strangerms removeAllObjects];
    self.loaded=NO;
}

#pragma mark -

- (void)firstPage
{
    [self getNewMessage];
}


- (void)nextPage
{
    [self firstPage];
}

-(void)getNewMessage
{
//    self.nowdate.nowdate= self.nowdate.nowdate?self.nowdate.nowdate:0;
    if (self.msgtype) {
        [self getMessageWithtype:self.msgtype date:self.nowdate.nowdate];
    }
    else
    {
        [self getMessageWithtype:[NSString stringWithFormat:@"%d",MSG_ALL] date:self.nowdate.nowdate];
    }
}

-(void)getALLMessageWithtype:(MSG_TYPE)style
{
    [self getMessageWithtype:[NSString stringWithFormat:@"%d",style] date:self.nowdate.nowdate];
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
//                     allpm=api.resp;
//                    [self.astrangermessages removeAllObjects];
//                    [self.agoodfriendms removeAllObjects];
//                    [self.friendms removeAllObjects];
//                    [self.systemms removeAllObjects];
//                    [self.strangerms removeAllObjects];
//                    self.newfriendms = nil;
//                    if (api.resp.friendms.count) {
//                        NSMutableArray *array=[self analysisagoodfriendsms:api.resp.friendms];
//                        [self.agoodfriendms addObjectsFromArray:[array copy]];
//                        NSMutableArray *array2=[self analysisfriendsms:api.resp.friendms];
//                        self.newfriendms = array2;
//                       [self.friendms addObjectsFromArray:[array copy]];
//                    } 
                    if (api.resp.allpm_public.count) {
                        [self.systemms addObjectsFromArray:api.resp.allpm_public];
                    }
                    
//                    self.newstrangerms = nil;
//                    if (api.resp.strangerms.count) {/*保存陌生人消息 */
//                        NSMutableArray *array=[self analysisastranderms:api.resp.strangerms];
//                        self.newstrangerms = [NSMutableArray arrayWithArray:api.resp.strangerms];
//                        [self.astrangermessages addObjectsFromArray:[array copy]];
//                        [self.strangerms addObjectsFromArray:api.resp.strangerms];
//                    }
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

//-(NSMutableArray *)analysisfriendsms:(NSArray *)selffriendsms
//{
//    NSMutableArray *myfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
//  
//    for (NSArray *array in selffriendsms) {
//        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
//        for ( NSDictionary *afriend in array) {
//            friendms *friendmscls=[friendms objectFromDictionary:afriend];
//            [subfriendsms addObject:friendmscls];
//        }
//        if (subfriendsms.count) {
//            [myfriendsms addObject:subfriendsms];
//        }
//    }
//    return myfriendsms;
//}

//-(NSMutableArray *)analysisagoodfriendsms:(NSArray *)selffriendsms
//{
//    NSMutableArray *myfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
//    BOOL needAddTODatabase=NO;
//    for (NSArray *array in selffriendsms) {
//        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
//        needAddTODatabase=NO;
//        for ( NSDictionary *afriend in array) {
//            friendms *friendmscls=[friendms objectFromDictionary:afriend];
//            
//            if (!self.frienduid.length) {//不是从某个好友界面进来
//                [subfriendsms addObject:friendmscls];
////                continue;
//            }
//            else{
//                NSString *selfuid=[UserModel sharedInstance].session.uid;
//                if ([friendmscls.touid isEqual:selfuid]) {//如果是自己说的话就不加入到消息表里面去
//                    if ([friendmscls.authorid isEqual:self.frienduid])
//                    {
//                        needAddTODatabase=YES;
//                    }
//                }
//                else if ([friendmscls.touid isEqual:self.frienduid]) {//保存到信息列表
//                    needAddTODatabase=YES;
//                }
//                if (needAddTODatabase) {
//                    [subfriendsms addObject:friendmscls];
//                    needAddTODatabase=NO;
//                }
//            }
//        }
//        if (subfriendsms.count) {
//            [myfriendsms addObject:subfriendsms];
//        }
//    }
//    return myfriendsms;
//}
//#pragma mark - 得到最后一条陌生人消息
//-(NSMutableArray *)analysisastranderms:(NSArray *)selffriendsms
//{
//    NSMutableArray *mystrangerms=[[NSMutableArray alloc] initWithCapacity:0];
//    for (NSArray *array in selffriendsms) {
////        NSMutableArray *subfriendsms=[[NSMutableArray alloc] initWithCapacity:0];
//        strangerms *astranger = [array lastObject];
//        /*0812 要更改的 */
//        if ([astranger.authorid isEqualToString:self.frienduid]) {
//            mystrangerms =[NSMutableArray arrayWithArray:array] ;
//            break;
//        }
//    }
//    return mystrangerms;
//}


//+(NSInteger)strangermsCount
//{
//    AllpmModel *allpmmodel =[[AllpmModel alloc] init];
//    allpmmodel.uid=[UserModel sharedInstance].session.uid;
//    if (!allpmmodel.uid) {
//        return 0;
//    }
////    allpmmodel.nowdate.nowdate=[NSNumber numberWithInt:1];
//    allpmmodel.strangerms = [allpmmodel loadstrangermsCache:allpmmodel.uid];
//    int count = 0;
//    for(int index =0; index < allpmmodel.strangerms.count; index ++) {
//        NSArray *strmsary = [allpmmodel.strangerms objectAtIndex:index];
//        for (int j=0;j<strmsary.count;j++) {
//            count ++;
//        }
//    }
//    return  count;
//}
@end
