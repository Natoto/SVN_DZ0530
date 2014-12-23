//
//  FriendsPM.h
//  DZ
//
//  Created by Nonato on 14-8-14.
//
//

#import "Bee_StreamViewModel.h"
#import "AllpmModel.h"
#import "UserModel.h"
 

@interface Allpm_FriendsModel : BeeStreamViewModel
{
    NSString * KEY_CLS_UID_TYPE;
}
AS_SINGLETON(Allpm_FriendsModel)

//@property(nonatomic,strong)NSMutableArray * agoodfriendms;
//@property(nonatomic,strong)NSMutableArray * friendms;
@property(nonatomic,strong)NSMutableDictionary * newfriendmsDic;
@property(nonatomic,strong)NSString       * uid;
@property(nonatomic,strong)LASFLASHDATA   * nowdate;
@property(nonatomic,strong)NSString       * msgtype;
@property(nonatomic,strong)NSString       * frienduid;
@property(nonatomic,assign)BOOL             loading;
@property(nonatomic,strong)NSMutableDictionary *friendmsDic;

-(void)saveNewMessage;
-(void)loadNewMessageCashe;
-(void)clearNewMessageCache;
-(void)clearOnewNewMessage:(NSString *)onefrienduid;
@end
