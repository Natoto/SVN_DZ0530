//
//  C0_HairPostEditTableViewCell.m
//  DZ
//
//  Created by nonato on 14-10-28.
//
//

#import "C0_HairPostBaseCell.h"

@implementation C0_HairPostBaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)loadimageArray:(NSArray *)imageArray
{
}
-(void)dataChange:(NSString *)data
{
    self.textLabel.text = data;
}
-(void)setTextColor:(NSString *)textColor
{
    if ([textColor isEqualToString:@"gray"]) {
        self.textLabel.textColor = [UIColor grayColor];
    }
    else
    {
        self.textLabel.textColor = [UIColor blackColor];
    }
}
@end
