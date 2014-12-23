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
        bgimageView = imageview;
        [self.contentView addSubview:imageview];
    }
    return self;
}
+(float)heightOfCell
{
    return 100.0f;
}

-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    if (bgimageView) {
        bgimageView.image = [UIImage bundleImageNamed:imageName];
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    if (!lbltitle) {
        lbltitle =  [ToolsFunc CreateBeeLabelWithFrame:CGRectMake(0, 10, CGRectGetWidth([UIScreen mainScreen].bounds), 50) andTxt:_title];
        lbltitle.font = [UIFont boldSystemFontOfSize:20];
        lbltitle.textColor = [UIColor whiteColor];
        lbltitle.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, [E0_DiscoveryCell heightOfCell]/3);
        lbltitle.verticalAlignment = VerticalAlignmentMiddle;
        [self.contentView addSubview:lbltitle];
    }
    lbltitle.text = _title;
}

-(void)setDetail:(NSString *)detail
{
    _detail=detail;
    if (!lbldetail) {
        lbldetail = [ToolsFunc CreateBeeLabelWithFrame:CGRectMake(0, CGRectGetMaxY(lbltitle.frame), CGRectGetWidth([UIScreen mainScreen].bounds), 40) andTxt:_detail];
        lbldetail.verticalAlignment = VerticalAlignmentMiddle;
         lbldetail.textColor = [UIColor whiteColor];
        lbldetail.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, [E0_DiscoveryCell heightOfCell]*2/3);
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
