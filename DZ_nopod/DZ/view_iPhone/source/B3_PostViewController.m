//
//  B2_PostViewController.m
//  DZ
//
//  Created by Nonato on 14-4-23.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "D1_FriendsInfoViewController.h"
#import "B4_PreviewImageView.h"
#import "B3_PostViewController.h"
#import "RCLabel.h"
#import "B3_PostMenuView.h"
#import "AppBoard_iPhone.h"
#import "D1_LoginBoard_iphone.h"
#import "B3_PostReplyViewController.h"
#import "UserModel.h"
#import "D2_Share.h"
#import "rmbdz.h"
#import "DZ_Timer.h"
#import "PostlistModel.h"
#import "collect.h"
#import "B3_QuickReplyView.h"
#import "MaskView.h"
#import "D2_ChatInputView.h"
#import "B3_Post_IWantApply.h"
#import "Deal_ActivityModel.h"
#import "B4_MoreOperationViewController.h"
//#import "PFTableViewCellModelOne.h"
//#import "PFTableViewCellModelTwo.h"
#import "PFTableViewCell.h"
#import "B3_PostView.h"
#import "B3_PostModel.h"
#import "Constants.h"

#define REPLYAREAHEIGHT 40

//extern BOOL isHeader;
extern NSInteger support;

@interface B3_PostViewController () <FaceBoardDelegate, MaskViewDelegate, D2_ChatInputViewDelegate, B3_Post_IWantApplyDelegate, UIAlertViewDelegate>
{
    float               historyY;
    BOOL                replyMode;
    B4_PreviewImageView *previewView;
    B3_PostMenuView     *menuView;
    UIButton            *toTopbtn;
    UIButton            *sendbtn;
//    NSTimer             *timer;
//    NSInteger           indexTimer;
//    BOOL                isHeader;
//    NSUInteger          index;
    D2_ChatInputView    *replyArea;
}

@property (nonatomic,retain) post               *friendpost;
@property (nonatomic,retain) UserModel          *usermodel;
@property (nonatomic,retain) Deal_ActivityModel *dealactivityModel;
@property (nonatomic,retain) content            *applyContent;
@property (nonatomic,retain) B3_Post_IWantApply *applyActivityView;

@end

@implementation B3_PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - BeeFramework Methods

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    if ([self.articleType isEqualToNumber:@1]) {
        menuView.isfavorite = self.postmodel.maintopic.isfavorite;
    } else {
        menuView.isfavorite = self.articleModel.article.isfavorite;
    }
    [menuView showInView:self.view];
//    self.postmodel.maintopic.isfavorite = menuView.isfavorite;
}

#pragma mark - 菜单: 只看楼主 回复 分享 收藏

ON_NOTIFICATION3(B3_PostMenuView, onlyReadBuildingOwner, signal)
{
    self.postmodel.tid = self.tid;
    self.postmodel.onlyauthorid = self.postmodel.maintopic.authorid;
    [self.postmodel loadCache];
    [self.postmodel firstPage];
//    [titleBtn setTitle:@"只看楼主" forState:UIControlStateNormal];
    self.title = @"只看楼主";
}

ON_NOTIFICATION3(B3_PostMenuView, copyurl, notify)
{
    if ([self.articleType isEqualToNumber:@1]) {
        NSString * url = [NSString stringWithFormat:@"%@",[ToolsFunc websiteArticleUrl:self.tid]];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
    } else {
        NSString * url = self.articleModel.article.weburl;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
    }
    [self presentSuccessTips:@"复制成功"];
}

ON_NOTIFICATION3(B3_PostMenuView, allRead, signal)
{
//    [titleBtn setTitle:@"全部" forState:UIControlStateNormal];
    self.title = @"全部";
    [self refreshView];
}

ON_NOTIFICATION3(B3_PostMenuView, reply, signal)
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    }
    B3_PostReplyViewController *ctr=[[B3_PostReplyViewController alloc] init];
    ctr.fid = self.fid;
    ctr.tid = self.tid;
    [self.navigationController pushViewController:ctr animated:YES];
}

ON_NOTIFICATION3(B3_PostMenuView, share, signal)
{
    D2_Share *share = [[D2_Share alloc] init];
    if ([self.articleType isEqualToNumber:@1]) {
        share.title = self.postmodel.maintopic.title;
    } else {
        share.title = self.articleModel.mainArcticle.title;
    }
    share.tid = self.tid;
    share.hasTid = YES;
    [self.navigationController pushViewController:share animated:YES];
}

ON_NOTIFICATION3(B3_PostMenuView, daoxu, notify)
{
    if (!self.postmodel.ordertype.integerValue) {
        self.postmodel.ordertype = @"1";
        [menuView reloadButton:@"倒序看帖" title:@"顺序看帖"];
    } else {
        self.postmodel.ordertype = @"0";
       [menuView reloadButton:@"倒序看帖" title:@"倒序看帖"];
    }
    [self refreshView];
}

#pragma mark - 收藏与取消收藏

ON_NOTIFICATION3(B3_PostMenuView, collect, signal)
{
    NSString *username = [UserModel sharedInstance].session.username;

    if (!username) {
        [self showAlertView];
        return;
    } else if ([self.articleType isEqualToNumber:@1]) {
        self.collectModel = [collectModel modelWithObserver:self];
        self.collectModel.tid = self.tid;
        self.collectModel.uid = [UserModel sharedInstance].session.uid;
        BeeLog(@"%@", self.postmodel.maintopic.isfavorite);

        if ([self.postmodel.maintopic.isfavorite isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self presentMessageTips:@"您已收藏本帖子，不可重复收藏"];
        } else {
            [self.collectModel collect];
        }
    } else {
        self.favoritearticleModel = [favoritearticleModel modelWithObserver:self];
        self.favoritearticleModel.aid = self.tid;
        self.favoritearticleModel.uid = [UserModel sharedInstance].session.uid;
        if ([self.articleModel.article.isfavorite isEqualToNumber:@1]) {
            [self presentMessageTips:@"您已收藏本文章，不可重复收藏"];
        } else {
            [self.favoritearticleModel collect];
        }
    }
}

