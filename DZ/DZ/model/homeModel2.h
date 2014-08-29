//
//  homeModel2.h
//  DZ
//
//  Created by PFei_He on 14-8-21.
//
//

#import "Bee_StreamViewModel.h"

@interface homeModel2 : BeeStreamViewModel

AS_SINGLETON(homeModel2)

@property (nonatomic, strong) NSMutableArray *shots;

- (void)loadImage;

@end
