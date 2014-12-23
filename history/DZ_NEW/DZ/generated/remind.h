 
// author: unknown
// date:   2014-06-03 08:44:56 +0000
//

#import "Bee.h"

#pragma mark - models

@class REMIND;
@class automatic;
@class dialog;
@class public2;

@interface REMIND : BeeActiveObject
@property (nonatomic, retain) NSArray *				automatic;
@property (nonatomic, retain) NSArray *				dialog;
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				public2;
@property (nonatomic, retain) NSNumber *            nowdate;
@end
/*
 applyid = 147;
 author = Test2;
 authorid = OZTHEpO0O0O0;
 avatar = "http://114.215.178.111/amanmanceshi/uc_server/images/noavatar_middle.gif";
 category = 1;
 check = 1;
 dateline = 1408611556;
 "from_id" = 0;
 "from_idtype" = "";
 "from_num" = 1;
 id = 777;
 interactivems = activity;
 new = 1;
 note = "Test2 \U7533\U8bf7\U52a0\U5165\U60a8\U4e3e\U529e\U7684\U6d3b\U52a8 [\U5410\U69fd]asfsafsf\Uff0c\U8bf7\U5ba1\U6838 &nbsp;  &rsaquo;";
 subject = asfsafsf;
 tid = 664;
 uid = OZTHApO0O0O0;
 */

@interface automatic : BeeActiveObject
@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			authorid;
@property (nonatomic, retain) NSString *			category;
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			from_id;
@property (nonatomic, retain) NSString *			from_idtype;
@property (nonatomic, retain) NSString *			from_num;
@property (nonatomic, retain) NSString *			id;
@property (nonatomic, retain) NSString *			news;
@property (nonatomic, retain) NSString *			note;
@property (nonatomic, retain) NSString *			type;
@property (nonatomic, retain) NSString *			uid;
@property (nonatomic, retain) NSString *            interactivems;

/*
 以下是活动贴专用
 */
@property (nonatomic, retain) NSString *            check;
@property (nonatomic, retain) NSString *            applyid;
@property (nonatomic, retain) NSString *            tid;
@property (nonatomic, retain) NSString *            subject;
@end

@interface dialog : BeeActiveObject
@property (nonatomic, retain) NSString *			isnew;
@property (nonatomic, retain) NSString *			lastdateline;
@property (nonatomic, retain) NSString *			lastupdate;
@property (nonatomic, retain) NSString *			plid;
@property (nonatomic, retain) NSString *			pmnum;
@property (nonatomic, retain) NSString *			uid;
@end

@interface public2 : BeeActiveObject
@property (nonatomic, retain) NSString *			dateline;
@property (nonatomic, retain) NSString *			gpmid;
@property (nonatomic, retain) NSString *			status;
@property (nonatomic, retain) NSString *			uid;
@end



@interface API_REMIND_SHOTS : BeeAPI
@property (nonatomic, retain) NSString           *   uid;
@property (nonatomic, retain) REMIND             *   resp;
@end


