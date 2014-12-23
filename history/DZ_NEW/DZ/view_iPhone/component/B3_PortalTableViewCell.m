//
//  B3_PortalTableViewCell.m
//  DZ
//
//  Created by nonato on 14-12-19.
//
//

#import "B3_PortalTableViewCell.h"

@implementation B3_PortalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)B3_PostBaseTableViewCellDidFinishLoad:(B3_PostBaseTableViewCell *)cell frame:(CGRect)frame
{
    if (![cell.cellIndex isEqualToString:self.cellIndex]) {
        return ;
    }
    CGRect myframe =frame;//frame 继续走下去就被释放了？？？
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellDidFinishLoad:andheight:)]) {
        if (myframe.size.height < 60) {
            myframe.size.height = 60;
        }
        self.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
        BeeLog(@"cell.frame.size.height =%d",myframe.size.height);
        //        headerpostcell.frame = frame;
        [self.delegate B3_CellDidFinishLoad:self andheight:myframe.size.height];
    }
}

+ (float)heightOfCell:(NSArray *)contents
{
    return  [B3_PostBaseTableViewCell heightOfSelfdefinecontents:contents celltype:CELL_PORTALPOST];
}

-(CELL_TYPE)typeOfcell:(B3_PostBaseTableViewCell *)cell
{
    return CELL_PORTALPOST;
}

@end
