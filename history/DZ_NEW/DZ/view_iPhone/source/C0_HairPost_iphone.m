//
//  C0_HairPost_SelectPlates.m
//  DZ
//
//  Created by nonato on 14-10-28.
//
//
#import <AssetsLibrary/AssetsLibrary.h>

#import "AppBoard_iPhone.h"
#import "C0_HairPost_iphone.h"
#import "ThreadtypeModel.h"

#import "C0_HairPost_SelectPlates.h"
#import "C0_ZhuTi_SelectPlates.h"
#import "MaskView.h"
#import "C0_HairEditFieldeCell.h"
#import "C0_HairEditTextViewCell.h"
#import "C0_HairPostAddPhotoCell.h"
#import "C0_HairPost_ToolFun.h"
#import "C0_HairPostPhotoCell.h"
#import "B4_PreviewImageView.h"

#import "HBImagePickerControllerEx.h"
#import "LXActionSheet.h"
#import "SEPhotoView.h"
#import "DZ_Timer.h"
#import "postImageModel.h"
#import "UserModel.h"
#import "newTopicModel.h"
#import "UIImage+FixOrientation.h"

#define NO_ZHUTI @"无主题"
#define CLR_GRAY @"gray"
#define CLR_BLACK @"black"

#define KEY_INDEXPATH(SECTION,ROW) [NSString stringWithFormat:@"section%u_%u",SECTION,ROW]

@interface CELL_STRUCT : NSObject
@property(nonatomic,assign) CGFloat     cellheight;
@property(nonatomic,assign) SEL         sel_selector;
@property(nonatomic,strong) NSString  * key_indexpath;
@property(nonatomic,strong) NSString  * cellclass;
@property(nonatomic,strong) NSString  * title;
@property(nonatomic,strong) NSString  * placeHolder;
@property(nonatomic,strong) NSString  * titlecolor;
@property(nonatomic,strong) NSString  * cellctr;
@property(nonatomic,strong) NSString  * picture;
@property(nonatomic,strong) NSString  * rightComponts;
@property(nonatomic,strong) NSString  * rightValue;
@property(nonatomic,assign) BOOL        accessory;
@property(nonatomic,assign) BOOL        selectionStyle;
@property(nonatomic,strong) NSMutableArray * array;
@property(nonatomic,strong) NSMutableArray * uploadobjcts;
@property(nonatomic,assign) NSInteger       uploadingIndex;
@property(nonatomic,assign) id              delegate;
-(id)initWithtitle:(NSString *)title cellclass:(NSString *)cellclass placeholder:(NSString *)placehoder accessory:(BOOL)accessory sel_selctor:(SEL)selector delegate:(id)delegate;
@end


@implementation CELL_STRUCT
-(id)initWithtitle:(NSString *)title cellclass:(NSString *)cellclass placeholder:(NSString *)placehoder accessory:(BOOL)accessory sel_selctor:(SEL)selector delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.uploadingIndex = 0;
        self.selectionStyle = YES;
        self.uploadobjcts = [[NSMutableArray alloc] initWithCapacity:0];
        self.array = [[NSMutableArray alloc] initWithCapacity:0];
        self.cellheight = 45.0;
        self.titlecolor = CLR_BLACK;
        self.title = title;
        self.cellclass = cellclass;
        self.placeHolder = placehoder;
        self.accessory = accessory;
        self.sel_selector = selector;
        self.delegate = delegate;
    }
    return self;
}

@end


@interface C0_HairPost_iphone ()<MaskViewDelegate,C0_HairPost_SelectPlates,C0_ZhuTi_SelectPlatesDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,LXActionSheetDelegate,C0_HairPostBaseCellDelegate>
{

}
AS_SIGNAL(didpostImage)
//@property(nonatomic,strong) UIButton  * selectforumbtn;
//@property(nonatomic, strong) UIButton * selectzhutibtn;
@property(nonatomic,strong) NSString  * selectfid;
@property(nonatomic,strong) MaskView  * maskview;

