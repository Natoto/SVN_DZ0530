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
// date:   2014-09-28 03:52:07 +0000
//

#import "Bee.h"

#pragma mark - models

@class threadtype;
@class threadtype;

@interface threadtype : BeeActiveObject
@property (nonatomic, retain) NSString *			count;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			name;
@end

@interface threadtype2 : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				threadtype;
@end

@interface API_THREADTYPE_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString             *fid;               //用户id
@property (nonatomic, strong)   threadtype2           *resp;

@end
