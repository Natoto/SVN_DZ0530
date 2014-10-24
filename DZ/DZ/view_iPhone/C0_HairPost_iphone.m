//
//  C0_HairPost.m
//  DZ
//
//  Created by Nonato on 14-4-1.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "C0_HairPost_iphone.h"
#import "AppBoard_iPhone.h"
#import "newTopic.h"
#import "newTopicModel.h"
#import "SETextView.h"
#import "C0_HairPost_ToolsView.h"
#import "TSLocateView.h"
#import "SEPhotoView.h"
#import "C0_HairPost_SelectPlates.h"
#import "LXActionSheet.h"
#import "FaceBoard.h"
#import "HBImagePickerControllerEx.h"
#import "MaskView.h"
#import "UITextView_Boarder.h"
#import "DZ_Timer.h"
#import "DZ_BeeUITextView.h"
#import "C0_ZhuTi_SelectPlates.h"
#import "DZ_SystemSetting.h"
#import "ThreadtypeModel.h"

@implementation DratfStruct

@end

@interface C0_HairPost_iphone ()<UITextViewDelegate,UITextFieldDelegate,LXActionSheetDelegate,FaceBoardDelegate,MaskViewDelegate,C0_ZhuTi_SelectPlatesDelegate,C0_HairPost_SelectPlates>
{
    MaskView  *maskview;
    FaceBoard *inputView;
    NSMutableArray *reloadArray;    //刷新的图片数组
    UILabel *titleLabel;
    UILabel *contentLabel;
    NSArray *aforums;
}
@property (nonatomic, strong) UITextView_Boarder  * titleTxt;
@property (nonatomic, strong) UITextView   * contentTxt;
@property (nonatomic, strong) UIButton     * selectforumbtn;
@property (nonatomic, strong) UIButton     * zhutitn;
@property (nonatomic, strong) SETextView  * fastTextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) newTopicModel * newtpicModel;
@property (nonatomic, strong) C0_HairPost_ToolsView *toolsview;
@property (nonatomic, strong) C0_HairPost_SelectPlates * locateView;
@property (nonatomic, strong) C0_ZhuTi_SelectPlates * zhutiselector;
@property (nonatomic, strong) UIImageView *testimgview;
@property (nonatomic, assign) NSInteger    totalUploadCount;
@property (nonatomic, assign) NSInteger    Uploadindex;
@property (nonatomic, strong) NSMutableArray * UploadedImageAry;
@property (nonatomic, strong) postImageModel * postImgModel;
@property (nonatomic, strong) NSMutableArray * faceAttachments;
@property (nonatomic, strong) NSMutableArray * imageAttachments;
@property (nonatomic, strong) UIView         * headerView;
@end

@implementation C0_HairPost_iphone

DEF_SIGNAL(didpostImage)
DEF_SINGLETON(C0_HairPost_iphone)

-(void)dealloc
{
    [_newtpicModel removeObserver:self];
    [_postImgModel removeObserver:self];
}

-(UIView *)headerView:(CGRect)frame zhuti:(BOOL)zhuti
{
    if (!_headerView) {
        UIView * view = [[UIView alloc] initWithFrame:frame];
        _selectforumbtn =[self createButton:CGRectMake(0, 0, frame.size.width, frame.size.height/2) title:@"选择版块" target:self sel:@selector(showLocateView:) border:YES];
        [view addSubview:_selectforumbtn];
        if (zhuti) {
            _zhutitn = [self createButton:CGRectMake(0, CGRectGetMaxY(_selectforumbtn.frame), CGRectGetWidth(_selectforumbtn.frame), CGRectGetHeight(_selectforumbtn.frame)) title:@"选择主题" target:self sel:@selector(showzhutiSelector:) border:NO];
            [view addSubview:_zhutitn];
        }
        
        float ARRORHEIGHT = 12;
        float MARGIN_RIGHT = 10;
        //箭头
        UIImageView *arrows1 = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"tiaozhuan001"]];
        arrows1.contentMode = UIViewContentModeScaleAspectFit;
        arrows1.frame = CGRectMake(CGRectGetMaxX(frame) - MARGIN_RIGHT- ARRORHEIGHT, CGRectGetHeight(_selectforumbtn.frame)/2-ARRORHEIGHT/2., ARRORHEIGHT, ARRORHEIGHT);
        [_selectforumbtn addSubview:arrows1];

        UIImageView *arrows2 = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"tiaozhuan001"]];
        arrows2.contentMode = UIViewContentModeScaleAspectFit;
        arrows2.frame = CGRectMake(CGRectGetMaxX(frame) - MARGIN_RIGHT- ARRORHEIGHT, CGRectGetHeight(_zhutitn.frame)/2-ARRORHEIGHT/2., ARRORHEIGHT, ARRORHEIGHT);
        [_zhutitn addSubview:arrows2];

        _headerView = view;
    }
    return _headerView;
}

- (UIButton *)createButton:(CGRect)frame title:(NSString *)title target:(id)target sel:(SEL)selector border:(BOOL)border
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    //标题文字靠左
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (border) {
        button.layer.borderWidth = LINE_LAYERBOARDWIDTH;
        button.layer.borderColor = LINE_LAYERBOARDCOLOR;
    }
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    return button;
}


