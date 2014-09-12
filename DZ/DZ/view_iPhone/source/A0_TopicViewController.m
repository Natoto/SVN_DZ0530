//
//  A0_TopicViewController.m
//  DZ
//
//  Created by PFei_He on 14-8-26.
//
//

#import "A0_TopicViewController.h"
#import "B2_TopicTableViewCell.h"
#import "ToolsFunc.h"
#import "rmbdz.h"
#import "B3_PostViewController.h"

typedef void(^didSelectBlock)(NSString *);

@interface A0_TopicViewController ()

@property (nonatomic, copy) didSelectBlock block;

@end

@implementation A0_TopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

ON_SIGNAL3(HomeTopicListModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}

ON_SIGNAL3(HomeTopicListModel, FAILED, signal)
{
    [self FinishedLoadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableViewList.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);

    self.listModel = [HomeTopicListModel modelWithObserver:self];
    self.listModel.type = self.topic_type;
    [self.listModel loadList];
    [self.listModel loadCache];
}

#pragma mark - Private Methods

//重新layout界面 针对越狱手机
- (void)viewWillLayoutSubviews
{
    self.tableViewList.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top);
    [self relayoutSubviews];
}

- (void)viewDidCurrentView
{
    if (!self.listModel.loaded) {
        [self.listModel loadList];
    }
    NSLog(@"加载为当前视图 = %@",self.title);
}

#pragma mark - Public Methods

- (void)A0_TopicViewControllTableViewCellDidSelectUsingBlock:(void (^)(NSString *))block
{
    if (block) self.block = block, block = nil;
}

#pragma mark - Refresh Management

//刷新调用的方法
-(void)refreshView
{
    [self.listModel loadList];
}

//加载调用的方法
-(void)getNextPageView
{
    if (!self.listModel.end) {
        [self removeFooterView];
        [self.listModel loadList];
    }
    else
    {
        [self removeFooterView];
        [self finishReloadingData];
        [self presentMessageTips:@"没有更多的了"];
    }
    [self FinishedLoadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [self addCellSelectedColor:cell];
    }
    hometopiclist *ahometopiclist = self.listModel.shots[indexPath.row];
    if (ahometopiclist) [cell loadHomeTopicList:ahometopiclist];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.shots.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    hometopiclist *topiclist = self.listModel.shots[indexPath.row];
    if (!self.delegate && self.block) self.block(topiclist.tid);
    else if ([self.delegate respondsToSelector:@selector(A0_TopicViewControllTableViewCellDidSelect:)])
        [self.delegate A0_TopicViewControllTableViewCellDidSelect:topiclist.tid];
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
