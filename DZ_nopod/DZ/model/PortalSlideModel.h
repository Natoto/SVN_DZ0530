//
//  PortalSlideModel.h
//  DZ
//
//  Created by PFei_He on 14-10-24.
//
//

#import "Bee_StreamViewModel.h"
#import "portalslide.h"

@interface PortalSlideModel : BeeStreamViewModel

@property (nonatomic, strong) PORTALSLIDE *shots;

- (void)loadData;

@end
