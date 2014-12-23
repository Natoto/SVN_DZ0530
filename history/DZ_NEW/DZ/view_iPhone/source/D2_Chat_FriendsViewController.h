//
//  D2_Chat_FriendsViewController.h
//  DZ
//
//  Created by Nonato on 14-8-14.
//
//
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#import <UIKit/UIKit.h>
#import "Base_TableviewController.h" 
#import "friends.h"
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHATTYPE_FRIEND,
    CHATTYPE_STRANGER,
} CHATTYPE;


@class D2_Chat_FriendsViewController;
@protocol D2_Chat_FriendsViewControllerDelegate <NSObject>
-(void)messageSendSuccess:(D2_Chat_FriendsViewController *)viewController;
@end

@interface D2_Chat_FriendsViewController : Base_TableviewController
//@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (nonatomic,retain) friends   * afriend;
@property (nonatomic, assign)NSObject <D2_Chat_FriendsViewControllerDelegate> *delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString * selectString;
@property (nonatomic,assign) CHATTYPE  chattype;

@end
