//
//  D1_Msg_InstationViewController.m
//  DZ
//
//  Created by Nonato on 14-6-5.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "QCSlideSwitchView.h"
#import "D1_Msg_InstationViewController.h" 
#import "D1_Msg_StrangerTableViewCell.h"
#import "ToolsFunc.h"
#import "bee.h"
#import "RCLabel.h"
#import "AppBoard_iPhone.h"
#import "D3_MSG_IgnoreView.h"
#import "D1_FriendsTableViewCell.h"
#import "friends.h"
#import "D1_FriendsInfoViewController.h"
#import "RemindModel.h"
#import "D1_Msg_Inter_ActivityCell.h"
#import "D1_Msg_InterCheckBox.h"
#import "ToolsFunc.h"
#import "ActivityapplylistModel.h"
@interface D1_Msg_InstationViewController ()<D1_FriendsTableViewCellDelegate,D1_Msg_Inter_ActivityCellDelegate,D1_Msg_InterCheckBoxDelegate>
@property(nonatomic,assign)BOOL ignoreMessage;
@property(nonatomic,strong)D3_MSG_IgnoreView * headView;
@property(nonatomic,strong)RemindModel       * remindmodel;
@property(nonatomic,strong)NSMutableDictionary * msg_instationDic;
@property(nonatomic,strong)D1_Msg_InterCheckBox *CheckBox;
@property(nonatomic,strong)ActivityapplylistModel *actapplylistModel;
@end

@implementation D1_Msg_InstationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(Allpm_StrangerModel, RELOADED, signal)
{
//    BeeLog(@"%@",self.allpmmodel.systemms);
    [self.allpmmodel clearNewMessageCache];
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(Allpm_StrangerModel, FAILED, signal)
{
    [self FinishedLoadData];
}

- (void)viewDidCurrentView
{
   
}
-(void)dealloc
{
    [self.allpmmodel removeObserver:self];
    [self.remindmodel removeObserver:self];
}
-(void)viewWillLayoutSubviews//重新layout界面 针对越狱手机
{
//    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
//    [self relayoutSubviews];
}
- (void)viewDidLoad
{
    self.noFooterView=YES;
    [super viewDidLoad];
    [self reframeTableView:TABLEVIEW_WITHSLIDSWITCH]; 
    [self relayoutSubviews];
    self.title=@"站内信";
//    self.view.backgroundColor=[UIColor blueColor];
    self.msg_instationDic =[[NSMutableDictionary alloc] initWithCapacity:0];
    self.ignoreMessage=[DZ_SystemSetting readIgnoreSetting:MSG_ZHANNEI];
    self.allpmmodel =[Allpm_StrangerModel modelWithObserver:self];
    self.allpmmodel.uid=[UserModel sharedInstance].session.uid;
    self.remindmodel = [RemindModel sharedInstance];
    self.actapplylistModel = [ActivityapplylistModel modelWithObserver:self];
    
    if (!self.ignoreMessage)
    {
        [self.allpmmodel loadCache];
        [self.allpmmodel loadNewMessageCashe];
        self.nowdate=nil;
        if (!self.allpmmodel.loaded) {
            [self.allpmmodel firstPage];
        }
       BeeLog(@"加载为当前视图 = %@",self.title);
    }
    _headView = [[D3_MSG_IgnoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) , 40) sel:@selector(ignoreMessages) target:self];
    _headView.recievemessage = @"需要接受站内信吗？";
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return [D3_MSG_IgnoreView heightOfView];
    }
    else
    {
        return 0;
    }

}
-(IBAction)clearmessage:(id)sender
{
    [self.allpmmodel clearCache];
    [self.allpmmodel firstPage];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    return [self shieldView:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) , 50)];
    if (section == 0) {
        return _headView;
    }
    else
        return nil;
}


