//
//  favoritearticleModel.h
//  DZ
//
//  Created by PFei_He on 14-12-1.
//
//

#import "Bee_StreamViewModel.h"

@interface favoritearticleModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, strong) NSNumber *favid;

- (void)collect;

@end
