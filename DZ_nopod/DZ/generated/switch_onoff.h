//    												
//    												
//    	 ______    ______
//    	/\  __ \  /\   \ \
//    	\ \  __<  \ \   \ \
//    	 \ \_____\ \ \___\ \
//    	  \/_____/  \/_____\/
//    												
//    												
//    												
// title:  
// author: unknown
// date:   2014-10-30 01:34:04 +0000
//

#import "Bee.h"

#pragma mark - models

@class onoff;
@class SWITCH_ONOFF;

@interface onoff : BeeActiveObject
@property (nonatomic, retain) NSNumber *			isactivity;
@property (nonatomic, retain) NSString *			iscommand;
@property (nonatomic, retain) NSString *			isportal;
@property (nonatomic, retain) NSString *			isregist;
@end

@interface SWITCH_ONOFF : BeeActiveObject
@property (nonatomic, retain) NSNumber *			ecode;
@property (nonatomic, retain) NSString *			emsg;
@property (nonatomic, retain) onoff     *			onoff;
@end


@interface API_SWITCH_ONOFF_SHOTS : BeeAPI
@property (nonatomic, strong)   SWITCH_ONOFF            *resp;
@end
