//
//  ToptenModel.h
//  DZ
//
//  Created by nonato on 14-10-20.
//
//

#import "Bee_StreamViewModel.h"
#import "topten.h"
typedef enum : int {
    TOPTEN_VIEWMOST = 1,
    TOPTEN_REPLYMOST = 2 ,
    TOPTEN_SUPPORTMOST = 3 ,
} TOPTENTYPE;
@interface ToptenModel : BeeStreamViewModel
@property(nonatomic,assign) TOPTENTYPE      type;
@property(nonatomic,strong) NSMutableArray * shots;
@property(nonatomic,strong) topten          * topTen;
@end