@property (nonatomic, strong) C0_HairPost_SelectPlates * locateView;
@property (nonatomic, strong) C0_ZhuTi_SelectPlates * zhutiselector;
@property (nonatomic, strong) BeeUITextField * titlefield;
@property (nonatomic, strong) BeeUITextView  * contentview;
@property (nonatomic, strong) B4_PreviewImageView * previewView;

@property (nonatomic,strong) NSMutableDictionary * dataDictionary;
@property(nonatomic,strong) NSNumber * typedid;
@property (nonatomic,strong) postImageModel * postImgModel;
@property (nonatomic,strong) newTopicModel * newtpicModel;
@end

@implementation C0_HairPost_iphone
DEF_SIGNAL(didpostImage)

- (void)viewDidLoad {
    self.noFooterView = YES;
    self.noHeaderFreshView = YES;
    [super viewDidLoad];
    
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage bundleImageNamed:@"fanhui(xin)"]];
    self.navigationBarShown = YES;
    [self showBarButton:BeeUINavigationBar.RIGHT  title:@"发布"];
    self.tableViewList.backgroundColor = CLR_BACKGROUND; //[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1]; //CLR_BACKGROUND; //[UIColor whiteColor];
    self.navigationBarTitle = __TEXT(@"POST");//发帖
    self.navigationBarShown = YES;
    self.tableViewList.showsVerticalScrollIndicator = NO;
    
    self.postImgModel = [postImageModel modelWithObserver:self];
    self.newtpicModel = [newTopicModel modelWithObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
    [self.newtpicModel removeObserver:self];
    [self.postImgModel removeObserver:self];
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

-(MaskView *)maskview
{
    if (!_maskview) {
        _maskview = [[MaskView alloc] initWithFrame:self.tableViewList.frame];
        _maskview.delegate =self;
    }
    return _maskview;
}

/*
-(UIButton *)selectzhutibtn
{
    if (!_selectzhutibtn) {
        _selectzhutibtn = [self createButton:CGRectMake(0, 0, CGRectGetWidth(_selectforumbtn.frame), CGRectGetHeight(_selectforumbtn.frame)) title:@"选择主题" target:self sel:@selector(showzhutiSelector:) border:NO];
    }
    return _selectzhutibtn;
}

-(UIButton *)selectforumbtn
{
    if (!_selectforumbtn) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _selectforumbtn =[self createButton:CGRectMake(0, 0, frame.size.width, frame.size.height/2) title:@"选择版块" target:self sel:@selector(showLocateView:) border:YES];
    }
    return _selectforumbtn;
}
*/


-(NSMutableDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        
        CELL_STRUCT * cell0_0;
        CELL_STRUCT * cell0_1;
        
        CELL_STRUCT * cell1_0;
        CELL_STRUCT * cell1_1;
        
        CELL_STRUCT * cell2_0;
        CELL_STRUCT * cell2_1;
        cell0_0 = [[CELL_STRUCT alloc] initWithtitle:@"选择板块" cellclass:@"C0_HairPostBaseCell" placeholder:@"" accessory:YES sel_selctor:@selector(showLocateView:) delegate:self];
        
        cell0_1 = [[CELL_STRUCT alloc] initWithtitle:@"选择主题" cellclass:@"C0_HairPostBaseCell" placeholder:@"" accessory:YES sel_selctor:@selector(showzhutiSelector:) delegate:self];
        
        cell1_0 = [[CELL_STRUCT alloc] initWithtitle:@"" cellclass:@"C0_HairEditFieldeCell" placeholder:@"请输入标题，不能超过80字符哦！" accessory:NO sel_selctor:nil delegate:self];
        cell1_0.selectionStyle = NO;
        
        cell1_1 = [[CELL_STRUCT alloc] initWithtitle:@"" cellclass:@"C0_HairEditTextViewCell" placeholder:@"请输入内容，不能少于10个字符哦！" accessory:NO sel_selctor:nil delegate:self];
        cell1_1.cellheight = C0TXTVIEW_HEIGHT;
        cell1_1.selectionStyle = NO;
        
        cell2_0 = [[CELL_STRUCT alloc] initWithtitle:@"" cellclass:@"C0_HairPostPhotoCell" placeholder:@"" accessory:NO sel_selctor:nil delegate:self];
        cell2_0.cellheight = 0;
        
        NSString * cl2_1title= [C0_HairPostAddPhotoCell uploadPhotoMode] == UPLPHOTOMODE_HIGH ? @"添加照片(高清 )":@"添加照片(标清)";
        cell2_1 = [[CELL_STRUCT alloc] initWithtitle:cl2_1title cellclass:@"C0_HairPostAddPhotoCell" placeholder:@"" accessory:NO sel_selctor:@selector(pictureSelect:) delegate:self];
        cell2_1.rightComponts = @"UISwitch";
        
//        _dataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"选择板块",@"section0_0",@"选择主题",@"section0_1",@"请输入标题，不能超过80字符哦！",@"section1_0",@"请输入内容，不能少于10个字符哦！",@"section1_1",@"添加照片",@"section1_2", nil];
        
         _dataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell0_0,@"section0_0",cell0_1,@"section0_1",cell1_0,@"section1_0",cell1_1,@"section1_1",cell2_0,@"section2_0",cell2_1,@"section2_1",nil];
        
    }
    return _dataDictionary;
}

