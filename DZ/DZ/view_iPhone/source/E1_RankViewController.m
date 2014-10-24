//
//  E1_RankViewController.m
//  DZ
//
//  Created by nonato on 14-10-16.
//
//
#import "E2_SubRankViewController.h"
#import "E1_RankViewController.h"
#import "AppBoard_iPhone.h"
#import "B3_PostViewController.h"
@interface E1_RankViewController ()<E2_SubRankViewControllerDelegate>
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) UITableView *list;
@end 

@implementation E1_RankViewController

#pragma mark -



//ON_RIGHT_BUTTON_TOUCHED(signal)
//{
    //#warning 需要添加主题分类筛选
//    [self.topicmenuView show];
//}
  

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
    self.vc3 = [[E2_SubRankViewController alloc] init];
    self.vc3.tptType= TOPTEN_SUPPORTMOST;
    self.vc3.topicvcdelegate=self;
    self.vc3.forum_fid=self.forum_fid;
    self.vc3.title = @"支持最多";
    
    
    self.vc1 = [[E2_SubRankViewController alloc] init];
    self.vc1.tptType = TOPTEN_VIEWMOST;
    self.vc1.forum_fid = self.forum_fid;
    self.vc1.title = @"查看最多";
    self.vc1.topicvcdelegate = self;
    
    self.vc2 =[[E2_SubRankViewController alloc] init];
    self.vc2.tptType= TOPTEN_REPLYMOST;
    self.vc2.forum_fid=self.forum_fid;
    self.vc2.title = @"回复最多";
    self.vc2.topicvcdelegate=self;
    
    self.slideSwitchView.rigthSideButton = nil;
    [self.slideSwitchView buildUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSVscrollview];
    self.navigationBarShown=YES;
    self.view.backgroundColor=[UIColor whiteColor];
}


- (void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}


#pragma mark -
#pragma mark 接受从子模块传过来的点击事件
-(void)E2_SubRankViewController:(E2_SubRankViewController *)controller topicViewControllerCellSelectedWithTid:(NSString *)tid
{
    NSArray *array=[tid componentsSeparatedByString:@":"];
    if (array.count) {
        B3_PostViewController *board = [[B3_PostViewController alloc] init];
        board.tid = [array objectAtIndex:1];
        board.fid = [array objectAtIndex:0];
        [self.navigationController pushViewController:board animated:YES];
    }
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 3;
}


-(CGSize)slideTabTextSize:(QCSlideSwitchView *)view
{
    return CGSizeMake((self.view.frame.size.width-20)/3, 44.);
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        self.currentIndex = self.vc1.tptType;
        return self.vc1;
    } else if (number == 1) {
        self.currentIndex = self.vc2.tptType;
        return self.vc2;
    } else if (number == 2) {
        self.currentIndex = self.vc3.tptType;
        return self.vc3;
    }
    else {
        return nil;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
 
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number == 0) {
        E2_SubRankViewController *vc = nil;
        vc = self.vc1;
        self.currentIndex = vc.tptType;
        [vc viewDidCurrentView];
    } else if (number == 1) {
        E2_SubRankViewController *vc = nil;
        vc = self.vc2;
        self.currentIndex = vc.tptType;
        [vc viewDidCurrentView];
    } else if (number == 2) {
        E2_SubRankViewController *vc = nil;
        vc = self.vc3;
        self.currentIndex = vc.tptType;
        [vc viewDidCurrentView];
    }
}


@end
