//
//  D2_Setting_AboutUsCtr_Cell.h
//  DZ
//
//  Created by Nonato on 14-7-17.
//
//

#import "DZ_BASETableViewCell.h"
@class RCLabel;
@interface D2_Setting_AboutUsCtr_Cell : UITableViewCell
{
    RCLabel *textlabel;
    NSString *codeStr;
}
@property (nonatomic, assign) id classtype;
@property (nonatomic, assign) BOOL hasQrencodeView;

+(float)heightOfcell:(NSString *)text;

@end
