//
//  B3_PostMenuView.m
//  DZ
//
//  Created by Nonato on 14-5-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UIImage+Tint.h"
#import "B3_PostMenuView.h"
//#import "bee.h"

@implementation B3_PostMenuView

DEF_SINGLETON(B3_PostMenuView)

DEF_NOTIFICATION(onlyReadBuildingOwner)
DEF_NOTIFICATION(allRead)
DEF_NOTIFICATION(reply)
DEF_NOTIFICATION(share)
DEF_NOTIFICATION(collect)
DEF_NOTIFICATION(delcollection)
DEF_NOTIFICATION(daoxu)
DEF_NOTIFICATION(copyurl)

#define BTNTXTCOLOR [UIColor whiteColor]
#define BACKGROUNDVIEWCOLOR HEX_RGBA(0x3f3f3f, 0.95)

#define MENUVIEWMINX CGRectGetWidth([UIScreen mainScreen].bounds) - 122
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor =[UIColor clearColor]; //[UIColor colorWithRed:241./255 green:241/255. blue:241/255 alpha:1];//WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        UIImageView *triangle=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"jiantou"]];
        triangle.image = [triangle.image imageWithTintColor:BACKGROUNDVIEWCOLOR];
        triangle.frame = CGRectMake(MENUVIEWMINX+102-20, 64.0f-15.0f, 20, 20);
        triangle.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:triangle];
        [self addSubview:self.backGroundView];
        
    }
    return self;
}

-(IBAction)BTNACTIONS:(id)sender
{
    UIButton *tapedBtn=(UIButton *)sender;
    for (int index=0; index<5; index++) {
        UIButton *button=(UIButton *)[_backGroundView viewWithTag:index + ITEMSSTARTTAG];
        if (button.tag==tapedBtn.tag) {
//            [button setTitleColor:[UIColor colorWithRed:16/255. green:150/255. blue:237./255. alpha:1] forState:UIControlStateNormal];
//            if (button.tag == 3 + ITEMSSTARTTAG)
//                [button setTitle:@"取消收藏" forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [self sendSelfUISignal:tapedBtn];
    [self tappedCancel];
}
typedef enum : NSUInteger {
    TAG_ALL = 0,
    TAG_DAOXU = 1,
    TAG_REPLY = 2,
    TAG_SHARE = 3,
    TAG_COLLENT = 4,
    TAG_COPYURL = 5
} TAG_TYPE;
-(void)sendSelfUISignal:(UIButton *)button
{
    switch (button.tag) {
        case ITEMSSTARTTAG:
            if ([button.titleLabel.text isEqualToString:@"只看楼主"]) {
                [self postNotification:self.onlyReadBuildingOwner];
                [button setTitle:@"全部" forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:@"只看楼主" forState:UIControlStateNormal];
                [self postNotification:self.allRead];
            }
            break;
        case ITEMSSTARTTAG + TAG_DAOXU:
            [self postNotification:self.daoxu];
            break;
        case ITEMSSTARTTAG + TAG_REPLY:
            [self postNotification:self.reply];
            break;
        case ITEMSSTARTTAG + TAG_SHARE:
            [self postNotification:self.share];
            break;
        case ITEMSSTARTTAG + TAG_COLLENT:
            if ([button.titleLabel.text isEqualToString:@"收藏"]) {
                [self postNotification:self.collect];
                [button setTitle:@"取消收藏" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"收藏" forState:UIControlStateNormal];
                [self postNotification:self.delcollection];
            }
            break;
        case ITEMSSTARTTAG+TAG_COPYURL:
            [self postNotification:self.copyurl];
        default:
            break;
    }
}

-(void)reloadButton:(NSString * )key title:(NSString *)title
{
    int index =[[items valueForKey:key] intValue];
    UIButton *button = (UIButton *)[_backGroundView viewWithTag:ITEMSSTARTTAG + index];
    [button setTitle:title forState:UIControlStateNormal];
}

-(UIView *)backGroundView
{ 
   if (!_backGroundView) {
       _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(MENUVIEWMINX, 64.0f , 102, 150)];
       _backGroundView.backgroundColor= BACKGROUNDVIEWCOLOR;
       //[UIColor colorWithRed:241./255 green:241./255. blue:241./255. alpha:1];
       items=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"只看楼主",@"1",@"倒序看帖",@"2",@"回复",@"3",@"分享",@"4",@"收藏",@"5",@"复制链接", nil];
       //,@"5",@"取消收藏"
      NSArray *array = [[NSArray alloc] initWithObjects:@"只看楼主",@"倒序看帖",@"回复",@"分享",@"收藏", @"复制链接", nil];
       
        float HEIGHT=35;
        float WIDTH=_backGroundView.frame.size.width;
        for (int index=0; index < array.count; index++) {
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT * index + 5, WIDTH , HEIGHT)];
            [button addTarget:self action:@selector(BTNACTIONS:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:BTNTXTCOLOR forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            NSString *key =[array objectAtIndex:index];
            NSString * value=[items objectForKey:key];
            button.tag= ITEMSSTARTTAG + value.integerValue;
            [button setTitle:key forState:UIControlStateNormal];
            [_backGroundView addSubview:button];
        }
       _backGroundView.frame = CGRectMake(MENUVIEWMINX, 64.0f , 102, 30 *(items.count + 1));
    }
    return _backGroundView;
}

-(void)setIsfavorite:(NSNumber *)isfavorite
{
    _isfavorite = isfavorite;
    int index = TAG_COLLENT;//[[items objectForKey:@"收藏"] intValue];
    UIButton *button=(UIButton *)[_backGroundView viewWithTag: ITEMSSTARTTAG + TAG_COLLENT];
    if (button.tag == ITEMSSTARTTAG + index) {
        if (isfavorite.integerValue == 1) {//变为取消收藏
            [button setTitle:@"取消收藏" forState:UIControlStateNormal];
           BeeLog(@"%@", [items objectForKey:@"取消收藏"]);
        } else {//变为收藏
            [button setTitle:@"收藏" forState:UIControlStateNormal];
        }
    }
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}

-(void)showInView:(UIView *)view
{
    [self.backGroundView setFrame:CGRectMake(MENUVIEWMINX, 64.0f - bee.ui.config.heightOfStatusBar, 102, (items.count +1) * 30)];
    self.alpha = 1;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(MENUVIEWMINX, 64.0f - bee.ui.config.heightOfStatusBar, 102, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

//    if ([self.isfavorite isEqualToNumber:[NSNumber numberWithInt:0]]) {
//        self.isfavorite = [NSNumber numberWithInt:1];
//    } else {
//        self.isfavorite = [NSNumber numberWithInt:0];
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