ON_NOTIFICATION3(B3_PostMenuView, delcollection, signal)
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    } else if ([self.articleType isEqualToNumber:@1]) {
        self.delcollectionModel = [delcollectionModel modelWithObserver:self];
        self.delcollectionModel.uid = [UserModel sharedInstance].session.uid;

        if (self.collectModel.favid != 0) {
            self.delcollectionModel.favid = self.collectModel.favid;
        } else {
            self.delcollectionModel.favid = (NSNumber *)self.postmodel.maintopic.favid;
        }
        [self.delcollectionModel delcollection];
    } else {
        self.delfavoritearticleModel = [delfavoritearticleModel modelWithObserver:self];
        self.delfavoritearticleModel.uid = [UserModel sharedInstance].session.uid;
        if (self.favoritearticleModel.favid) {
            self.delfavoritearticleModel.favid = self.favoritearticleModel.favid;
        } else {
            self.delfavoritearticleModel.favid = self.articleModel.article.favid;
        }
        [self.delfavoritearticleModel delcollection];
    }
}

/*
//点赞
ON_NOTIFICATION3(B3_PostBaseTableViewCell, SUPPORT, notify)
{
    NSString *username = [UserModel sharedInstance].session.username;
    isHeader = [notify.object boolValue];
    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.supportModel = [SupportModel modelWithObserver:self];
        self.supportModel.tid = self.tid;
        self.supportModel.pid = self.pid;
        self.supportModel.type = self.type;
    }
    [self.supportModel firstPage];
}
 */

/**
 * 帖子加载
 */
ON_SIGNAL3(PostlistModel, RELOADED, signal)
{
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setTable2ReplyViewalpha:1];
                     } completion:^(BOOL f) {
                         [self setTable2ReplyViewalpha:1];
                     }];

    for (int i=0; i<self.postmodel.shots.count; i++) {
        [_cellsHeightDic setObject:[NSNumber numberWithFloat:60] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    self.fid = self.postmodel.maintopic.fid;
    menuView.isfavorite = self.postmodel.maintopic.isfavorite;

    if (!self.postmodel.shots.count) {
        self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(PostlistModel, FAILED, signal)
{
//    [self presentFailureTips:message];
    [self setTable2ReplyViewalpha:1.0];
    [self showErrorTips:signal];
    [self FinishedLoadData];
}

/**
 * 文章加载
 */
ON_SIGNAL3(ArticleModel, RELOADED, signal)
{
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setTable2ReplyViewalpha:1];
                     } completion:^(BOOL f) {
                         [self setTable2ReplyViewalpha:1];
                     }];
    PFTableViewCellReload = YES;
    imageLoaded = NO;
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(ArticleModel, FAILED, signal)
{
    [self setTable2ReplyViewalpha:1.0];
    [self showErrorTips:signal];
    [self FinishedLoadData];
}

/**
 * 收藏
 */
ON_SIGNAL3(collectModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"collect_success")];//收藏成功
    self.isSelected = YES;
    self.postmodel.maintopic.isfavorite = [NSNumber numberWithInt:1];
//    [self.postmodel firstPage];
}

ON_SIGNAL3(collectModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"collect_failed")];//收藏失败
    self.isSelected = NO;
}

ON_SIGNAL3(favoritearticleModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"collect_success")];//收藏成功
    self.isSelected = YES;
    self.articleModel.article.isfavorite = [NSNumber numberWithInt:1];
}

ON_SIGNAL3(favoritearticleModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"collect_failed")];//收藏失败
    self.isSelected = NO;
}

/**
 * 取消收藏
 */
ON_SIGNAL3(delcollectionModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"decollect_success")];//已取消收藏
    self.isSelected = YES;
    self.postmodel.maintopic.isfavorite = 0;
//    [self.postmodel firstPage];
}

ON_SIGNAL3(delcollectionModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"decollect_failed")];//取消收藏失败
    self.isSelected = NO;
}

ON_SIGNAL3(delfavoritearticleModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"decollect_success")];//已取消收藏
    self.isSelected = YES;
    self.articleModel.article.isfavorite = 0;
}

ON_SIGNAL3(delfavoritearticleModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:__TEXT(@"decollect_failed")];//取消收藏失败
    self.isSelected = NO;
}

/**
 * 点赞
 */
ON_SIGNAL3(SupportModel, RELOADED, signal)
{
    long index= self.currentIndexPath.row;
    if (index >0) {
        post *post = self.postmodel.shots[index];
        post.support = @(post.support.integerValue + 1);
        post.status = @0;
    } else {
        topic *post = self.postmodel.maintopic;
        post.support = @(post.support.integerValue + 1);
        post.status = @0;
    }
    [self.tableViewList reloadData];
}

ON_SIGNAL3(SupportModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:[NSString stringWithFormat:@"%@",self.supportModel.shots.emsg]];
}


ON_SIGNAL3(UserModel, LOGIN_RELOADED, signal)
{
//    [replayField resignFirstResponder];
    [replyArea resignFirstReponder];
    [self.postmodel firstPage];
}

/**
 * 开始回复
 */
ON_SIGNAL3(replyModel, FAILED, signal)
{
    self.friendpost = nil;
    [self dismissTips];
    replyModel *amodel = (replyModel *)signal.sourceViewModel;
    NSString *tips=[NSString stringWithFormat:@"%@", amodel.shots.emsg];
    [self presentFailureTips:tips];
    //    indexTimer = 0;
}

