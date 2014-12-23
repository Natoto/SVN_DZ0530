//
//  C0_HairEditTextViewCell.m
//  DZ
//
//  Created by nonato on 14-10-28.
//
//

#import "C0_HairEditTextViewCell.h"
#import "C0_HairPost_ToolsView.h"
#import "FaceBoard.h"

@interface C0_HairEditTextViewCell()<FaceBoardDelegate>
@property(nonatomic,retain) FaceBoard * faceBoard;
@property(nonatomic,retain) C0_HairPost_ToolsView * toolsview;
@end

@implementation C0_HairEditTextViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.editText) {
            
        }
    }
    return self;
}

-(C0_HairPost_ToolsView *)toolsview
{
    if (!_toolsview) {
        _toolsview = [[C0_HairPost_ToolsView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 33) withTarget:self andFacialSel:@selector(showFace:) andpictureSel:nil andkeyboardSel:@selector(showKeyboard:) donesel:@selector(doneSelect:)];
        _toolsview.showDoneButton = YES;
        _toolsview.showPictureButton = NO;
//        [self.view addSubview:self.toolsview];
        
    }
    return _toolsview;
}
-(FaceBoard *)faceBoard
{
    if (!_faceBoard) {
        _faceBoard=[[FaceBoard alloc] init];
        _faceBoard.delegate = self;
        _faceBoard.inputTextView = (UITextView *)self.editText;
    }
    return _faceBoard;
}


#pragma mark - 添加表情
-(IBAction)showFace:(UIButton*)sender
{
    if (![self.editText isFirstResponder]) {
        [self.editText becomeFirstResponder];
    }
    self.editText.inputView=self.faceBoard;
    [self.editText reloadInputViews];
    [self.toolsview showKeyboardBtn:YES];
}

-(IBAction)doneSelect:(id)sender
{
    [self.editText resignFirstResponder];
}
-(IBAction)showKeyboard:(id)sender
{
    if (![self.editText isFirstResponder]) {
        return;
    }
    [self.toolsview showKeyboardBtn:NO];
     self.editText.inputView=nil;
    [self.editText reloadInputViews];
}
#pragma mark  - faceboard delegate
-(void)facebuttonTap:(id)sender andName:(NSString *)name
{
//    UIButton *button = sender;
//    UIImage *stampImage = [button imageForState:UIControlStateNormal];
    
    NSRange range = self.editText.selectedRange;
    self.editText.text = [self.editText.text stringByReplacingCharactersInRange:range withString:name];
    self.editText.selectedRange = NSMakeRange(range.length + range.location + name.length, 0);
    
//    self.editText.text = [NSString stringWithFormat:@"%@%@",self.editText.text,name];
   
}
-(void)faceboardBackface
{
    [self.editText deleteBackward];
}

-(BeeUITextView *)editText
{
    if (!_editText) {
        _editText = [[BeeUITextView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth([UIScreen mainScreen].bounds) - 10, C0TXTVIEW_HEIGHT - 10)];
        _editText.placeHolderColor = LINE_LAYERBOARD_NOTCGCOLOR;
        _editText.font = [UIFont systemFontOfSize:15.0];
        _editText.tag = TXTVIEW_TAG;
        _editText.inputAccessoryView = self.toolsview;
        [self addSubview:_editText];
    }
    return _editText;
}

-(void)setText:(NSString *)text
{
    if (text.length) {
        _editText.text = text;
    }
}

-(NSString *)text
{
    return _editText.text;
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _editText.placeholder = placeHolder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dataChange:(NSString *)data
{
    self.editText.text = data; 
}

@end
