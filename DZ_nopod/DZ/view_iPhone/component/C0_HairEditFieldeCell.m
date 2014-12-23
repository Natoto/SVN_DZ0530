//
//  C0_HairButtonTableViewCell.m
//  DZ
//
//  Created by nonato on 14-10-28.
//
//

#import "C0_HairEditFieldeCell.h"

@implementation C0_HairEditFieldeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.editText) {
            
        }
    }
    return self;
}

-(BeeUITextField *)editText
{
    if (!_editText) {
        _editText = [[BeeUITextField alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth([UIScreen mainScreen].bounds) - 10, self.height - 10)];
        _editText.tag = TXTFIELD_TAG;
        _editText.font = [UIFont systemFontOfSize:15.0];
        _editText.returnKeyType = UIReturnKeyDone;
        [self addSubview:_editText];
    }
    return _editText;
}

ON_SIGNAL3(BeeUITextField,RETURN, signal)
{
    [_editText resignFirstResponder];
}

//BeeUITextField.
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self.editText resignFirstResponder];
//    return YES;
//}

-(void)setText:(NSString *)text
{
    if (text.length) {
        _editText.text = text;
    }
}
-(void)setTextColor:(NSString *)textColor
{
}
-(NSString *)text
{
    return _editText.text;
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _editText.placeholder = placeHolder;
}

-(void)dataChange:(NSString *)data
{
//    if(self.editText)
//    {
        self.editText.text = data;
//    }
}


//-(BOOL)resignFirstResponder
//{
//    [_editText resignFirstResponder];
//    return YES;
//}
//
//-(BOOL)becomeFirstResponder
//{
//    [_editText becomeFirstResponder];
//    return YES;
//}
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}




@end