ON_SIGNAL3(replyModel, RELOADED, signal)
{
    self.friendpost=nil;
    [self dismissTips];
    [self presentSuccessTips:__TEXT(@"reply_success")];//回复成功
    //    replayField.text=@"";
    replyArea.replayField.text=@"";
    [self.postmodel firstPage];
    canscrollTableToFoot=YES;
    if (self.postmodel.ordertype.integerValue) {
        canscrollTableToFoot = NO;
    }
    [[DZ_Timer sharedInstance] endReply];
}

ON_SIGNAL3(ArticleReplyModel, FAILED, signal)
{
    [self dismissTips];
    ArticleReplyModel *amodel = (ArticleReplyModel *)signal.sourceViewModel;
    NSString *tips=[NSString stringWithFormat:@"%@", amodel.shots.emsg];
    [self presentFailureTips:tips];
    //    indexTimer = 0;
}

ON_SIGNAL3(ArticleReplyModel, RELOADED, signal)
{
    [self dismissTips];
    [self presentSuccessTips:__TEXT(@"reply_success")];//回复成功
    //    replayField.text=@"";
    replyArea.replayField.text=@"";
    [self.articleModel firstPage];
//    canscrollTableToFoot=YES;
//    if (self.postmodel.ordertype.integerValue) {
//        canscrollTableToFoot = NO;
//    }
    [[DZ_Timer sharedInstance] endReply];
    [self.tableViewList reloadData];
}

ON_SIGNAL3(Deal_ActivityModel, RELOADED, signal)
{
    [self dismissTips];
    if (self.dealactivityModel.shots.applyid.length){
        [self presentMessageTips:@"取消成功!"];
    } else {
        [self presentMessageTips:@"操作成功!"];
    }
    [self.postmodel firstPage];
}

ON_SIGNAL3(Deal_ActivityModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:_dealactivityModel.shots.emsg];
}

#pragma mark - Views Management

