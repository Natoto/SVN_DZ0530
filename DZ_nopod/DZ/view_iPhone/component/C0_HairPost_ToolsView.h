//
//  C0_HairPost_ToolsView.h
//  DZ
//
//  Created by Nonato on 14-4-28.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C0_HairPost_ToolsView : UIView

@property(nonatomic,assign) BOOL showPictureButton;
@property(nonatomic,assign) BOOL showDoneButton;
- (id)initWithFrame:(CGRect)frame withTarget:(id)delegate andFacialSel:(SEL)facialTap andpictureSel:(SEL)pictureTap andkeyboardSel:(SEL)keyboardTap;

- (id)initWithFrame:(CGRect)frame withTarget:(id)delegate andFacialSel:(SEL)facialTap andpictureSel:(SEL)pictureTap andkeyboardSel:(SEL)keyboardTap donesel:(SEL)donsel;

-(void)showKeyboardBtn:(BOOL)show;
@end
