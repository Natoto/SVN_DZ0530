//
//  B1_TopicMenuView.h
//  DZ
//
//  Created by nonato on 14-9-17.
//
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#define ANIMATE_DURATION                        0.25f
#define ITEMSSTARTTAG                           917959
@class B1_TopicMenuView;


@interface B1_TopicMenuView : UIView
{
    NSDictionary *items;
}
AS_SINGLETON(B1_TopicMenuView)
AS_NOTIFICATION(selectitem)
@property(nonatomic,strong)UIScrollView * backGroundView;
@property(nonatomic,strong)NSArray * array;
@property (nonatomic, strong) NSNumber *isfavorite;
@property (nonatomic, strong) NSDictionary *items;
-(void)show;

-(void)reloadButton:(NSString * )key title:(NSString *)title;
@end