- (void)viewDidLoad
{
//    self.noFooterView=YES;
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;

    //文章类型
    if (self.articleType == nil) self.articleType = @1;
    if ([self.articleType isEqual:@1]) {
        self.postmodel = [PostlistModel modelWithObserver:self];
        self.postmodel.tid = self.tid;
        [self.postmodel loadCache];
    } else {
        self.articleModel = [ArticleModel modelWithObserver:self];
        self.articleModel.aid = self.tid;
        [self.articleModel loadCache];
    }

    self.usermodel = [UserModel modelWithObserver:self];
    menuView = [[B3_PostMenuView alloc] initWithFrame:CGRectMake(250, 20, 60, 100) itemNumber:[self.articleType isEqual:@1] ? 6 : 3];
    
    _cellsHeightDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (int i = 0; i < self.postmodel.shots.count; i++) {
        [_cellsHeightDic setObject:[NSNumber numberWithFloat:60] forKey:[NSString stringWithFormat:@"%d",i]];
    }

    //回复区
    replyArea = [[D2_ChatInputView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT,self.view.bounds.size.width, REPLYAREAHEIGHT)];//[self addReplayEditArea:CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT,self.view.bounds.size.width, REPLYAREAHEIGHT)];
    if ([self.articleType isEqual:@2]) {
        [replyArea.btnFacial removeFromSuperview], replyArea.btnFacial = nil;
    }
    replyArea.sentTxt = @"回复";
    replyArea.delegate = self;
    [self.view addSubview:replyArea];
//    replayField = replyArea.replayField;
    [self.view bringSubviewToFront:replyArea];
    
    [self addObserver];

    [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage bundleImageNamed:@"caidan"]];
    [self observeNotification:[B3_PostMenuView sharedInstance].onlyReadBuildingOwner];
    [self observeNotification:[B3_PostMenuView sharedInstance].reply];
    [self observeNotification:[B3_PostMenuView sharedInstance].share];
    [self observeNotification:[B3_PostMenuView sharedInstance].collect];
    [self observeNotification:[B3_PostMenuView sharedInstance].delcollection];
    [self observeNotification:[B3_PostMenuView sharedInstance].allRead];
    [self observeNotification:[B3_PostMenuView sharedInstance].daoxu];
    [self observeNotification:[B3_PostMenuView sharedInstance].copyurl];
    
    //回到顶部
    toTopbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopbtn.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-40,self.view.bounds.size.height-REPLYAREAHEIGHT-70, 40, 40);
    [toTopbtn setImage:[UIImage bundleImageNamed:@"huidaoshouye-02"] forState:UIControlStateNormal];
    [toTopbtn addTarget:self action:@selector(titleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    toTopbtn.hidden = YES;
    [self.view addSubview:toTopbtn];
//    [self.view bringSubviewToFront:toTopbtn];
    
    self.title = __TEXT(@"all");//全部
//    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    titleBtn.frame=CGRectMake(100, 0, 200, self.navigationController.navigationBar.bounds.size.height);
//    titleBtn.center =CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) .0/2.0, self.navigationController.navigationBar.bounds.size.height/2.0);
//    [titleBtn setTitle:@"全部" forState:UIControlStateNormal];
//    [titleBtn addTarget:self action:@selector(titleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = titleBtn;



    maskview = [[MaskView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    maskview.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.postmodel firstPage];
    [self.articleModel firstPage];

    [self.tableViewList reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [replayField resignFirstResponder];
    [replyArea resignFirstReponder];
}

- (void)setTable2ReplyViewalpha:(float)alpha
{
    self.tableViewList.alpha = alpha;
    replyArea.alpha = alpha;
    if (alpha == 0) {
        [self presentLoadingTips:__TEXT(@"loading")];//加载中……
    } else {
        [self dismissTips];
    }
}

- (void)keybordWillAppear:(NSNotification *)notify
{
    replyMode=YES;
    NSDictionary* info = [notify userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
//    bgtransparencyView.hidden=NO;
    replyArea.frame=CGRectMake(0, self.view.bounds.size.height-keyBoardSize.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
    [maskview showInView:nil];
    maskview.frame = CGRectMake(0, 0, keyBoardSize.width,CGRectGetHeight(self.view.window.bounds) - keyBoardSize.height-REPLYAREAHEIGHT);
   [UIView commitAnimations];
}

- (void)resignAll:(UIGestureRecognizer *)gesture
{
    [replyArea resignFirstReponder];
//    [replayField resignFirstResponder];
    [maskview hiddenMask];
//      bgtransparencyView.hidden=YES;
//    bgtransparencyView=nil;
}

- (void)keybordWillDisAppear:(NSNotification *)notify
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
//     bgtransparencyView.hidden=YES;
    [maskview hiddenMask];
    replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
     replyMode=NO;
    [UIView commitAnimations];
}

- (void)showPreviewsBigImgview:(NSString *)url imageView:(BeeUIImageView *)imageView mainTopic:(BOOL)maintopic
{
    if (imageView.command ==COMMAND_URL && url && [url rangeOfString:@"file://"].location==NSNotFound) {
        NSArray *contentArray = nil;
        if (maintopic || currentindexPath.integerValue < 0) {
            contentArray = self.postmodel.maintopic.content;
        } else {
            post *apost=[self.postmodel.shots objectAtIndex:currentindexPath.integerValue];
            contentArray = apost.content;
        }

        if (!contentArray.count) return;

        CGRect frame =[UIScreen mainScreen].bounds;
        previewView =[[B4_PreviewImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) withurl:url target:self andSEL:@selector(handleSingleViewTap:) contentAry:contentArray];
        [self.view addSubview:previewView];
        [self.view bringSubviewToFront:previewView];

        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.5f animations:^{
            previewView.frame =CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        }];
        replyArea.hidden = YES;
    }
    else
    {
        if (imageView.command == COMMAND_NOPERMISSION) {
            [self presentMessageTips:@"亲，您没有权限查看附件图片哦！"];
            [bee.ui.appBoard showLogin];
        } else if (imageView.command == COMMAND_2G3GNOSEE) {
            [self presentMessageTips:@"当前设置2G3G不显示，请在我的->设置修改"];
//            imageView.command = COMMAND_2G3GCAN;
//            [imageView GET:url useCache:YES];
        } else if (imageView.command == COMMAND_NORMARL) {
            [bee.ui.appBoard showLogin];
//            [self presentMessageTips:@"亲，您没有权限查看附件图片哦!"];
        }
    }
}

//显示提示框
- (void)showAlertView
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:__TEXT(@"tips")//温馨提示
                                                        message:@"您还没有登录，是否现在登录？"
                                                       delegate:self
                                              cancelButtonTitle:__TEXT(@"do_no")
                                              otherButtonTitles:__TEXT(@"ok"), nil];
    alertview.tag = 1338;
    [alertview show];
}

#pragma mark - Property Management

//我要报名活动
- (Deal_ActivityModel *)dealactivityModel
{
    if (!_dealactivityModel) {
        _dealactivityModel = [Deal_ActivityModel modelWithObserver:self];
    }
    return  _dealactivityModel;
}

//- (NSMutableArray *)spliteFacialandText:(NSString *)text
//{
//    NSArray *compants=[text componentsSeparatedByString:@" "];
//    NSMutableArray *contentTextAry=[[NSMutableArray alloc] initWithCapacity:0];
//    
//    if (compants.count==0) {
//        replyContent *acont1=[[replyContent alloc] init];
//        acont1.msg=text;
//        acont1.type=[NSNumber numberWithInt:0];
//        [contentTextAry addObject:acont1];
//    }
//    for (int index2 = 0; index2 < compants.count; index2 ++) {
//        NSString *key=[compants objectAtIndex:index2];
//        NSString *isfacion=[FaceBoard isExistFacail:key];
//        if (!isfacion) {//不是表情
//            replyContent *acont1=[[replyContent alloc] init];
//            acont1.msg=key;
//            acont1.type=[NSNumber numberWithInt:0];
//            [contentTextAry addObject:acont1];
//        }
//        else//是表情
//        {
//            replyContent *acont1=[[replyContent alloc] init];
//            acont1.msg=isfacion;
//            acont1.type=[NSNumber numberWithInt:0];
//            [contentTextAry addObject:acont1];
//        }
//    }
//    return contentTextAry;
//}

#pragma mark - Private Management

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
/*
//获取host的名称
- (NSString *) hostname
{
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '/0';

#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}

//这是本地host的IP地址
- (NSString *) localIPAddress
{
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}
*/
#pragma mark - Task Management

- (void)supportAPIstart:(NSString *)pid type:(NSString *)type
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.supportModel = [SupportModel modelWithObserver:self];
        self.supportModel.tid = self.tid;
        self.supportModel.pid = pid;
        self.supportModel.type = type;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    [self.supportModel firstPage];
}

