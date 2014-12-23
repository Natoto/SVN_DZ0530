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
// date:   2014-10-20 02:31:43 +0000
//

#import "Bee.h"
#import "Topiclist.h"

#pragma mark - models
//@class topics;
@class topten;

/*@interface topics : BeeActiveObject
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			authorname;
@property (nonatomic, retain) NSNumber *			digest;
@property (nonatomic, retain) NSString *			fid;
@property (nonatomic, retain) NSNumber *			heats;
@property (nonatomic, retain) NSString *			img;
@property (nonatomic, retain) NSString *			lastpost;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			recommends;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSNumber *			stickreply;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			views;
@end*/

@interface topten : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSNumber *			isEnd;
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSArray *				topics;
@property (nonatomic, retain) NSNumber *			totalPage;
@end


@interface REQ_TOPTEN_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_TOPTEN_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString             * type;
@property (nonatomic,strong)    REQ_TOPTEN_SHOTS     * req;
@property (nonatomic, strong)   topten               *resp;

@end
