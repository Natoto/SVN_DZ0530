//
//  Switch_OnoffModel.h
//  DZ
//
//  Created by nonato on 14-10-30.
//
//

#import "Bee_StreamViewModel.h"
#import "switch_onoff.h"


typedef void (^successBlock)(onoff * reciveData);
typedef void (^errorBlock)(NSString *errmsg);
typedef void (^startBlock)();

@interface Switch_OnoffModel : BeeStreamViewModel
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) onoff * shots;

@property (nonatomic,copy) successBlock successblock;
@property (nonatomic,copy) errorBlock errorblock;
@property (nonatomic,copy) startBlock startblock;
+(onoff *)readOnff;

+(void)getSwitch_OnOff:(successBlock)successblock errorblock:(errorBlock)errorblock;

@end
