//
//  D0_DiscoveryCell.m
//  DZ
//
//  Created by nonato on 14-10-13.
//
//

#import "E0_DiscoveryCell.h"
#import "ToolsFunc.h"
#import "bee.h"
@implementation E0_DiscoveryCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10,CGRectGetWidth([UIScreen mainScreen].bounds) , [E0_DiscoveryCell heightOfCell] -10)];
        imageview.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:imageview];
    }
    return self;
}
+(float)heightOfCell
{
    return 100.0f;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    if (!lbltitle) {
        lbltitle =  [ToolsFunc CreateBeeLabelWithFrame:CGRectMake(0, 10, CGRectGetWidth([UIScreen mainScreen].bounds), 50) andTxt:_title];
        lbltitle.font = [UIFont systemFontOfSize:20];
        lbltitle.verticalAlignment = VerticalAlignmentBottom;
        [self.contentView addSubview:lbltitle];
    }
    lbltitle.text = _title;
}

-(void)setDetail:(NSString *)detail
{
    _detail=detail;
    if (!lbldetail) {
        lbldetail = [ToolsFunc CreateBeeLabelWithFrame:CGRectMake(0, CGRectGetMaxY(lbltitle.frame), CGRectGetWidth([UIScreen mainScreen].bounds), 40) andTxt:_detail];
        lbldetail.verticalAlignment = VerticalAlignmentTop;
         lbldetail.textColor = [UIColor grayColor];
        [self.contentView addSubview:lbldetail];
    }
    lbldetail.text = _detail;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
