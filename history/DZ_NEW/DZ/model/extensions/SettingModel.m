//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "SettingModel.h"

#pragma mark -

#define KEY_REFRESHMSG @"SettingModel.autorefreshmsg"

@implementation SettingModel


DEF_SINGLETON( SettingModel )
DEF_INT( PHOTO_23G_NOTLOAD,	0 )
DEF_INT( PHOTO_23G_LOAD,	1 )

DEF_INT( AUTOREFRESH_NO, 0)
DEF_INT( AUTOREFRESH_YES, REFRESHMSG_ONE)
@synthesize photoMode = _photoMode;

- (void)load
{
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
}

#pragma mark -

- (void)loadCache
{
    self.fontsize =  [[self userDefaultsRead:@"SettingModel.fontsize"] intValue];
    self.fontsize = self.fontsize ? self.fontsize :FONTSIZE_MIDDLE;
	self.photoMode = [[self userDefaultsRead:@"SettingModel.photoMode"] intValue];
    if (![self userDefaultsRead:@"SettingModel.photoMode"]) {//默认加载图片
        self.photoMode = self.PHOTO_23G_LOAD;
    }
    self.uploadphotoMode = [[self userDefaultsRead:@"SettingModel.uploadphotomode"] intValue]?[[self userDefaultsRead:@"SettingModel.uploadphotomode"] intValue]:UPLPHOTOMODE_HIGH;
    
    self.autoRefreshmsgmode = [[self userDefaultsRead:@"SettingModel.uploadphotomode"] intValue]?REFRESHMSG_NO:REFRESHMSG_ONE;
}

- (void)saveCache
{
    [self userDefaultsWrite:@(self.fontsize) forKey:@"SettingModel.fontsize"];
	[self userDefaultsWrite:@(self.photoMode) forKey:@"SettingModel.photoMode"];
}

- (void)clearCache
{
    self.fontsize = FONTSIZE_MIDDLE;
	self.photoMode = self.PHOTO_23G_LOAD;
	self.loaded = NO;
}
-(void)setAutoRefreshmsgmode:(NSUInteger)autoRefreshmsgmode
{
    [self userDefaultsWrite:@(autoRefreshmsgmode) forKey:KEY_REFRESHMSG];
    _autoRefreshmsgmode = autoRefreshmsgmode;
    
}
-(void)setUploadphotoMode:(UPLOADPHOTOMODE)uploadphotoMode
{
    [self userDefaultsWrite:@(uploadphotoMode) forKey:@"SettingModel.uploadphotomode"];
    _uploadphotoMode = uploadphotoMode;
}

@end
