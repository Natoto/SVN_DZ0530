//
//  C0_HairPost_SelectPlates.h
//  DZ
//
//  Created by Nonato on 14-5-4.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumlistModel.h"
#import "forumlist.h"
@class C0_HairPost_SelectPlates;
@class LoacateChild;
@protocol C0_HairPost_SelectPlates<NSObject>
-(void)C0_HairPost_SelectPlates:(C0_HairPost_SelectPlates *)action select_LoacateChild:(LoacateChild *)loate clickedButtonAtIndex:(NSInteger)index;
@end


@interface LoacateChild : NSObject
@property(nonatomic,strong) forums  * parent;
@property(nonatomic,strong) forums   * child;
@property(nonatomic,strong) child   * subchild;
@end

@interface C0_HairPost_SelectPlates : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
//@private
//    NSArray *provinces;
//    NSArray	*cities; 
}
@property (nonatomic,weak)   id<C0_HairPost_SelectPlates> hpdelegate;
@property (strong, nonatomic) ForumlistModel        * fmModel;
@property (strong, nonatomic) UILabel               * titlelabel;
@property (strong, nonatomic) UIPickerView          * locatePicker;
@property (strong, nonatomic) NSArray               * forumAry;
@property (strong, nonatomic) NSArray               * childAry;
@property (strong, nonatomic) NSArray               * subchildAry;
@property (strong, nonatomic) LoacateChild                 * locate;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
- (IBAction)cancel:(id)sender;
-(void)resignFirstResponder;
@end