-(C0_HairPost_SelectPlates *)locateView
{
    if (!_locateView) {
        _locateView = [[C0_HairPost_SelectPlates alloc] initWithTitle:@"版块选择" delegate:self];
        
    }
    return _locateView;
}
-(C0_ZhuTi_SelectPlates *)zhutiselector
{
    if (!_zhutiselector) {
        _zhutiselector = [[C0_ZhuTi_SelectPlates alloc] initWithTitle:@"主题选择" delegate:self];
    }
    return _zhutiselector;
}

#pragma mark  - maskview delegate
-(void)MaskViewDidTaped:(id)object
{
    
}
#pragma mark  - KVO

ON_SIGNAL3(BeeUITextField,WILL_ACTIVE , signal)
{
    BeeUITextField * txtfield = (BeeUITextField *) signal.sourceView;
    if (txtfield.tag == TXTFIELD_TAG) {
        self.titlefield = txtfield;
    [self.locateView resignFirstResponder];
    [self.zhutiselector resignFirstResponder];
    }
}

ON_SIGNAL3(BeeUITextView, WILL_ACTIVE, signal)
{
    BeeUITextView * txtview = (BeeUITextView *) signal.sourceView;
    if (txtview.tag == TXTVIEW_TAG) {
        self.contentview = txtview;
        [self.locateView resignFirstResponder];
        [self.zhutiselector resignFirstResponder];
    }
}
ON_SIGNAL3(BeeUITextView, WILL_DEACTIVE, signal)
{
    BeeUITextView * txtview = (BeeUITextView *) signal.sourceView;
    if (txtview.tag == TXTVIEW_TAG) {
      }
}

ON_SIGNAL3(BeeUITextField,TEXT_CHANGED , signal)
{
    BeeUITextField * txtfield = (BeeUITextField *) signal.sourceView;
    if (txtfield.tag == TXTFIELD_TAG) {
        self.titlefield = txtfield;
        CELL_STRUCT * cell1_0 = [self.dataDictionary objectForKey:KEY_INDEXPATH(1, 0)];
        cell1_0.title = txtfield.text;
        [self.dataDictionary setObject:cell1_0 forKey:KEY_INDEXPATH(1, 0)];
        NSLog(@"%@",txtfield.text);
    }
}
//
ON_SIGNAL3(BeeUITextView, SELECTION_CHANGED, signal)
{
    BeeUITextView * txtview = (BeeUITextView *) signal.sourceView;
    if (txtview.tag == TXTVIEW_TAG) {
        CELL_STRUCT * cell1_1 = [self.dataDictionary objectForKey:KEY_INDEXPATH(1, 1)];
        cell1_1.title = txtview.text;
        [self.dataDictionary setObject:cell1_1 forKey:KEY_INDEXPATH(1, 1)];
        NSLog(@"%@",txtview.text);
    }
}


