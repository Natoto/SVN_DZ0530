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

@class B3_PostModel;

@protocol B3_PostModelDelegate <NSObject>

@optional

- (void)articleImageView:(BeeUIImageView *)imageView;

@end

typedef void(^textLabelBlock)(B3_PostModel *, UIView *, UIGestureRecognizer *);
typedef void(^loadedBlock)(NSIndexPath *);

@interface B3_PostModel : NSObject <B3_PostViewDelegate>

///
@property (nonatomic, copy) loadedBlock                 loadedBlock;

///
@property (nonatomic, copy) textLabelBlock              textLabelBlock;

///
@property (nonatomic, weak) id<B3_PostModelDelegate>    delegate;

/**
 *
 */
+ (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath articleModel:(ArticleModel *)articleModel;

/**
 *
 */
- (UITableViewCell *)setupTableViewCellInTableView:(UITableView *)tableView aboveView:(UIView *)view viewControl:(UIViewController *)viewControl articleModel:(ArticleModel *)articleModel atIndexPath:(NSIndexPath *)indexPath;

/**
 *
 */
- (void)loadedUsingBlock:(void (^)(NSIndexPath *indexPath))block;

/**
 *
 */
- (void)textLabelTouchUsingBlock:(void (^)(B3_PostModel *postModel, UIView *view, UIGestureRecognizer *recognizer))block;

@end