- (void)scrollTableToFoot:(BOOL)animated tableview:(UITableView *)Table
{
    if (!canscrollTableToFoot) return;

    canscrollTableToFoot = NO;

    NSInteger s = [Table numberOfSections];
    if (s<1) return;

    NSInteger r = [Table numberOfRowsInSection:s - 1];
    if (r<1) return;

    NSIndexPath *ip = [NSIndexPath indexPathForRow:r - 1 inSection:s - 1];
    [Table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)showB3_Post_IWantApply:(id)object
{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (!self.applyActivityView) {
        B3_Post_IWantApply *PopupBox = [[B3_Post_IWantApply alloc] initWithFrame:rect];
        PopupBox.ppboxdelegate = self;
        PopupBox.title = @"我要报名";
        self.applyActivityView = PopupBox;
    }
    [_applyActivityView show];
    content *acontent = (content *)object;
    self.applyContent = acontent;
    _applyActivityView.acontent = acontent;

    NSMutableDictionary *diction=[[NSMutableDictionary  alloc] initWithCapacity:0];

    if (acontent.userfield.length) {
        NSRegularExpression *rgex=[[NSRegularExpression alloc] initWithPattern:@"\\(|\\)|\\s{1,}" options:NSRegularExpressionCaseInsensitive error:nil];
        acontent.userfield = [rgex stringByReplacingMatchesInString:acontent.userfield options:NSMatchingReportCompletion range:NSMakeRange(0, acontent.userfield.length) withTemplate:@""];
    }
    NSMutableArray * keys =[[NSMutableArray alloc] initWithCapacity:0];
    if (acontent.userfield) {
        [keys addObjectsFromArray:[acontent.userfield componentsSeparatedByString:@","]];
    }
    [keys addObject:@"leavemessage"];
    for (int idx = 0; idx < keys.count; idx ++) {
        NSString *mykey=keys[idx];
        if (mykey) {
            [diction setObject:@"" forKey:mykey.trim];
            if (_applyActivityView.iWantapplyDic) {
                NSString *value =[_applyActivityView.iWantapplyDic objectForKey:mykey.trim];
                if (value) {
                    [diction setObject:value forKey:mykey.trim];
                }
            }
        }
    }
    [self removeObserver];
    [_applyActivityView loadDatas:diction];
}

#pragma mark - Events Management

- (IBAction)titleBtnTap:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableViewList setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        [self.tableViewList setContentOffset:CGPointMake(0, 0)];
    }];
}

//刷新调用的方法
- (void)refreshView
{
    if ([self.articleType isEqual:@1]) {
        self.postmodel.onlyauthorid = nil;
        [self.postmodel firstPage];
    } else {
        [self.articleModel firstPage];
    }
}

- (void)getNextPageView
{
    if ([self.articleType isEqualToNumber:@1] && self.postmodel.more) {
            [self removeFooterView];
            [self.postmodel nextPage];
        
    } else if ([self.articleType isEqualToNumber:@2] && self.articleModel.more) {
            [self removeFooterView];
            [self.articleModel nextPage];
    } else {
        [self FinishedLoadData];
        [self presentMessageTips:@"没有更多的了"];
        [self tableView:self.tableViewList didSelectRowAtIndexPath:nil];
    }
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    replyArea.hidden = NO;
    [previewView removeFromSuperview];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)applyActivity
{
    self.dealactivityModel.type = @"1";
    self.dealactivityModel.uid = [UserModel sharedInstance].session.uid;
    self.dealactivityModel.tid = self.tid;
    NSString *payment = [_applyActivityView.iWantapplyDic valueForKey:KEY_COSTTYPE];
    self.dealactivityModel.payment = payment;
    self.dealactivityModel.authorid = self.postmodel.maintopic.authorid;
    self.dealactivityModel.message = [_applyActivityView.iWantapplyDic valueForKey:@"leavemessage"];
    self.dealactivityModel.subject = self.postmodel.maintopic.title ;
    [self.dealactivityModel firstPage];
    [self presentLoadingTips:@"提交申请..."];
}

- (void)cancelApplyActivity
{
    self.dealactivityModel.type = @"2";
    self.dealactivityModel.uid = [UserModel sharedInstance].session.uid;
    self.dealactivityModel.tid = self.tid;
    self.dealactivityModel.payment = [_applyActivityView.iWantapplyDic valueForKey:KEY_COSTTYPE];
    self.dealactivityModel.authorid = self.postmodel.maintopic.authorid;
    self.dealactivityModel.message = [_applyActivityView.iWantapplyDic valueForKey:@"leavemessage"];
    self.dealactivityModel.subject = self.postmodel.maintopic.title ;
    [self.dealactivityModel firstPage];
    [self presentLoadingTips:@"提交申请..."];
}

- (void)handleMoreCell:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    B4_MoreOperationViewController *b4ctr=[[B4_MoreOperationViewController alloc] init];
    b4ctr.contentstring =  self.selectString;
    [self.navigationController  pushViewController:b4ctr animated:NO];
}

//复制cell
- (void)handleCopyCell:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.selectString;
}

- (void)gotoUrlWeb:(NSString *)url
{
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    if(![url hasPrefix:@"http://"]) {
        url =[NSString stringWithFormat:@"%@%@",@"http://",url];
    }
    NSURL * gotourl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];

    if ([ToolsFunc isSelfWebSite:url]) {
        NSString *tid =[ToolsFunc articletid:url];
        if (tid.length) {
            B3_PostViewController *board=[[B3_PostViewController alloc] init];
            board.tid = tid;
            [self.navigationController pushViewController:board animated:YES];
            return;
        }
    }
    [[UIApplication sharedApplication] openURL:gotourl];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1338) {
        if (buttonIndex == 1) {
            [bee.ui.appBoard showLogin];
        }
    } else if(alertView.tag == 154543) {
        if (buttonIndex == 1) {//取消活动
            [self cancelApplyActivity];
        } else {

        }
    }
}

#pragma mark - UIScrollViewDelegate

