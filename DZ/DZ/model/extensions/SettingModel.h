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


typedef enum : int {
    FONTSIZE_SMALL = 14,
    FONTSIZE_MIDDLE = 16,
    FONTSIZE_BIG = 20,
} FONTSIZE_TYPE;
#define FONT_MIDDLEBASE FONTSIZE_MIDDLE
#import "Bee.h"

#pragma mark -

@interface SettingModel : BeeOnceViewModel

AS_SINGLETON( SettingModel )
AS_INT( PHOTO_23G_NOTLOAD )
AS_INT( PHOTO_23G_LOAD )


//AS_INT( PHOTO_MODE_LOW )
@property (nonatomic, assign) FONTSIZE_TYPE	fontsize;
@property (nonatomic, assign) NSUInteger	photoMode;
@property(nonatomic,assign)NSUInteger       navigationbarColorMode;
@end
