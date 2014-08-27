//
//  activitydata.h
//  DZ
//
//  Created by Nonato on 14-8-19.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h" 

@interface ACTIVITYDATA : BeeActiveObject
@property (nonatomic, retain) NSNumber          *ecode;
@property (nonatomic, retain) NSString          *emsg;
@end

@interface API_ACTIVITYDATA_SHOTS : BeeAPI
@property (nonatomic, copy)     NSString        * applyid;
@property (nonatomic, strong)   ACTIVITYDATA   * resp;
@end