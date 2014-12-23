//
//  B4_PreviewImageViewController.m
//  DZ
//
//  Created by Nonato on 14-5-15.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import "UIImage+Bundle.h"
#import "B4_PreviewImageView.h"
#import "LXActionSheet.h"
#import "UIImage+BeeExtension.h"
#import "MRZoomScrollView.h"
#import "postlist.h"
#import "C0_HairPost_ToolFun.h"

@interface B4_PreviewImageView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    BeeUIImageView *showView;
    UIScrollView *scrollview;
 
    CGFloat currentScale;
    UIImage * srcImage;
}
@property (nonatomic, retain) UILabel               * lblTips;
@property (nonatomic, retain) UIScrollView          * scrollView;
@property (nonatomic, retain) NSMutableArray        * imgURLarray;
@property (nonatomic, retain) UITapGestureRecognizer* singleTap;
@property (nonatomic, assign) NSUInteger              TOTALCOUNT;
@property (nonatomic, strong) NSMutableArray        * zoomviewArray;
@property (nonatomic, strong) UIButton              * deleteButton;
@property (nonatomic, strong) UIButton              * closeButton;
@property (nonatomic, strong) UIButton              * menuButton;
@property (nonatomic, strong) UIActionSheet         * actionSheet;
@end

@implementation B4_PreviewImageView

-(NSArray *)imgURLAry:(NSArray *)contentsAry
{
    NSMutableArray *imgarray=[[NSMutableArray alloc] init];
    for ( content *acontent in contentsAry) {
        if (acontent.type.integerValue == 1) {
            [imgarray addObject:acontent];
        }
    }
    return imgarray;
}

-(NSMutableArray *)zoomviewArray
{
    if (!_zoomviewArray) {
        _zoomviewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _zoomviewArray;
}

-(NSInteger)indexOfImage:(NSString *)url
{
    int Index=0;
    for (Index = 0 ;Index < self.imgURLarray.count;Index++) {
        content *acontent =[self.imgURLarray objectAtIndex:Index];
        if ([acontent.msg isEqualToString:url]) {
            break;
        }
    }
    return Index;
}

//caidan

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) - 60, 20, 50, 40);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
    }
  
    return _deleteButton;
    
}

-(UIButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _menuButton.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) - 60, CGRectGetHeight(self.scrollView.frame) - 70, 50, 40);
        [_menuButton setImage:[UIImage bundleImageNamed:@"caidan"] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_menuButton];
    }
    return _menuButton;
}

-(UIActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",nil];
    }
    return _actionSheet;
}

-(UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _closeButton.frame = CGRectMake(20, 20, 50, 40);
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _deleteButton;
}

#pragma mark - actionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BeeLog(@"clicked Button Index%d",buttonIndex);
    switch (buttonIndex) {
        case 1://压缩图片
        {
            break;
        }
        case 0://删除图片
        {
            [self deleteButtonTap:nil];
             NSUInteger index = [self currentImageViewIndex];
            if (self.imgURLarray.count) {
                NSString * key =[self.imgURLarray objectAtIndex:index];
                [[BeeImageCache sharedInstance] deleteImageForURL:key];
                [self loadSubViews:self.imgURLarray imgindex:index];
            }
            break;
        }
        default:
            break;
    }
}

-(IBAction)menuButtonTap:(id)sender
{
    if (self.actionSheet) {
        NSUInteger index = [self currentImageViewIndex];
        NSString * url =[self.imgURLarray objectAtIndex:index];
        float imgsize =[[C0_HairPost_ToolFun sharedInstance] imageSizewithUrl:url];
        self.actionSheet.title = [NSString stringWithFormat:@"当前图片大小%.2fM",imgsize];
        [self.actionSheet showInView:self];
    }
}
-(IBAction)closeButtonTap:(id)sender
{
    self.tappedBlock(self.imgURLarray);
}

-(IBAction)deleteButtonTap:(id)sender
{
    NSUInteger index = [self currentImageViewIndex];
    [self.imgURLarray removeObjectAtIndex:index];
    if (!self.imgURLarray.count) {
        self.tappedBlock(nil);
    }
    else if(index < self.imgURLarray.count)
    {
        [self loadSubViews:self.imgURLarray imgindex:index];
    }
    else
    {
        [self loadSubViews:self.imgURLarray imgindex:self.imgURLarray.count-1];
    }
}

const float TAG_ZOOMSCRVIEWSTART = 203118;
const float TAG_IMAGEVIEWSTART = 103118;
//show
-(void)showInView:(UIView *)superview currenturl:(NSString *)url index:(NSInteger )index urls:(NSArray *)urls shownblock:(PREVIEWSHOWN)showblock tappedblock:(PREVIEWTAPPEDBLOCK)tappedblock
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.scrollView) {
        _scrollView.frame = CGRectMake(0, 0, frame.size.width,frame.size.height);
    }
    NSUInteger indexImage = index;
    if (url.length && !index) {
        indexImage = [self indexOfImage:url];
    }
    [self loadSubViews:urls imgindex:indexImage];
    if (self.menuButton) {
        BeeLog(@"加载 menuButton。。。");
    }
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    [_scrollView addGestureRecognizer:_singleTap];
    [superview addSubview:self];
    [superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.5f animations:^{
        self.frame =CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    }];
    showblock(YES);
    self.tappedBlock = ^(NSArray *result){
        tappedblock(result);
    };
}

