//
//  E2_SubRankViewController.m
//  DZ
//
//  Created by nonato on 14-10-16.
//
//

#import "E2_SubRankViewController.h"
#import "ToolsFunc.h"
#import "B2_TopicTableViewCell.h"
@interface E2_SubRankViewController ()

@end

@implementation E2_SubRankViewController

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
    [self.tpclistModel removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
    self.tpclistModel =[ToptenModel modelWithObserver:self];
    self.tpclistModel.type=self.tptType;
    [self.tpclistModel loadCache];
    [self setFooterView];
}

ON_SIGNAL3(ToptenModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
    
}

ON_SIGNAL3(ToptenModel, FAILED, signal)
{
    [self FinishedLoadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews//重新layout界面 针对越狱手机
{
    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
    [self relayoutSubviews];
}

- (void)viewDidCurrentView
{
    if (!self.tpclistModel.loaded)
    {
        [self.tpclistModel firstPage];
    }
    BeeLog(@"加载为当前视图 = %@",self.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数据加载完成
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == (self.tpclistModel.shots.count-1)){
        [self setFooterView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tpclistModel.shots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = indexPath.row;
    static NSString *ListViewCellId = @"ToptenModelListViewCellId";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        [self addCellSelectedColor:cell];
    }
    topics *atopic = [self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (atopic)
    {
        [cell datachanges:atopic];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    topics *atopic = [self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (_topicvcdelegate != nil && [_topicvcdelegate respondsToSelector:@selector(E2_SubRankViewController:topicViewControllerCellSelectedWithTid:)])
    {
        NSString *keys = [NSString stringWithFormat:@"%@:%@", atopic.fid,atopic.tid];
        if (self.topicvcdelegate && [self.topicvcdelegate respondsToSelector:@selector(E2_SubRankViewController:topicViewControllerCellSelectedWithTid:)]) {
            [self.topicvcdelegate E2_SubRankViewController:self topicViewControllerCellSelectedWithTid:keys];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //tid: 14
}

//刷新调用的方法
- (void)refreshView
{
    [self.tpclistModel firstPage];
}

//加载调用的方法
- (void)getNextPageView
{
    if (!self.tpclistModel.more) {
        [self removeFooterView];
        [self.tpclistModel nextPage];
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
