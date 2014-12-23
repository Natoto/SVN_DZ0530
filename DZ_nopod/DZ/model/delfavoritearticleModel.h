//
//  delfavoritearticleModel.h
//  DZ
//
//  Created by PFei_He on 14-12-1.
//
//

#import "Bee_StreamViewModel.h"

@interface delfavoritearticleModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *favid;

- (void)delcollection;

@end
