//
//  D1_FriendsInfoViewController.m
//  DZ
//
//  Created by Nonato on 14-6-17.
//
//
#import "D1_FriendsInfo_HeaderCell.h"
#import "D1_FriendsInfoViewController.h"
#import "D1_FriendsInfo_BelowCell.h"
#import "UserModel.h"
#import "ToolsFunc.h"
#import "AddfriendModel.h"
#import "D2_Chat_StrangerViewController.h"
#import "friends.h"
#import "AppBoard_iPhone.h"
#import "DelfriendModel.h"

#import "D1_MypostViewController_iphone.h"
#import "D1_FriendsViewController_iphone.h"
#import "D1_Reply_MyViewController.h"
#import "D1_CollectionViewController_iphone.h"
#import "DZ_PopupBox.h"
#import "UIImage+Tint.h"
#import "PFRadioButton.h"
#import "NSData+base64.h"
#import "InformModel.h"
#import "PFPopupBox.h"
#import "PFTextView.h"

@interface D1_FriendsInfoViewController ()<D1_FriendsInfo_HeaderCellDelegate,DZ_PopupBoxDelegate,UIAlertViewDelegate>
{
    NSString *informString;
}

@property (nonatomic, strong) UserModel         *profilemodel;
@property (nonatomic, strong) NSMutableArray    *items;
@property (nonatomic, strong) UIButton          *addfriendBtn;
@property (nonatomic, strong) UIButton          *delfriendBtn;
@property (nonatomic, strong) UIButton          *informBtn;
@property (nonatomic, strong) UIButton          *sendMessageBtn;

@property (nonatomic, strong) DelfriendModel    *delfrdModel;
@property (nonatomic, strong) AddfriendModel    *addfrdModel;
@property (nonatomic, strong) friends           *myfriends;
@property (nonatomic, strong) InformModel       *informModel;

@property (nonatomic, strong) DZ_PopupBox       *wealthBox;
@property (nonatomic, strong) PFPopupBox        *informBox;
@property (nonatomic, strong) PFTextView        *textView;

@end

@implementation D1_FriendsInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [self.delfrdModel removeObserver:self];
    [self.profilemodel removeObserver:self];
    [self.addfrdModel removeObserver:self];
}

- (void)viewDidLoad
{
//    self.noHeaderFreshView = YES;
    self.noFooterView = YES;
    [super viewDidLoad];
    self.noFooterView = YES;
    self.title=@"详细资料";
    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewList.showsVerticalScrollIndicator = NO;
    self.profilemodel = [UserModel modelWithObserver:self];
    [self.profilemodel updateFriendProfile:self.uid];
    self.items=[[NSMutableArray alloc] initWithCapacity:0];
    
    self.addfrdModel = [AddfriendModel modelWithObserver:self];
    self.delfrdModel = [DelfriendModel modelWithObserver:self];
    self.informModel = [InformModel modelWithObserver:self];
}

#pragma mark - 个人资料加载成功

