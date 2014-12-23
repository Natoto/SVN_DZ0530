//
//  InformModel.h
//  DZ
//
//  Created by PFei_He on 14-9-4.
//
//

#import "Bee_StreamViewModel.h"
#import "inform.h"

@interface InformModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *ruid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) INFORM *shots;

- (void)inform;

@end
