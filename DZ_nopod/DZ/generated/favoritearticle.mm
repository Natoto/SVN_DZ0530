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
// date:   2014-12-01 02:16:27 +0000
//

#import "favoritearticle.h"
#import "rmbdz.h"

#pragma mark - favoritearticle

@implementation favoritearticle

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize favid = _favid;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_FAVORITEARTICLE_SHOTS

- (void)routine
{
    //发送请求
    if (self.sending)
    {
        if (NULL == self.uid)
        {
            self.failed = YES;
            return;
        }
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=favoritearticle%@", [ServerConfig sharedInstance].url,[ServerConfig sharedInstance].urlpostfix];
        self.HTTP_POST(requestURI).PARAM(@"uid", self.uid).PARAM(@"aid", self.aid);
    }
    //请求成功
    else if (self.succeed)
    {
        //请求结果转JSON
        NSObject *result = self.responseJSON;
        //获取结果转NSDictionary
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            self.resp = [favoritearticle objectFromDictionary:(NSDictionary *)result];
        }
        //请求响应失败
        if (nil == self.resp || NO == [self.resp validate]) {
            self.failed = YES;
            return;
        }
    }
    //发送失败
    else if (self.failed) {
        BeeLog(@"self.descripting===%@", self.description);
    }
    //发送取消
    else if (self.cancelled) {
        BeeLog(@"self.description===%@", self.description);
    }
}

@end
