//
//  ActivityModel.h
//  DZ
//
//  Created by Nonato on 14-8-18.
//
//

#import "Bee_StreamViewModel.h"
#import "activity.h"
@interface ActivityModel : BeeStreamViewModel
{
    NSString * KEY_CLS_TYPE;
}
@property (nonatomic, retain) NSString          *    type;
@property (nonatomic,retain)  NSMutableArray    *    shots;
@property (nonatomic,retain)  ACTIVITY          *    ACTY;
@end