ON_SIGNAL3(BeeUITextView, TEXT_CHANGED, signal)
{
    BeeUITextView * txtview = (BeeUITextView *) signal.sourceView;
    if (txtview.tag == TXTVIEW_TAG) {
        CELL_STRUCT * cell1_1 = [self.dataDictionary objectForKey:KEY_INDEXPATH(1, 1)];
        cell1_1.title = txtview.text;
        [self.dataDictionary setObject:cell1_1 forKey:KEY_INDEXPATH(1, 1)];
        NSLog(@"%@",txtview.text);
    }
}


-(void)keyboardWillHide:(NSNotification *)notification
{
    if([self.contentview isFirstResponder])
    {
        self.tableViewList.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.tableViewList reloadData];
    }
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if([self.contentview isFirstResponder])
    {
        NSDictionary *info = notification.userInfo;//[notify.object userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGSize keyBoardSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        /*CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;*/
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.tableViewList.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyBoardSize.height);
        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableViewList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView commitAnimations];
        BeeLog(@"show keybord user time %f's",duration);
    }
}
#pragma mark - 显示板块  主题
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
            [dic setObject:@"" forKey:@"不选主题"];
            [self.zhutiselector setDataDic:dic];
            [self.zhutiselector showInView:self.view];
            [_locateView resignFirstResponder];
            [self.titlefield resignFirstResponder];
            [self.contentview resignFirstResponder];
        }
    }];
    
}

- (IBAction)showLocateView:(id)sender
{
    [self.titlefield resignFirstResponder];
    [self.contentview resignFirstResponder];
    [self.zhutiselector resignFirstResponder];
    [self.locateView showInView:self.view];
//    self.maskview.frame = self.frame;
//    [self.maskview showInView:self.view belowSubview:_locateView];
}



#pragma mark -
#pragma mark 图片拍照选择
-(IBAction)pictureSelect:(UIButton*)sender
{
    [self.zhutiselector resignFirstResponder];
    [self.titlefield resignFirstResponder];
    [self.contentview resignFirstResponder];
    [self.locateView cancel:nil];
    
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

-(B4_PreviewImageView *)previewView
{
    if (!_previewView) {
         CGRect frame =[UIScreen mainScreen].bounds;
        _previewView =[[B4_PreviewImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
    return _previewView;
}
#pragma mark  -   预览图片   删除图片
-(void)C0_HairPostBaseCell:(C0_HairPostBaseCell *)cell viewTapped:(NSInteger)index
{
    if ([[cell class] isSubclassOfClass:[C0_HairPostPhotoCell class]]) {
        if (self.previewView) {
            CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(2, 0)];
            if (!cellstruct.array.count) {
                return;
            }
            [self.previewView showInView:self.view currenturl:nil index:0 urls:cellstruct.array shownblock:^(BOOL result) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                BeeLog(@"----preview 添加");
            } tappedblock:^(NSArray  *result) {
                if(!result || !result.count) cellstruct.cellheight = 0;
                cellstruct.array =[NSMutableArray arrayWithArray:result];
                [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(2, 0)];
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.previewView removeFromSuperview];
                [self.tableViewList reloadData];
                BeeLog(@"--preview 消失");
            }];
        }
    }
}

-(void)C0_HairPostBaseCell:(C0_HairPostBaseCell *)cell rightCompontsChange:(NSInteger)value
{
    if (value) {
        CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(2, 1)];
        cellstruct.title = [NSString stringWithFormat:@"添加照片(高清)"];
    }
    else
    {
        CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(2, 1)];
        cellstruct.title = [NSString stringWithFormat:@"添加照片(标清)"];
    }
    [self.tableViewList reloadData];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    BeeLog(@"%d",(int)buttonIndex);
    [self selectpicture:nil andclickedButtonAtIndex:(int)buttonIndex];
}

