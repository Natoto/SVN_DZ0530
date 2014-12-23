//
//  B3_PostModel.m
//  DZ
//
//  Created by PFei_He on 14-11-19.
//
//

#import "B3_PostModel.h"
#import "D1_FriendsInfoViewController.h"
#import "PFTableViewCell.h"

@implementation B3_PostModel

+ (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath articleModel:(ArticleModel *)articleModel
{
    if (indexPath.row == 0) {
        if ([PFTableViewCell heightAtIndexPath:indexPath]) {
            return [PFTableViewCell heightAtIndexPath:indexPath];
        } else {
            return 1000;
        }
    } else {
        if ([PFTableViewCell heightAtIndexPath:indexPath]) {
            return [PFTableViewCell heightAtIndexPath:indexPath];
        } else {
            commentlist *commentlist = articleModel.shots[indexPath.row - 1];
            CGSize size = [commentlist.message sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(310, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            [PFTableViewCell setHeight:size.height + 45 + 30 atIndexPath:indexPath];
            return 300;
        }
    }
}

- (UITableViewCell *)setupTableViewCellInTableView:(UITableView *)tableView aboveView:(UIView *)view viewControl:(UIViewController *)viewControl articleModel:(ArticleModel *)articleModel atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    if (indexPath.row == 0) cellIdentifier = @"cellIdentifierModelOne";
    else cellIdentifier = @"cellIdentifierModelTwo";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier delegate:nil size:CGSizeMake(view.frame.size.width, indexPath.row == 0 ? 300 : 100)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupTableViewCell:cell inTableView:tableView viewControl:viewControl indexPath:indexPath];
    }
    //序号
    cell.indexPath = indexPath;

    if (indexPath.row == 0) {//内容页，头像，标题，摘要，用户名，发布日期
        [self setupRow0InTableViewCell:cell articleModel:articleModel viewControl:viewControl indexPath:indexPath];
    } else {//内容页，头像，内容，用户名，发布日期
        [self setupRowInTableViewCell:cell articleModel:articleModel viewControl:viewControl indexPath:indexPath];
    }
    //分割线
    cell.lineFrame = CGRectMake(0, cell.bounds.size.height - 0.5, cell.bounds.size.width, 0.5f);

    return cell;
}

//设置列表
- (void)setupTableViewCell:(PFTableViewCell *)cell inTableView:(UITableView *)tableView viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath
{
    cell.firstImageViewShow = YES;//头像
    cell.firstImageView.frame = CGRectMake(5, indexPath.row == 0 ? cell.bounds.origin.y + 50 : cell.bounds.origin.y + 5, 40, 40);
    cell.firstImageView.userInteractionEnabled = YES;
    [cell setRoundedImageView:cell.firstImageView];


    cell.secondTextLabelShow = YES;//摘要或回复内容
    cell.secondTextLabel.numberOfLines = 0;


    cell.thirdTextLabelShow = YES;//用户名
    cell.thirdTextLabel.font = [UIFont systemFontOfSize:14];
    cell.thirdTextLabel.frame = CGRectMake(cell.firstImageView.frame.origin.x + cell.firstImageView.frame.size.width + 5, indexPath.row == 0 ? cell.bounds.origin.y + 55 : cell.bounds.origin.y + 10, 150, 30);


    cell.fourthTextLabelShow = YES;//时间
    cell.fourthTextLabel.font = [UIFont systemFontOfSize:14];
    cell.fourthTextLabel.frame = CGRectMake(cell.bounds.size.width - 135, indexPath.row == 0 ? cell.bounds.origin.y + 55 : cell.bounds.origin.y + 10, 130, 30);
    cell.fourthTextLabel.textAlignment = NSTextAlignmentRight;


    cell.lineShow = YES;//分割线


    if (indexPath.row == 0) {
        cell.firstTextLabelShow = YES;//标题
        cell.firstTextLabel.font = [UIFont systemFontOfSize:17];
        cell.firstTextLabel.numberOfLines = 0;


        cell.secondContentViewShow = YES;//楼主分割线
        cell.secondContentView.frame = CGRectMake(0, cell.bounds.origin.y + 100, cell.bounds.size.width, 0.5f);
        cell.secondContentView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    }

    //加载完成
    [cell loadedUsingBlock:self.loadedBlock];
}

