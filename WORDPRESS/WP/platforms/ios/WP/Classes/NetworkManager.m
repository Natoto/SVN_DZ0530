#import "NetworkManager.h"
#import <CoreFoundation/CoreFoundation.h>
@interface NetworkManager ()

@property (assign) NSStringEncoding stringEncoding;
@property (nonatomic, assign, readwrite) NSUInteger     networkOperationCount;
@end

@implementation NetworkManager

@synthesize networkOperationCount = _networkOperationCount;

+ (NetworkManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static NetworkManager * sSharedInstance;

    dispatch_once(&onceToken, ^{
        sSharedInstance = [[NetworkManager alloc] init];
    });
    return sSharedInstance;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self setStringEncoding:NSUTF8StringEncoding];
    }
    return self;
}

-(NSMutableURLRequest *)createURLRequest:(NSString *)URL postKeys:(NSDictionary *)postKeys
{
    //create the URL POST Request to tumblr
//    NSURL *tumblrURL = [NSURL URLWithString:URL];
    NSURL * tumblrURL = [self smartURLForString:URL];
    NSMutableURLRequest *tumblrPost = [NSMutableURLRequest requestWithURL:tumblrURL];
    [tumblrPost setHTTPMethod:@"POST"];
    NSString *charset=  (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding([self stringEncoding]));//utf-8
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset];
    [tumblrPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    NSEnumerator *keys = [postKeys keyEnumerator];
    int i;
    int count = [postKeys count];
    for (i = 1; i < count; i++) {
        NSString *tempKey = [keys nextObject];
        NSString *data = [NSString stringWithFormat:@"%@=%@%@", tempKey, [postKeys objectForKey:tempKey],(i<count ?  @"&" : @"")];
        [postBody appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [tumblrPost setHTTPBody:postBody];
    
    return tumblrPost;
}

#pragma mark utilities
- (NSString*)encodeURL:(NSString *)string
{
	NSString * temp = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding([self stringEncoding])));
	NSString * str = [NSString stringWithString:temp];
	return str;
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);

    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
              || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

-(void)Url:(NSString *)path parasdic:(NSDictionary *)paras  onSuccess:(successBlock)successBlock onError:(errorBlock)errorBlock onStart:(startBlock)startBlock onCompletion:(complectionBlock)complectionBlock
{
    [self StartUrl:path paradic:paras];
    
    NSHTTPURLResponse * __block httpses = httpResponse;
    self.successblock = ^(NSMutableURLRequest * request,NSMutableData * reciveData){
        if (httpses.statusCode == 200)
        {
            successBlock(request,reciveData);
        }
    };
    self.startblock = ^(NSMutableURLRequest *request){
        startBlock(request);
    };
    self.errorblock = ^(NSMutableURLRequest * request){
        errorBlock(request);
    };
    self.complectionblock = ^(NSMutableURLRequest * request,NSMutableData * reciveData){
        complectionBlock(request,reciveData);
    };
}
-(void)StartUrl:(NSString *)path paradic:(NSDictionary *)paras
{
//    NSURL * url = [NSURL URLWithString:path];    
    NSMutableURLRequest * request1 = [self createURLRequest:path postKeys:paras];//[NSMutableURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request1 delegate:self];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    self.errorblock((NSMutableURLRequest *)connection.currentRequest);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"返回数据类型：%@",[response textEncodingName]);
  
    httpResponse = (NSHTTPURLResponse *)response;
    self.reciveMutableData = [NSMutableData dataWithCapacity:0];
    self.startblock((NSMutableURLRequest *)connection.currentRequest);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    NSUInteger datalength = [data length];
    NSLog(@"返回数据量：%ld",datalength);
    NSLog(@"%s",__FUNCTION__);
    [self.reciveMutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__FUNCTION__);
    self.complectionblock((NSMutableURLRequest *)connection.currentRequest,self.reciveMutableData);
}

@end
