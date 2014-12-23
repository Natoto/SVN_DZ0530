//
//  DiscoveryModel.h
//  DZ
//
//  Created by nonato on 14-10-27.
//
//

#import "Bee_StreamViewModel.h"
#import "discovery_dz.h"
@interface DiscoveryModel : BeeStreamViewModel
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSMutableArray * shots;
@end
