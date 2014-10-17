//
//  B1_ATopicViewController.m
//  DZ
//
//  Created by Nonato on 14-4-21.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "ToolsFunc.h"
#import "B1_ATopicViewController.h"
#import "AppBoard_iPhone.h"
#import "TopiclistModel.h"
#import "B2_SearchViewController.h"
#import "B1_TopicMenuView.h"
#import "ThreadtypeModel.h"

@interface B1_ATopicViewController () <B2_TopicViewControllerDelegate>
@property (nonatomic,retain) B1_TopicMenuView * topicmenuView;
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) UITableView *list;
@property (nonatomic,retain) ThreadtypeModel * threadModel;
@end

@implementation B1_ATopicViewController
DEF_NOTIFICATION(catalogselect)
#pragma mark -


#pragma mark - BeeFramework Macro

-(B1_TopicMenuView *)topicmenuView
{
    if (!_topicmenuView) {
        _topicmenuView = [[B1_TopicMenuView alloc] initWithFrame:CGRectZero];
    }
    return _topicmenuView;
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
//#warning 需要添加主题分类筛选
    self.topicmenuView.items =self.threadtypesDic;
    //[NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"全部",@"0",@"吐槽",@"1",@"潜水",@"2",@"冒泡", nil];
    [self.topicmenuView show];
//    BeeLog(@"搜索------");
//    B2_SearchViewController *searchctr=[[B2_SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchctr animated:YES];
}
#pragma mark - 主题分类筛选
ON_NOTIFICATION3(B1_TopicMenuView, selectitem, notify)
{
    int index = 0;
    self.currentIndex = index;
    [self.slideSwitchView selectItemView:index];
    [self postNotification:self.catalogselect withObject:notify.object];
}

ON_NOTIFICATION3(B2_TopicViewController2, skiptosub, notify)
{
    if (_haveSubForums) {
        self.currentIndex = TOPIC_TYPE_SUBTOPIC;
        [self.slideSwitchView selectItemView:TOPIC_TYPE_SUBTOPIC];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark  - 设置主题
-(void)setThreadtypes:(NSArray *)threadtypes
{
    if (threadtypes.count) {
        if (!_threadtypesDic) {
            _threadtypesDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        for (int index = 0; index < threadtypes.count; index ++) {
            threadtype  *athreaddic=[threadtypes objectAtIndex:index];
            NSString *count = athreaddic.count; //[athreaddic valueForKey:@"count"];
            NSString *value = athreaddic.name; //[athreaddic valueForKey:@"value"];
            NSString *key = [NSString stringWithFormat:@"%@",athreaddic.id];//[athreaddic valueForKey:@"key"];
            value = [value stringByAppendingFormat:@"(%@)",count];
            [_threadtypesDic setObject:key forKey:value];
        }
        [_threadtypesDic setObject:@"-1" forKey:@"全部"];
        if (!_threadtypes) {
            _threadtypes = [NSMutableArray arrayWithCapacity:0];
            [_threadtypes addUniqueObject:@"全部" compare:^NSComparisonResult(id left, id right) {
             return [((NSString *)left) compare:((NSString *)right)];
            }];
            _threadtypes =(NSMutableArray *)[_threadtypes arrayByAddingObjectsFromArray:_threadtypesDic.allKeys];
        }
        [BeeUINavigationBar setButtonSize:CGSizeMake(30, 30)];
        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage bundleImageNamed:@"fenglei"]];
    }
}

-(void)initSVscrollview
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    self.title =self.forum_name;
    _slideSwitchView=[[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, self.bounds.size.height)];
    _slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:_slideSwitchView];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
     UIColor *color = [DZ_SystemSetting sharedInstance].navigationBarColor;
    self.slideSwitchView.tabItemSelectedColor = color;//[QCSlideSwitchView colorFromHexRGB:@"139AF2"];
    UIImage *image = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
   
     self.slideSwitchView.shadowImage = [image imageWithTintColor:color];
    self.vc3 = [[B2_TopicViewController2 alloc] init];
    self.vc3.topic_type=TOPIC_TYPESTR(TOPIC_TYPE_DEGIST);// @"1";
    self.vc3.selfIndex = TOPIC_TYPE_DEGIST;
    self.vc3.superdelegate = self;
    self.vc3.topicvcdelegate=self;
    self.vc3.forum_fid=self.forum_fid;
    self.vc3.title = @"精华";
    
    self.vc4 = [[B2_TopicViewController2 alloc] init];
    self.vc4.topic_type=TOPIC_TYPESTR(TOPIC_TYPE_TOP);//@"2";
    self.vc4.selfIndex = TOPIC_TYPE_TOP;
    self.vc4.superdelegate = self;
    self.vc4.topicvcdelegate=self;
    self.vc4.forum_fid=self.forum_fid;
    self.vc4.title = @"置顶";
    
    self.vc5 = [[B2_QCListViewController alloc] init];
    self.vc5.title = @"子版块";
    self.vc5.delegate=self;
    self.vc5.childAry=self.childAry;
    
    self.vc1 = [[B2_TopicViewController2 alloc] init];
    self.vc1.topic_type = TOPIC_TYPESTR(TOPIC_TYPE_ALL); //@"0";
    self.vc1.selfIndex = TOPIC_TYPE_ALL;
    self.vc1.superdelegate = self;
    self.vc1.forum_fid = self.forum_fid;
    self.vc1.title = @"全部";
    self.vc1.topicvcdelegate = self;
    
    self.vc2 =[[B2_TopicViewController2 alloc] init];
    self.vc2.topic_type= TOPIC_TYPESTR(TOPIC_TYPE_HOT);//@"3";
    self.vc2.selfIndex = TOPIC_TYPE_HOT;
    self.vc2.superdelegate = self;
    self.vc2.forum_fid=self.forum_fid;
    self.vc2.title = @"热帖";
    self.vc2.topicvcdelegate=self;
    
