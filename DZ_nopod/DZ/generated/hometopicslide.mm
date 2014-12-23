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
// date:   2014-08-26 12:43:36 +0000
//

#import "hometopicslide.h"
#import "rmbdz.h"

#pragma mark - HOMETOPICSLIDE

@implementation HOMETOPICSLIDE

@synthesize ecode = _ecode;
@synthesize emsg = _emsg;
@synthesize hometopicslide = _hometopicslide;

CONVERT_RENAME_CLASS(hometopicslide, home)
CONVERT_PROPERTY_CLASS(home, hometopicslide)

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - home

@implementation hometopicslide

@synthesize slide = _slide;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - slide

@implementation slide

@synthesize img = _img;
@synthesize subject = _subject;
@synthesize tid = _tid;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_HOMETOPICSLIDE_SHOTS

- (id)init
{
    self = [super init];
    if (self) {
        self.resp = nil;
    }
    return self;
}

- (void)dealloc
{
    self.resp = nil;
}

- (void)routine
{
    if (self.sending)
    {
        NSString *requestURI = [NSString stringWithFormat:@"%@?action=home_tpl_2%@", [ServerConfig sharedInstance].url, [ServerConfig sharedInstance].urlpostfix];
       BeeLog(@"%@", requestURI);
        self.HTTP_POST(requestURI);
    }
    else if (self.succeed)
    {
        NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [HOMETOPICSLIDE objectFromDictionary:(NSDictionary *)result];
            NSArray *slideDicAry = [self.resp.hometopicslide.slide copy];
           BeeLog(@"%@", slideDicAry);
            NSMutableArray *slideArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (int index = 0; index < slideDicAry.count; index++) {
                NSDictionary *dic = [slideDicAry objectAtIndex:index];
                BeeLog(@"%@", dic);
                slide *aSlide = [slide objectFromDictionary:dic];
                aSlide.subject = aSlide.subject?aSlide.subject:@"";
                BeeLog(@"%@", aSlide);
                [slideArray addObject:aSlide];
                BeeLog(@"%@", slideArray);
            }
            self.resp.hometopicslide.slide = slideArray;
           BeeLog(@"%@", self.resp.hometopicslide.slide);
		}
        
		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
    }
    else if (self.failed)
	{
       BeeLog(@"self.description===%@",self.description);
		// TODO:
	}
	else if (self.cancelled)
	{
       BeeLog(@"self.description %@",self.description);
		// TODO:
	}
}

@end
