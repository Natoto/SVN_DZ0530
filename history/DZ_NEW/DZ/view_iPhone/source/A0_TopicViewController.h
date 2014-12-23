//
//  A0_TopicViewController.h
//  DZ
//
//  Created by PFei_He on 14-8-26.
//
//

#import <UIKit/UIKit.h>
#import "Base_TableViewController.h"
#import "HomeTopicListModel.h"

@protocol A0_TopicViewControllerDelegate <NSObject>

- (void)A0_TopicViewControllTableViewCellDidSelect:(NSString *)tid;

@end

@interface A0_TopicViewController : Base_TableviewController
{
    NSNumber *tid;
}

@property (nonatomic, strong) HomeTopicListModel *listModel;

@property (nonatomic, weak) id<A0_TopicViewControllerDelegate> delegate;

- (void)A0_TopicViewControllTableViewCellDidSelectUsingBlock:(void (^)(NSString *tid))block;

@end
