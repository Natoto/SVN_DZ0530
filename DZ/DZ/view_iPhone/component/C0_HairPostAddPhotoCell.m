//
//  C0_HairPostAddPhotoCell.m
//  DZ
//
//  Created by nonato on 14-11-3.
//
//

#import "C0_HairPostAddPhotoCell.h"
#import "DZ_SystemSetting.h"
#import "SettingModel.h"
@interface C0_HairPostAddPhotoCell()
@property(nonatomic,strong) UISwitch * switchItem;
@end

@implementation C0_HairPostAddPhotoCell


-(UISwitch *)switchItem
{
    if (!_switchItem) {
        
        UISwitch *switcher =[[UISwitch alloc] init];
        switcher.on=([SettingModel sharedInstance].uploadphotoMode == UPLPHOTOMODE_HIGH?YES:NO);
        float switcherwidth = switcher.frame.size.width;
        switcher.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - switcherwidth - 15, 5, switcherwidth, 30);
        [switcher addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        switcher.onTintColor = [DZ_SystemSetting sharedInstance].navigationBarColor;
        [self addSubview:switcher];
        _switchItem = switcher;
    }
    return _switchItem;
}

+(UPLOADPHOTOMODE)uploadPhotoMode
{
    return [SettingModel sharedInstance].uploadphotoMode;
        
}
-(IBAction)switchChange:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(C0_HairPostBaseCell:rightCompontsChange:)]) {
        [SettingModel sharedInstance].uploadphotoMode = self.switchItem.on? UPLPHOTOMODE_HIGH:UPLPHOTOMODE_LOW;
        [self.delegate C0_HairPostBaseCell:self rightCompontsChange:self.switchItem.on];
    }
}

-(void)setRightComponts:(NSString *)rightComponts
{
    Class swtch=NSClassFromString(rightComponts);
    if ([[swtch class] isSubclassOfClass:[UISwitch class]]) {
        if (self.switchItem) {
            
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
