 
// author: unknown
// date:   2014-07-23 12:00:56 +0000
//

#import "Bee.h"

#pragma mark - models

@class pcms;
@class PICTUREWALL;
/*
 attachment = "http://114.215.178.111/amanmanceshi/dztoapp/status.php?action=showimage&aid=598&width=240&attachment=201408/11/143557lepgogm1p11da1o1.jpg&remote=0&ishome=1&ostype=-1";
 author = laimo056;
 height = 320;
 replies = 4;
 subject = sdfsdf;
 tid = 624;
 views = 255;
 width = 240;
 */
@interface pcms : BeeActiveObject
@property (nonatomic, retain) NSString *			attachment;
@property (nonatomic, retain) NSString *			replies;
@property (nonatomic, retain) NSString *			views;
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSNumber *			height;
@property (nonatomic, retain) NSString *			subject;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSNumber *			width;
@end

@interface PICTUREWALL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				pcms;
@end


@interface REQ_PICTUREWALL_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *			page;
@property (nonatomic, retain) NSNumber *			per_page;
@end

@interface API_PICTUREWALL_SHOTS : BeeAPI
//@property (nonatomic, retain) NSString              *   uid;
@property(nonatomic,retain) NSString *last_tid;
@property (nonatomic, retain) REQ_PICTUREWALL_SHOTS *   req;
@property (nonatomic, retain) PICTUREWALL           *   resp;
@end
