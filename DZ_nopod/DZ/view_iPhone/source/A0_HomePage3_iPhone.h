//
//  A0_HomePage3_iPhone.h
//  DZ
//
//  Created by PFei_He on 14-10-23.
//
//

#import <UIKit/UIKit.h>
#import "BaseBoard_iPhone.h"
#import "PFCarouselView.h"
#import "PortalModel.h"
#import "PortalSlideModel.h"

@interface A0_HomePage3_iPhone : BaseBoard_iPhone <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tv;

    NSMutableArray  *tidArr;        //轮播图帖子ID数组
    NSMutableArray  *cellArray;

    PFCarouselView *carouselView;
}

@property (nonatomic, strong) NSMutableArray    *viewsArray;    //视图数组
@property (nonatomic, strong) NSArray           *textsArray;     //文本数组

@property (nonatomic, assign) NSInteger         type;
@property (nonatomic, assign) NSInteger         section;
@property (nonatomic, strong) PortalModel       *portalModel;
@property (nonatomic, strong) PortalSlideModel  *portalSlideModel;

@end
