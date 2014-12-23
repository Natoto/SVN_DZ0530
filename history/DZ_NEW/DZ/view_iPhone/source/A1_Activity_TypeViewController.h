//
//  A1_Activity_TypeViewController.h
//  DZ
//
//  Created by Nonato on 14-8-18.
//
//

#import <UIKit/UIKit.h>
#import "Base_TableviewController.h"
@class A1_Activity_TypeViewController;
@protocol A1_Activity_TypeViewControllerDelegate <NSObject>
- (void)A1_Activity_TypeViewController:(A1_Activity_TypeViewController *)controller cellSelectedWithTid:(NSString *)tid;
@end

@interface A1_Activity_TypeViewController : Base_TableviewController
@property (nonatomic, assign) NSObject <A1_Activity_TypeViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSString * type;
-(void)viewDidCurrentView;
@end