//ON_SIGNAL2( BeeUIBoard, signal )
-(void)viewDidLoad
{
    
    aforums = [ForumlistModel forumsAry];

    _newtpicModel=[newTopicModel modelWithObserver:self];
    _postImgModel=[postImageModel modelWithObserver:self];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage bundleImageNamed:@"fanhui(xin)"]];
    self.navigationBarShown = YES;
    [self showBarButton:BeeUINavigationBar.RIGHT  title:@"发布"];
    
    self.view.backgroundColor = CLR_BACKGROUND; //[UIColor whiteColor];
    self.navigationBarTitle = __TEXT(@"POST");//发帖
    self.navigationBarShown = YES;

    float MARIGINY=10.0;
    float MARGIN_TOP = 10.0;
    /*float MARGIN_LEFT = 10.0;
    float MARGIN_RIGHT = 10.0;
    float BUTTON_HEIGHT = 40;*/
    float MARGIN_V = 10.0f;
    UIEdgeInsets edg = bee.ui.config.baseInsets;
    edg.top = 0.0;
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
  
    /*
     添加选择板块 主题选择按钮
     */
    _headerView =[self headerView:CGRectMake(0, MARGIN_TOP, CGRectGetWidth(mainScreenRect), 80) zhuti:YES];
    [self.view addSubview:_headerView];
    
    /*
     标题和内容排版
     */
    self.titleTxt = [[UITextView_Boarder alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame) + MARGIN_V , mainScreenRect.size.width, 40)];
    self.titleTxt.noboarder = NO;
    self.titleTxt.delegate = self;
    [self.titleTxt setContentInset:UIEdgeInsetsMake(0, 10, 0, -20)];
    self.titleTxt.returnKeyType = UIReturnKeyNext;
    self.titleTxt.tag =TITLTTAG;
    self.titleTxt.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleTxt];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleTxt.frame), CGRectGetWidth(_headerView.frame),190)];
    _scrollView.backgroundColor =[UIColor whiteColor];
    KT_CORNER_RADIUS(_scrollView, 0);
    [self.view addSubview:_scrollView];
 

    SETextView *view = [[SETextView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_scrollView.frame) - 20 ,CGRectGetHeight(_scrollView.frame))];
    view.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleHeight;
    view.delegate = (id<SETextViewDelegate>)self;
    view.lineHeight=-1;
    view.lineSpacing=8;
    view.textColor = [UIColor blackColor];
//    view.font = GB_FontHelveticaNeue(15);
    view.font = [UIFont systemFontOfSize:15];
    view.tag = CONTENTTAG;
    [self.scrollView addSubview:view];
    self.fastTextView = view;
    self.fastTextView.editable = YES;
    self.fastTextView.lineSpacing = 8.0f;
    [self.fastTextView sizeThatFits:_scrollView.frame.size];
    /*
     placeHoder
     */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainScreenRect.size.width-20, 35)];
    titleLabel.text = @"请输入标题，不能超过80字符哦!";
    titleLabel.font = PLACEHOLDERFONT; //[UIFont systemFontOfSize:15];
    titleLabel.textColor = PLACEHOLDERCOLOR; //[UIColor lightGrayColor];
    [self.titleTxt addSubview:titleLabel];

    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainScreenRect.size.width-20, 20)];
    contentLabel.text = @"请输入内容，不少于10个字符哦!";
    contentLabel.font = PLACEHOLDERFONT; //[UIFont systemFontOfSize:15];
    contentLabel.textColor = PLACEHOLDERCOLOR; //[UIColor lightGrayColor];
    [view addSubview:contentLabel];
 
    _locateView = [[C0_HairPost_SelectPlates alloc] initWithTitle:@"版块选择" delegate:self];
    _zhutiselector = [[C0_ZhuTi_SelectPlates alloc] initWithTitle:@"主题选择" delegate:self];
    
    inputView=[[FaceBoard alloc] init];
    inputView.delegate = self;
    inputView.inputTextView = (UITextView *)_fastTextView;
    //toolsview
    self.toolsview = [[C0_HairPost_ToolsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), 33) withTarget:self andFacialSel:@selector(showFace:) andpictureSel:@selector(pictureSelect:) andkeyboardSel:@selector(showKeyboard:)];
    [self.view addSubview:self.toolsview];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _testimgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 300 + MARIGINY*4,200,200)];
    [self.view addSubview:_testimgview];

    _UploadedImageAry=[[NSMutableArray alloc] initWithCapacity:0];
    _imageAttachments=[[NSMutableArray alloc] initWithCapacity:0];
    _faceAttachments=[[NSMutableArray alloc] initWithCapacity:0];
    [self loadDrafts];
    maskview = [[MaskView alloc] initWithFrame:self.fastTextView.frame];
    maskview.delegate =self;
//    }

    if (self.titleTxt.text == nil || self.titleTxt.text.length == 0) {
        titleLabel.hidden = NO;
    } else {
        titleLabel.hidden = YES;
    }

    if (view.text == nil || view.text.length == 0) {
        contentLabel.hidden = NO;
    } else {
        contentLabel.hidden = YES;
    }
}

