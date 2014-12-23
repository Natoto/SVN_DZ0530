//
//  ArticleModel.h
//  DZ
//
//  Created by PFei_He on 14-11-4.
//
//

#import "Bee_StreamViewModel.h"
#import "article.h"

@interface ArticleModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, retain) NSMutableArray *shots;
@property (nonatomic, retain) portal_article *mainArcticle;
@property (nonatomic, strong) ARTICLE   *article;

@end