//上滑隐藏回复栏
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (replyMode) return;

    if (historyY+50<targetContentOffset->y) {//下拉
        [UIView animateWithDuration:0.25
                         animations:^{
                             toTopbtn.hidden=NO;
                             replyArea.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, REPLYAREAHEIGHT);
                         }];

    } else if (historyY-50>targetContentOffset->y) {//上拉 显示回复框
        [UIView animateWithDuration:0.25
                         animations:^{
                             toTopbtn.hidden=YES;
                             replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
                         }];
    }
    historyY = targetContentOffset->y;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([self.articleType isEqual:@1]) return self.postmodel.shots.count + 1;
    else {
//        [PFTableViewCell heightSettingsCount:self.articleModel.shots.count + 1];
        return self.articleModel.shots.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.articleType == nil) {
        self.articleType = @1;
    }
    if ([self.articleType isEqualToNumber:@1]) {
        if (indexPath.row == 0) {
            static NSString *headerindeifier = @"postview.header.cell";
            B3_PostTableView_HeadCell *cell =[tableView dequeueReusableCellWithIdentifier:headerindeifier];
            if (!cell) {
                cell = [[B3_PostTableView_HeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerindeifier];
                cell.delegate=self;
                [self addCellSelectedColor:cell];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.celltopic = self.postmodel.maintopic;
            cell.lblfloortext = [NSString stringWithFormat:@"楼主: "];
            cell.support = self.postmodel.maintopic.support;

            if (cell.celltopic.support != nil) cell.status = self.postmodel.maintopic.status;

            [cell reloadsubviews];
            cell.isHeader = YES;

            return cell;
        } else {
            static NSString *indeifier=@"postview.cell";
            B3_PostTableView_Cell *cell =[tableView dequeueReusableCellWithIdentifier:indeifier];
            if (!cell) {
                cell = [[B3_PostTableView_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indeifier];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.cellIndex = [NSString stringWithFormat:@"%ld", indexPath.row - 1];
            cell.cellpost = [self.postmodel.shots objectAtIndex:indexPath.row - 1];
            cell.lblfloortext = [NSString stringWithFormat:@"%@楼: ",cell.cellpost.position];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell reloadsubviews];
            });

            return cell;
        }
    } else {
        B3_PostModel *postModel = [[B3_PostModel alloc] init];

        @weakify_self
        [postModel textLabelTouchUsingBlock:^(B3_PostModel *postModel, UIView *view, UIGestureRecognizer *recognizer) {
            //双击结束 和长按开始状态
            if (([[recognizer class] isSubclassOfClass:[UILongPressGestureRecognizer class]] && recognizer.state == UIGestureRecognizerStateBegan) || ([[recognizer class] isSubclassOfClass:[UITapGestureRecognizer class]] && recognizer.state == UIGestureRecognizerStateEnded))
            {
                UILabel *label = (UILabel *)view;
                weakSelf.selectString = label.text;
                [weakSelf handleMoreCell:nil];
            }
        }];

        [postModel loadedUsingBlock:^(PFTableViewCell *tableViewCewll, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
//                if (!imageLoaded) {
//                    imageLoaded = YES;
//                    [weakSelf.tableViewList reloadData];
//                }
            }
        }];

        return [postModel setupTableViewCellInTableView:self.tableViewList aboveView:self.view viewControl:self articleModel:self.articleModel atIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate

//加载完成的判断
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    [self scrollTableToFoot:YES tableview:tableView];
    
    if (!replyMode) {
        if (tableView.contentSize.height<self.view.frame.size.height) {
            replyArea.frame = CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.articleType isEqualToNumber:@1]) {
        if (indexPath.row == 0) {
            /*
             topic *atopic=self.postmodel.maintopic;
             float myheadercellheight=120;
             myheadercellheight= 120 + headercellheight;
             post *apost = [self.postmodel.mai objectAtIndex:indexPath.row];
             */
            float height = [B3_PostTableView_HeadCell heightOfCell:self.postmodel.maintopic.content];
            height = height + 100 ;
            return height;
            //        return headercellheight;
        } else {
            post *apost = [self.postmodel.shots objectAtIndex:indexPath.row - 1];
            float height = [B3_PostTableView_Cell heightOfCell:apost.content];
            height = height + 60 ;
            return height; 
        }
    } else {
        return [B3_PostModel heightAtIndexPath:indexPath articleModel:self.articleModel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (replyMode) {
        return;
    }
//    [replayField resignFirstResponder];
    [replyArea resignFirstReponder];
    if (replyArea.frame.origin.y == self.view.bounds.size.height-REPLYAREAHEIGHT) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             toTopbtn.hidden=NO;
                             replyArea.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, REPLYAREAHEIGHT);
                         }];
    } else {
        [UIView animateWithDuration:0.25
                     animations:^{
                         toTopbtn.hidden=YES;
                         replyArea.frame=CGRectMake(0, self.view.bounds.size.height-REPLYAREAHEIGHT, self.view.bounds.size.width, REPLYAREAHEIGHT);
                     }];

    }
}

#pragma mark - B3_PostTableView_HeadCellDelegate

