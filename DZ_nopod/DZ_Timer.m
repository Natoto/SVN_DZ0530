//
//  DZ_Timer.m
//  DZ
//
//  Created by Nonato on 14-7-8.
//
//

#import "DZ_Timer.h"
@implementation DZ_Timer
DEF_SINGLETON(DZ_Timer)

-(void)dealloc
{
    [DZ_RemindTime invalidate];
    [DZ_RefreshmsgTime invalidate];
    [DZ_PublicTime invalidate];
    [DZ_ReplyTime invalidate];
}

#pragma mark - 刷新提醒

//-(void)invalidateDZ_RemindTime
//{
//    [DZ_RemindTime invalidate];
//    DZ_RemindTime = nil;
//}
//
//-(void)endRemind
//{
//   [self invalidateDZ_RemindTime];
//    DZ_RemindTime = [NSTimer scheduledTimerWithTimeInterval:REMINDINTERVAL target:self selector:@selector(remindNewMessages) userInfo:nil repeats:YES];
//    _remindcount = REMINDINTERVAL;
//    [DZ_RemindTime fire];
//}

-(void)freshNewRemindMessage:(NSUInteger)step fire:(BOOL)fire astepblock:(ASTEPBLOCK)astepblock
{
    if (fire) {
        [DZ_RemindTime invalidate];
        DZ_RemindTime = [NSTimer scheduledTimerWithTimeInterval:REMINDINTERVAL target:self selector:@selector(remindNewMessages) userInfo:nil repeats:YES];
        _remindcount = REMINDINTERVAL;
        [DZ_RemindTime fire];
    }
    else
    {
        [DZ_RemindTime invalidate];
        DZ_RemindTime = nil;
    }
    self.astepblock = ^(BOOL result){
        astepblock(result);
    };
}

-(void)remindNewMessages
{
    self.astepblock(YES);
}


#pragma mark  -------------
//拉取新消息
-(void)endRefresh
{
    [self invalidateDZ_RefreshmsgTime];
     DZ_RefreshmsgTime = [NSTimer scheduledTimerWithTimeInterval:REFRESHINTERVAL target:self selector:@selector(refreshNewMessage) userInfo:nil repeats:YES];
    [DZ_RefreshmsgTime invalidate];
    refreshmsgcount = 10;
    [DZ_RefreshmsgTime fire];
}

-(void)refreshNewMessage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshMessage:)]) {
        [self.delegate refreshMessage:self];
    }
}

-(void)invalidateDZ_RefreshmsgTime
{
    [DZ_RefreshmsgTime invalidate];
    DZ_RefreshmsgTime = nil;
}

#pragma mark -

//发布帖子时间
-(void)endPush
{
    [DZ_PublicTime invalidate];
    DZ_PublicTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pushStep) userInfo:nil repeats:YES];
    _publishcount = PUSHINTERVAL;
    [DZ_PublicTime fire];
}

-(void)pushStep
{
    if (_publishcount <= 0) {
        _publishcount = 0;
        [DZ_PublicTime invalidate];
    }
    else
        _publishcount --;
    
}

#pragma mark - 回复时间间隔
-(void)endReply
{
    [DZ_ReplyTime invalidate];
    DZ_ReplyTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(replyStep) userInfo:nil repeats:YES];
    _replycount = REPLYINTERVAL;
//    [DZ_ReplyTime invalidate];
    [DZ_ReplyTime fire];
}

-(void)replyStep
{
    if (_replycount <=0 ) {
        _replycount = 0;
        [DZ_ReplyTime invalidate];
    }
    else
    _replycount --;
}

@end
