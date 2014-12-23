//    												
//    												
//    	 ______    ______    ______					
//    	/\  __ \  /\  ___\  /\  ___\			
//    	\ \  __<  \ \  __\_ \ \  __\_		
//    	 \ \_____\ \ \_____\ \ \_____\		
//    	  \/_____/  \/_____/  \/_____/			
//    												
//    												
//    												
// title:  
// author: unknown
// date:   2014-12-01 02:16:23 +0000
//

#import "Bee.h"

#pragma mark - models

@class delfavoritearticle;

@interface delfavoritearticle : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface API_DELFAVORITEARTICLE_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString            *uid;
@property (nonatomic, strong)   NSString            *favid;
@property (nonatomic, strong)   delfavoritearticle  *resp;

@end
