//
//  Allpm_StrangerModel.h
//  DZ
//
//  Created by Nonato on 14-8-15.
//
//

#import "Bee_StreamViewModel.h"
#import "AllpmModel.h"
@interface Allpm_StrangerModel : BeeStreamViewModel
{
    NSString * KEY_CLS_UID_TYPE;
}
AS_SINGLETON(Allpm_StrangerModel) 
@property(nonatomic,strong)NSMutableDictionary * newstrangermsDic;
@property(nonatomic,strong)NSString       * uid;
@property(nonatomic,strong)LASFLASHDATA   * nowdate;
@property(nonatomic,strong)NSString       * msgtype;
@property(nonatomic,strong)NSString       * frienduid;
@property(nonatomic,assign)BOOL             loading;
@property(nonatomic,strong)NSMutableDictionary *strangermsDic;

-(void)saveNewMessage;
-(void)loadNewMessageCashe;
-(void)clearNewMessageCache;
-(void)clearOnewNewMessage:(NSString *)onestrangeruid;
@end
