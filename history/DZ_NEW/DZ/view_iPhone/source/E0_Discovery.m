//
//  D0_Discovery.m
//  DZ
//
//  Created by nonato on 14-10-13.
//
//

#import "E0_Discovery.h"
#import "E0_DiscoveryCell.h"
#import "E0_AlbumBoard_iphone.h"
#import "E1_RankViewController.h"
#import "DiscoveryModel.h"

#define constdataarray   @[@"图集",@"排行榜",@"附近的优惠券",@"附近的团购"]
#define constdetailArray @[@"这里汇聚了全站的图片贴...",@"点赞、查看和回复最多的帖子",@"看看周围有什么优惠券",@"看看附近的团购"]
#define constimagenames  @[@"b11@2x.png",@"b10@2x.png",@"b9@2x.png",@"b8@2x.png"]
//,@"b7@2x.png"

@interface E0_Discovery()
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * detailArray;
@property(nonatomic,strong)NSMutableArray * imageNames;
@property(nonatomic,strong)DiscoveryModel * discoveymodel;
@end
@implementation E0_Discovery

-(void)load
{
    self.noFooterView = YES;
    self.noHeaderView = NO;
}
-(void)dealloc
{
    [self.discoveymodel removeObserver:self];
}

-(void)refreshView
{
    [self.discoveymodel firstPage];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.title = __TEXT(@"DISCOVERY");
        [self initDatas];
        self.list.showsVerticalScrollIndicator = NO;
        self.list.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.discoveymodel = [DiscoveryModel modelWithObserver:self];
        [self.discoveymodel loadCache];
    }
    else if ([signal is:BeeUIBoard.LAYOUT_VIEWS])
    {
       self.list.frame = CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), self.view.frame.size.height - TAB_HEIGHT);
    }
}
-(void)initDatas
{
    self.dataArray = [NSMutableArray arrayWithArray:constdataarray];
    self.detailArray =[NSMutableArray arrayWithArray:constdetailArray];
    self.imageNames =[NSMutableArray arrayWithArray:constimagenames];
}
ON_SIGNAL3(DiscoveryModel, RELOADED, signal)
{
    [self FinishedLoadData];
    if (self.discoveymodel.shots.count) {
        [self initDatas];
        for (NSInteger index = 0; index < self.discoveymodel.shots.count; index ++) {
            discovery * dis =[self.discoveymodel.shots objectAtIndex:index];
            [self.dataArray addObject:dis.name];
            [self.detailArray addObject:dis.description];
            srand(time(NULL));
            int randx = (random() + index)%12 + 1;
            [self.imageNames addObject:[NSString stringWithFormat:@"b%d@2x.png",randx]];
        }
        [self.list reloadData];
    }
}
ON_SIGNAL3(DiscoveryModel, FAILED, signal)
{
    [self FinishedLoadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idfcell=@"e0cell";
    E0_DiscoveryCell * cell = [tableView dequeueReusableCellWithIdentifier:idfcell];
    if (!cell) {
        cell = [[E0_DiscoveryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfcell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.title = [self.dataArray objectAtIndex:indexPath.row];
    cell.detail = [self.detailArray objectAtIndex:indexPath.row];
    cell.imageName = [self.imageNames objectAtIndex:indexPath.row];
    return cell;
}

-(void)viewDidAppear:(BOOL)animated
{
    [bee.ui.appBoard showTabbar];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        E0_AlbumBoard_iphone * waterflay = [E0_AlbumBoard_iphone board];
        [self.navigationController pushViewController:waterflay animated:YES];
    }
    else if(indexPath.row == 1)
    {
        E1_RankViewController * ctr = [[E1_RankViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if (indexPath.row == 2)//附近的优惠券
    {
        NSString *keywords = [@"优惠券" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"dianping://shoplist?q=%@",keywords]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            //没有安装应用，默认打开HTML5站
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.dianping.com/shoplist/4/kw/%@/search", keywords]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else if (indexPath.row == 3)//附近的团购
    {
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"dianping://tuanhome"]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            //没有安装应用，默认打开HTML5站
            url = [NSURL URLWithString: [NSString stringWithFormat:@"http://m.dianping.com/tuan"]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else if(indexPath.row >= constdataarray.count)
    {
        NSInteger count = constdataarray.count;
        NSInteger index = indexPath.row - count;
        discovery * disc = [self.discoveymodel.shots objectAtIndex:index];
        if (![disc.link hasPrefix:@"http://"]) {
            disc.link = [NSString stringWithFormat:@"http://%@",disc.link];
        }
        NSURL *url = [NSURL URLWithString: disc.link];
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
