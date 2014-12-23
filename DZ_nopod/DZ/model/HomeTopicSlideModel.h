//
//  HomeTopicSlideModel.h
//  DZ
//
//  Created by PFei_He on 14-8-27.
//
//

#import "Bee_StreamViewModel.h"
#import "hometopicslide.h"

@interface HomeTopicSlideModel : BeeStreamViewModel

@property (nonatomic, strong) hometopicslide *shots;

- (void)loadSlide;

@end
