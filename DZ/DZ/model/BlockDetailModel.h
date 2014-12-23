//
//  BlockDetailModel.h
//  DZ
//
//  Created by PFei_He on 14-10-29.
//
//

#import "Bee_StreamViewModel.h"

@interface BlockDetailModel : BeeStreamViewModel

@property (nonatomic, strong)   NSArray     *shots;
@property (nonatomic, copy)     NSString    *bid;
@property (nonatomic, assign)   BOOL        end;

- (void)loadData;

@end
