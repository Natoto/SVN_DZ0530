//
//  C0_HairPostPhotoCell.m
//  DZ
//
//  Created by nonato on 14-10-29.
//
//

#import "C0_HairPostPhotoCell.h"
#import "ToolsFunc.h"

#define TAG_IMAGESTART 112911
@interface C0_HairPostPhotoCell()
@property(nonatomic,strong) UIScrollView * scrollview;
@property(nonatomic,assign) NSUInteger     imagesCount;
@end

@implementation C0_HairPostPhotoCell


-(UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), H_IMAGECELLHEIGHT)];
        [self addSubview:_scrollview];
         objc_setAssociatedObject(_scrollview, "section2_0",self, OBJC_ASSOCIATION_ASSIGN);
        UITapGestureRecognizer * tapgesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
        [_scrollview addGestureRecognizer:tapgesture];
    }
    return _scrollview;
}

-(void)scrollViewTap:(id)sender
{
    BeeLog(@"点击了scrollview");
//    UITableViewCell * cell = objc_getAssociatedObject(_scrollview, "section2_0");
    if (self.delegate && [self.delegate respondsToSelector:@selector(C0_HairPostBaseCell:viewTapped:)]) {
        [self.delegate C0_HairPostBaseCell:self viewTapped:0];
    }
}
-(void)loadimageArray:(NSArray *)imageArray
{
    float F_IMAGEWIDTH = 45.0;
    float F_IMGSPLIT = 5;
    for (NSInteger index = 0; index < imageArray.count; index ++) {
        CGRect rect = CGRectMake(index * (F_IMAGEWIDTH + F_IMGSPLIT) , 2, F_IMAGEWIDTH, F_IMAGEWIDTH);
        NSString * imageurl = [imageArray objectAtIndex:index];
        [ToolsFunc  LoadImageViewWithFrame:rect andImgName:imageurl tag:TAG_IMAGESTART + index superview:self.scrollview];
        if ((index +1) * (F_IMAGEWIDTH + F_IMGSPLIT) > CGRectGetWidth(_scrollview.frame)) {
            _scrollview.contentSize = CGSizeMake((index +1) * (F_IMAGEWIDTH + F_IMGSPLIT), self.frame.size.height);
        }
    }
    [self reloadSubViews:imageArray];
}
-(void)reloadSubViews:(NSArray *)imgary
{
    if ( self.imagesCount > imgary.count) {
        for (NSInteger index = imgary.count; index < self.imagesCount; index ++) {
            UIImageView * imgview = (UIImageView *)[self.scrollview viewWithTag:TAG_IMAGESTART + index];
            if (imgview) {
                [imgview removeFromSuperview];
            }
        }
    }
    self.imagesCount = imgary.count;
}
-(void)setTextColor:(NSString *)textColor
{
    
}
-(void)dataChange:(NSString *)data
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