-(void)selectFromAblum{
    
    HBImagePickerControllerEx *m_imagePicker = [[HBImagePickerControllerEx alloc] init];
    [m_imagePicker setDelegate:self];
    [m_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [m_imagePicker setAllowsEditing:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self presentViewController:m_imagePicker animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - tableview delegate datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier01 = [NSString stringWithFormat:@"sec%ld_row%ld",(long)indexPath.section,(long)indexPath.row];
    C0_HairPostBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier01];
    NSString * key = KEY_INDEXPATH((int)indexPath.section, (int)indexPath.row);
    CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:key];
    Class cls = NSClassFromString(cellstruct.cellclass);
    if (!cell)
    {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier01];
    }
    cell.delegate = cellstruct.delegate;
    cell.selectionStyle = cellstruct.selectionStyle ? UITableViewCellSelectionStyleDefault  : UITableViewCellSelectionStyleNone;
    cell.accessoryType  = cellstruct.accessory ? UITableViewCellAccessoryDisclosureIndicator :UITableViewCellAccessoryNone;
    cell.textColor = cellstruct.titlecolor;
    cell.placeHolder = cellstruct.placeHolder;
    cell.rightComponts = cellstruct.rightComponts;
    [cell dataChange:cellstruct.title];
    [cell loadimageArray:cellstruct.array];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CELL_STRUCT * cellstruct =[self.dataDictionary objectForKey:KEY_INDEXPATH((int)indexPath.section,(int)indexPath.row)];
    return cellstruct.cellheight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
         case 1:
            return 2;
         case 2:
            return 2;
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH((int)indexPath.section, (int)indexPath.row)];
    if (cellstruct.sel_selector) {
        [self performSelector:cellstruct.sel_selector withObject:nil afterDelay:0];
    }
    
}
#pragma mark  - 选择版块 选择主题
-(void)C0_HairPost_SelectPlates:(C0_HairPost_SelectPlates *)action select_LoacateChild:(LoacateChild *)loate clickedButtonAtIndex:(NSInteger)index
{
    if(index == 0) {
        BeeLog(@"Cancel");
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
            CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(0, 0)];
            cellstruct.title = key;
            [self updatezhutiInfo:selectfid];
            [self.tableViewList reloadData];
        }
        //You can uses location to your application.
    }
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
            self.typedid = [NSNumber numberWithInt:key.intValue];
            NSString *value = athreaddic.name;
             CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(0, 1)];
            cellstruct.title = value;
            cellstruct.titlecolor = CLR_BLACK;
        }
        if (!athread || !athread.count) {
            self.typedid = nil;
             CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(0, 1)];
            cellstruct.title = NO_ZHUTI;
            cellstruct.titlecolor = CLR_GRAY;
        }
        [self.tableViewList reloadData];
    }];
}

-(void)C0_ZhuTi_SelectPlates:(C0_ZhuTi_SelectPlates *)action select_thtps:(THTPS_SELECT *)loate clickedButtonAtIndex:(NSInteger)index
{
    //选择主题
    if(index == 0) {
        BeeLog(@"Cancel");
        return;
    }
    C0_ZhuTi_SelectPlates *zhutiView = (C0_ZhuTi_SelectPlates *)action;
    THTPS_SELECT *item = zhutiView.locate;
    NSString *key=[NSString stringWithFormat:@"%@",item.threadtypesitem];
    if([key rangeOfString:@"null"].location == NSNotFound)
    {
        if (item.typedid) {
            self.typedid = [NSNumber numberWithInt:item.typedid.intValue];
             CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(0, 1)];
             cellstruct.title = key;
            [self.tableViewList reloadData];
        }
    }
}

