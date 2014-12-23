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
// date:   2014-10-29 10:13:34 +0000
//

#import "Bee.h"

#pragma mark - models

@class BLOCKDETAIL;
@class blockitem;
@class items;

@interface BLOCKDETAIL : BeeActiveObject
@property (nonatomic, retain) blockitem *			blockitem;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@end

@interface blockitem : BeeActiveObject
@property (nonatomic, retain) NSString *			bid;
@property (nonatomic, retain) NSArray *				items;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSNumber *			type;
@end

@interface blockdetail_items : BeeActiveObject
@property (nonatomic, retain) NSString *			aid;
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSNumber *			recommends;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSNumber *			views;
@end

@interface API_BLOCKDETAIL_SHOTS : BeeAPI

@property (nonatomic, copy)     NSString            *bid;
@property (nonatomic, strong)   BLOCKDETAIL         *resp;

@end
