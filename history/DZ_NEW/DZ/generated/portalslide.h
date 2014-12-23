 
// author: unknown
// date:   2014-10-24 09:50:09 +0000
//

#import "Bee.h"

#pragma mark - models

@class PORTALSLIDE;
@class itemlist;

@interface PORTALSLIDE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) NSArray *				itemlist;
@end

@interface itemlist : BeeActiveObject
@property (nonatomic, retain) NSString *			itemid;
@property (nonatomic, retain) NSString *			pic;
@property (nonatomic, retain) NSString *			startdate;
@property (nonatomic, retain) NSString *			tid;
@property (nonatomic, retain) NSString *			title;
@end

@interface API_PORTALSLIDE_SHOTS : BeeAPI

@property (nonatomic, strong) PORTALSLIDE           *resp;

@end