#pragma mark - 退出编辑状态
ON_LEFT_BUTTON_TOUCHED(signal)
{
    CELL_STRUCT * cellstruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(1, 1)];
    CELL_STRUCT * cellstruct2 = [self.dataDictionary objectForKey:KEY_INDEXPATH(1, 0)];
    if (cellstruct.title.length || cellstruct2.title.length) {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃编辑" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续", nil];
        alertview.tag=235;
        [alertview show];
    }
    else
    {
        [bee.ui.appBoard hideSendhtm];
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



#pragma mark - 发帖按钮

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    [self.titlefield resignFirstResponder];
    [self.contentview resignFirstResponder];
    [self.zhutiselector resignFirstResponder];
    
//    CELL_STRUCT *titlestruct = [self.dataDictionary objectForKey:KEY_INDEXPATH(1, 0)];
    self.titlefield.text = self.titlefield.text.trim;
//    self.fastTextView.text = self.fastTextView.text.trim;
    if (!self.titlefield.text.length) {
        [self presentMessageTips:@"帖子标题不能为空"];
        return;
    }
    
    NSUInteger titlelength =[NSString unicodeLengthOfString:self.titlefield.text];
    if (titlelength >80)
    {
        [self presentMessageTips:[NSString stringWithFormat:@"标题超过最大长度80个字符，需删除%u个字符",titlelength - 80]];
        return;
    }
    if (!self.selectfid) {
        [self presentMessageTips:@"请选择版块"];
        return;
    }
    NSUInteger length =[NSString unicodeLengthOfString:self.contentview.text];
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


-(void)startuploadimg
{
    CELL_STRUCT * imagescell = [self.dataDictionary objectForKey:KEY_INDEXPATH(2, 0)];
    if (imagescell.uploadingIndex < imagescell.array.count) {
        NSString * imgurl =[imagescell.array objectAtIndex:imagescell.uploadingIndex];
        [self uploadImage:imgurl index:imagescell.uploadingIndex count:imagescell.array.count];
    }
    else
    {
//        [self presentMessageTips:@""]
        [self sendUISignal:self.didpostImage];
    }
}

ON_SIGNAL3(C0_HairPost_iphone, didpostImage, signal)
{
    [self presentLoadingTips:@"帖子发布中"];
    BeeLog(@"======发布========%@",self.contentview.text);
    self.newtpicModel.typedid = self.typedid;
    self.newtpicModel.fid = self.selectfid;
    self.newtpicModel.subject=self.titlefield.text;
    self.newtpicModel.authorid=[UserModel sharedInstance].session.uid;
    NSString *author=[UserModel sharedInstance].session.username;
    self.newtpicModel.author=author;
    newtopicContent *acont=[[newtopicContent alloc] init];
    acont.msg=_contentview.text;
    acont.type=[NSNumber numberWithInt:0];
    
    CELL_STRUCT * imagescell = [self.dataDictionary objectForKey:KEY_INDEXPATH(2, 0)];
    
    NSMutableArray *contentTextAry=[[NSMutableArray alloc] initWithCapacity:2];
    [contentTextAry addObject:acont];
    if (imagescell.uploadobjcts.count) {
        [contentTextAry addObjectsFromArray:imagescell.uploadobjcts];
    }
    [contentTextAry addObject:[C0_HairPost_ToolFun pushDeviceMark]];
    self.newtpicModel.contents = contentTextAry;
    [self.newtpicModel load];
    [self.newtpicModel firstPage];
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

#pragma mark - 上传图片
-(void)uploadImage:(NSString *)imageurl index:(NSInteger)index count:(NSInteger)count
{
    if (index >=count) {
        [self sendUISignal:self.didpostImage];
        return;
    }
    _postImgModel.fid=self.selectfid;
    _postImgModel.uid=[UserModel sharedInstance].session.uid;
    
    UIImage *image =[[BeeImageCache sharedInstance] imageForURL:imageurl];
    _postImgModel.filedata= UIImageJPEGRepresentation(image, 1);
    [_postImgModel load];
    [_postImgModel firstPage];
    [self presentLoadingTips:[NSString stringWithFormat:@"正在上传(%d/%ld)",index + 1 , (unsigned long)count]];
}

ON_SIGNAL3(postImageModel, FAILED, signal)
{
    [self dismissTips];
    NSString *errmsg=[NSString stringWithFormat:@"图片上传失败,%@",signal.object];
    [self presentMessageTips:errmsg];
}

ON_SIGNAL3(postImageModel, RELOADED, signal)
{
     CELL_STRUCT * imagescell = [self.dataDictionary objectForKey:KEY_INDEXPATH(2, 0)];
    postImageModel *postmodel=(postImageModel *)signal.sourceViewModel;
    newtopicContent *imgcontent=[[newtopicContent alloc] init];
    imgcontent.msg = [imagescell.array objectAtIndex:imagescell.uploadingIndex];
    imgcontent.type = [NSNumber numberWithInt:IMGTYPE];
    imgcontent.aid = postmodel.postimge.aid;
    
    [imagescell.uploadobjcts addObject:imgcontent];
    imagescell.uploadingIndex = imagescell.uploadingIndex + 1;
    [self.dataDictionary setObject:imagescell forKey:KEY_INDEXPATH(2, 0)];
    
    if (imagescell.uploadingIndex  < imagescell.array.count )
    {
        NSString * setxt = [imagescell.array objectAtIndex:imagescell.uploadingIndex];
        [self uploadImage:setxt index:imagescell.uploadingIndex count:imagescell.array.count];
    }
    else
    {
        [self dismissTips];
        [self presentMessageTips:@"图片上传成功"];
        [self sendUISignal:self.didpostImage];
    }
    
}


#pragma mark  - 处理图片选择

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
                [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.2];
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
    float scalerat = [C0_HairPostAddPhotoCell uploadPhotoMode]==UPLPHOTOMODE_HIGH?1:0.5;
    [self presentLoadingTips:@""];
    UIImage *scaleImage = [[C0_HairPost_ToolFun sharedInstance] scaleImage:originImage toScale:scalerat];
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[[NSDate date] stringWithDateFormat:@"yyyy_MM_dd_HH_MM_SS"]];
    if (UIImagePNGRepresentation(scaleImage) == nil) {
        //将图片转换为JPG格式的二进制数据
        data = UIImageJPEGRepresentation(scaleImage, 1);
        fileName = [NSString stringWithFormat:@"ios_dz%dp_%@.jpg",[C0_HairPostAddPhotoCell uploadPhotoMode],[[NSDate date] stringWithDateFormat:@"yyyy_MM_dd_HH_MM_SS"]];
    } else {
        //将图片转换为PNG格式的二进制数据
        data = UIImagePNGRepresentation(scaleImage);
        fileName = [NSString stringWithFormat:@"ios_dz%dp_%@.png",[C0_HairPostAddPhotoCell uploadPhotoMode],[[NSDate date] stringWithDateFormat:@"yyyy_MM_dd_HH_MM_SS"]];
    } //        //将二进制数据生成UIImage
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
  
    [[BeeImageCache  sharedInstance] saveImage:image forURL:fileName];
    CELL_STRUCT * cellstruct =[self.dataDictionary objectForKey:KEY_INDEXPATH(2,0)];
    cellstruct.cellheight = H_IMAGECELLHEIGHT;
    [cellstruct.array addObject:fileName];
    [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(2, 0)];
    [self.tableViewList reloadData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissTips];
    }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}

