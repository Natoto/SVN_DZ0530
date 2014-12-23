//
//  A1_PortalDetail.m
//  DZ
//
//  Created by PFei_He on 14-10-27.
//
//

#import "A1_PortalDetail.h"
#import "B2_TopicTableViewCell.h"
#import "B3_PostViewController.h"
#import "blockdetail.h"
#import "MJRefresh.h"

@interface A1_PortalDetail ()

@end

@implementation A1_PortalDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - BeeFramework Methods

ON_SIGNAL3(BlockDetailModel, RELOADED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
    [tv reloadData];
}

ON_SIGNAL3(BlockDetailModel, FAILED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
}

ON_SIGNAL3(TopiclistModel, RELOADED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
    [tv reloadData];
}

ON_SIGNAL3(TopiclistModel, FAILED, signal)
{
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
}

#pragma mark - Views Management

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    portal *portal = self.portalModel.shots[self.section];
    self.title = portal.title;

    self.blockDetailModel = [BlockDetailModel modelWithObserver:self];
    self.tpclistModel = [TopiclistModel modelWithObserver:self];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    tv.dataSource = self;
    tv.delegate = self;
    tv.separatorInset = bee.ui.config.separatorInset;
    [self.view addSubview:tv];
    [self setExtraCellHidden:tv];

    [self setupRefresh];
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

- (NSArray *)loadListData:(NSInteger)index
{
    portal *portal = self.portalModel.shots[self.section];
    if ([portal.type isEqualToNumber:@1]) {
        NSArray *array = [self.tpclistModel.shots copy];
        return array;
    } else {
        NSArray *array = [self.blockDetailModel.shots copy];
        return array;
    }
}

#pragma mark - Events Management

- (void)pushWithTid:(NSString *)tid type:(NSNumber *)type
{
    B3_PostViewController *board = [[B3_PostViewController alloc] init];
    board.tid = tid;
    board.articleType = type;
    [self.navigationController pushViewController:board animated:YES];
}

//刷新调用的方法
-(void)refreshView
{
    portal *portal = self.portalModel.shots[self.section];
    if ([portal.type isEqualToNumber:@1]) {
        self.tpclistModel.fid = portal.fid;;
        self.tpclistModel.type = @"0";
        self.tpclistModel.typeids = @"";
        [self.tpclistModel firstPage];
    } else {
        NSString *str = portal.bid;
        self.blockDetailModel.bid = str;
        [self.blockDetailModel loadData];
    }
}

//加载调用的方法
- (void)getNextPageView
{
    portal *portal = self.portalModel.shots[self.section];
    if ([portal.type isEqualToNumber:@1]) {
        if (!self.tpclistModel.end) {
            [self.tpclistModel firstPage];
        }
    } else if (!self.blockDetailModel.end) {
        [self.blockDetailModel loadData];
    } else {
        [tv headerEndRefreshing];
        [tv footerEndRefreshing];
        [self presentMessageTips:@"没有更多的了"];
    }
    [tv headerEndRefreshing];
    [tv footerEndRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self loadListData:self.section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    portal *portal = self.portalModel.shots[self.section];
    if ([portal.type isEqualToNumber:@1]) {
        NSArray *array = [self.tpclistModel.shots copy];
        if ([array isEqual:@[]]) {
            array = nil;
        }
        topics *topics = array[indexPath.row];
        [cell datachanges:topics];
    } else {
        NSArray *array = self.blockDetailModel.shots;
        if ([array isEqual:@[]]) {
            array = nil;
        }
        NSDictionary *dic = array[indexPath.row];
        [cell loadBlockDetailList:dic];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    portal *portal = self.portalModel.shots[self.section];
    if ([portal.type isEqualToNumber:@1]) {
        topics *topics = self.tpclistModel.shots[indexPath.row];
        [self pushWithTid:topics.tid type:portal.type];
    } else {
        NSDictionary *dic = self.blockDetailModel.shots[indexPath.row];
        [self pushWithTid:dic[@"aid"] type:portal.type];
    }
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
