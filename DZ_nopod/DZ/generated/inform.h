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
// date:   2014-09-04 07:00:47 +0000
//

#import "Bee.h"

#pragma mark - models

@class INFORM;

@interface INFORM : BeeActiveObject

@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;

@end

@interface API_INFORM_SHOTS : BeeAPI

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *ruid;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) INFORM *resp;

@end
