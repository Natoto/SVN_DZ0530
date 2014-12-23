//    												
//    												
 		
//    												
//    												
//    												
// title:  
// author: unknown
// date:   2014-08-26 12:43:36 +0000
//

#import "Bee.h"

#pragma mark - models

@class HOMETOPICSLIDE;
@class hometopicslide;
@class slide;

@interface HOMETOPICSLIDE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) hometopicslide *			hometopicslide;
@end

@interface hometopicslide : BeeActiveObject
@property (nonatomic, retain) NSArray *				slide;
@end

@interface slide : BeeActiveObject
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSNumber *			tid;
@end

@interface API_HOMETOPICSLIDE_SHOTS : BeeAPI

@property (nonatomic, copy) NSString              *type;

@property (nonatomic, strong) HOMETOPICSLIDE         *resp;

@end
