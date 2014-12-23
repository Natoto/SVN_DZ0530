//
//  TopicTableViewCell.h
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "bee.h"
#import "Topiclist.h"
#import "DZ_BASETableViewCell.h"
#import "hometopiclist.h"
#import "portal.h"
#import "blockdetail.h"

@interface B2_TopicTableViewCell : UITableViewCell
{
    UIButton *chakan;
    UIButton *reply;
    UILabel  *message; 
}

@property (nonatomic, strong) UILabel           *message;
@property (nonatomic, strong) BeeUIImageView    *cellicon;
@property (nonatomic, strong) UILabel           *lbltitle;
@property (nonatomic, strong) UILabel           *lbllandlord;
@property (nonatomic, strong) UILabel           *lblreadl;
@property (nonatomic, strong) UILabel           *lblreply;
@property (nonatomic, strong) UILabel           *lbltime;

- (void)isOwner:(BOOL)owner;
//- (void)layoutSubviews:(topics *)atopic;
- (void)layoutSubviews:(BOOL)havePhote;
- (void)datachanges:(topics *)atopics;
- (void)loadHomeTopicList:(hometopiclist *)ahometopiclist;
- (void)loadPortalList:(items *)items;
- (void)loadBlockDetailList:(NSDictionary *)items;

@end
