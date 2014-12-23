//
//  B3_PostModel.m
//  DZ
//
//  Created by PFei_He on 14-11-19.
//
//

#import "B3_PostModel.h"
#import "PFTableViewCell.h"
#import "D1_FriendsInfoViewController.h"

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
/*
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

    if (indexPath.row == 0) {//内容页，头像，标题，摘要，层，用户名，发布日期
        [self setupRow0InTableViewCell:cell articleModel:articleModel viewControl:viewControl indexPath:indexPath];
    } else {//内容页，头像，内容，层，用户名，发布日期
        [self setupRowInTableViewCell:cell articleModel:articleModel viewControl:viewControl indexPath:indexPath];
    }
    //分割线
    cell.lineFrame = CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1.0f);

    return cell;
}
*/
//设置列表
- (void)setupTableViewCell:(PFTableViewCell *)cell inTableView:(UITableView *)tableView viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath
{
    //头像，层，用户名，时间，分割线
    cell.firstImageViewShow = YES;
    cell.firstImageView.frame = CGRectMake(15, indexPath.row == 0 ? cell.bounds.origin.y + 50 : cell.bounds.origin.y + 5, 40, 40);
    cell.firstImageView.userInteractionEnabled = YES;
    [cell setRoundedImageView:cell.firstImageView];

    cell.secondTextLabelShow = YES;
    cell.secondTextLabel.numberOfLines = 0;

    cell.thirdTextLabelShow = YES;
    cell.thirdTextLabel.font = [UIFont systemFontOfSize:14];
    cell.thirdTextLabel.frame = CGRectMake(cell.firstImageView.frame.size.width + cell.firstImageView.frame.origin.x, indexPath.row == 0 ? cell.bounds.origin.y + 55 : cell.bounds.origin.y + 10, 150, 30);

    cell.fifthTextLabelShow = YES;
    cell.fifthTextLabel.font = [UIFont systemFontOfSize:14];
    cell.fifthTextLabel.frame = CGRectMake(cell.bounds.size.width - 150, indexPath.row == 0 ? cell.bounds.origin.y + 55 : cell.bounds.origin.y + 10, 130, 30);
    cell.fifthTextLabel.textAlignment = NSTextAlignmentRight;

    cell.lineShow = YES;

    if (indexPath.row == 0) {
        //标题
        cell.firstTextLabelShow = YES;
        cell.firstTextLabel.font = GB_FontHelveticaNeue(16);
        cell.firstTextLabel.numberOfLines = 0;

        //分割线
        cell.secondImageViewShow = YES;
        cell.secondImageView.frame = CGRectMake(0, cell.bounds.origin.y + 100, cell.bounds.size.width, 0.5f);
        cell.secondImageView.image = [UIImage bundleImageNamed:@"fengexian02"];
    }

    [cell tableViewCellLoadedAtIndexPathUsingBlock:^(NSIndexPath *indexPath) {
        if (indexPath.row == 0) {
            if (!imageLoaded) {
                imageLoaded = YES;
                [tableView reloadData];
            }
        }
    }];
}

