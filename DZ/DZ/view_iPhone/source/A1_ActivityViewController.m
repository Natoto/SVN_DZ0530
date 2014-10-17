//
//  A1_ActivityViewController.m
//  DZ
//
//  Created by Nonato on 14-8-1.
//
//
#import "AppBoard_iPhone.h"
#import "UIImage+Tint.h"
#import "Bee.h"
#import "B3_PostViewController.h"
#import "DZ_SystemSetting.h"
#import "A1_ActivityViewController.h"
#import "A1_Activity_TypeViewController.h"

#define ACTV_TYPE_ALL   @"0"
#define ACTV_TYPE_DOING @"2"
#define ACTV_TYPE_DONE  @"1"

@interface A1_ActivityViewController ()<A1_Activity_TypeViewControllerDelegate>

@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) UITableView *list;

@end

@implementation A1_ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initSVscrollview
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    self.title =@"活动";
    _slideSwitchView=[[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, self.bounds.size.height)];
    _slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:_slideSwitchView];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [DZ_SystemSetting sharedInstance].navigationBarColor;
    UIImage *image = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                      stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
     
    self.slideSwitchView.shadowImage = [image imageWithTintColor:[DZ_SystemSetting sharedInstance].navigationBarColor];
    
    self.vc1 = [[A1_Activity_TypeViewController alloc] init];
    self.vc1.type = ACTV_TYPE_ALL;
    self.vc1.delegate = self;
    self.vc1.title=@"全部活动";
    
    self.vc2 = [[A1_Activity_TypeViewController alloc] init];
    self.vc2.type = ACTV_TYPE_DOING;
    self.vc2.delegate = self;
    self.vc2.title = @"当前活动";
    
    self.vc3 = [[A1_Activity_TypeViewController alloc] init];
    self.vc3.type = ACTV_TYPE_DONE;
    self.vc3.delegate = self;
    self.vc3.title = @"未开始活动";
    
    self.slideSwitchView.rigthSideButton = nil;
    [self.slideSwitchView buildUI];
    
}
-(void)dealloc
{
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initSVscrollview];
    self.navigationBarShown=YES;
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [bee.ui.appBoard hideTabbar];
}


#pragma mark - 子版块
-(void)QCListViewControllerDelegateCellSelectedWithFid:(NSString *)fid name:(NSString *)name
{ 
}

-(CGSize)slideTabTextSize:(QCSlideSwitchView *)view
{
    return CGSizeMake((self.view.frame.size.width-20)/3, 44.);
}
#pragma mark -
#pragma mark 接受从子模块传过来的点击事件
-(void)topicViewControllerCellSelectedWithTid:(NSString *)tid
{
}
-(void)setHaveSubForums:(BOOL)haveSubForums
{
}
#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 3;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    }
    else if (number == 2) {
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
        A1_Activity_TypeViewController *vc = nil;
        vc = self.vc1;
        vc.type = ACTV_TYPE_ALL ;
        [vc viewDidCurrentView];
    } else if (number == 1) {
        A1_Activity_TypeViewController *vc = nil;
        vc = self.vc2;
        vc.type = ACTV_TYPE_DOING;
        [vc viewDidCurrentView];
    }
    else if (number == 2) {
        A1_Activity_TypeViewController *vc = nil;
        vc = self.vc3;
        vc.type = ACTV_TYPE_DONE;
        [vc viewDidCurrentView];
    }
}
-(void)A1_Activity_TypeViewController:(A1_Activity_TypeViewController *)controller cellSelectedWithTid:(NSString *)tid
{
       B3_PostViewController *board=[[B3_PostViewController alloc] init];
       board.tid=tid;
      [self.navigationController pushViewController:board animated:YES];
}
//-(void)D1_Reply_MyViewController:(A1_Activity_TypeViewController *)controller cellSelectedWithTid:(NSString *)tid
//{
//    B3_PostViewController *board=[[B3_PostViewController alloc] init];
//    board.tid=tid;
//    [self.navigationController pushViewController:board animated:YES];
//}
//-(void)D1_Reply_OtherViewController:(D1_Reply_OtherViewController *)controller cellSelectedWithTid:(NSString *)tid
//{
//    B3_PostViewController *board=[[B3_PostViewController alloc] init];
//    board.tid=tid; //[array objectAtIndex:1];
//    [self.navigationController pushViewController:board animated:YES];
//}

@end
