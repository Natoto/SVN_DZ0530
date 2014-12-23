//
//  A0_HomePage3_iPhone.m
//  DZ
//
//  Created by PFei_He on 14-10-23.
//
//

#import "A0_HomePage3_iPhone.h"
#import "PFPopupBox.h"
#import "PFRadioButton.h"
#import "PFRadioButton.h"
#import "DZ_SystemSetting.h"
#import "AppBoard_iPhone.h"
#import "portal.h"
#import "portalslide.h"
#import "B3_PostViewController.h"
#import "B2_TopicTableViewCell.h"
#import "A1_PortalDetail.h"
#import "MJRefresh.h"

@interface A0_HomePage3_iPhone ()
{
    NSString *text;
}

@end

@implementation A0_HomePage3_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - BeeFramework Methods

ON_SIGNAL2(BeeUIBoard, signal)
{
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
//        self.tileArray = [[NSMutableArray alloc] initWithCapacity:0];
        UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
        myBarButtonItem.title = __TEXT(@"homepage");
        self.navigationItem.backBarButtonItem = myBarButtonItem;
        self.navigationBarShown=YES;

        /*获得工程名字
         NSString *title= [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
         */
        NSString * title = [DZ_SystemSetting sharedInstance].appname;
        self.navigationBarTitle = title;
        [self setupTabelView];
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
        
    }
}

ON_SIGNAL3(PortalSlideModel, RELOADED, signal)
{
    [self loadSlideData];
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
    [tv reloadData];
}

ON_SIGNAL3(PortalSlideModel, FAILED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
}

ON_SIGNAL3(PortalModel, RELOADED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
    [tv reloadData];
}

ON_SIGNAL3(PortalModel, FAILED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
}

ON_LOAD_DATAS(signal)
{
    [self.portalSlideModel loadCache];
    [self.portalModel loadCache];
}

#pragma mark - Views Management

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.portalModel = [PortalModel modelWithObserver:self];
    self.portalSlideModel = [PortalSlideModel modelWithObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [carouselView refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //加载失败时重新加载
    if (NO == self.portalSlideModel.loaded) {

        [self.portalSlideModel loadData];
        [self.portalModel loadData];
    }
    [bee.ui.appBoard showTabbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [carouselView stop];
}

//设置列表
- (void)setupTabelView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, self.viewBound.size.height - 44)];
    tv.dataSource = self;
    tv.delegate = self;
    tv.tableHeaderView = [self setupCarouselView];
    [self.view addSubview:tv];
    [self setExtraCellHidden:tv];

    [self setupRefresh];
}

//设置轮播图
- (UIView *)setupCarouselView
{
    //轮播图
    if (!carouselView) {
        carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, 170) animationDuration:2.5 delegate:nil];
        carouselView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        [self.view addSubview:carouselView];
    }

    return carouselView;
}

//隐藏多余的TableViewCell
- (void)setExtraCellHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tv addHeaderWithTarget:self action:@selector(refreshView)];
    [tv headerBeginRefreshing];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tv addFooterWithTarget:self action:@selector(getNextPageView)];
}

#pragma mark - Data Management

- (void)loadSlideData
{
    //轮播图图片数组
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    //轮播图标题数组
    NSMutableArray *subArr = [[NSMutableArray alloc] init];
    tidArr = [[NSMutableArray alloc] init];
    [imgArr removeAllObjects];
    [subArr removeAllObjects];

    for (int i = 0; i < self.portalSlideModel.shots.itemlist.count; i++) {
        itemlist *aportal = self.portalSlideModel.shots.itemlist[i];
        [imgArr addObject:aportal.pic];
        [subArr addObject:aportal.title];
        [tidArr addObject:aportal.tid];
    }
    [self loadCarouselViewDatasWithImageArray:imgArr titleArray:subArr];
}

//加载轮播图数据
- (void)loadCarouselViewDatasWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray
{
    if (!imageArray) return;

    //视图数组
    if (!self.viewsArray) self.viewsArray = [@[] mutableCopy];
    [self.viewsArray removeAllObjects];

    //遍历视图
    for (int i = 0; i < imageArray.count; i++) {
        BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewBound.size.width, 200)];
        [imageView setUrl:imageArray[i]];
        [self.viewsArray addObject:imageView];
    }

    @weakify_self

    //设置轮播图的页数
    [carouselView numberOfPagesUsingBlock:^NSInteger{
        @strongify_self
        return self.viewsArray.count;
    }];

    //设置轮播图的内容
    [carouselView setupContentViewUsingBlock:^UIView *(NSInteger index) {
        @strongify_self
        return self.viewsArray[index];
    }];

    //设置轮播图的文本
    [carouselView resetTextLabelUsingBlock:^(UILabel *textLabel, NSInteger index) {
        textLabel.text = titleArray[index];
    }];

    //设置轮播图的点击事件
    [carouselView didSelectViewUsingBlock:^(NSInteger index) {
        @strongify_self
        [self pushWithTid:tidArr[index] type:nil];
    }];
}

- (NSArray *)loadListData:(NSInteger)index
{
    NSArray *array = self.portalModel.shots;
    portal *portal = [array objectAtIndex:index];
    array = [NSMutableArray arrayWithArray:portal.items];
    return array;
}

#pragma mark - Events Management

- (void)pushWithTid:(NSString *)tid type:(NSNumber *)type
{
    B3_PostViewController *board = [[B3_PostViewController alloc] init];
    board.tid = tid;
    board.articleType = type;
    [self.navigationController pushViewController:board animated:YES];
}

- (void)cellHeaderDidSelect:(id)sender
{
    A1_PortalDetail *portalDetail = [[A1_PortalDetail alloc] init];
    portalDetail.portalModel = self.portalModel;
    portalDetail.section = [sender tag];
    [self.navigationController pushViewController:portalDetail animated:YES];
}

//刷新调用的方法
-(void)refreshView
{
    [self.portalSlideModel loadData];
    [self.portalModel loadData];
}

//加载调用的方法
- (void)getNextPageView
{
    if (!self.portalModel.end) {
        [self.portalModel loadData];
    } else {
        [tv headerEndRefreshing];
        [tv footerEndRefreshing];
        [self presentMessageTips:@"没有更多的了"];
    }
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.portalModel.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }

    NSArray *array = [self loadListData:indexPath.section];
    [cell loadPortalList:array[indexPath.row]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self loadListData:section].count <= 3) return [self loadListData:section].count;
    else return 3;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
    control.tag = section;
    [control addTarget:self action:@selector(cellHeaderDidSelect:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    portal *portal = self.portalModel.shots[section];
    label.backgroundColor = [UIColor colorWithRed:224./255. green:224./255. blue:224./255. alpha:1];
    label.text = [NSString stringWithFormat:@"  %@", portal.title];
    [control addSubview:label];

    float ARRORHEIGHT = 12;
    float MARGIN_RIGHT =10;
    //箭头
    UIImageView *arrows = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"tiaozhuan001"]];
    arrows.contentMode = UIViewContentModeScaleAspectFit;
    arrows.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - MARGIN_RIGHT- ARRORHEIGHT, CGRectGetMidY(label.frame)-ARRORHEIGHT/2., ARRORHEIGHT, ARRORHEIGHT);
    [label addSubview:arrows];

    return control;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *array = [self loadListData:indexPath.section];
    items *items = [array objectAtIndex:indexPath.row];
    items.tid = items.tid ? items.tid : items.aid;
    [self pushWithTid:items.tid type:items.idtype];
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
