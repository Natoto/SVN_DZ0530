//
//  A0_HomePage2_iphone.m
//  DZ
//
//  Created by PFei_He on 14-8-25.
//
//

#import "A0_HomePage2_iphone.h"
#import "B3_PostViewController.h"
#import "B2_TopicTableViewCell.h"
#import "AppBoard_iPhone.h"
#import "rmbdz.h"
#import "Bee_UIImageView.h"
#import "hometopicslide.h"
#import "B3_PostViewController.h"

@interface A0_HomePage2_iphone ()

@end

@implementation A0_HomePage2_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - BeeFramework Methods

ON_SIGNAL2( BeeUIBoard, signal )
{
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
//        self.tileArray = [[NSMutableArray alloc] initWithCapacity:0];
        UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
        myBarButtonItem.title = __TEXT(@"homepage");
        self.navigationItem.backBarButtonItem = myBarButtonItem;
        self.navigationBarShown=YES;

        /*获得工程名字
         NSString *title= [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];*/
        NSString * title = [DZ_SystemSetting sharedInstance].appname;
        self.navigationBarTitle=title;
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
        
    }
}

ON_SIGNAL3(HomeTopicSlideModel, RELOADED, signal)
{
    [self loadData];
}

ON_SIGNAL3(HomeTopicSlideModel, FAILED, signal)
{
//    [self loadData];
}

ON_LOAD_DATAS(signal)
{
    [self.slideModel loadCache];
}

#pragma mark - Views Management

- (void)viewDidLoad
{
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_6_1
#else
    //取消全屏效果
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif

    self.slideModel = [HomeTopicSlideModel modelWithObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //加载失败时重新加载
    if (NO == self.slideModel.loaded) {

        [self.slideModel loadSlide];
    }
    [bee.ui.appBoard showTabbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [carouselView remove];
}

//自动滚动视图
- (void)loadCarouselViewWithImageArray:(NSArray *)imageArray subjectArray:(NSArray *)subjectArray
{
    //视图数组
    self.viewsArray = [@[] mutableCopy];

    //遍历视图
    for (int i = 0; i < imageArray.count; i++) {
        BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, 200)];
        [imageView setUrl:imageArray[i]];
        [self.viewsArray addObject:imageView];
    }

    if (!carouselView) {
        carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, 170) animationDuration:2.5 delegate:nil];
        carouselView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        [self.view addSubview:carouselView];
    }

    @weakify_self

    //视图数量
    [carouselView numberOfPagesUsingBlock:^NSInteger{
        @strongify_self
        return self.viewsArray.count;
    }];

    //添加视图
    [carouselView setupContentViewUsingBlock:^UIView *(NSInteger index) {
        @strongify_self
        return self.viewsArray[index];
    }];

    //设置文本
    [carouselView resetTextLabelUsingBlock:^(UILabel *textLabel, NSInteger index) {
        textLabel.text = subjectArray[index];
    }];

    //点击事件
    [carouselView didSelectViewUsingBlock:^(NSInteger index) {
        @strongify_self
        B3_PostViewController *board=[[B3_PostViewController alloc] init];
        board.tid = tidArr[index];
        [self.navigationController pushViewController:board animated:YES];
    }];

    [self loadTabView];
}

//滑动标签视图
- (void)loadTabView
{
    if (!tabView) {
        tabView = [[PFTabView alloc] initWithFrame:CGRectMake(0, 175, self.viewBound.size.width, self.view.frame.size.height - 64 - 49 - 30 - 18)];

        //视图数目
        @weakify_self
        [tabView numberOfItemUsingBlock:^NSInteger{
            @strongify_self
            return [self viewControllers].count;
        }];

        //设置标签尺寸
        [tabView textSizeOfItemUsingBlock:^CGSize{
            @strongify_self
            return CGSizeMake((self.view.frame.size.width - 40) / 4, 30.0f);
        }];

        //设置视图
        [tabView setupViewControllerUsingBlock:^UIViewController *(NSInteger index) {
            @strongify_self
//            if (index == 3) {
//                return self.recommend;
//            } else if (index == 0) {
//                return self.newly;
//            } else if (index == 1) {
//                return self.hot;
//            } else if (index == 2) {
//                return self.reply;
//            } else {
//                return nil;
//            }
            return [self viewControllers][index];
        }];

        //重设标签按钮
        [tabView resetItemButtonUsingBlock:^(UIButton *button, NSInteger index) {
            [button setTitleColor:[PFTabView colorFromHexRGB:@"868686"] forState:UIControlStateNormal];
            [button setTitleColor:[DZ_SystemSetting sharedInstance].navigationBarColor forState:UIControlStateSelected];
        }];

        //点击事件
        [tabView didSelectItemUsingBlock:^(NSInteger index) {
            @strongify_self
            if (index == 0) {
                A0_TopicViewController *recommend = nil;
                recommend =  self.recommend;
                [recommend viewDidCurrentView];
                BeeLog(@"123");
            } else if (index == 1) {
                A0_TopicViewController *newly = nil;
                newly = self.newly;
                [newly viewDidCurrentView];
                BeeLog(@"234");
            } else if (index == 2) {
                A0_TopicViewController *hot = nil;
                hot = self.hot;
                [hot viewDidCurrentView];
                BeeLog(@"345");
            } else if (index == 3) {
                A0_TopicViewController *reply = nil;
                reply = self.reply;
                [reply viewDidCurrentView];
                BeeLog(@"456");
            }
        }];
        [self.view addSubview:tabView];
    }
}

//视图控制器
- (NSArray *)viewControllers
{
    self.recommend = [[A0_TopicViewController alloc] init];
    self.recommend.topic_type = @"1";
    self.recommend.title = @"推荐";
    [self.recommend A0_TopicViewControllTableViewCellDidSelectUsingBlock:^(NSString *tid) {
        [self pushWithTid:tid];
    }];

    self.newly = [[A0_TopicViewController alloc] init];
    self.newly.topic_type = @"2";
    self.newly.title = @"最新";
    [self.newly A0_TopicViewControllTableViewCellDidSelectUsingBlock:^(NSString *tid) {
        [self pushWithTid:tid];
    }];

    self.hot = [[A0_TopicViewController alloc] init];
    self.hot.topic_type = @"3";
    self.hot.title = @"热帖";
    [self.hot A0_TopicViewControllTableViewCellDidSelectUsingBlock:^(NSString *tid) {
        [self pushWithTid:tid];
    }];

    self.reply = [[A0_TopicViewController alloc] init];
    self.reply.topic_type = @"4";
    self.reply.title = @"回复";
    [self.reply A0_TopicViewControllTableViewCellDidSelectUsingBlock:^(NSString *tid) {
        [self pushWithTid:tid];
    }];

    return @[self.newly, self.hot, self.reply, self.recommend];
}

#pragma mark - Data Management

- (void)loadData
{
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSMutableArray *subArr = [[NSMutableArray alloc] init];
    tidArr = [[NSMutableArray alloc] init];
    [imgArr removeAllObjects];
    [subArr removeAllObjects];

    for (int i = 0; i < self.slideModel.shots.slide.count; i++) {
        slide *aslide = self.slideModel.shots.slide[i];
        [imgArr addObject:aslide.img];
        [subArr addObject:aslide.subject];
        [tidArr addObject:aslide.tid];
    }
    [self loadCarouselViewWithImageArray:imgArr subjectArray:subArr];
}

#pragma mark - Events Management

- (void)pushWithTid:(NSString *)tid
{
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid = tid;
    [self.navigationController pushViewController:board animated:YES];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
