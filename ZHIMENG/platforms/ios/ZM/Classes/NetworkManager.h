#import <Foundation/Foundation.h>

typedef void (^successBlock)(NSMutableURLRequest * request,NSMutableData * reciveData);
typedef void (^errorBlock)(NSMutableURLRequest * request);
typedef void (^startBlock)(NSMutableURLRequest * request);
typedef void (^complectionBlock)(NSMutableURLRequest * request,NSMutableData * reciveData);

@interface NetworkManager : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSHTTPURLResponse * httpResponse;
}
+ (NetworkManager *)sharedInstance;
@property (nonatomic,copy) successBlock successblock;
@property (nonatomic,copy) errorBlock errorblock;
@property (nonatomic,copy) startBlock startblock;
@property (nonatomic,copy) complectionBlock complectionblock;
@property (nonatomic,retain) __block NSMutableData * reciveMutableData;

-(void)Url:(NSString *)path parasdic:(NSDictionary *)paras onSuccess:(successBlock)successBlock onError:(errorBlock)errorBlock onStart:(startBlock)startBlock onCompletion:(complectionBlock)complectionBlock;


@end
