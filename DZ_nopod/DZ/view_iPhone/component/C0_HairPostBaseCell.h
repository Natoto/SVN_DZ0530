//
//  C0_HairPostEditTableViewCell.h
//  DZ
//
//  Created by nonato on 14-10-28.
//
//

#import <UIKit/UIKit.h>

@class C0_HairPostBaseCell;
@protocol C0_HairPostBaseCellDelegate
-(void)C0_HairPostBaseCell:(C0_HairPostBaseCell *)cell viewTapped:(NSInteger) index;
@optional
-(void)C0_HairPostBaseCell:(C0_HairPostBaseCell *)cell rightCompontsChange:(NSInteger)value;
@end

@interface C0_HairPostBaseCell : UITableViewCell
@property(nonatomic,strong) NSString * rightComponts;
@property(nonatomic,strong) NSString * textColor;
@property(nonatomic,strong) NSString * text;
@property(nonatomic,strong) NSString * placeHolder;
@property(nonatomic,assign) NSObject<C0_HairPostBaseCellDelegate> * delegate;
-(void)dataChange:(NSString *)data;
-(void)loadimageArray:(NSArray *)imageArray;
@end
