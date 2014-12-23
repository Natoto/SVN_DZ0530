//
//  D2_Setting_RefreshSwitcherCell.m
//  DZ
//
//  Created by nonato on 14-11-4.
//
//

#import "D2_Setting_RefreshSwitcherCell.h"
#import "SettingModel.h"
#import "DZ_SystemSetting.h"

@implementation D2_Setting_RefreshSwitcherCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        label=leftlabel;
        label.text=@"自动刷新聊天系统等消息";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];
        
        switcher=[[BeeUISwitch alloc] init];
        switcher.on=![SettingModel sharedInstance].autoRefreshmsgmode;
        float switcherwidth = switcher.frame.size.width;
        switcher.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - switcherwidth - 15, 10, switcherwidth, 30);
        [switcher addTarget:self action:@selector(dataDidChanged) forControlEvents:UIControlEventValueChanged];
        switcher.onTintColor = [DZ_SystemSetting sharedInstance].navigationBarColor;
        [self addSubview:switcher];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}


- (void)dataDidChanged
{
    [SettingModel sharedInstance].autoRefreshmsgmode = (switcher.on==YES)?SettingModel.AUTOREFRESH_NO:SettingModel.AUTOREFRESH_YES;
}

@end