#pragma mark - 保存草稿
-(void)saveDrafts
{
    return;//先不保存草稿
    DratfStruct *adraft=[[DratfStruct alloc] init];
    adraft.title=self.titleTxt.text;
    adraft.plates=self.selectforumbtn.titleLabel.text;
    adraft.selectfid=self.selectfid;
    [DratfStruct saveObject:adraft forKey:DRAFTSTRUCT];
    
    NSArray * array=[self spliteContentWithattAry:_fastTextView.attachments.allObjects atrributestr:_fastTextView.attributedText UploadedImageAry:self.UploadedImageAry];
    
    [[newTopicModel sharedInstance] savedraft:array];
}

#pragma mark - 加载草稿
-(void)loadDrafts
{
    return ;
    DratfStruct *adraft=[DratfStruct readObjectForKey:DRAFTSTRUCT];
    self.titleTxt.text=adraft.title;
    self.selectfid=adraft.selectfid;
    if (adraft.plates.length) {
        [self.selectforumbtn setTitle:adraft.plates forState:UIControlStateNormal];;
    }    
    NSArray *array =[self.newtpicModel loaddratfs];
    for (int index=0; index<array.count; index++)
    {
        newtopicContent *acont = [array objectAtIndex:index];
        if (acont.type.integerValue == TEXTTYPE) {//文本
            if (![self isFacialMark:acont.msg seTextView:self.fastTextView]) {
                NSAttributedString *atrrstring=[[NSAttributedString alloc] initWithString:acont.msg];
                [self.fastTextView appendAttributedText:atrrstring];
            }
        }
        else if (acont.type.integerValue == IMGTYPE) {//图片
            
        }
        else if (acont.type.integerValue == FACETYPE) {//表情
            NSString *facename = [FaceBoard faceFileName:acont.msg];
            UIImage *stampImage = [UIImage bundleImageNamed:facename];
            if (stampImage) {
                self.fastTextView.addobj_name = acont.msg;
                self.fastTextView.addobj_type = @"2";
                [self.fastTextView insertObject:stampImage size:stampImage.size];
            }
        }
    }
//    [self.newtpicModel clearDrafts];
}

