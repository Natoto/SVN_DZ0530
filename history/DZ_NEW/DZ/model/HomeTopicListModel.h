//
//  HomeTopicListModel.h
//  DZ
//
//  Created by PFei_He on 14-8-26.
//
//

#import "Bee_StreamViewModel.h"
#import "hometopiclist.h"

@interface HomeTopicListModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray *shots;
@property (nonatomic, assign) BOOL end;

- (void)loadList;

@end
