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
// date:   2014-10-27 10:10:00 +0000
//

#import "Bee.h"

#pragma mark - models

@class PORTAL;
@class items;
@class portal;

@interface PORTAL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				portal;
@end

@interface items : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			recommends;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *            aid;
@property (nonatomic, retain) NSNumber *            idtype;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			views;
@end

@interface portal : BeeActiveObject
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSString *            bid;
@property (nonatomic, retain) NSArray *				items;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSNumber *			type;
@end

@interface API_PORTAL_SHOTS : BeeAPI

@property (nonatomic, strong) PORTAL                *resp;

@end
