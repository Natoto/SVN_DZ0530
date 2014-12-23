//
//  Base_TableViewController.h
//  DZ
//
//  Created by Nonato on 14-5-14.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base_TableViewController.h"
#import "TopiclistModel.h"
#import "B1_ATopicViewController.h"

@protocol B2_TopicViewControllerDelegate <NSObject>
- (void)topicViewControllerCellSelectedWithTid:(NSString *)tid;
@end

@class B1_ATopicViewController;
@interface B2_TopicViewController2 : Base_TableviewController
AS_NOTIFICATION(skiptosub)
AS_SIGNAL(selectpost)
@property (nonatomic, assign) NSInteger selfIndex;
@property (nonatomic, assign) B1_ATopicViewController * superdelegate;

@property (nonatomic, assign) NSObject <B2_TopicViewControllerDelegate> * topicvcdelegate;
@property(nonatomic,strong) TopiclistModel *tpclistModel;

@end