-(BOOL)isFacialMark:(NSString *)mark seTextView:(SETextView *)textview
{
    if ([mark rangeOfString:@":"].location != NSNotFound) {
        NSString *facename=[FaceBoard faceFileName:mark];
        UIImage *stampImage = [UIImage bundleImageNamed:facename];
        if (stampImage) {
            textview.addobj_name=mark;
            textview.addobj_type=@"2";
            [textview insertObject:stampImage size:stampImage.size];
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark 显示选择版块

- (IBAction)showLocateView:(id)sender
{
    [self.zhutiselector resignFirstResponder];
    [self.titleTxt resignFirstResponder];
    [self.fastTextView resignFirstResponder];
    [_locateView showInView:self.view];
    maskview.frame = self.frame;
    [maskview showInView:self.view belowSubview:_locateView];
}


#pragma mark 显示主题
- (IBAction)showzhutiSelector:(id)sender
{
    if (!self.selectfid) {
        [self presentMessageTips:@"请先选择版块"];
        return;
    }
   [ThreadtypeModel readthreadtype:self.selectfid block:^(NSArray *block) {
       NSArray *athread = block;       
       if (athread.count) {
           NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithCapacity:0];
           for (int index = 0; index < athread.count; index ++) {
               threadtype *athreaddic=[athread objectAtIndex:index];
               NSString *value = athreaddic.name;
               NSString *key =[NSString stringWithFormat:@"%@",athreaddic.id];
               [dic setObject:key forKey:value];
           }
           [self.zhutiselector setDataDic:dic];
           [self.zhutiselector showInView:self.view];
           [self.titleTxt resignFirstResponder];
           [self.fastTextView resignFirstResponder];
           [_locateView resignFirstResponder];
           
           maskview.frame = self.frame;
           [maskview showInView:self.view belowSubview:_zhutiselector];
       }
//       else
//       {
//           self.typedid = nil;
//           [self.zhutitn setTitle:@"无主题" forState:UIControlStateNormal];
//           //         [self presentMessageTips:@"无主题"];
//       }       
    }];
   
}


-(void)updatezhutiInfo:(NSString *)fid
{
    if (!fid) {
//        [self presentMessageTips:@"请先选择版块"];
        return;
    }
    @weakify(self)
    //    NSArray *forums=[ForumlistModel forumsAry];
     NSString *oldselectfid = [NSString stringWithFormat:@"%@",self.selectfid];
     self.selectfid = fid;
    [ThreadtypeModel readthreadtype:fid block:^(NSArray *block) {
        NSArray *athread = block;
        @normalize(self);
        if (athread.count && oldselectfid!=fid) {
            threadtype  *athreaddic=[athread objectAtIndex:0];
            NSString * key =[NSString stringWithFormat:@"%@", athreaddic.id];
            // [athreaddic valueForKey:@"key"];
            self.typedid = [NSNumber numberWithInt:key.intValue];
            NSString *value = athreaddic.name;
            //[athreaddic valueForKey:@"value"];
            [self.zhutitn setTitle:value forState:UIControlStateNormal];
        }
        if (!athread || !athread.count) {
            self.typedid = nil;
            [self.zhutitn setTitle:@"无主题" forState:UIControlStateNormal];
            [self.zhutitn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else
        {
            [self.zhutitn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
}
#pragma mark -
#pragma mark 图片拍照选择
-(IBAction)pictureSelect:(UIButton*)sender
{
    [self.zhutiselector resignFirstResponder];
    [self.titleTxt resignFirstResponder];
    [self.fastTextView resignFirstResponder];
    [_locateView cancel:nil];
    
    LXActionSheet *sheet;
    // 判断是否支持相机
    if([HBImagePickerControllerEx isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    } else {
        sheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册选择"]];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
    [self.view bringSubviewToFront:sheet];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
   BeeLog(@"%d",(int)buttonIndex);
     [self selectpicture:nil andclickedButtonAtIndex:(int)buttonIndex];
}

- (void)didClickOnDestructiveButton
{
   BeeLog(@"destructuctive");
}

- (void)didClickOnCancelButton
{
   BeeLog(@"cancelButton");
}

#pragma mark - actionsheet delegate
//-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 255) {
//       
//    }
//    else
//    {
//        if (buttonIndex==0 || buttonIndex==1) {
//            [self selectPlates:actionSheet andclickedButtonAtIndex:buttonIndex];
//        }
//    }
//}
#pragma mark  - 选择版块 选择主题
-(void)C0_HairPost_SelectPlates:(C0_HairPost_SelectPlates *)action select_LoacateChild:(LoacateChild *)loate clickedButtonAtIndex:(NSInteger)index
{
//-(void)selectPlates:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
    if(index == 0) {
        BeeLog(@"Cancel");
        [maskview hiddenMask];
        return;
    }
    if ([[action class] isSubclassOfClass:[C0_HairPost_SelectPlates class]]) {
        C0_HairPost_SelectPlates *locateView = (C0_HairPost_SelectPlates *)action;
        LoacateChild *location = locateView.locate;
        if (location.child) {
            BeeLog(@"name:%@ fid:%@ lastpost:%@", location.child.name, location.child.fid, location.child.lastpost);
            
            NSString *key=[NSString stringWithFormat:@"%@ / %@",location.parent.name,location.child.name];
            NSString * selectfid = [NSString stringWithFormat:@"%@",loate.child.fid];
            if (location.subchild) {
                key=[NSString stringWithFormat:@"%@ / %@ /%@",location.parent.name,location.child.name,location.subchild.name];
                selectfid = [NSString stringWithFormat:@"%@",location.subchild.fid];
            };
            [self.selectforumbtn setTitle:key forState:UIControlStateNormal];
            [self updatezhutiInfo:selectfid];
        }
        //You can uses location to your application.
        
    }
    
    
}

-(void)C0_ZhuTi_SelectPlates:(C0_ZhuTi_SelectPlates *)action select_thtps:(THTPS_SELECT *)loate clickedButtonAtIndex:(NSInteger)index
{
    //选择主题
        if(index == 0) {
            BeeLog(@"Cancel");
            [maskview hiddenMask];
            return;
        }
        C0_ZhuTi_SelectPlates *zhutiView = (C0_ZhuTi_SelectPlates *)action;
        THTPS_SELECT *item = zhutiView.locate;
        NSString *key=[NSString stringWithFormat:@"%@",item.threadtypesitem];
        if([key rangeOfString:@"null"].location == NSNotFound)
        {
            if (item.typedid) {
                self.typedid = [NSNumber numberWithInt:item.typedid.intValue];
                [self.zhutitn setTitle:key forState:UIControlStateNormal];
            }
        }
    
}
-(void)selectpicture:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([HBImagePickerControllerEx isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 2:
                // 取消
                return;
            case 0:
                // 相机
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
                break;
            }
            case 1:
                // 相册
            {
                 sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self selectFromAblum];
            }
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self selectFromAblum];
    }
    }
}
#pragma mark - 打开相机
- (void)showcamera
{
    UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
    [m_imagePicker setDelegate:self];
    [m_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [m_imagePicker setAllowsEditing:NO];
    [self presentViewController:m_imagePicker animated:YES completion:nil];
}

#pragma mark - 从相册中选择
-(void)selectFromAblum{
    
    HBImagePickerControllerEx *m_imagePicker = [[HBImagePickerControllerEx alloc] init];
    [m_imagePicker setDelegate:self];
    [m_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [m_imagePicker setAllowsEditing:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self presentViewController:m_imagePicker animated:YES completion:nil];
    
    /*暂时不用选择多个图片
     
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];    
    [self presentViewController:picker animated:YES completion:NULL];*/
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
       
        if ([mediaType isEqualToString:@"public.image"]){
            [self handleCanmearInfo:info];
        }
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [self handleAblumInfo:info];
    }
}
-(void)handleCanmearInfo:(NSDictionary *)info
{
    NSData *data;
    //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片压缩，因为原图都是很大的，不必要传原图
    UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    if (UIImagePNGRepresentation(scaleImage) == nil) {
        //将图片转换为JPG格式的二进制数据
        data = UIImageJPEGRepresentation(scaleImage, 0.5);
    } else {
        //将图片转换为PNG格式的二进制数据
        data = UIImagePNGRepresentation(scaleImage);
    } //        //将二进制数据生成UIImage
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
    photoView.image = image;
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[[NSDate date] stringWithDateFormat:@"yyyy_MM_dd_HH_MM_SS"]];
    self.fastTextView.addobj_name=fileName;
    self.fastTextView.addobj_type=@"1";
    [self.fastTextView insertObject:photoView size:photoView.bounds.size];
    [self dismissViewControllerAnimated:YES completion:NULL];
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)handleAblumInfo:(NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        UIImage *image=[UIImage imageWithCGImage:myasset.defaultRepresentation.fullScreenImage];
        //            UIImageJPEGRepresentation(image, 0.5);
        SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
        CGImageRef iref = [representation fullResolutionImage];
        NSString *fileName = representation.filename;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (iref) {
                photoView.image = image;
                self.fastTextView.addobj_name=fileName;
                self.fastTextView.addobj_type=@"1";
                [self.fastTextView insertObject:photoView size:photoView.bounds.size];
            }
        });
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];    
    [self dismissViewControllerAnimated:YES completion:NULL];
 
}



#pragma mark - 相册选择完成 ZYQAssetPickerController Delegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
////    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        src.contentSize=CGSizeMake(assets.count*src.frame.size.width, src.frame.size.height);
//        dispatch_async(dispatch_get_main_queue(), ^{
////            pageControl.numberOfPages=assets.count;
//        });
//        
//        for (int i=0; i<assets.count; i++) {
//            ALAsset *asset=assets[i];
//            ALAssetRepresentation *representation = [asset defaultRepresentation];
//            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
////            UIImageJPEGRepresentation(image, 0.5);
//            SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
//            CGImageRef iref = [representation fullResolutionImage];
//            NSString *fileName = representation.filename;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (iref) {
//                    photoView.image = image;
//                    self.fastTextView.addobj_name=fileName;
//                    self.fastTextView.addobj_type=@"1";
//                    [self.fastTextView insertObject:photoView size:photoView.bounds.size];
//                }
//            });
//        }
//    });
//}


//#pragma 拍照选择照片协议方法
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    
//    
//}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - 添加表情
-(IBAction)showFace:(UIButton*)sender
{
    if (![_fastTextView isFirstResponder]) {
        [_fastTextView becomeFirstResponder];
    }
    _fastTextView.inputView=inputView;
    [_fastTextView reloadInputViews];
    [self.toolsview showKeyboardBtn:YES];
}
-(IBAction)showKeyboard:(id)sender
{
    if (![_fastTextView isFirstResponder]) {
        return;
    }
    [self.toolsview showKeyboardBtn:NO];
    _fastTextView.inputView=nil;
    [_fastTextView reloadInputViews];
}
-(void)faceboardBackface
{
    [self.fastTextView deleteBackward];
}

-(void)facebuttonTap:(id)sender andName:(NSString *)name
{
    UIButton *button = sender;
    UIImage *stampImage = [button imageForState:UIControlStateNormal];
    if (stampImage) {
        self.fastTextView.addobj_name=name;
        self.fastTextView.addobj_type=@"2";
        [self.fastTextView insertObject:stampImage size:stampImage.size];
    }
}

- (void)_addEmotion:(NSString *)emotionImgName;
{
    
}


-(IBAction)dismissKeyBoard:(id)sender {
    [_fastTextView resignFirstResponder];
}
#pragma mark - 发布成功
ON_SIGNAL3(newTopicModel, RELOADED, signal)
{
    BeeLog(@"-------success------");
    [self dismissTips];
    [self presentMessageTips:@"发布成功"];
    [bee.ui.appBoard hideSendhtm];
    [self.newtpicModel clearDrafts];
    [DratfStruct removeObjectForKey:DRAFTSTRUCT];
    [[DZ_Timer sharedInstance] endPush];
}


ON_SIGNAL3(newTopicModel, FAILED, signal)
{
    BeeLog(@"-------FAILED------");
    [self dismissTips];
    NSString *errmsg=[NSString stringWithFormat:@"发布失败,%@",signal.object];
    [self presentMessageTips:errmsg];
}
#pragma mark - 切分句子将文件和图片分开提取句子
-(NSMutableArray *)spliteContentWithattAry:(NSArray *)attAry atrributestr:(NSAttributedString *)AttributedString UploadedImageAry:(NSMutableArray *)UploadedImageAry
{
    NSMutableArray *contentTextAry=[[NSMutableArray alloc] init];
    NSMutableArray *array=[NSMutableArray arrayWithArray:attAry];
    if (!attAry.count) {
        newtopicContent *acont1=[[newtopicContent alloc] init];
        acont1.msg=AttributedString.string;
        acont1.type=[NSNumber numberWithInt:TEXTTYPE];
        [contentTextAry addObject:acont1];
        [contentTextAry addObject:[C0_HairPost_iphone pushDeviceMark]];
        return contentTextAry;
    }
    NSSortDescriptor *goodscodeDesc = [NSSortDescriptor sortDescriptorWithKey:@"sortforRangLocation" ascending:YES];
    NSArray *descs = @[goodscodeDesc];
    array =[NSMutableArray arrayWithArray:[attAry sortedArrayUsingDescriptors:descs]];
    
    int imgIndex=0;
    for (int index=0;index<array.count;index++) {
        id object=[array objectAtIndex:index];
        if (![[object class] isSubclassOfClass:NSClassFromString(@"SETextAttachment")]) {
            continue;
        }
        SETextAttachment *achtment=(SETextAttachment *)object;
        if (index==0) {
            if (achtment.range.location) {
                NSAttributedString *substr=[AttributedString attributedSubstringFromRange:NSMakeRange(0, achtment.range.location)];
                newtopicContent *acont1=[[newtopicContent alloc] init];
                acont1.msg=substr.string;
                acont1.type=[NSNumber numberWithInt:TEXTTYPE];
                [contentTextAry addObject:acont1];
            }
            if ([achtment.type isEqual:@"1"]) {
                if (UploadedImageAry.count>imgIndex) {
                    newtopicContent *imgcont=[UploadedImageAry objectAtIndex:imgIndex];//加入图片
                    [contentTextAry addObject:imgcont];
                    imgIndex++;
                }
            }
            else if ([achtment.type isEqual:@"2"]) {
                newtopicContent *facecont=[[newtopicContent alloc] init];
                facecont.msg=achtment.name;
                facecont.type=[NSNumber numberWithInt:FACETYPE];
                [contentTextAry addObject:facecont];
            }
        }
        else
        {
            SETextAttachment *lastachtment=[array objectAtIndex:index-1];
            NSUInteger lastpostion=lastachtment.range.location+lastachtment.range.length;
            if (achtment.range.location >  lastpostion) {
                NSAttributedString *substr=[AttributedString attributedSubstringFromRange:NSMakeRange(lastpostion,(achtment.range.location-lastpostion))];
                newtopicContent *acont1=[[newtopicContent alloc] init];
                acont1.msg=substr.string;
                acont1.type=[NSNumber numberWithInt:TEXTTYPE];
                [contentTextAry addObject:acont1];
            }
            if ([achtment.type isEqual:@"1"]) {//图片
                if (UploadedImageAry.count>imgIndex) {
                    newtopicContent *imgcont=[UploadedImageAry objectAtIndex:imgIndex];//加入图片
                    [contentTextAry addObject:imgcont];
                    imgIndex++;
                }
            }
            else if ([achtment.type isEqual:@"2"]) {//表情
                newtopicContent *facecont=[[newtopicContent alloc] init];
                facecont.msg=achtment.name;
                facecont.type=[NSNumber numberWithInt:FACETYPE];
                [contentTextAry addObject:facecont];
            }
            
        }
    }
     SETextAttachment *achtment=[array lastObject];
    if ((achtment.range.location+achtment.range.length)<(AttributedString.length)) {
        NSUInteger length=AttributedString.length-(achtment.range.location+achtment.range.length);
        NSUInteger location=achtment.range.location+achtment.range.length ;
        NSAttributedString *substr=[AttributedString attributedSubstringFromRange:NSMakeRange(location,length)];
        newtopicContent *acont1=[[newtopicContent alloc] init];
        acont1.msg=substr.string;
        acont1.type=[NSNumber numberWithInt:TEXTTYPE];
        [contentTextAry addObject:acont1];
    }
    /*插入标签 发布于iOS客户端*/
    [contentTextAry addObject:[C0_HairPost_iphone pushDeviceMark]];
    return contentTextAry;
}
#pragma mark - 发布标签
+(newtopicContent *)pushDeviceMark
{
    newtopicContent *acont1=[[newtopicContent alloc] init];
    NSString * device = [ToolsFunc   deviceType];
    acont1.msg= TL_PUSTMAK(device) ;
    acont1.type=[NSNumber numberWithInt:TEXTTYPE];
    return acont1;
}

#pragma mark - 发帖按钮

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    [self.titleTxt resignFirstResponder];
    [self.fastTextView resignFirstResponder];
    [self.zhutiselector resignFirstResponder];
    
    self.titleTxt.text = self.titleTxt.text.trim;
    self.fastTextView.text = self.fastTextView.text.trim;
    if (!self.titleTxt.text.length) {
        [self presentMessageTips:@"帖子标题不能为空"];
        return;
    }
    
    NSUInteger titlelength =[NSString unicodeLengthOfString:self.titleTxt.text];
    if (titlelength >80)
    {
        [self presentMessageTips:[NSString stringWithFormat:@"标题超过最大长度80个字符，需删除%u个字符",titlelength - 80]];
        return;
    }
    if (!self.selectfid) {
        [self presentMessageTips:@"请选择版块"];
        return;
    }
    NSUInteger length =[NSString unicodeLengthOfString:self.fastTextView.text];
    if (length < 10) {
        [self presentMessageTips:@"帖子内容不能少于10个字符"];
        return;
    }
    NSUInteger pushinterval = [DZ_Timer sharedInstance].publishcount;
    if (!pushinterval) {
        [self startuploadimg];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"您发布太快，%lds后重试",(unsigned long)pushinterval];
        [self presentMessageTips:msg];
    }
}

ON_SIGNAL3(C0_HairPost_iphone, didpostImage, signal)
{
    
     [self presentLoadingTips:@"帖子发布中"];
     BeeLog(@"======发布========%@",_fastTextView.text);
     
     self.newtpicModel.typedid = self.typedid;
     self.newtpicModel.fid = self.selectfid;
     self.newtpicModel.subject=self.titleTxt.text; //@"我的测试1——HB";
     self.newtpicModel.authorid=[UserModel sharedInstance].session.uid; //self.titleTxt.text;
     NSString *author=[UserModel sharedInstance].session.username;
     self.newtpicModel.author=author;
     newtopicContent *acont=[[newtopicContent alloc] init];
     acont.msg=_fastTextView.text;
     acont.type=[NSNumber numberWithInt:0];     
     self.newtpicModel.contents=[self spliteContentWithattAry:_fastTextView.attachments.allObjects atrributestr:_fastTextView.attributedText UploadedImageAry:self.UploadedImageAry];
     [self.newtpicModel load];
     [self.newtpicModel firstPage];
}

-(void)startuploadimg
{
    [_imageAttachments removeAllObjects];
    [_faceAttachments removeAllObjects];
    for ( id object in _fastTextView.attachments.allObjects ) {
        if ([[object class] isSubclassOfClass:[SETextAttachment class]]) {
             SETextAttachment *setxt=(SETextAttachment *)object;
            if ([setxt.type isEqual:@"1"]) {//图片
                [_imageAttachments addObject:setxt];
            }
            else if([setxt.type isEqual:@"2"])
            {
                [_faceAttachments addObject:setxt];
            }
        }
    }
    
    self.Uploadindex=0;
    self.totalUploadCount=_imageAttachments.count;
    if (!self.totalUploadCount) {
        [self sendUISignal:self.didpostImage];
        return;
    }
    id object = [_imageAttachments objectAtIndex:_Uploadindex];
    if ([[object class] isSubclassOfClass:[SETextAttachment class]]) {
        SETextAttachment *setxt=(SETextAttachment *)object;
        [self uploadImage:setxt];
    }

}

#pragma mark - 上传图片
-(void)uploadImage:(SETextAttachment *)setxt
{
        _postImgModel.fid=self.selectfid;
        _postImgModel.uid=[UserModel sharedInstance].session.uid;
        SEPhotoView *photoview=setxt.object;
        _postImgModel.filename=setxt.name; 
        _postImgModel.filedata=UIImageJPEGRepresentation(photoview.image, 0.5);
    
        [_postImgModel load];
        [_postImgModel firstPage];
        [self presentLoadingTips:[NSString stringWithFormat:@"正在上传(%d/%ld)",self.Uploadindex+1,(long)self.totalUploadCount]];
}

ON_SIGNAL3(postImageModel, FAILED, signal)
{
    [self dismissTips];
      NSString *errmsg=[NSString stringWithFormat:@"图片上传失败,%@",signal.object];
    [self presentMessageTips:errmsg];
}

ON_SIGNAL3(postImageModel, RELOADED, signal)
{
    postImageModel *postmodel=(postImageModel *)signal.sourceViewModel;
    newtopicContent *imgcontent=[[newtopicContent alloc] init];
    imgcontent.msg=postmodel.filename;
    imgcontent.type=[NSNumber numberWithInt:IMGTYPE];
    imgcontent.aid=postmodel.postimge.aid;
    [self.UploadedImageAry addObject:imgcontent];
    self.Uploadindex=self.Uploadindex + 1;
    if (self.Uploadindex < self.totalUploadCount)
    {
        SETextAttachment *setxt = [_imageAttachments objectAtIndex:_Uploadindex];
        [self uploadImage:setxt];
    }
    else
    {
        [self dismissTips];
        [self presentMessageTips:@"图片上传成功"];
        [self sendUISignal:self.didpostImage];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==235) {
        if (buttonIndex==1) {//保存草稿
//            [self saveDrafts];
        }
        else
        {
            [bee.ui.appBoard hideSendhtm];
        }
    }
    
}
#pragma mark - 退出编辑状态
ON_LEFT_BUTTON_TOUCHED(signal)
{
    if (self.titleTxt.text.length || self.fastTextView.text.length) {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃编辑" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续", nil];
        alertview.tag=235;
        [alertview show];
    }
    else
    { 
       [bee.ui.appBoard hideSendhtm];
    }
    
}


