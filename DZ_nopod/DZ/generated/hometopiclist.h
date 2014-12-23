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
// date:   2014-08-26 06:53:52 +0000
//

#import "Bee.h"

#pragma mark - models

@class HOMETOPICLIST;
@class hometopiclist;

@interface HOMETOPICLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				hometopiclist;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			totalPage;
@end

@interface hometopiclist : BeeActiveObject
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end

@interface API_HOMETOPICLIST_SHOTS : BeeAPI

@property (nonatomic, copy) NSString              *type;

@property (nonatomic, strong) HOMETOPICLIST         *resp;

@end