ON_SIGNAL3(UserModel, PROFILE_RELOADED, signal)
{
    friends *afriend=[[friends alloc] init];
    afriend.avatar = self.profilemodel.friendProfile.avatar;
    afriend.fuid = self.uid;
    afriend.username = self.profilemodel.friendProfile.username;
    self.myfriends = afriend;
    [self.items removeAllObjects];


//    NSString * money =[NSString stringWithFormat:@"积分: %@",self.profilemodel.friendProfile.credits];
//    [self.items addObject:money];
//   BeeLog(@"money%@", self.profilemodel.friendProfile.credits);


    NSString * baomi = @"保密";
    if (self.profilemodel.friendProfile.gender && self.profilemodel.friendProfile.gender.intValue == 1) baomi = @"男";
    else if (self.profilemodel.friendProfile.gender && self.profilemodel.friendProfile.gender.intValue == 2) baomi = @"女";
    else baomi = @"保密";
    NSString * gender = [NSString stringWithFormat:@"性别: %@", baomi];
   BeeLog(@"gender%@", self.profilemodel.friendProfile.gender);
    [self.items addObject:gender];
#warning data woring
    if (self.profilemodel.friendProfile.birthyear) {
         NSString * birthday =[NSString stringWithFormat:@"生日: %@-%@-%@", self.profilemodel.friendProfile.birthyear, self.profilemodel.friendProfile.birthmonth,self.profilemodel.friendProfile.birthday];
        [self.items addObject:birthday];
    }
   BeeLog(@"birth%@-%@-%@", self.profilemodel.friendProfile.birthyear, self.profilemodel.friendProfile.birthmonth, self.profilemodel.friendProfile.birthday);


//    NSString * oltime2 = [ToolsFunc datefromstring:self.profilemodel.friendProfile.oltime];
//    NSString * oltime=[NSString stringWithFormat:@"在线时间: %@",oltime2];
    NSString *oltime = [NSString stringWithFormat:@"在线时间: %@小时", self.profilemodel.friendProfile.oltime];
    [self.items addObject:oltime];
   BeeLog(@"oltime%@", self.profilemodel.friendProfile.oltime);


    /*
    NSString * lastactivity2 = [ToolsFunc datefromstring:self.profilemodel.friendProfile.lastactivity];
    NSString * lastactivity =[NSString stringWithFormat:@"上次活动时间: %@",lastactivity2];
    [self.items addObject:lastactivity];
    

    NSString * lastpost2 = [ToolsFunc datefromstring:self.profilemodel.friendProfile.lastpost];
    NSString * lastpost  =[NSString stringWithFormat:@"上次发布: %@",lastpost2];
    [self.items addObject:lastpost];
    */


    if (self.profilemodel.friendProfile.resideprovince && self.profilemodel.friendProfile.residecity) {
        NSString * residearea =[NSString stringWithFormat:@"所在地区: %@ %@",self.profilemodel.friendProfile.resideprovince,self.profilemodel.friendProfile.residecity];
        [self.items addObject:residearea];
    }
   BeeLog(@"residecity%@", self.profilemodel.friendProfile.residecity);


    NSString * lastvisit2 = [ToolsFunc datefromstring2:self.profilemodel.friendProfile.lastvisit];
    NSString * lastvisit=[NSString stringWithFormat:@"最后登录时间: %@",lastvisit2];
    [self.items addObject:lastvisit];
   BeeLog(@"lastvisit%@", self.profilemodel.friendProfile.lastvisit);


    /*
    NSString * regdate2 = [ToolsFunc datefromstring:self.profilemodel.friendProfile.regdate];
    NSString * regdate = [NSString stringWithFormat:@"注册时间: %@",regdate2];
    [self.items addObject:regdate];
    */
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(UserModel, PROFILE_FAILED, signal)
{
    [self FinishedLoadData];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [bee.ui.appBoard hideTabbar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 240;
    }
    else  if (indexPath.row == self.items.count + 1)
    {
        return 60;
    }
    else
    {
        return [D1_FriendsInfo_BelowCell heightOfD1_FriendInfo_BelowCell];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.uid isEqualToString:[UserModel sharedInstance].session.uid]) {
        return self.items.count + 2;
    }
    else
        return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    if (indexPath.row == 0) {
        NSString *ListViewCellId = @"ListViewCellId";
        D1_FriendsInfo_HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
        if (cell == nil) {
            cell = [[D1_FriendsInfo_HeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (self.profilemodel.friendProfile) {
            cell.delegate = self;
            cell.profile=self.profilemodel.friendProfile;
            [cell dataDidChanged];
        }
        return  cell;
    }
    else if (indexPath.row == self.items.count + 1)
    {
        float BTN_Y = 25;
        float BTN_X = 20;
        float BTN_WIDTH = 60;
        float BTN_HEIGHT = 30;
        float MARGIN_RIGHT = 20;
        NSString *ListViewCellId = @"ListViewCellId2";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ListViewCellId];
        UIImage *btnimge=[UIImage bundleImageNamed:@"tianjiahaoyou"];
        UIColor *color =[DZ_SystemSetting sharedInstance].navigationBarColor;
        UIColor *fontcolor =[UIColor blackColor];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
            UIImage *image=[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 10)];
            cell.backgroundImage = image;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _addfriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _addfriendBtn.titleLabel.font = [UIFont systemFontOfSize:15];

            //加好友
              btnimge = [btnimge imageWithTintColor:color];
            [_addfriendBtn setBackgroundImage:btnimge forState:UIControlStateNormal];
             [_addfriendBtn setTitleColor:fontcolor forState:UIControlStateNormal];
             _addfriendBtn.frame = CGRectMake(BTN_X, BTN_Y, BTN_WIDTH, BTN_HEIGHT);
            [cell.contentView addSubview:_addfriendBtn];

            //删好友
            _delfriendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _delfriendBtn.frame = CGRectMake(BTN_X, BTN_Y, BTN_WIDTH + 10, BTN_HEIGHT);
            [_delfriendBtn setTitleColor:fontcolor forState:UIControlStateNormal];
            _delfriendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_delfriendBtn setBackgroundImage:btnimge forState:UIControlStateNormal];
            [cell.contentView addSubview:_delfriendBtn];

            //举报
            _informBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _informBtn.frame = CGRectMake(cell.centerX - BTN_WIDTH / 2, BTN_Y, BTN_WIDTH, BTN_HEIGHT);
            [_informBtn setBackgroundImage:btnimge forState:UIControlStateNormal];
            _informBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:_informBtn];

            //发信息
            _sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_sendMessageBtn setBackgroundImage:btnimge forState:UIControlStateNormal];
            _sendMessageBtn.frame = CGRectMake(cell.width - BTN_WIDTH - MARGIN_RIGHT, BTN_Y, BTN_WIDTH, BTN_HEIGHT);
            _sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:_sendMessageBtn];
        }
        
        if (self.profilemodel.friendProfile.relationship.intValue) {//非好友
            _delfriendBtn.hidden = YES;
            _addfriendBtn.hidden = NO;
            [_addfriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
            [_addfriendBtn setTitleColor:fontcolor forState:UIControlStateNormal];
            [_addfriendBtn addTarget:self action:@selector(addfriendBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            _delfriendBtn.hidden = NO;
            _addfriendBtn.hidden = YES;
            [_delfriendBtn setTitle:@"删除好友" forState:UIControlStateNormal];
            [_delfriendBtn setTitleColor:fontcolor forState:UIControlStateNormal];
            [_delfriendBtn addTarget:self action:@selector(delfriendBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_informBtn setTitle:@"举报" forState:UIControlStateNormal];
        [_informBtn setTitleColor:fontcolor forState:UIControlStateNormal];
        [_informBtn addTarget:self action:@selector(informBtnTap:) forControlEvents:UIControlEventTouchUpInside];

        [_sendMessageBtn setTitle:@"发信息" forState:UIControlStateNormal];
        [_sendMessageBtn setTitleColor:fontcolor forState:UIControlStateNormal];
        [_sendMessageBtn addTarget:self action:@selector(sendMessageBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        NSString *ListViewCellId = @"ListViewCellId3";
        D1_FriendsInfo_BelowCell *cell=[tableView dequeueReusableCellWithIdentifier:ListViewCellId];
        if (cell == nil) {
            cell = [[D1_FriendsInfo_BelowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImage *image=[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 10)];
            cell.backgroundImage = image;
        }
        cell.textLabel.text=[_items objectAtIndex:indexPath.row -1];
//        cell.textLabel.frame = CGRectMake(25, 0, 280, 40);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - 删除好友成功

ON_SIGNAL3(DelfriendModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:[NSString stringWithFormat:@"%@", self.delfrdModel.shots.emsg]];
}

ON_SIGNAL3(DelfriendModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:@"删除成功"];
}

ON_SIGNAL3(AddfriendModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:@"发送成功"];
}

ON_SIGNAL3(AddfriendModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:[NSString stringWithFormat:@"%@", self.addfrdModel.shots.emsg]];
}

ON_SIGNAL3(InformModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:@"举报成功"];
}

ON_SIGNAL3(InformModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:[NSString stringWithFormat:@"%@", self.informModel.shots.emsg]];
}

#pragma mark - 功能列表


- (void)D1_FriendsInfo_HeaderCell_gotorwealth:(D1_FriendsInfo_HeaderCell *)cell
{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (!self.wealthBox) {
        DZ_PopupBox *PopupBox = [[DZ_PopupBox alloc] initWithFrame:rect];
        PopupBox.ppboxdelegate = self;
        PopupBox.title =[NSString stringWithFormat:@"%@的财富",self.profilemodel.friendProfile.username]; //@"我的财富";
        self.wealthBox = PopupBox;
    }
    [self.wealthBox show];
    PROFILE *profile =self.profilemodel.friendProfile; //[UserModel sharedInstance].profile;
    NSArray * keys =[NSArray arrayWithObjects:@"积分",@"金钱",@"威望",@"贡献", nil];
    NSString * credits= [NSString stringWithFormat:@"%@",profile.credits];
    NSString * contribution = [NSString stringWithFormat:@"%@",profile.contribution];
    NSString * prestige = [NSString stringWithFormat:@"%@",profile.contribution];
    NSString * money = [NSString stringWithFormat:@"%@",profile.money];
    NSArray * values = [NSArray arrayWithObjects:credits,money,prestige,contribution, nil];
    
    NSMutableDictionary *diction=[[NSMutableDictionary  alloc] initWithCapacity:0];
    [diction setObject:values[0] forKey:keys[0]];
    [diction setObject:values[1] forKey:keys[1]];
    [diction setObject:values[2] forKey:keys[2]];
    [diction setObject:values[3] forKey:keys[3]];
    [self.wealthBox loadDatas:diction];
}

- (void)D1_FriendsInfo_HeaderCell_gotosendhtml:(D1_FriendsInfo_HeaderCell *)cell
{
    D1_MypostViewController_iphone *ctr=[[D1_MypostViewController_iphone alloc] init];
    ctr.uid = self.uid;
    ctr.username = self.profilemodel.friendProfile.username;
    ctr.newtitle = [NSString stringWithFormat:@"%@的发帖",ctr.username];
    [self.navigationController  pushViewController:ctr animated:YES];
}

- (void)D1_FriendsInfo_HeaderCell_gotofriend:(D1_FriendsInfo_HeaderCell *)cell
{
    D1_FriendsViewController_iphone *ctr=[[D1_FriendsViewController_iphone alloc] init];
    ctr.uid = self.uid;
    ctr.username = self.profilemodel.friendProfile.username;
    ctr.newtitle = [NSString stringWithFormat:@"%@的好友",ctr.username];
    [self.navigationController  pushViewController:ctr animated:YES];
}

- (void)D1_FriendsInfo_HeaderCell_gotoreply:(D1_FriendsInfo_HeaderCell *)cell
{
    D1_Reply_MyViewController *ctr=[[D1_Reply_MyViewController alloc] init];
    ctr.uid = self.uid;
    ctr.replytype = MYREPLY_OTHERS;
    ctr.username = self.profilemodel.friendProfile.username;
    ctr.newtitle = [NSString stringWithFormat:@"%@的回复",ctr.username];
    [self.navigationController  pushViewController:ctr animated:YES];
}

- (void)D1_FriendsInfo_HeaderCell_gotocollect:(D1_FriendsInfo_HeaderCell *)cell
{
    D1_CollectionViewController_iphone *collectctr=[[D1_CollectionViewController_iphone alloc] init];
    collectctr.uid = self.uid;
    collectctr.username = self.profilemodel.friendProfile.username;
    collectctr.newtitle = [NSString stringWithFormat:@"%@的收藏",collectctr.username];
    [self.navigationController  pushViewController:collectctr animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1131) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            if (self.profilemodel.session.uid) {
                self.delfrdModel.fid = self.uid;
                self.delfrdModel.uid= [UserModel sharedInstance].session.uid;
                [self.delfrdModel firstPage];
                [self presentLoadingTips:@"发送删除请求..."];
            } else {
                [bee.ui.appBoard showLogin];
            }
        }
    }
}