#pragma mark -
#pragma mark fastTextViewDelegate

- (void)viewWillLayoutSubviews
{
    [self updateLayout];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if (self.titleTxt.isFirstResponder) {
        return;
    }
    [self resizeTextView:notification];
    UIEdgeInsets edg= bee.ui.config.baseInsets;
    edg.top = 0.0;
    NSDictionary* info  =  [notification userInfo];
    CGSize keyBoardSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, edg.top + 10, self.scrollView.frame.size.width,self.view.bounds.size.height -edg.top - keyBoardSize.height-TOP_VIEW_HEIGHT - 10);
    self.toolsview.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), self.scrollView.frame.size.width, TOP_VIEW_HEIGHT);
    [self.view bringSubviewToFront:self.toolsview];
    [UIView commitAnimations];
}

-(void)MaskViewDidTaped:(id)object
{
    [_zhutiselector resignFirstResponder];
    [self.titleTxt resignFirstResponder];
    [self.locateView resignFirstResponder];
    [maskview hiddenMask];
}



-(void)keyboardWillHide:(NSNotification *)notification
{
    [self resizeTextView:notification];
//    UIEdgeInsets edg= bee.ui.config.baseInsets;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.scrollView.frame =CGRectMake(0, CGRectGetMaxY(_titleTxt.frame), CGRectGetWidth(_scrollView.frame),CGRectGetHeight(_scrollView.frame));
    self.toolsview.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), self.bounds.size.width, TOP_VIEW_HEIGHT);
    [self.toolsview showKeyboardBtn:NO];
