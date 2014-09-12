//
//  A1_Activity_TypeViewController.m
//  DZ
//
//  Created by Nonato on 14-8-18.
//
//
#import "B2_TopicTableViewCell.h"
#import "A1_Activity_TypeViewController.h"
#import "ActivityModel.h"
#import "Topiclist.h"

@interface A1_Activity_TypeViewController ()
@property(nonatomic,strong)ActivityModel * tpclistModel;
@end

@implementation A1_Activity_TypeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [self.tpclistModel removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewList.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bee.ui.config.baseInsets.top); 
    self.tpclistModel =[ActivityModel modelWithObserver:self];
    self.tpclistModel.type=self.type;
    [self.tpclistModel loadCache];
    [self setFooterView];
}

ON_SIGNAL3(ActivityModel, RELOADED, signal)
{
    [self.tableViewList reloadData];
    [self FinishedLoadData];
}
ON_SIGNAL3(ActivityModel, FAILED, signal)
{
    [self FinishedLoadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillLayoutSubviews//重新layout界面 针对越狱手机
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
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数据加载完成
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
    static NSString *ListViewCellId = @"ListViewCellId";
    B2_TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[B2_TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        [self addCellSelectedColor:cell];
    }
    activity *atopic = [self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (atopic)
    {/*
      author;
      @property (nonatomic, retain) NSString *			dateline;
      @property (nonatomic, retain) NSString *			img;
      @property (nonatomic, retain) NSString *			replies;
      @property (nonatomic, retain) NSString *			subject;
      @property (nonatomic, retain) NSString *			tid;
      @property (nonatomic, retain) NSString *			views;
      */
        topics *aitem= [[topics alloc] init];
        aitem.lastpost = atopic.dateline;
        aitem.img = atopic.img;
        aitem.replies = atopic.replies;
        aitem.subject = atopic.subject;
        aitem.message = atopic.message;
        aitem.authorname = atopic.author;
        aitem.tid = atopic.tid;
        aitem.views = atopic.views;
        [cell datachanges:aitem];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    topics *atopic = [self.tpclistModel.shots objectAtIndex:indexPath.row];
    if (self.delegate != nil && [_delegate respondsToSelector:@selector(A1_Activity_TypeViewController:cellSelectedWithTid:)])
    {
//        NSString *keys = [NSString stringWithFormat:@"%@:%@", atopic.fid,atopic.tid];
        [_delegate performSelector:@selector(A1_Activity_TypeViewController:cellSelectedWithTid:) withObject:atopic.tid];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //tid: 14
}

//刷新调用的方法
-(void)refreshView{
    [self.tpclistModel firstPage];
}

//加载调用的方法
-(void)getNextPageView{
    if (!self.tpclistModel.ACTY.isEnd) {
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
