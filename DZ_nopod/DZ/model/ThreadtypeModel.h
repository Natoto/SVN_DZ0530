//
//  ThreadtypeModel.h
//  DZ
//
//  Created by nonato on 14-9-28.
//
//

#import "Bee_StreamViewModel.h"
#import "threadtype.h"

typedef void(^resultThreadBlock)(NSArray * block);
@interface ThreadtypeModel : BeeStreamViewModel
@property (nonatomic,retain)   NSString          *    KEY_CLS_TYPE;
@property (nonatomic, retain) NSString          *    fid;
@property (nonatomic,retain)  NSMutableArray    *    shots;

+(void)readthreadtype:(NSString *)fid block:(resultThreadBlock) block;
@end