//    self.vc6 = [[QCListViewController alloc] init];
//    self.vc6.title = @"清幽Saup";
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    self.slideSwitchView.rigthSideButton = rightSideButton;
    [self.slideSwitchView buildUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSVscrollview];
    self.navigationBarShown=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    NSString *notiid =[B1_TopicMenuView sharedInstance].selectitem;// @"notify.B1_TopicMenuView.selectitem";
    [self observeNotification:notiid];
    [self observeNotification:@"notify.B2_TopicViewController2.skiptosub"];
    
}

ON_SIGNAL3(ThreadtypeModel, RELOADED, signal)
{
    [self loadthreadtypes];
}
ON_SIGNAL3(ThreadtypeModel, FAILED, signal)
{
    [self loadthreadtypes];
}
-(void)loadthreadtypes
{
    if (self.threadModel.shots.count) {
        [self setThreadtypes:self.threadModel.shots];
       BeeLog(@"%@",self.threadModel.shots);
    }
}
-(void)setForum_fid:(NSString *)forum_fid
{
    _forum_fid = forum_fid;
    if (!_threadModel) {
        self.threadModel = [ThreadtypeModel modelWithObserver:self];
    }
    self.threadModel.fid = _forum_fid;
    [self.threadModel loadCache];
    [self.threadModel firstPage];
}
- (void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}

#pragma mark - 子版块
- (void)QCListViewControllerDelegateCellSelectedWithFid:(NSString *)fid name:(NSString *)name
{
    B1_ATopicViewController *board=[[B1_ATopicViewController alloc] init];
    board.forum_fid = fid;
    board.forum_name = name;
    [self.navigationController pushViewController:board animated:YES];
}

#pragma mark -
#pragma mark 接受从子模块传过来的点击事件
- (void)topicViewControllerCellSelectedWithTid:(NSString *)tid
{
    NSArray *array=[tid componentsSeparatedByString:@":"];
    if (array.count) {
        B3_PostViewController *board = [[B3_PostViewController alloc] init];
        board.tid = [array objectAtIndex:1];
        board.fid = [array objectAtIndex:0];
        [self.navigationController pushViewController:board animated:YES];
    }
}

- (void)setHaveSubForums:(BOOL)haveSubForums
{
    _haveSubForums = haveSubForums;
    [self.slideSwitchView  layoutSubviews];
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return _haveSubForums ? 5 : 4;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        self.currentIndex = self.vc1.selfIndex;
        return self.vc1;
    } else if (number == 1) {
        self.currentIndex = self.vc2.selfIndex;
        return self.vc2;
    } else if (number == 2) {
        self.currentIndex = self.vc3.selfIndex;
        return self.vc3;
    } else if (number == 3) {
        self.currentIndex = self.vc4.selfIndex;
         self.slideSwitchView.rigthSideButton.hidden=YES;
        return self.vc4;
    } else if (number == 4) {
//        self.currentIndex = self.vc5.selfIndex;
       self.slideSwitchView.rigthSideButton.hidden=NO;
        return self.vc5;
    }
    else {
        return nil;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    //[self.navigationController popViewControllerAnimated:YES];
//    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number == 0) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc1;
        self.currentIndex = vc.selfIndex;
        [vc viewDidCurrentView];
    } else if (number == 1) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc2;
        self.currentIndex = vc.selfIndex;
        [vc viewDidCurrentView];
    } else if (number == 2) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc3;
        self.currentIndex = vc.selfIndex;
        [vc viewDidCurrentView];
    } else if (number == 3) {
        B2_TopicViewController2 *vc = nil;
        vc = self.vc4;
        self.currentIndex = vc.selfIndex;
        [vc viewDidCurrentView];
    } else if (number == 4) {
        B2_QCListViewController *vc=nil;
        vc = self.vc5;
        vc.childAry=self.childAry;
    }
}

@end
