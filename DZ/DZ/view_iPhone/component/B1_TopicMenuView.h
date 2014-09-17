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
@interface B1_TopicMenuView : UIView
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
@property(nonatomic,strong)UIView * backGroundView;
@property(nonatomic,strong)NSArray * array;
@property (nonatomic, strong) NSNumber *isfavorite;
@property (nonatomic, strong) NSDictionary *items;
-(void)show;

-(void)reloadButton:(NSString * )key title:(NSString *)title;
@end
