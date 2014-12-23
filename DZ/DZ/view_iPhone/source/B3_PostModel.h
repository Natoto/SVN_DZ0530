//
//  B3_PostModel.h
//  DZ
//
//  Created by PFei_He on 14-11-19.
//
//

#import <Foundation/Foundation.h>
#import "ArticleModel.h"
#import "B3_PostView.h"
#import "PFTableViewCell.h"

@class B3_PostModel;

@protocol B3_PostModelDelegate <NSObject>

@optional

- (void)articleImageView:(BeeUIImageView *)imageView;

@end

typedef void(^longPressBlock)(B3_PostModel *, UIView *, UIGestureRecognizer *);

@interface B3_PostModel : UIView <B3_PostViewDelegate>

@property (nonatomic, copy) longPressBlock longPressBlock;

@property (nonatomic, strong) id<B3_PostModelDelegate> delegate;

+ (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath articleModel:(ArticleModel *)articleModel;

- (UITableViewCell *)setupTableViewCellInTableView:(UITableView *)tableView aboveView:(UIView *)view viewControl:(UIViewController *)viewControl articleModel:(ArticleModel *)articleModel atIndexPath:(NSIndexPath *)indexPath;

- (void)setupTableViewCell:(PFTableViewCell *)cell inTableView:(UITableView *)tableView viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath;

- (void)setupRow0InTableViewCell:(PFTableViewCell *)cell articleModel:(ArticleModel *)articleModel viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath;

- (void)setupRowInTableViewCell:(PFTableViewCell *)cell articleModel:(ArticleModel *)articleModel viewControl:(UIViewController *)viewControl indexPath:(NSIndexPath *)indexPath;

- (void)longPressUsingBlock:(void (^)(B3_PostModel *postModel, UIView *view, UIGestureRecognizer *recognizer))block;

@end
