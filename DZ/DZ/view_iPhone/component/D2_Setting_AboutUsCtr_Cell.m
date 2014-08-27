//
//  D2_Setting_AboutUsCtr_Cell.m
//  DZ
//
//  Created by Nonato on 14-7-17.
//
//

#import "D2_Setting_AboutUsCtr_Cell.h"
#import "RCLabel.h"
#import "QRCodeGenerator.h"

#define MARGIN_X 15

@implementation D2_Setting_AboutUsCtr_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addbackgroundView:nil];
        textlabel =[[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_X, 5, 320 - 2*MARGIN_X,  10)];
        [self addSubview:textlabel];
    }
    return self;
}

- (void)datachange:(id)object
{
    [super datachange:object];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:(NSString *)self.classtype];
    textlabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [textlabel optimumSize];
    textlabel.frame=CGRectMake(MARGIN_X, 5, self.frame.size.width - 2 * MARGIN_X,optimumSize.height);
}

+ (float)heightOfcell:(NSString *)text
{
    RCLabel *label =[[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_X, 5, 320 - 2 * MARGIN_X,  10)];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:text];
    label.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [label optimumSize];
    return optimumSize.height + 10;
}

//二维码
- (void)setHasQrencodeView:(BOOL)hasQrencodeView
{
    _hasQrencodeView = hasQrencodeView;
    if (hasQrencodeView) {
        codeStr = [DZ_SystemSetting sharedInstance].downloadurl;
        codeStr = [self url:codeStr];
        UIImageView *qrencodeView = [[UIImageView alloc] initWithFrame:CGRectMake(95, textlabel.frame.size.height + 20, 130, 130)];
        qrencodeView.image = [QRCodeGenerator qrImageForString:codeStr imageSize:qrencodeView.frame.size.width];
        [self addSubview:qrencodeView];
    }
}

//匹配URL
- (NSString *)url:(NSString *)string
{
    NSLog(@"%@", string);
    NSError *error;
    NSString *regulaStr = @"(http[s]{0,1}|ftp):\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSLog(@"%@", arrayOfAllMatches);

    NSString *urlStr = nil;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        urlStr = [string substringWithRange:match.range];
        NSLog(@"%@", urlStr);
    }
    //获得匹配个数
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSLog(@"numberOfMatches===%d",numberOfMatches);

    return urlStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