- (void)informText:(NSString *)string
{
    informString = string;
    informString = [NSData base64encode:informString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//刷新调用的方法
-(void)refreshView
{
    [self.profilemodel updateFriendProfile:self.uid];
}

//加载调用的方法
-(void)getNextPageView
{
    [self FinishedLoadData];
}

#pragma mark - Events Methods

- (IBAction)addfriendBtnTap:(id)sender
{
    if (self.profilemodel.session.uid) {
        self.addfrdModel.fid = self.uid;
        self.addfrdModel.uid = [UserModel sharedInstance].session.uid;
        [self.addfrdModel firstPage];
        [self presentLoadingTips:@"发送好友请求..."];
    } else {
        [bee.ui.appBoard showLogin];
    }
}

- (IBAction)delfriendBtnTap:(id)sender
{
    UIAlertView *alertview =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定删除此好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.tag = 1131;
    [alertview show];
}

//举报按钮点击
- (void)informBtnTap:(UIButton *)button
{
    if (self.profilemodel.session.uid) {
        if (!self.informBox) {
            CGRect rect = [UIScreen mainScreen].bounds;
            self.informBox = [[PFPopupBox alloc] initWithFrame:rect contentViewWidth:290 contentViewHeight:270];
            self.informBox.title = [NSString stringWithFormat:@"举报"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.informBox.contentView.width - 20, 30)];
            label.text = @"请点击举报理由";
            label.font = [UIFont systemFontOfSize:15];
            [self.informBox.contentView addSubview:label];
        }
        [self.informBox show];

        if (!self.textView) {
            self.textView = [[PFTextView alloc] initWithFrame:CGRectMake(10, 200, self.informBox.contentView.width - 20, 40)];
            self.textView.delegate = self;
            self.textView.font = [UIFont systemFontOfSize:15];
            self.textView.placeholder = @"请填写举报内容（200字内）";
            self.textView.userInteractionEnabled = NO;
            self.textView.layer.borderColor = [UIColor grayColor].CGColor;
            self.textView.layer.borderWidth = 0.5f;
            self.textView.layer.cornerRadius = 5.0;
            [self.informBox.contentView addSubview:self.textView];

            PFRadioButton *radioButton = [[PFRadioButton alloc] initWithFrame:CGRectMake(10, 70, 80, 120) number:5 textArray:@[@"广告垃圾", @"违规内容", @"恶意灌水", @"重复发帖", @"其它"]];
            [self.informBox.contentView addSubview:radioButton];
            [radioButton didSelectItemAtIndexUsingBlock:^(NSString *title, NSUInteger index) {
                if (![title isEqualToString:@"其它"]) {
                    [self informText:title];
                    self.textView.userInteractionEnabled = NO;
                    self.textView.placeHolderLabel.hidden = YES;
                } else {
                    self.textView.userInteractionEnabled = YES;
                    self.textView.placeHolderLabel.hidden = NO;
                }
            }];
            informString = @"广告垃圾";
            UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
            confirm.frame = CGRectMake(self.informBox.contentView.frame.size.width - 60, 240, 50, 30);
            [confirm setTitle:@"确定" forState:UIControlStateNormal];
            [confirm addTarget:self action:@selector(confirmTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.informBox.contentView addSubview:confirm];
        }
    } else {
        [bee.ui.appBoard showLogin];
    }
}

- (void)confirmTap:(UIButton *)button
{
    self.informModel.ruid = self.uid;
    self.informModel.uid = [UserModel sharedInstance].session.uid;
    self.informModel.message = informString;
    [self.informModel inform];
    [self.informBox hide];
}

- (IBAction)sendMessageBtnTap:(id)sender
{
    if (self.profilemodel.session.uid) {
        D2_Chat_StrangerViewController *ctr=[[D2_Chat_StrangerViewController alloc] init];
        ctr.afriend = self.myfriends;
        if (self.profilemodel.friendProfile.relationship) {
            ctr.chattype =CHATTYPE_STRANGER;
        } else {
            ctr.chattype =CHATTYPE_FRIEND;
        }
        [self.navigationController  pushViewController:ctr animated:YES];
    } else {
        [bee.ui.appBoard showLogin];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.informBox.contentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 80);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.informBox.contentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    if (textView.text != nil && textView.text.length != 0) [self informText:textView.text];
    else [self informText:@"请填写举报内容"];
}

#pragma mark - DZ_PopupBoxDelegate

- (void)DZ_PopupBox:(DZ_PopupBox *)view MaskViewDidTaped:(id)object
{
    [self.wealthBox hide];
}

@end