//    self.toolsview.frame=CGRectMake(0, edg.top + 280 + 10*4, CGRectGetWidth([UIScreen mainScreen].bounds) , 33);
    [UIView commitAnimations];
}

-(void)resizeTextView:(NSNotification *)notify
{
    self.scrollView.scrollEnabled = NO;
	CGRect keyboardBounds;
    [notify.userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	CGRect containerFrame = self.scrollView.frame;
    containerFrame.size.height = 300;//CGRectGetHeight(self.view.bounds) - CGRectGetHeight(keyboardBounds);
	self.scrollView.frame = containerFrame;
    self.scrollView.scrollEnabled = YES;
}

- (void)updateLayout
{
    CGSize containerSize = self.scrollView.frame.size;
    CGSize contentSize = [self.fastTextView sizeThatFits:containerSize];
    CGRect frame = self.fastTextView.frame;
    frame.size.height = MAX(contentSize.height, containerSize.height);
    
    self.fastTextView.frame = frame;
    self.scrollView.contentSize = frame.size;
    [self.scrollView scrollRectToVisible:self.fastTextView.caretRect animated:YES];
    
}

#pragma mark -

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == TITLTTAG) {
        maskview.frame = _fastTextView.frame;
        [maskview showInView:_fastTextView];
        [self.zhutiselector resignFirstResponder];
        [self.fastTextView resignFirstResponder];
        [self.locateView cancel:nil];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == TITLTTAG) {
        NSUInteger length =[NSString unicodeLengthOfString:textField.text];
        if (length >80) {
            [self presentMessageTips:[NSString stringWithFormat:@"标题超过最大长度80个字符，需删除%u字符",length - 80]];
        }
    }
} 
- (void)textViewDidBeginEditing:(SETextView *)textView
{
    if (textView.tag == TITLTTAG) {
         maskview.frame = _fastTextView.frame;
        [maskview showInView:_fastTextView];
        [self.zhutiselector resignFirstResponder];
        [self.fastTextView resignFirstResponder];
        [self.locateView cancel:nil];
        self.toolsview.hidden = YES;
        titleLabel.hidden = YES;
 
    }
    if (textView.tag == CONTENTTAG) {
        [self.zhutiselector resignFirstResponder];
        [self.titleTxt resignFirstResponder];
        [self.locateView cancel:nil];
        contentLabel.hidden = YES;
    }
//    self.doneButton.enabled = YES;
}