- (void)B3_HeadCell:(B3_PostTableView_HeadCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    [self gotoUrlWeb:url];
//     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

//申请参加活动
- (void)B3_HeadCell:(B3_PostTableView_HeadCell *)cell applyButtonTaped:(id)object
{
    if (![UserModel sharedInstance].session.uid) {
        [bee.ui.appBoard showLogin];
    }
    else
    {
        self.applyContent = object;
        if ([self.applyContent.applied isEqualToString:@"1"] || [self.applyContent.applied isEqualToString:@"0"]) {
            UIAlertView *alertview =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出活动吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertview.tag = 154543;
            [alertview show];
        } else {
            [self showB3_Post_IWantApply:object];
        }
        //        [self presentMessageTips:@"活动搞起..."];
    }
}

/**
 * 复制
 */
/*此处是弹起菜单方式展现
 [cell becomeFirstResponder];
 //给sel 传递多个参数
 UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(handleCopyCell:)];
 UIMenuItem *itMore = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(handleMoreCell:)];
 UIMenuController *menu = [UIMenuController sharedMenuController];
 self.selectString = rtlabel.visibleText;
 [menu setMenuItems:[NSArray arrayWithObjects:itCopy,itMore,nil]];
 CGRect rect = rtlabel.frame;
 if([[cell class] isSubclassOfClass:[B3_PostTableView_Cell class]])
 {
 rect.origin.y = rect.origin.y + 70;
 }
 else
 {
 rect.origin.y = rect.origin.y + 100;
 }
 [menu setTargetRect:rect inView:cell];
 [menu setMenuVisible:YES animated:YES];
 */

/**
 * 查看好友资料
 */
- (void)B3_HeadCellProfileBtnTapped:(B3_PostTableView_HeadCell *)obj
{
    D1_FriendsInfoViewController *ctr = [[D1_FriendsInfoViewController alloc] init];
    ctr.uid=obj.celltopic.authorid;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)B3_HeadCellReplyButtonTap:(B3_PostTableView_HeadCell *)obj
{
    self.friendpost = nil;
    self.reply_model.pid = @"";
    [replyArea becomeFirstResponder];
//    replayField.placeholder = @"回复楼主...";
//    [replayField becomeFirstResponder];
}

- (void)B3_HeadCell:(B3_PostTableView_HeadCell *)cell rtlabel:(RCLabel *)rtlabel LongPress:(UIGestureRecognizer *)recognizer
{
    [self B3_Cell:cell rtlabel:rtlabel LongPress:recognizer];
}

//输入框隐藏和显示
- (void)B3_HeadCellHeaderViewTapped:(B3_PostTableView_HeadCell *)object
{
    [self tableView:self.tableViewList didSelectRowAtIndexPath:nil];
}

//预览图片
- (void)B3_HeadCellShowBigImgview:(NSString *)url imageView:(BeeUIImageView *)imageView
{
    currentindexPath = @"-1";
    [self showPreviewsBigImgview:url imageView:imageView mainTopic:YES];
}

- (void)B3_HeadCellDidFinishLoad:(CGRect)frame
{
    if (headercellheight != frame.size.height) {
        headercellheight = frame.size.height;
        [self.tableViewList reloadData];
    }
}

//点赞
- (void)B3_HeadCell:(B3_PostTableView_HeadCell *)cell supportbtn:(id)sender support:(BOOL)support
{
    /*
    self.postmodel.maintopic.status = @0;
    self.postmodel.maintopic.support = @(self.postmodel.maintopic.support.integerValue + 1);
     */
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self supportAPIstart:cell.celltopic.pid type:@"1"];
}

//    [self dismissTips];
////    [self presentMessageTips:@"点赞成功"];
//    [B3_PostBaseTableViewCell sharedInstance].lblsupport.text = [NSString stringWithFormat:@"%d", support + 1];
//
//    if (isHeader)
//    {
//        UIImage *weidingtieimage02=[UIImage bundleImageNamed:@"weidingtie(02)"];
//        [[B3_PostBaseTableViewCell sharedInstance].btnsupport setImage:weidingtieimage02 forState:UIControlStateNormal];
//        self.postmodel.maintopic.status = @0;
//        self.postmodel.maintopic.support = @(self.postmodel.maintopic.support.integerValue + 1);
//    }
//    else
//    {
//        UIImage *weidingtieimage = [UIImage bundleImageNamed:@"dingtie"];
//        [[B3_PostBaseTableViewCell sharedInstance].btnsupport setImage:weidingtieimage forState:UIControlStateNormal];
//        post *post = self.postmodel.shots[index];
//        post.support = @(post.support.integerValue + 1);
//        post.status = @0;
//    }
//}

#pragma mark - B3_PostTableView_CellDelegate

- (void)B3_Cell:(B3_PostTableView_Cell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    /*
     url = [url stringByReplacingOccurrencesOfString:@"'" withString:@""];
     url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
     */
    [self gotoUrlWeb:url];
}

- (void)B3_Cell:(B3_PostTableView_Cell *)cell rtlabel:(RCLabel *)rtlabel LongPress:(UIGestureRecognizer *)recognizer
{
    //双击结束 和长按开始状态
    if (([[recognizer class] isSubclassOfClass:[UILongPressGestureRecognizer class]] && recognizer.state == UIGestureRecognizerStateBegan) || ([[recognizer class] isSubclassOfClass:[UITapGestureRecognizer class]] && recognizer.state == UIGestureRecognizerStateEnded))
    {
        self.selectString = rtlabel.visibleText;
        [self handleMoreCell:nil];
    }
}

- (void)B3_CellReplyBtnTapped:(B3_PostTableView_Cell *)object
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    }

    self.friendpost = object.cellpost;
    if (self.friendpost) {
        self.reply_model.pid = self.friendpost.pid.length?self.friendpost.pid:self.postmodel.maintopic.pid;
    }
    B3_PostReplyViewController *ctr=[[B3_PostReplyViewController alloc] init];
    ctr.fid = self.fid;
    ctr.tid = self.tid;
    ctr.pid = self.friendpost.pid;
    ctr.friendpost = self.friendpost;
    ctr.title = [NSString stringWithFormat:@"回复%@",self.friendpost.authorname];
    [self.navigationController pushViewController:ctr animated:YES];
}

//赞楼主
/*
- (void)B3_HeadCellSupportButtonTap:(B3_PostTableView_HeadCell *)obj
{
    NSString *username = [UserModel sharedInstance].session.username;
    if (!username) {
        [self showAlertView];
        return;
    } else {
        self.supportModel = [SupportModel modelWithObserver:self];
        self.supportModel.tid = self.tid;
        self.supportModel.pid = obj.celltopic.pid;
        self.supportModel.type = @"1";
    }
//    isHeader = YES;

    [self.supportModel firstPage];
}
 */

