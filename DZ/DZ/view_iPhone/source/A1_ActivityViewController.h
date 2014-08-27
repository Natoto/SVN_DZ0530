//
//  A1_ActivityViewController.h
//  DZ
//
//  Created by Nonato on 14-8-1.
//
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "A1_Activity_TypeViewController.h" 
@interface A1_ActivityViewController : UIViewController<QCSlideSwitchViewDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    A1_Activity_TypeViewController  *_vc1;
    A1_Activity_TypeViewController     *_vc2;
    A1_Activity_TypeViewController *_vc3;
}
@property (nonatomic, strong) QCSlideSwitchView    *slideSwitchView;
@property (nonatomic, strong) A1_Activity_TypeViewController  * vc1;
@property (nonatomic, strong) A1_Activity_TypeViewController  * vc2;
@property (nonatomic, strong) A1_Activity_TypeViewController  * vc3;

@end
