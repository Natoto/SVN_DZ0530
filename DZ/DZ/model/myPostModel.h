//
//  myPostModel.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#undef	PER_PAGE
#define PER_PAGE	(20)
#define MYPOSTOBJECTKEY(uid) [NSString stringWithFormat:@"myPostModel.%@",uid]

#import "Bee_StreamViewModel.h"
#import "mypost.h"
@interface myPostModel : BeeStreamViewModel
@property (nonatomic, retain) NSString          *    uid;
@property (nonatomic,retain)  NSMutableArray    *    shots;

@end
