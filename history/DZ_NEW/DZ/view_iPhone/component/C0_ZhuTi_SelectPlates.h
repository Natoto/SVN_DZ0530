//
//  C0_ZhuTi_SelectPlates.h
//  DZ
//
//  Created by Nonato on 14-7-25.
//
//
#import "bee.h"
#import <UIKit/UIKit.h>
#import "forumlist.h"
#import "UIImage+Bundle.h"
//actionSheet:self clickedButtonAtIndex:1
@class THTPS_SELECT;
@class C0_ZhuTi_SelectPlates;

@protocol C0_ZhuTi_SelectPlatesDelegate<NSObject>
-(void)C0_ZhuTi_SelectPlates:(C0_ZhuTi_SelectPlates *)action select_thtps:(THTPS_SELECT *)loate clickedButtonAtIndex:(NSInteger)index;
@end

@interface THTPS_SELECT : NSObject
//@property(nonatomic,strong) threadtypes *athreadtypes;
@property(nonatomic,strong) NSString  * threadtypesitem;
@property(nonatomic,strong) NSNumber  * typedid;

@end


@interface C0_ZhuTi_SelectPlates : BeeUIActionSheet <UIPickerViewDelegate, UIPickerViewDataSource>

AS_SIGNAL( WILL_ACTIVE )		// 将要获取焦点
AS_SIGNAL( WILL_DEACTIVED)		// 将要失去焦点

@property (nonatomic, weak) id<C0_ZhuTi_SelectPlatesDelegate> ztdelegate;
@property (strong, nonatomic)  UILabel               * titlelabel;
@property (strong, nonatomic)  UIPickerView          * locatePicker;
//@property (strong, nonatomic)  threadtypes          * athreadtypes;

@property (strong, nonatomic)  NSDictionary         * dataDic;
@property (strong, nonatomic)  THTPS_SELECT         * locate;
//@property (nonatomic,assign)   BOOL                   show;
//@property (strong,nonatomic)   NSString             * basefid;
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
- (IBAction)cancel:(id)sender;
-(void)resignFirstResponder;

@end