- (void)setupRow0InTableViewCell:(PFTableViewCell *)cell articleModel:(ArticleModel *)articleModel viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath
{
    cell.firstContentViewShow = YES;
    cell.firstContentView.frame = CGRectMake(0, cell.secondTextLabel.frame.origin.y + cell.secondTextLabel.frame.size.height + 20, viewControl.view.frame.size.width, 30);

    cell.firstImageViewUrl = articleModel.mainArcticle.avatar;
    [cell imageViewDidSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath, NSInteger controlIndex) {
        D1_FriendsInfoViewController *ctr = [[D1_FriendsInfoViewController alloc] init];
        ctr.uid = articleModel.mainArcticle.uid;
        [viewControl.navigationController pushViewController:ctr animated:YES];
    }];

    cell.firstTextLabel.text = articleModel.mainArcticle.title;
    CGSize size = [cell.firstTextLabel.text sizeWithFont:cell.firstTextLabel.font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    cell.firstTextLabel.frame = CGRectMake(cell.bounds.origin.x + 10, cell.bounds.origin.y + 10, cell.bounds.size.width - 5, size.height);

    cell.secondTextLabel.text = [NSString stringWithFormat:@"摘要:%@", articleModel.mainArcticle.summary];
    cell.secondTextLabel.textColor = [UIColor orangeColor];
    size = [cell.secondTextLabel.text sizeWithFont:cell.secondTextLabel.font constrainedToSize:CGSizeMake(310, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    cell.secondTextLabel.frame = CGRectMake(cell.bounds.origin.x + 5, cell.bounds.origin.y + 105, cell.bounds.size.width - 10, size.height);

    cell.thirdTextLabel.text = [NSString stringWithFormat:@"发表者:%@", articleModel.mainArcticle.username];

    NSString *time = @"";
    KT_DATEFROMSTRING(articleModel.mainArcticle.dateline, time);
    cell.fifthTextLabel.text = [NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:articleModel.mainArcticle.dateline]];

    B3_PostView *postView = [[B3_PostView alloc] init];
    [postView loadContents:articleModel.mainArcticle.content height:[postView heightOfContents:articleModel.mainArcticle.content cellType:cellTypeArticla otherViewHeight:cell.secondTextLabel.frame.size.height + 100 + 20 indexPath:indexPath] contentView:cell.firstContentView];
    [cell.firstContentView addSubview:postView];
}

- (void)setupRowInTableViewCell:(PFTableViewCell *)cell articleModel:(ArticleModel *)articleModel viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath
{
    commentlist *commentlist1 = articleModel.shots[indexPath.row - 1];

    cell.firstContentView.frame = CGRectMake(10, 150, viewControl.view.frame.size.width - 20, 30);
    cell.firstContentView.backgroundColor = nil;
    cell.firstImageViewUrl = commentlist1.avatar;
    [cell imageViewDidSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath, NSInteger controlIndex) {
        D1_FriendsInfoViewController *ctr = [[D1_FriendsInfoViewController alloc] init];
        commentlist *commentlist2 = articleModel.shots[indexPath.row - 1];
        ctr.uid = commentlist2.uid;
        [viewControl.navigationController pushViewController:ctr animated:YES];
    }];
    cell.secondTextLabel.text = commentlist1.message;
    cell.secondTextLabel.font = [UIFont systemFontOfSize:14];
    cell.secondTextLabel.userInteractionEnabled = YES;
    cell.secondTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    CGSize size = [cell.secondTextLabel.text sizeWithFont:cell.secondTextLabel.font constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [cell textLabelDidSelectRowAtIndexPathUsingBlock:^(PFTableViewCell *tableViewCell, NSIndexPath *indexPath, UIGestureRecognizer *recognizer, UIView *view) {
        if (self.longPressBlock) {
            self.longPressBlock(self, view, recognizer);
        }
    }];

    cell.secondTextLabel.frame = CGRectMake(cell.bounds.origin.x + 30, cell.bounds.origin.y + 50, size.width, size.height);
//    B3_PostView *postView = [[B3_PostView alloc] init];
//    [postView loadContents:commentlist1.message height:[postView heightOfContents:commentlist1.message cellType:cellTypeArticla otherViewHeight:cell.bounds.origin.y + 50 indexPath:indexPath] contentView:cell.firstContentView];

    NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
    [formatter1 setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter1 numberFromString:[NSString stringWithFormat:@"%@", commentlist1.position]];
    NSInteger position = number.integerValue;
    cell.thirdTextLabel.text = [NSString stringWithFormat:@"%ld楼:%@", position + 1, commentlist1.username];

    NSString *time = @"";
    KT_DATEFROMSTRING(commentlist1.dateline, time);
    cell.fifthTextLabel.text = [NSString stringWithFormat:@"%@",[ToolsFunc datefromstring:commentlist1.dateline]];
    cell.fifthTextLabel.textColor = [UIColor lightGrayColor];

    commentlist1 = nil;
}

#pragma mark - Public Management

- (void)longPressUsingBlock:(void (^)(B3_PostModel *, UIView *, UIGestureRecognizer *))block
{
    if (block) self.longPressBlock = block, block = nil;
}

- (void)dealloc
{
    
}

@end