- (void)setupRow0InTableViewCell:(PFTableViewCell *)cell articleModel:(ArticleModel *)articleModel viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath
{
    cell.firstContentViewShow = YES;//文章内容
    cell.firstContentView.frame = CGRectMake(0, cell.secondTextLabel.frame.origin.y + cell.secondTextLabel.frame.size.height + 20, viewControl.view.frame.size.width, 30);


    cell.firstImageViewUrl = articleModel.mainArcticle.avatar;//作者头像
    @weakify(viewControl)
    [cell imageViewTouchUsingBlock:^(NSIndexPath *indexPath, NSInteger controlIndex) {
        D1_FriendsInfoViewController *ctr = [[D1_FriendsInfoViewController alloc] init];
        @normalize(viewControl)
        ctr.uid = articleModel.mainArcticle.uid;
        [viewControl.navigationController pushViewController:ctr animated:YES];
    }];


    cell.firstTextLabel.text = articleModel.mainArcticle.title;//标题
    CGSize size = [cell.firstTextLabel.text sizeWithFont:cell.firstTextLabel.font constrainedToSize:CGSizeMake(310, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    cell.firstTextLabel.frame = CGRectMake(cell.bounds.origin.x + 5, cell.bounds.origin.y + 5, cell.bounds.size.width, size.height);


    cell.secondTextLabel.text = [NSString stringWithFormat:@"摘要:%@", articleModel.mainArcticle.summary];//摘要或回复内容
    cell.secondTextLabel.textColor = [UIColor orangeColor];
    size = [cell.secondTextLabel.text sizeWithFont:cell.secondTextLabel.font constrainedToSize:CGSizeMake(310, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    cell.secondTextLabel.frame = CGRectMake(cell.bounds.origin.x + 5, cell.bounds.origin.y + 105, cell.bounds.size.width - 10, size.height);


    cell.thirdTextLabel.text = [NSString stringWithFormat:@"发表者:%@", articleModel.mainArcticle.username];//用户名


    NSString *time = @"";//时间
    KT_DATEFROMSTRING(articleModel.mainArcticle.dateline, time);
    cell.fourthTextLabel.text = [NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:articleModel.mainArcticle.dateline]];

    B3_PostView *postView = [[B3_PostView alloc] init];
    [postView loadContents:articleModel.mainArcticle.content height:[postView heightOfContents:articleModel.mainArcticle.content cellType:cellTypeArticla otherViewHeight:cell.secondTextLabel.frame.size.height + 100 + 20 indexPath:indexPath] contentView:cell.firstContentView];
    [cell.firstContentView addSubview:postView];
}

- (void)setupRowInTableViewCell:(PFTableViewCell *)cell articleModel:(ArticleModel *)articleModel viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath
{
    commentlist *commentlist1 = articleModel.shots[indexPath.row - 1];

    cell.firstContentView.frame = CGRectMake(10, 150, viewControl.view.frame.size.width - 20, 30);//文章内容
    cell.firstContentView.backgroundColor = nil;


    cell.firstImageViewUrl = commentlist1.avatar;//头像
    @weakify(viewControl)
    [cell imageViewTouchUsingBlock:^(NSIndexPath *indexPath, NSInteger controlIndex) {
        D1_FriendsInfoViewController *ctr = [[D1_FriendsInfoViewController alloc] init];
        @normalize(viewControl)
        commentlist *commentlist2 = articleModel.shots[indexPath.row - 1];
        ctr.uid = commentlist2.uid;
        [viewControl.navigationController pushViewController:ctr animated:YES];
    }];


    cell.secondTextLabel.text = commentlist1.message;//摘要或回复内容
    cell.secondTextLabel.font = [UIFont systemFontOfSize:14];
    cell.secondTextLabel.userInteractionEnabled = YES;
    cell.secondTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    CGSize size = [cell.secondTextLabel.text sizeWithFont:cell.secondTextLabel.font constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    @weakify_self
    [cell textLabelDidSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath, UIGestureRecognizer *recognizer, UIView *view) {
        if (weakSelf.textLabelBlock) {
            weakSelf.textLabelBlock(self, view, recognizer);
        }
    }];
    cell.secondTextLabel.frame = CGRectMake(cell.bounds.origin.x + 30, cell.bounds.origin.y + 50, size.width, size.height);
//    B3_PostView *postView = [[B3_PostView alloc] init];
//    [postView loadContents:commentlist1.message height:[postView heightOfContents:commentlist1.message cellType:cellTypeArticla otherViewHeight:cell.bounds.origin.y + 50 indexPath:indexPath] contentView:cell.firstContentView];


    cell.thirdTextLabel.text = [NSString stringWithFormat:@"%@楼:%@", commentlist1.position, commentlist1.username];//用户名


    NSString *time = @"";//时间
    KT_DATEFROMSTRING(commentlist1.dateline, time);
    cell.fourthTextLabel.text = [NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:commentlist1.dateline]];
    cell.fourthTextLabel.textColor = [UIColor lightGrayColor];
}

#pragma mark - Public Management

- (void)loadedUsingBlock:(void (^)(NSIndexPath *))block
{
    if (block) self.loadedBlock = block;
}

- (void)textLabelTouchUsingBlock:(void (^)(B3_PostModel *, UIView *, UIGestureRecognizer *))block
{
    if (block) self.textLabelBlock = block;
}

@end
