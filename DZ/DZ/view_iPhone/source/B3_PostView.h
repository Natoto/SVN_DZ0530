//
//  B3_PostView.h
//  DZ
//
//  Created by PFei_He on 14-11-24.
//
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

extern BOOL imageLoaded;

typedef NS_ENUM(NSUInteger, contentType) {
    contentTypeText = 0,
    contentTypeImage = 1,
    contentTypeFace,
    contentTypeQuoteReply,
    contentTypeNoImage = 1,
};

typedef NS_ENUM(NSUInteger, cellType) {
    cellTypeTopic = 0,
    cellTypeArticla,
    cellTypeReply,
};

@class B3_PostView;

@protocol B3_PostViewDelegate <NSObject>

- (void)B3_PostData:(B3_PostView *)cell ShowBigImgview:(NSString *)imgurl imageView:(BeeUIImageView *)imageview;

@optional

- (void)articleImageView:(BeeUIImageView *)imageView;

@end

@interface B3_PostView : UIView <RTLabelDelegate>
{
    NSDictionary    *faceMap;
    SEL             loadcontentselector;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RCLabel         *rtLabel;

@property (nonatomic, strong) id<B3_PostViewDelegate> delegate;

- (CGFloat)heightOfMessage:(NSString *)message view:(UIView *)view cellType:(cellType)cellType;
- (CGFloat)heightOfContents:(NSArray *)contents cellType:(cellType)cellType otherViewHeight:(CGFloat)otherViewHeight indexPath:(NSIndexPath *)indexPath;
- (void)loadContents:(NSArray *)contents height:(CGFloat)height contentView:(UIView *)contentView;

@end
