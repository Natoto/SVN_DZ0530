//
//  PortalModel.h
//  DZ
//
//  Created by PFei_He on 14-10-24.
//
//

#import "Bee_StreamViewModel.h"
#import "portal.h"

@interface PortalModel : BeeStreamViewModel

@property (nonatomic, strong) NSArray   *shots;
@property (nonatomic, assign) BOOL      end;

- (void)loadData;

@end