- (void)textViewDidEndEditing:(SETextView *)textView
{
    if (textView.tag == TITLTTAG) {
         NSUInteger length = [NSString unicodeLengthOfString:self.titleTxt.text];
        if (length > 80) {
            [self presentMessageTips:[NSString stringWithFormat:@"标题超过最大长度80个字符，需删除%u个字符", length - 80]];
        }        
        [self.titleTxt updatePlaceHolder];
        self.toolsview.hidden = NO;
        if (textView.text.length == 0) {
            titleLabel.hidden = NO;
        }
    }
//    self.doneButton.enabled = NO;
//    [self.fastTextView  resignFirstResponder];
    if (textView.tag == CONTENTTAG && textView.text.length == 0) {
        contentLabel.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag == TITLTTAG)
    {
        if ( [text isEqualToString:@"\n"] || [text isEqualToString:@"\r"] )
        {
           [maskview hiddenMask];
//           [self showLocateView:nil];
            [self.fastTextView becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}
- (void)textViewDidChangeSelection:(SETextView *)textView
{
     if (textView.tag == TITLTTAG)
     {
//         [self.titleTxt updatePlaceHolder];
         
     }
    if (textView.tag == CONTENTTAG) {
        NSRange selectedRange = textView.selectedRange;
        if (selectedRange.location != NSNotFound && selectedRange.length > 0) {
            //        self.inputAccessoryView.boldButton.enabled = YES;
            //        self.inputAccessoryView.nomalButton.enabled = YES;
        }
        else {
            //        self.inputAccessoryView.boldButton.enabled = NO;
            //        self.inputAccessoryView.nomalButton.enabled = NO;
        }
    }
}

- (void)textViewDidChange:(SETextView *)textView
{
    if (textView.tag == CONTENTTAG) {
        [self updateLayout];
    }
    
}

@end
