//
//  B3_PostMenuView.h
//  DZ
//
//  Created by Nonato on 14-5-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "bee.h"
#import <UIKit/UIKit.h>

#define ANIMATE_DURATION                        0.25f
#define ITEMSSTARTTAG                           1447

@interface B3_PostMenuView : UIView
{
    NSDictionary *items;
}
AS_SINGLETON(B3_PostMenuView)
AS_NOTIFICATION(onlyReadBuildingOwner)
AS_NOTIFICATION(allRead)
AS_NOTIFICATION(reply)
AS_NOTIFICATION(share)
AS_NOTIFICATION(collect)
AS_NOTIFICATION(delcollection)
AS_NOTIFICATION(daoxu)
AS_NOTIFICATION(copyurl)

@property (nonatomic, assign) NSInteger itemNumber;
@property(nonatomic,strong)UIView * backGroundView;
@property(nonatomic,strong)NSArray * array;
@property (nonatomic, strong) NSNumber *isfavorite;

- (id)initWithFrame:(CGRect)frame itemNumber:(NSInteger)number;

-(void)showInView:(UIView *)view;

-(void)reloadButton:(NSString * )key title:(NSString *)title;
@end