-(void)loadSubViews:(NSArray *)urls imgindex:(NSInteger)imgindex
{
    self.imgURLarray =[NSMutableArray arrayWithArray:urls];
    for (int i = 0; i < self.imgURLarray.count; i++)
    {
        MRZoomScrollView  *_zoomScrollView = (MRZoomScrollView *)[_scrollView viewWithTag:TAG_ZOOMSCRVIEWSTART + i];
        if (!_zoomScrollView) {
            _zoomScrollView = [[MRZoomScrollView alloc]init];
            _zoomScrollView.tag = TAG_ZOOMSCRVIEWSTART + i;
            [self.scrollView addSubview:_zoomScrollView];
        }
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        _zoomScrollView.frame = frame;
        NSString *imgurl =[self.imgURLarray objectAtIndex:i];
        _zoomScrollView.imageView.image = [[BeeImageCache sharedInstance] imageForURL:imgurl];
        _zoomScrollView.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _zoomScrollView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (![self.zoomviewArray containsObject:_zoomScrollView]) {
            [self.zoomviewArray addObject:_zoomScrollView];
        }
    }
    CGRect scrollViewframe = self.scrollView.frame;
    self.scrollView.contentSize = CGSizeMake(scrollViewframe.size.width * (self.imgURLarray.count), scrollViewframe.size.height);
    [self.scrollView setContentOffset:CGPointMake(scrollViewframe.size.width * imgindex, 0) animated:YES];
    if (self.lblTips) {
        _lblTips.text = [NSString stringWithFormat:@"%u/%ld",(imgindex+1),(unsigned long)self.imgURLarray.count];
    }
    [self freshSubViews];
}

//重新刷新 去掉多余的界面
-(void)freshSubViews
{
    if (self.imgURLarray.count < self.TOTALCOUNT) {
        for (int index = self.imgURLarray.count; index <  self.TOTALCOUNT; index++)
        {
            MRZoomScrollView  *_zoomScrollView = (MRZoomScrollView *)[_scrollView viewWithTag:TAG_ZOOMSCRVIEWSTART + index];
            if (_zoomScrollView) {
                [_zoomScrollView removeFromSuperview];
            }
        }
    }
    self.TOTALCOUNT = self.imgURLarray.count;
}

-(void)gestureTap:(id)sender
{
    self.tappedBlock(self.imgURLarray);
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.backgroundColor=[UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
    }
    return _scrollView;
}
-(id)initWithFrame:(CGRect)frame withurl:(NSString *)url target:(id)target andSEL:(SEL)selaction contentAry:(NSArray *)contentAry
{
    self=[super initWithFrame:frame];
    if (self) {
        if (self.scrollView) {
            _scrollView.frame = CGRectMake(0, 0, frame.size.width,frame.size.height);
            [_scrollView setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 1, frame.size.height)];
        }
        
        _imgURLarray=[[NSMutableArray alloc] init];
        self.contentAry = contentAry;
        if (self.contentAry.count) {
            self.imgURLarray=[NSMutableArray arrayWithArray:[self imgURLAry:self.contentAry]];
        }
        else
        {
            content *acont=[[content alloc] init];
            acont.type=[NSNumber numberWithInt:2];
            acont.msg=url;
            _imgURLarray=[NSMutableArray arrayWithObject:acont];
        }
        
        for (int i = 0; i < self.imgURLarray.count; i++){
            
            MRZoomScrollView  *_zoomScrollView = [[MRZoomScrollView alloc]init];
            CGRect frame = self.scrollView.frame;
            frame.origin.x = frame.size.width * i;
            frame.origin.y = 0;
            _zoomScrollView.frame = frame;
            content *acontent =[self.imgURLarray objectAtIndex:i]; 
            [_zoomScrollView.imageView GET:acontent.originimg useCache:YES];
            self.scrollView.contentSize=CGSizeMake(frame.size.width * (i+1), frame.size.height);
            [self.scrollView addSubview:_zoomScrollView];
        }
        NSUInteger indexImage=[self indexOfImage:url];
        CGRect frame = self.scrollView.frame;
        [self.scrollView setContentOffset:CGPointMake(frame.size.width * indexImage, 0) animated:YES];
        
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selaction];
        [_scrollView addGestureRecognizer:_singleTap];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        if (self.lblTips) {
            _lblTips.text = [NSString stringWithFormat:@"%u/%ld",(indexImage+1),(unsigned long)self.imgURLarray.count];
        }
    }
    return self;
}

-(UILabel *)lblTips
{
    if (!_lblTips) {
        _lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _lblTips.textAlignment = NSTextAlignmentCenter;
        _lblTips.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, self.frame.size.height - 50);
        _lblTips.textColor = [UIColor whiteColor];
        _lblTips.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblTips];
    }
    return _lblTips;
}

-(NSUInteger)currentImageViewIndex
{
    return  self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index =  1 + [self currentImageViewIndex];
    NSUInteger count= self.imgURLarray.count;
    _lblTips.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)index,(unsigned long)count];
}
@end