-(void)ignoreMessages
{
    if (!_headView.ignoreMessage) {
        _headView.ignoreMessage = YES;
        [_headView.ignoreButton setTitle:@"点此开启" forState:UIControlStateNormal];
        _headView.ignoreLabel.text=@"需要接受站内信吗？";
        [self.allpmmodel.strangermsDic removeAllObjects];
        [self.remindmodel.activityautomatic removeAllObjects];
    }
    else
    {
        _headView.ignoreMessage=NO;
        [_headView.ignoreButton setTitle:@"点此屏蔽" forState:UIControlStateNormal];
         _headView.ignoreLabel.text=@"不希望收到此消息?";
        [self.allpmmodel loadCache];
        [self.allpmmodel firstPage];
        [self.remindmodel loadCache];
    }
    self.ignoreMessage = _headView.ignoreMessage;
    [self.tableViewList reloadData];
    [DZ_SystemSetting saveIgnoreSetting:MSG_ZHANNEI ignore:self.ignoreMessage];

}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0 ) {
        NSArray *array = self.allpmmodel.strangermsDic.allKeys;
        int numberofrows = array.count;
        return numberofrows;
    }
    else if (section ==1)
    {
        return self.remindmodel.activityautomatic.count;
    }
    else
    {
        return self.remindmodel.threadautomatic.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    if (indexPath.section == 0) {
        NSString *ListViewCellId = @"ListViewCellId2";
        D1_FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
        if (cell == nil) {
            cell = [[D1_FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
            cell.delegate = self;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.havenewmessage = NO;
            [self addCellSelectedColor:cell];
        }
        cell.indexPath = indexPath;
        strangerms *stranger=[self astrangersms:self.allpmmodel.strangermsDic.allKeys index:indexPath.row];
        friends *frd =[[friends alloc] init];
        frd.avatar = stranger.avatar;
        frd.username = stranger.author;
        /*0812 此处有更新？*/
        frd.fuid = stranger.authorid;
        cell.message.text = stranger.message;
        cell.message.textColor = [UIColor grayColor];
        [cell setcellData:frd];
        NSArray *newmsgary=[self.allpmmodel.newstrangermsDic objectForKey:frd.fuid];
        if (newmsgary.count) {
            strangerms *astranger = [newmsgary lastObject];
            cell.message.text = astranger.message;
            cell.message.textColor = CLR_NEWMESSAGE; //[UIColor colorWithRed:221./255. green:153./255. blue:85./255 alpha:1];//[UIColor redColor];
        }
        return  cell;
    }
   else if(indexPath.section == 1)
   {
       NSString *ListViewCellId = @"ListViewCellId3";
       D1_Msg_Inter_ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
       if (cell == nil) {
           cell = [[D1_Msg_Inter_ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
           cell.delegate = self;
       }
       cell.activityAutomatic = [self.remindmodel.activityautomatic objectAtIndex:indexPath.row];
       return cell;
   }
   else
    {
        NSString *ListViewCellId = @"ListViewCellId4";
        D1_Msg_Inter_ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
        if (cell == nil) {
            cell = [[D1_Msg_Inter_ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
            cell.delegate = self;
        }
        cell.activityAutomatic = [self.remindmodel.threadautomatic objectAtIndex:indexPath.row];
        return cell;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 ) {
        return [D1_FriendsTableViewCell heightOfFriendsCell];
    }
    else if (indexPath.section ==1)
    {
        automatic *atomac=[self.remindmodel.activityautomatic objectAtIndex:indexPath.row];
        return [D1_Msg_Inter_ActivityCell heightOfCell:atomac];
    }
    else
    {
        automatic *atomac=[self.remindmodel.threadautomatic objectAtIndex:indexPath.row];
        return [D1_Msg_Inter_ActivityCell heightOfCell:atomac];
    }
}

-(strangerms *)astrangersms:(NSArray *)array index:(NSInteger )index
{
//    int numberofrows = 0;
    strangerms *ams= nil; //[[strangerms alloc] init];
    NSArray *array2 = [self.allpmmodel.strangermsDic objectForKey:[array objectAtIndex:index]]; //[array objectAtIndex:index];
    if (array2.count) {
        ams = [array2 lastObject];
    }
    /*for (int i = 0; i < array.count; i ++) {
        NSArray *array2 =[array objectAtIndex:i];
        for (int j = 0; j < array2.count; j++) {
            if (index == numberofrows) {
                ams = [array2 objectAtIndex:j];
                return ams;
            }
            numberofrows ++;
        }
    }*/
    return ams;
}

/*
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    strangerms *apublic=[self astrangersms:self.allpmmodel.strangerms index:indexPath.row];
    return [D1_Msg_StrangerTableViewCell heightOfCell:apublic.message];
  
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Msg_InstationViewController:cellSelectedWithStrangerms:)])
        {
            strangerms *apublic= [self astrangersms:self.allpmmodel.strangermsDic.allKeys index:indexPath.row];
            [self.delegate D1_Msg_InstationViewController:self cellSelectedWithStrangerms:apublic];
        }
    }
}
#pragma mark - D1_Msg_Inter_ActivityCell delegate
-(void)D1_Msg_Inter_ActivityCell:(D1_Msg_Inter_ActivityCell *)cell checkBtnTap:(id)sender
{
    if (!_CheckBox) {
       D1_Msg_InterCheckBox *popup = [[D1_Msg_InterCheckBox alloc] initWithFrame:self.frame];
        _CheckBox = popup;
        _CheckBox.ppboxdelegate = self;
        _CheckBox.title = @"审核";
    }
    [_CheckBox show];
    automatic *activityAutomatic = cell.activityAutomatic;
    _CheckBox.activityContent = activityAutomatic;
    NSArray * keys =[NSArray arrayWithObjects:@"申请人",@"申请时间",@"申请状态",@"留言",@"您的附言", nil];
    NSString * person= [NSString stringWithFormat:@"%@",activityAutomatic.author];
    NSString * time = [NSString stringWithFormat:@"%@",activityAutomatic.dateline];
    time = [ToolsFunc datefromstring2:time];
    NSString * state = [NSString stringWithFormat:@"%@",@"已提交申请"];//activityAutomatic.type
    NSString * message = [NSString stringWithFormat:@"%@",activityAutomatic.subject];
    NSArray * values = [NSArray arrayWithObjects:person,time,state,message,@"已通过审核，欢迎您的加入!", nil];
    
    NSMutableDictionary *diction=[[NSMutableDictionary  alloc] initWithCapacity:0];
    [diction setObject:values[0] forKey:keys[0]];
    [diction setObject:values[1] forKey:keys[1]];
    [diction setObject:values[2] forKey:keys[2]];
    [diction setObject:values[3] forKey:keys[3]];
    [diction setObject:values[4] forKey:keys[4]];
    [_CheckBox loadDatas:diction];
    
}
#pragma mark - D1_Msg_InterCheckBox  delegate
-(void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view MaskViewDidTaped:(id)object
{
    [_CheckBox hide];
}

-(void)run_actapplylistModel:(NSString *)type D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view
{
    [_CheckBox hide];
    self.actapplylistModel.type = type;
    self.actapplylistModel.uid = [UserModel sharedInstance].session.uid;
    self.actapplylistModel.applyid = view.activityContent.applyid;
    self.actapplylistModel.authorid = view.activityContent.authorid;
    self.actapplylistModel.subject = view.activityContent.subject;
    self.actapplylistModel.tid = view.activityContent.tid;
    self.actapplylistModel.reason = [view.iWantapplyDic valueForKey:@"您的附言"];
    [self.actapplylistModel firstPage];
    [self presentLoadingTips:@"操作中..."];
}

ON_SIGNAL3(ActivityapplylistModel, RELOADED, signal)
{
    [self dismissTips];
    _CheckBox.activityContent.check = @"0";
    [self presentMessageTips:@"操作成功！"];
    [self.remindmodel saveCache];
    [self.tableViewList reloadData];
}


ON_SIGNAL3(ActivityapplylistModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:[NSString stringWithFormat:@"%@",self.actapplylistModel.shots.emsg]];
}
-(void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view agreeButtonTap:(id)object
{
    [self run_actapplylistModel:TYPE_AGREE D1_Msg_InterCheckBox:view];
}
-(void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view needCompleteButtonTap:(id)object
{
     [self run_actapplylistModel:TYPE_NEEDCOMPLETE D1_Msg_InterCheckBox:view];
}

-(void)D1_Msg_InterCheckBox:(D1_Msg_InterCheckBox *)view refuseButtonTap:(id)object
{
     [self run_actapplylistModel:TYPE_REFUSE D1_Msg_InterCheckBox:view];
}

#pragma mark - D1_FriendsTableViewCell delegate
-(void)D1_FriendsTableViewCell:(D1_FriendsTableViewCell *)cell avator:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D1_Msg_InstationViewController:D1_FriendsTableViewCell:avator:)]) {
        [self.delegate D1_Msg_InstationViewController:self D1_FriendsTableViewCell:cell avator:sender];
    }
}


//刷新调用的方法
-(void)refreshView
{
    if (!self.ignoreMessage)
    {
        [self.allpmmodel firstPage];
    }
    else
    {
        [self FinishedLoadData];
    }
}

//加载调用的方法
-(void)getNextPageView{
    if (self.allpmmodel.more) {
        [self removeFooterView];
        [self.allpmmodel nextPage];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:@"没有更多的了"];
    }
    [self FinishedLoadData];
}

@end
