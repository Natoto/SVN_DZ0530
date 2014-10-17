//
//  D0_DiscoveryCell.h
//  DZ
//
//  Created by nonato on 14-10-13.
//
//

#import <UIKit/UIKit.h>
#import "bee.h"
@interface E0_DiscoveryCell : UITableViewCell
{
    BeeUILabel * lbltitle;
    BeeUILabel * lbldetail;
}
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * detail;
+(float)heightOfCell;
@end
