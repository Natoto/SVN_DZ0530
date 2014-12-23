//
//  DZ_Timer.h
//  DZ
//
//  Created by Nonato on 14-7-8.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"

#define PUSHINTERVAL 15
#define REPLYINTERVAL 15
#define REMINDINTERVAL 10
#define REFRESHINTERVAL 15
@class DZ_Timer;
@protocol DZ_TimerDelegate <NSObject>
@optional
-(void)refreshMessage:(DZ_Timer *)dztimer;
//-(void)remindMessage:(DZ_Timer *)dztimer;
@end

typedef void (^ASTEPBLOCK)(BOOL result);

@interface DZ_Timer : NSObject
{
    NSInteger refreshmsgcount;
    NSTimer * DZ_RefreshmsgTime;
    NSTimer * DZ_PublicTime;
    NSTimer * DZ_ReplyTime;
    NSTimer * DZ_RemindTime;
}

AS_SINGLETON(DZ_Timer)
@property(nonatomic,copy) ASTEPBLOCK astepblock;
@property(nonatomic,assign)NSObject<DZ_TimerDelegate> * delegate;
@property(nonatomic,assign)NSInteger publishcount;
@property(nonatomic,assign)NSInteger replycount;
@property(nonatomic,assign)NSInteger remindcount;

-(void)freshNewRemindMessage:(NSUInteger)step fire:(BOOL)fire astepblock:(ASTEPBLOCK)astepblock;

-(void)endReply;
-(void)endPush;

-(void)endRefresh;//开始再次刷新
-(void)invalidateDZ_RefreshmsgTime;

//-(void)endRemind;
//-(void)invalidateDZ_RemindTime;
@end
