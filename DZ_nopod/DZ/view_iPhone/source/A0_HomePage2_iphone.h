//
//  A0_HomePage2_iphone.h
//  DZ
//
//  Created by PFei_He on 14-8-25.
//
//

#import <UIKit/UIKit.h>
#import "PFCarouselView.h"
#import "PFTabView.h"
#import "A0_TopicViewController.h"
#import "BaseBoard_iPhone.h"
#import "ASIHTTPRequest.h"
#import "HomeTopicSlideModel.h"

@interface A0_HomePage2_iphone : BaseBoard_iPhone <ASIHTTPRequestDelegate>
{
    NSIndexPath *cellIndexPath;
    NSMutableArray *tidArr;

    PFCarouselView *carouselView;
    PFTabView *tabView;
}

@property (nonatomic, strong) NSMutableArray            *viewsArray;

@property (nonatomic, strong) HomeTopicSlideModel       *slideModel;
@property (nonatomic, strong) A0_TopicViewController    *recommend;
@property (nonatomic, strong) A0_TopicViewController    *newly;
@property (nonatomic, strong) A0_TopicViewController    *hot;
@property (nonatomic, strong) A0_TopicViewController    *reply;

@end
