//
//  B4_PreviewImageViewController.h
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
typedef  void (^PREVIEWSHOWN)(BOOL result);
typedef  void (^PREVIEWTAPPEDBLOCK)(NSArray *urls);

@interface B4_PreviewImageView : UIView
@property(nonatomic,copy) PREVIEWSHOWN       shownBlock;
@property(nonatomic,copy) PREVIEWTAPPEDBLOCK tappedBlock;
//@property(nonatomic,strong)BeeUIImageView *imgview;
-(id)initWithFrame:(CGRect)frame withurl:(NSString *)url target:(id)target andSEL:(SEL)selaction contentAry:(NSArray *)contentAry;

-(void)showInView:(UIView *)superview currenturl:(NSString *)url index:(NSInteger )index urls:(NSArray *)urls shownblock:(PREVIEWSHOWN)showblock tappedblock:(PREVIEWTAPPEDBLOCK)tappedblock;
@property(nonatomic,retain)NSString * imgURL;
@property(nonatomic,retain)NSArray *contentAry;
@end