- (void)B3_CellHeaderViewTapped:(B3_PostTableView_Cell *)object
{
    [self tableView:self.tableViewList didSelectRowAtIndexPath:nil];
}

- (void)B3_CellDidFinishLoad:(B3_PostTableView_Cell *)cell andheight:(float)height
{
    NSNumber *nbheight=[_cellsHeightDic objectForKey:cell.cellIndex];
    if (nbheight.floatValue != height)
    {
        [_cellsHeightDic setValue:[NSNumber numberWithFloat:height] forKey:cell.cellIndex];
        [self.tableViewList reloadData];

        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:(cell.cellIndex.intValue +1) inSection:0];
        NSArray *array = [NSArray arrayWithObject:indexpath];
        [self.tableViewList reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)B3_CellShowBigImgview:(NSString *)imgurl cell:(B3_PostTableView_Cell *)cell imageview:(BeeUIImageView *)ImageView
{
    currentindexPath = cell.cellIndex;
    [self showPreviewsBigImgview:imgurl imageView:ImageView  mainTopic:NO];
}

//点赞
- (void)B3_Cell:(B3_PostTableView_Cell *)cell supportbtn:(id)sender support:(BOOL)support
{
    /*
    post *post = self.postmodel.shots[cell.cellIndex.integerValue +1];
    post.support = @(post.support.integerValue);
    post.status = @0;
     */
    NSUInteger section = 0;
    NSUInteger row =cell.cellIndex.integerValue ;
    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self supportAPIstart:cell.cellpost.pid type:@"2"];
}

- (void)B3_CellProfileBtnTapped:(B3_PostTableView_Cell *)object
{
    D1_FriendsInfoViewController *ctr=[[D1_FriendsInfoViewController alloc] init];
    ctr.uid=object.cellpost.authorid;
    [self.navigationController pushViewController:ctr animated:YES];

}

#pragma mark - B3_Post_IWantApplyDelegate

- (void)B3_Post_IWantApply:(B3_Post_IWantApply *)view MaskViewDidTaped:(id)object
{
    [self.applyActivityView hide];
    [self addObserver];
}

- (void)B3_Post_IWantApply:(B3_Post_IWantApply *)view ConfirmButtonTaped:(id)object
{
    [self.applyActivityView hide];
    [self addObserver];
//    [self presentMessageTips:@"确认参加活动啦"];
    _dealactivityModel = [self dealactivityModel];
//    self.applyContent
    [self applyActivity];
}

#pragma mark - D2_ChatInputViewDelegate

//回复点击
- (void)D2_ChatInputdShouldSendMessage:(UITextView *)textField
{
    textField.text=textField.text.trim;
    UITextView * replayField = textField;

    if (replayField.text.length == 0) {
        [replayField resignFirstResponder];
        return;
    }

    if ([NSString unicodeLengthOfString:replayField.text]<10) {
        [self presentMessageTips:@"回复不得小于10个字"];
        [replayField resignFirstResponder];
        return;
    }

    long indexTimer = [DZ_Timer sharedInstance].replycount;

    if (indexTimer >0 ) {
        [self presentMessageTips:[NSString stringWithFormat:@"%lds 后可以回复", indexTimer]];
        return;
    }
    if ([self.articleType isEqualToNumber:@1]) {
        self.reply_model = [replyModel modelWithObserver:self];
        self.reply_model.tid = self.postmodel.maintopic.tid;
        self.reply_model.fid = self.postmodel.maintopic.fid;
        self.reply_model.authorid = [[UserModel sharedInstance] session].uid; //@"1";
        self.reply_model.pid  = @"";

        //此处回复只针对楼主
        self.friendpost = nil;
        if (self.friendpost) {
            self.reply_model.pid = self.friendpost.pid.length?self.friendpost.pid:self.postmodel.maintopic.pid;
            //        replayField.placeholder = [NSString stringWithFormat:@"回复%@...", self.friendpost.authorname];
        }

        NSMutableArray *contentTextAry= [D2_ChatInputView spliteFacialandText:replayField.text];
        //compants
        self.reply_model.contents=contentTextAry;
        [self.reply_model firstPage];
        [replayField resignFirstResponder];
        [self presentLoadingTips:@"回复中..."];
        //    return YES;
    } else {
        self.articleReplyModel = [ArticleReplyModel modelWithObserver:self];
        self.articleReplyModel.aid = self.tid;
        self.articleReplyModel.uid = [[UserModel sharedInstance] session].uid;
        self.articleReplyModel.ip = [self getIPAddress];
        self.articleReplyModel.message = replayField.text;

        [self.articleReplyModel firstPage];
        [replayField resignFirstResponder];
        [self presentLoadingTips:@"回复中..."];
    }
}

//输入框
- (void)D2_ChatInputView:(D2_ChatInputView *)view textView:(UITextView *)textView ShouldBeginEditing:(BOOL)canedit
{
    if (!canedit) {
        [bee.ui.appBoard showLogin];
    } else {
        [sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark - MaskViewDelegate

- (void)MaskViewDidTaped:(id)object
{
//    [replayField resignFirstResponder];
    [replyArea resignFirstReponder];
}

#pragma mark -

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//    [timer invalidate];
    [self removeObserver];
    [maskview hiddenMask];
    [self.postmodel removeObserver:self];
    [self.usermodel removeObserver:self];
    [self.collectModel removeObserver:self];
    [self.delcollectionModel removeObserver:self];

    //移除高度设置
    [PFTableViewCell removeAllHeightSettings];
//    PFTableViewCellReload = NO;
}

@end
