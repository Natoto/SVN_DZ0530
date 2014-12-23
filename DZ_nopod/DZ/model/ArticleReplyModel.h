//
//  ArticleReplyModel.h
//  DZ
//
//  Created by PFei_He on 14-12-2.
//
//

#import "Bee_StreamViewModel.h"
#import "articlereply.h"

@interface ArticleReplyModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, strong) ArticleReply *shots;

@end