-(void)handleAblumInfo:(NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
      // .fullScreenImage];
//        image = [image fixOrientation:image];//旋转方向
        /*
        //获取资源图片的高清图
        [representation fullResolutionImage];
        //获取资源图片的全屏图
        [representation fullScreenImage];
        //获取资源图片的名字
        */
        [self presentLoadingTips:@""];
        CGImageRef iref = [representation fullScreenImage];//
        float scalerat = [C0_HairPostAddPhotoCell uploadPhotoMode]==UPLPHOTOMODE_HIGH?1:0.5;
        UIImage *orimage=[UIImage imageWithCGImage:iref scale:1 orientation:UIImageOrientationUp];
        UIImage *scaleImage = [[C0_HairPost_ToolFun sharedInstance] scaleImage:orimage toScale:scalerat];
        
        NSString *fileName = [NSString stringWithFormat:@"ios_dz%dp_%@",[C0_HairPostAddPhotoCell uploadPhotoMode],representation.filename];
        NSLog(@"旋转方向 %d",[representation orientation]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (iref) {
//                photoView.image = image;
                [[BeeImageCache  sharedInstance] saveImage:scaleImage forURL:fileName];
                CELL_STRUCT * cellstruct =[self.dataDictionary objectForKey:KEY_INDEXPATH(2,0)];
                cellstruct.cellheight = H_IMAGECELLHEIGHT;
                [cellstruct.array addObject:fileName];
                [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(2, 0)];
                [self.tableViewList reloadData];
            }
        });
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:^(NSError *error) {
                      [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                      [self dismissTips];
                  }];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self dismissTips];
    }];
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    
}

@end
