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
// date:   2014-10-27 08:24:58 +0000
//

#import "Bee.h"

#pragma mark - models

@class discovery;
@class discovery;

@interface discovery : BeeActiveObject
@property (nonatomic, retain) NSString *			description;
@property (nonatomic, retain) NSString *			link;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSObject *			order;
@end

@interface DISCOVERY : BeeActiveObject
@property (nonatomic, retain) NSArray *				discovery;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end


@interface API_DISCOVERY_SHOTS : BeeAPI
@property (nonatomic, strong)   DISCOVERY            *resp;
@end

