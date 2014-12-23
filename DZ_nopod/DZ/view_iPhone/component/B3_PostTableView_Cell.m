//
//  B3_PostTableView_Cell.m
//  DZ
//
//  Created by Nonato on 14-4-24.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "B3_PostTableView_Cell.h"
#import "Constants.h"
#import "RCLabel.h"
@implementation B3_PostTableView_Cell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        cntSubViewsAry=[[NSMutableArray alloc] initWithCapacity:1];
        //        fontsize =[SettingModel sharedInstance].fontsize;
        //        [self loadheaderviews];
        headerpostcell = [[B3_PostBaseTableViewCell alloc] initWithStyle:style reuseIdentifier:@"postbaseTabel.cell" target:self];
        headerpostcell.delegate = self;
        headerpostcell.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200);

        [self.contentView addSubview:headerpostcell];
    }
    return self;
}

+ (float)heightOfCell:(NSArray *)contents
{
       return  [B3_PostBaseTableViewCell heightOfSelfdefinecontents:contents celltype:CELL_REPLYTOPIC];
}

-(CELL_TYPE)typeOfcell:(B3_PostBaseTableViewCell *)cell
{
    return CELL_REPLYTOPIC;
}

-(void)setCellIndex:(NSString *)cellIndex
{
    _cellIndex = cellIndex;
    headerpostcell.cellIndex = cellIndex;
}

-(BOOL)isTopicArtile:(B3_PostBaseTableViewCell *)cell
{
    return NO;
}

-(float)cellheight
{
    return  headerpostcell.cellheight;
}

-(CGRect)frameOfCellHeader:(B3_PostBaseTableViewCell *)cell
{
//    return CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) , 60);
    self.cellHeaderFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60);
    return self.cellHeaderFrame;
}

-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ProfileBtnTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellProfileBtnTapped:)]) {
        [self.delegate B3_CellProfileBtnTapped:self];
    }
}
-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ShowBigImgview:(NSString *)imgurl imageView:(BeeUIImageView *)imageview
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellShowBigImgview:cell:imageview:)])
    {
        [self.delegate B3_CellShowBigImgview:imgurl cell:self imageview:imageview];
    }
}

- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell ReplyButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellReplyBtnTapped:)]) {
        [self.delegate B3_CellReplyBtnTapped:self];
    }
}

//- (void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell supportBtnTapped:(id)sender
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellSupportBtnTapped:)]) {
////        [self.delegate performSelector:@selector(B3_CellSupportBtnTapped:) withObject:self];
//        [self.delegate B3_CellSupportBtnTapped:self];
//    }
//}

-(TYPETOSHOWCONTENT)typeToshowContent:(B3_PostBaseTableViewCell *)cell
{
    self.typetoshow = FORMSELFDEFINE;
    return  self.typetoshow;//FORMWEB;
}

-(void)B3_PostBaseTableViewCellDidFinishLoad:(B3_PostBaseTableViewCell *)cell frame:(CGRect)frame
{
    if (![cell.cellIndex isEqualToString:self.cellIndex]) {
        return ;
    }
    CGRect myframe =frame;//frame 继续走下去就被释放了？？？
       if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellDidFinishLoad:andheight:)]) {
           if (myframe.size.height < 80) {
               myframe.size.height = 80;
           }
        self.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
        BeeLog(@"cell.frame.size.height =%d",myframe.size.height);
//        headerpostcell.frame = frame;
        [self.delegate B3_CellDidFinishLoad:self andheight:myframe.size.height];
    }
}
-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:rtLabel:didSelectLinkWithURL:)]) {
        [self.delegate  B3_Cell:self rtLabel:rtLabel didSelectLinkWithURL:url];
    }
}

-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell rtlabel:(RCLabel *)rtlabel LongPress:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_Cell:rtlabel:LongPress:)]) {
        [self.delegate B3_Cell:self rtlabel:rtlabel LongPress:recognizer];
    }
}

-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell tappedheaderview:(BOOL)selected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_CellHeaderViewTapped:)]) {
        [self.delegate B3_CellHeaderViewTapped:self];
    }
}

-(void)B3_PostBaseTableViewCell:(B3_PostBaseTableViewCell *)cell supportbtn:(id)sender support:(BOOL)support
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_Cell:supportbtn:support:)]) {
        [self.delegate B3_Cell:self supportbtn:sender support:support];
    }
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(post *)cellpost:(B3_PostBaseTableViewCell *)cell
{
    return self.cellpost;
}

- (void)reloadsubviews
{
    [headerpostcell reloadsubviews];
}

-(NSString *)lblfloorText:(B3_PostBaseTableViewCell *)cell
{
    return self.lblfloortext;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
 
- (void)setSupport:(NSNumber *)support
{
    _support = support;
    headerpostcell.support = support;
}

- (void)setStatus:(NSNumber *)status
{
    _status = status;
    headerpostcell.status = status;
}

//- (void)B3_PostTableView_Cell:(void (^)(id sender))obj
//{
//    [headerpostcell B3_PostBaseTableViewCell:obj];
//}

@end
