//
//  A1_PortalDetail.h
//  DZ
//
//  Created by PFei_He on 14-10-27.
//
//

#import <UIKit/UIKit.h>
#import "PortalModel.h"
#import "B2_TopicTableViewCell.h"
#import "BlockDetailModel.h"
#import "TopiclistModel.h"

@interface A1_PortalDetail : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tv;
}

@property (nonatomic, strong) PortalModel           *portalModel;
@property (nonatomic, assign) NSInteger             section;
@property (nonatomic, strong) BlockDetailModel      *blockDetailModel;
@property (nonatomic, strong) TopiclistModel        *tpclistModel;

@end
