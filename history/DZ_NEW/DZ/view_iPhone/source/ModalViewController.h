//
//  ModalViewController.h
//  DZ
//
//  Created by Nonato on 14-9-4.
//
//

#import <UIKit/UIKit.h>
@class ModalViewController;
@protocol ModalViewControllerDelegate <NSObject>

-(void) modalViewControllerDidClickedDismissButton:(ModalViewController *)viewController;

@end

@interface ModalViewController : UIViewController
@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;
@end
