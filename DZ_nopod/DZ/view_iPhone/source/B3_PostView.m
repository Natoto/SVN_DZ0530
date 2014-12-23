//
//  B3_PostView.m
//  DZ
//
//  Created by PFei_He on 14-11-24.
//
//

#import "B3_PostView.h"
#import "article.h"
#import "FaceBoard.h"
#import "SettingModel.h"
#import "PFTableViewCell.h"
#import "PHOTO+AutoSelection.h"

#define HEADCONTENTVIEWSTARTTAG 110043
#define  CONTENTVIEWSTARTTAG 153314
#define DEFAULTHEIGHT 50.0
#define DEFAULINTERVAL 5.0
#define DEFAULIMAGERECT(LEFT,OriginY,RIGHT) CGRectMake(LEFT, OriginY, DEFAULTHEIGHT*3 - LEFT - RIGHT, 3*DEFAULTHEIGHT)

#define DEF_CELL_MARGIN_LEFT 20
#define DEF_CELL_MARGIN_RIGHT 10

#define DEF_HEAD_MARGIN_LEFT 10
#define DEF_HEAD_MARGIN_RIGHT 10
#define FRAME_REPLYBTN(Y) CGRectMake(self.width - 35, Y, 35, 35)
#define FRAME_SUPPORTBTN(Y) CGRectMake(self.width - 35 - 20, Y, 100, 30)

#define SMILEFACAIL_WIDTH 40

BOOL imageLoaded;

@interface RepeatTXTClassa : NSObject

@property (nonatomic, copy)     NSString    *string;
@property (nonatomic, assign)   NSUInteger  index;

@end

@implementation RepeatTXTClassa

@end

@implementation B3_PostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Datas Management

//签到标签中去掉空格
+ (NSString *)removeVotebrMark:(NSString *)acontmsg
{
    NSRegularExpression *regular1;
    //<font size='3'><font color='dimgray'>我今天最想说:「<font color='red'>.*</font><br />」.</font><br /></font>

    regular1 = [[NSRegularExpression alloc] initWithPattern:@"</font><br />」.</font><br /></font>"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];

    acontmsg = [regular1 stringByReplacingMatchesInString:acontmsg
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [acontmsg length])
                                             withTemplate:@"</font>」.</font></font>"];
    return acontmsg;

}

+ (NSString *)newText:(NSString *)acontmsg
{
    //    NSString *message=[acontmsg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    //    message=[message stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];

    NSRegularExpression *regular;
    NSRegularExpression *regular1;
    NSRegularExpression *regular2;

    acontmsg = [B3_PostView removeVotebrMark:acontmsg];
    regular1 = [[NSRegularExpression alloc] initWithPattern:@"<(?!a|font|br|strong|img|/a|/font|/strong|/img).*?>"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];

    acontmsg = [regular1 stringByReplacingMatchesInString:acontmsg
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [acontmsg length])
                                             withTemplate:@""];
    /* <(?!a|br|strong|/a|/strong).*?> 只保留一下标签&quot;*/
    regular2 = [[NSRegularExpression alloc] initWithPattern:@"<br />(\\s*|\\w{1})<br />"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:nil];

    acontmsg = [regular2 stringByReplacingMatchesInString:acontmsg
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [acontmsg length])
                                             withTemplate:@"<br /><br />"];

    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    //    acontmsg = [acontmsg trim];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    acontmsg = [acontmsg stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    NSString *message = acontmsg;
    //将多个换行变为1个换行
    regular = [[NSRegularExpression alloc] initWithPattern:@"\n{2,}"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];

    message = [regular stringByReplacingMatchesInString:message
                                                options:NSMatchingReportCompletion
                                                  range:NSMakeRange(0, [message length])
                                           withTemplate:@"\n\n"];

    //去掉空白行
    NSRegularExpression *trims = [[NSRegularExpression alloc] initWithPattern:@"^(\n){2,}$"
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];

    message = [trims stringByReplacingMatchesInString:message
                                              options:NSMatchingReportCompletion
                                                range:NSMakeRange(0, [message length])
                                         withTemplate:@""];

    return message;
}

- (CGFloat)heightOfMessage:(NSString *)message view:(UIView *)view cellType:(cellType)cellType
{
    float OriginY = 0.0;
    float MARGIN_LEFT = 10;
    float MARGIN_RIGHT = 10;

    int fontSize = [SettingModel sharedInstance].fontsize;

    if (cellType == cellTypeArticla) {
        MARGIN_LEFT = 10;
    } else {
        MARGIN_LEFT = 20;
    }
    RCLabel *rtLabel = [[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_RIGHT - MARGIN_LEFT, 30)];
    [rtLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [rtLabel setTextColor:[UIColor orangeColor]];
    NSString *rtlabelText = [[NSString alloc] initWithFormat:@""];
    rtlabelText = [rtlabelText stringByAppendingString:message];
    rtlabelText = [B3_PostView newText:rtlabelText];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame = CGRectMake(MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_LEFT - MARGIN_RIGHT, optimumSize.height);
    OriginY = OriginY + optimumSize.height;
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), OriginY + 30);
    rtLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:rtLabel];
    return self.frame.size.height;
}

//cell的高度
- (CGFloat)heightOfContents:(NSArray *)contents cellType:(cellType)cellType  otherViewHeight:(CGFloat)otherViewHeight indexPath:(NSIndexPath *)indexPath
{
    float OriginY = 0.0;

    //获取表情包
    NSDictionary *faceMap = [FaceBoard facailDictionary];

    int fontSize = [SettingModel sharedInstance].fontsize;

    float MARGIN_LEFT = 10;
    float MARGIN_RIGHT = 10;

    if (cellType == cellTypeArticla) {
        MARGIN_LEFT = 10;
    } else {
        MARGIN_LEFT = 20;
    }

    //    for (int index = 0; index < contents.count; index++) {
    //        article_content *content = [article_content objectAtIndex:index];
    //        [B3_PostBaseTableViewCell checkContent:acont faceMap:faceMap];
    //    }

    for (NSUInteger index = 0; index < contents.count; index++)
    {
        article_content *content = [contents objectAtIndex:index];
        if (content.type.intValue == contentTypeText || content.type.intValue == contentTypeFace) {//文字

            //富文本
            RCLabel *rtLabel = [[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_RIGHT - MARGIN_LEFT, 30)];
            [rtLabel setFont:[UIFont systemFontOfSize:fontSize]];
            NSString *rtlabelText = [[NSString alloc] initWithFormat:@""];
            if (content.type.intValue == contentTypeText) {
                rtlabelText = [rtlabelText stringByAppendingString:content.msg];
            }/* else  if (content.type.intValue == contentTypeFace) {
              NSString *faceimg = [faceMap objectForKey:content.msg];
              NSString *htmlcode = [NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
              rtlabelText = [rtlabelText stringByAppendingString:htmlcode];
              }*/

            while (index < contents.count - 1) {
                article_content *imgcontent=[contents objectAtIndex:++index];
                if (imgcontent.type.intValue == contentTypeFace) {
                    NSString *faceimg = [faceMap objectForKey:imgcontent.msg];
                    NSString *htmlcode = [NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
                    rtlabelText = [rtlabelText stringByAppendingString:htmlcode];
                } else if (imgcontent.type.intValue == contentTypeText) {
                    NSString *htmlcode = [NSString stringWithFormat:@"%@",imgcontent.msg];
                    rtlabelText = [rtlabelText stringByAppendingString:htmlcode];
                    RepeatTXTClassa *rptcls = [B3_PostView RepeatTXT:(int)index contents:contents rtlabelText:rtlabelText];
                    rtlabelText = rptcls.string;
                    index = rptcls.index;
                } else {
                    index--;
                    break;
                }
            }

            rtlabelText = [B3_PostView newText:rtlabelText];
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
            rtLabel.componentsAndPlainText = componentsDS;
            CGSize optimumSize = [rtLabel optimumSize];
            rtLabel.frame=CGRectMake(MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_LEFT - MARGIN_RIGHT, optimumSize.height);
            OriginY = OriginY + optimumSize.height;
        }/* else if (content.type.intValue == contentTypeQuoteReply) {//计算引用文本大小
          RCLabel *rtLabel = [[RCLabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_LEFT - MARGIN_RIGHT , 30)];
          [rtLabel setFont:[UIFont systemFontOfSize:fontSize]];
          NSString *rtlabelText = [[NSString alloc] initWithFormat:@""];
          NSString *message = [content.msg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
          message = [message stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
          rtlabelText = [rtlabelText stringByAppendingString:message];
          //            if (content.signmod.length) {
          //                if (![B3_PostBaseTableViewCell HideSignMode:(int)index content:acont]) {
          //                    NSString *htmlcode=[NSString stringWithFormat:@"<br /><img src='dzimages.bundle/%@.gif'></img>",acont.signmod];
          //                    rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
          //                }
          //            }
          rtlabelText=[B3_BaseTableViewCellData newText:rtlabelText];
          RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
          rtLabel.componentsAndPlainText = componentsDS;
          CGSize optimumSize = [rtLabel optimumSize];
          rtLabel.frame=CGRectMake(MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_LEFT - MARGIN_RIGHT, optimumSize.height);
          OriginY = OriginY + optimumSize.height;
          } else if (acont.type.intValue == CONTENTTYPE_ACTIVE)//活动啊 {
          OriginY = OriginY + [B3_PostView_Activity heightOfView:8];
          } */else if (content.type.intValue == contentTypeImage) {//图片

              BeeUIImageView *imgview = [[BeeUIImageView alloc] initWithFrame:DEFAULIMAGERECT(MARGIN_LEFT,OriginY,MARGIN_RIGHT)];
              //              imgview.defaultImage = [UIImage bundleImageNamed:@"morenwututubiao"];
              imgview.contentMode = UIViewContentModeScaleAspectFit;
              imgview.enableAllEvents = YES;

              /*if (content.type.integerValue == contentTypeNoImage) {
               imgview.image = [UIImage bundleImageNamed:@"tishihuamian"];
               }*/ if (content.type.integerValue == contentTypeImage) {
                   [imgview loadonlyCache:content.msg];//仅仅获取缓存
               }

              float width = imgview.image.size.width;
              float height = imgview.image.size.height;
              float imgwith = MIN(imgview.image.size.width, CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_RIGHT - MARGIN_LEFT);
              if (imgwith) {
                  imgwith = CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN_RIGHT - MARGIN_LEFT; //
                  //                if (acont.smileurl) {
                  //                    imgwith = SMILEFACAIL_WIDTH;
                  //                }
                  float scale =  height / width ;
                  float imgheight = imgwith * scale;  //imgview.image.size.height;
                  imgview.size = CGSizeMake(imgwith, imgheight);
                  CGRect frame = CGRectMake(MARGIN_LEFT, OriginY, imgwith, imgheight);
                  imgview.frame = frame;
                  OriginY = OriginY + imgheight + DEFAULINTERVAL;

              } else {
                  OriginY = OriginY + DEFAULTHEIGHT + DEFAULINTERVAL;
              }
          }
    }
    OriginY = OriginY  + 10 ;
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), OriginY + 30);

    [PFTableViewCell setHeight:OriginY + otherViewHeight atIndexPath:indexPath];

    //    return rect.size.height;
    return OriginY;
}

+(article_content *)checkContent:(article_content *)content faceMap:(NSDictionary *)faceMap
{
    article_content * tempcontent = content;
    if (content.type.intValue == contentTypeFace/* && content.smileurl*/) {
        NSString *faceimg= [faceMap objectForKey:content.msg];
        if (!faceimg) {
            content.type = [NSNumber numberWithInt:contentTypeImage];
            //            acont.msg = acont.smileurl;
            //            acont.originimg= acont.smileurl;
        }
    }
    return tempcontent;
}

+(RepeatTXTClassa *)RepeatTXT:(int)index contents:(NSArray *)contents rtlabelText:(NSString *)rtlabelText
{
    while (index < contents.count - 1) {
        article_content *txt = [contents objectAtIndex:++index];
        if (txt.type.intValue == contentTypeText) {
            if ([txt.msg isallHtmlMark]) {
                NSString *htmlcode=[NSString stringWithFormat:@"%@",txt.msg];
                rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
            }
            else
            {
                if (txt.msg.trim.length) {
                    NSString *htmlcode=[NSString stringWithFormat:@"%@",txt.msg];
                    rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
                }
            }
        } else {
            index--;
            break;
        }
    }
    RepeatTXTClassa *rptcls =[[RepeatTXTClassa alloc] init];
    rptcls.string = rtlabelText;
    rptcls.index = index;
    return rptcls;
}

- (void)loadContents:(NSArray *)contents height:(CGFloat)height contentView:(UIView *)contentView
{
    //    self.contentsAry = contents;

    //    if (!contentView) {
    //        CGRect frame = CGRectZero;
    //        if (!self.delegate || ![self.delegate respondsToSelector:@selector(frameOfCellHeader:)]) {
    //            return;
    //        }
    //        frame =[self.delegate frameOfCellHeader:self];
    //        contentView.frame = CGRectMake(0, CGRectGetMaxY(frame), CGRectGetWidth([UIScreen mainScreen].bounds), 60);
    //        contentView.backgroundColor = [UIColor clearColor];
    //        [self addSubview:contentView];
    //
    //        _btnreply.frame = FRAME_REPLYBTN(CGRectGetMaxY(_belowcontentView.frame));
    //        _btnsupport.frame = CGRectMake(_btnreply.frame.origin.x - 60, _btnreply.frame.origin.y - 8, _btnreply.frame.size.width, _btnreply.frame.size.height);
    //        _lblsupport.frame = CGRectMake(_btnsupport.frame.origin.x + 30, _btnreply.frame.origin.y - 3, _btnreply.frame.size.width, _btnreply.frame.size.height);
    //        //CGRectMake(self.frame.size.width - 30, 0, 30, 30);
    //    }

    NSMutableArray *subContentAry = [[NSMutableArray alloc] initWithCapacity:0];

    //    for (int index = 0; index < contents.count; index++)
    //    {
    //        article_content *content = [contents objectAtIndex:index];
    //        [B3_BaseTableViewCellData checkContent:content faceMap:faceMap];
    //    }

    float OriginY = 0.0;
    for (int index = 0; index < contents.count; index++)
    {
        article_content *content = [contents objectAtIndex:index];

        if (content.type.intValue == contentTypeText) {//内容为文字
            NSString *resstring = [self loadTextOrFacial:content contentView:contentView index:index OriginY:OriginY subContentAry:subContentAry contents:contents];
            NSArray *compants = [resstring componentsSeparatedByString:@":"];
            if (compants.count == 2) {
                NSString *compon1 = [compants objectAtIndex:0];
                NSString *compon2 = [compants objectAtIndex:1];
                OriginY = compon1.floatValue;
                index = compon2.intValue;
            }
        } else if (content.type.intValue == contentTypeImage || content.type.intValue== contentTypeNoImage) {//如果内容是图片
            OriginY = [self loadImages:content contentView:contentView index:index OriginY:OriginY subContentAry:subContentAry contents:contents];
        } else if (content.type.intValue == contentTypeQuoteReply) {
            NSString *resstring = [self loadVoteElement:content contentView:contentView index:index OriginY:OriginY subContentAry:subContentAry contents:contents];
            NSArray *compants = [resstring componentsSeparatedByString:@":"];
            if (compants.count == 2) {
                NSString *compon1 = [compants objectAtIndex:0];
                NSString *compon2 = [compants objectAtIndex:1];
                OriginY = compon1.floatValue;
                index = compon2.intValue;
            }
        }
    }
    //如果有更新的情况下去掉缓存里面的
    for(UIView *view in contentView.subviews)
    {
        int index = 0;
        for (index = 0 ;index < subContentAry.count; index ++) {
            UIView *view2  = [subContentAry objectAtIndex:index];
            if (view.tag >= HEADCONTENTVIEWSTARTTAG && view.tag  == view2.tag) {
                break;
            }
        }
        if (view.tag >= HEADCONTENTVIEWSTARTTAG && index >= subContentAry.count) {
            [view removeFromSuperview];
        }
    }

    OriginY = OriginY  + 10;
    contentView.size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), OriginY);
    //    contentView.frame = CGRectMake(0, CGRectGetMaxY(headerFrame), CGRectGetWidth([UIScreen mainScreen].bounds), OriginY);

    CGRect frame = contentView.frame;

    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 50);

    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetMaxY(contentView.frame) + 30);
    //    contentView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    //    if (self.delegate && [self.delegate isTopicArtile:self]) {
    //        BOOL topicarticle = [self.delegate isTopicArtile:self];
    //        if (topicarticle) {
    //            rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetMaxY(_belowcontentView.frame) + 50);
    //            self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    //        }
    //    }
    //    _cellheight = rect.size.height;
    //    if (send) {
    //        if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCellDidFinishLoad:frame:)])
    //        {
    //            [self.delegate B3_PostBaseTableViewCellDidFinishLoad:self frame:rect];
    //        }
    //    }
}

//加载图片
- (float)loadImages:(article_content *)content contentView:(UIView *)contentView index:(int)index OriginY:(float )OriginY subContentAry:(NSMutableArray *)subContentAry contents:(NSArray *)contents
{
    float IMG_MARGIN_LEFT = 10;
    float IMG_MARGIN_RIGHT = 10;
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(typeOfcell:)]) {
    //        CELL_TYPE type = [self.delegate typeOfcell:self];
    //        if (type == CELL_MAINTOPIC) {
    //            IMG_MARGIN_LEFT = DEF_HEAD_MARGIN_LEFT;
    //        }
    //        else if(type == CELL_REPLYTOPIC)
    //        {
    //            IMG_MARGIN_LEFT = DEF_CELL_MARGIN_LEFT;
    //        }
    //    }
    float tempOriginY = OriginY;
    BeeUIImageView *imgview = (BeeUIImageView *)[contentView viewWithTag:HEADCONTENTVIEWSTARTTAG + index];
    if ((imgview && ![[imgview class] isSubclassOfClass:[BeeUIImageView class]]) || (imgview && ![content.msg isEqualToString:imgview.loadedURL])) {//当图片的权限切换时
        [imgview removeFromSuperview];
        [subContentAry removeObject:imgview];
        imgview=nil;
    }
    if (!imgview)
    {
        imgview = [[BeeUIImageView alloc] initWithFrame:DEFAULIMAGERECT(IMG_MARGIN_LEFT, OriginY, IMG_MARGIN_RIGHT)];
        imgview.defaultImage = [UIImage bundleImageNamed:@"morenwututubiao"];
        imgview.tag = index + HEADCONTENTVIEWSTARTTAG;
        imgview.backgroundColor = [UIColor clearColor];//调试的时候讲此赋值
        imgview.indicator = [imgview indicator];
        imgview.contentMode = UIViewContentModeScaleAspectFit;// UIViewContentModeScaleAspectFit;
        imgview.backupurl = content.msg;
        imgview.userInteractionEnabled = YES;
        imgview.enableAllEvents = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        tap.numberOfTapsRequired = 1;
        [imgview addGestureRecognizer:tap];
        [self addSubview:imgview];
        [subContentAry addObject:imgview];

        /*if (content.type.integerValue == contentTypeNoImage) {
         imgview.image = [UIImage bundleImageNamed:@"tishihuamian"];
         } else*/ if (content.type.integerValue == contentTypeImage) {
             [imgview setData:content.msg baseNetwork:YES];
         }
    } else {
        [subContentAry addObject:imgview];
    }

    float width = imgview.image.size.width;
    float height = imgview.image.size.height;
    float imgwith = MIN(imgview.image.size.width, CGRectGetWidth([UIScreen mainScreen].bounds) - IMG_MARGIN_LEFT - IMG_MARGIN_RIGHT);
    if (imgwith) {
        imgwith = CGRectGetWidth([UIScreen mainScreen].bounds) - IMG_MARGIN_LEFT - IMG_MARGIN_RIGHT;
        //        if (content.smileurl) {
        //            imgwith = SMILEFACAIL_WIDTH;
        //        }
        float scale = height / width ;
        float imgheight = imgwith * scale;  //imgview.image.size.height ;
        imgview.size = CGSizeMake(imgwith, imgheight);
        CGRect frame = CGRectMake(IMG_MARGIN_LEFT, OriginY, imgwith, imgheight);
        imgview.frame = frame;
        OriginY = OriginY + imgheight + DEFAULINTERVAL;
    } else {
        OriginY = OriginY + DEFAULTHEIGHT + DEFAULINTERVAL;
    }
    tempOriginY = OriginY;
    return tempOriginY;
}

//加载文字
- (NSString *)loadTextOrFacial:(article_content *)content contentView:(UIView *)contentView index:(int)index OriginY:(float )OriginY subContentAry:(NSMutableArray *)subContentAry contents:(NSArray *)contents
{
    float TXT_MARGIN_LEFT = 10;
    float TXT_MARGIN_RIGHT = 10;
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(typeOfcell:)]) {
    //        CELL_TYPE type = [self.delegate typeOfcell:self];

    //        if (type == CELL_MAINTOPIC) {
    //            TXT_MARGIN_LEFT = DEF_HEAD_MARGIN_LEFT;
    //        } else if(type == CELL_REPLYTOPIC) {
    //            TXT_MARGIN_LEFT = DEF_CELL_MARGIN_LEFT;
    //        }
    //    }

    float tempOriginY = OriginY;
    RCLabel *rtLabel = (RCLabel *)[contentView viewWithTag:HEADCONTENTVIEWSTARTTAG + index];

    if (rtLabel && ![[rtLabel class] isSubclassOfClass:[RCLabel class]]) {//有图和无图切换
        [subContentAry removeObject:rtLabel];
        [rtLabel removeFromSuperview];
        rtLabel = nil;
    }

    int currentIndex = index;
    //    int tempfontsize = self.fontsize;
    //    tempfontsize = tempfontsize * 2 + FONT_MIDDLEBASE;

    if (!rtLabel) {
        rtLabel = [[RCLabel alloc] initWithFrame:CGRectMake(TXT_MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - TXT_MARGIN_LEFT - TXT_MARGIN_RIGHT, 3000)];
        [rtLabel setFont:[UIFont systemFontOfSize:16]];
        rtLabel.tag = currentIndex + HEADCONTENTVIEWSTARTTAG;
        rtLabel.backgroundColor = [UIColor clearColor];
        rtLabel.delegate = self;
        [self addSubview:rtLabel];
    }

    //    rtLabel.backgroundColor = [UIColor clearColor];
    NSString *rtlabelText = [[NSString alloc] initWithFormat:@""];
    //    if (content.type.intValue == contentTypeText) {
    rtlabelText = [rtlabelText stringByAppendingString:content.msg];
    [subContentAry addObject:rtLabel];
    //    } else if (content.type.intValue == contentTypeImage) {
    //        NSString *faceimg= [faceMap objectForKey:content.msg];
    //        if(!faceimg)
    //        {
    //
    //        }
    //        NSString *htmlcode=[NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
    //        rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
    //    }

    //    while (index < contents.count - 1) {
    //        article_content *imgcontent = [contents objectAtIndex:index];
    //        if (imgcontent.type.intValue == contentTypeFace) {
    //            NSString *faceimg= [faceMap objectForKey:imgcontent.msg];
    //            NSString *htmlcode=[NSString stringWithFormat:@"<img src='image.bundle/expressions/%@.png'></img>",faceimg];
    //            rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
    //        } else if (imgcontent.type.intValue == contentTypeText) {
    //            NSString *htmlcode=[NSString stringWithFormat:@"%@",imgcontent.msg];
    //            rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
    //            RepeatTXTClassa *rptcls = [B3_BaseTableViewCellData RepeatTXT:index contents:contents rtlabelText:rtlabelText];
    //            rtlabelText = rptcls.string;
    //            index = (int)rptcls.index;
    //        } else {
    //            index--;
    //            break;
    //        }
    //    }

    rtlabelText=[B3_PostView newText:rtlabelText];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame = CGRectMake(TXT_MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - TXT_MARGIN_LEFT - TXT_MARGIN_RIGHT, optimumSize.height);
    OriginY = OriginY + optimumSize.height;
    [subContentAry addObject:rtLabel];

    tempOriginY = OriginY;
    return [NSString stringWithFormat:@"%f:%d",tempOriginY,index];
}

/*
 整合contentary 数组
 将txt和表情
 */
- (NSString *)loadVoteElement:(article_content *)content contentView:(UIView *)contentView index:(int)index OriginY:(float )OriginY subContentAry:(NSMutableArray *)subContentAry contents:(NSArray *)contents
{
    float VOTE_MARGIN_LEFT = 10;
    float VOTE_MARGIN_RIGHT = 10;
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(typeOfcell:)]) {
    //        CELL_TYPE type = [self.delegate typeOfcell:self];
    //        if (type == cellTypeArticla) {
    //            VOTE_MARGIN_LEFT = DEF_HEAD_MARGIN_LEFT;
    //        } else if(type == cellTypeReply) {
    //            VOTE_MARGIN_LEFT = DEF_CELL_MARGIN_LEFT;
    //        }
    //    }


    float tempOriginY = OriginY;
    RCLabel *rtLabel = (RCLabel *)[contentView viewWithTag:HEADCONTENTVIEWSTARTTAG+index];
    rtLabel.backgroundColor = VOTECOLOR;
    int  currentIndex = index;
    //    int tempfontsize = self.fontsize;
    //    tempfontsize = tempfontsize * 2 + FONT_MIDDLEBASE;

    if (rtLabel && ![[rtLabel class] isSubclassOfClass:[RCLabel class]]) {
        //切换时候
        [rtLabel removeFromSuperview];
        rtLabel=nil;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    if (!rtLabel) {
        rtLabel=[[RCLabel alloc] initWithFrame:CGRectMake(VOTE_MARGIN_LEFT, OriginY, rect.size.width - VOTE_MARGIN_LEFT -VOTE_MARGIN_RIGHT, 50)];
        rtLabel.delegate = self;
        //        [rtLabel setFont:[UIFont systemFontOfSize:tempfontsize]];
        rtLabel.tag = currentIndex + HEADCONTENTVIEWSTARTTAG;
        [contentView addSubview:rtLabel];
    }

    [subContentAry addObject:rtLabel];
    NSString *rtlabelText=[[NSString alloc] initWithFormat:@""];
    if (content.type.intValue == contentTypeQuoteReply)
    {
        rtLabel.backgroundColor = VOTECOLOR;
        rtlabelText=[rtlabelText stringByAppendingString:content.msg];
        //        if (content.signmod.length) {
        //            if (![B3_BaseTableViewCellData HideSignMode:index content:content]) {
        //                NSString *htmlcode=[NSString stringWithFormat:@"<br /><img src='dzimages.bundle/%@.gif'></img>",content.signmod];
        //                rtlabelText=[rtlabelText stringByAppendingString:htmlcode];
        //            }
        //        }
    }
    rtlabelText=[B3_PostView newText:rtlabelText];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rtlabelText];
    rtLabel.componentsAndPlainText = componentsDS;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame=CGRectMake(VOTE_MARGIN_LEFT, OriginY, CGRectGetWidth([UIScreen mainScreen].bounds) - VOTE_MARGIN_LEFT -VOTE_MARGIN_RIGHT, 100);
    OriginY = OriginY + optimumSize.height;
    tempOriginY = OriginY;
    return [NSString stringWithFormat:@"%f:%d",tempOriginY,index];
}

+(BOOL)HideSignMode:(int)index content:(article_content *)acont
{
    //    if ([acont.msg rangeOfString:QIANDAO_MARK].location!=NSNotFound && index ==0) {
    //        return YES;
    //    }
    return NO;
}

#pragma mark - 用网页加载
-(void)loadwebcontents:(NSArray *)contents senddelegate:(BOOL)send
{
    //    if (!_belowcontentView) {
    //        CGRect rect = [UIScreen mainScreen].bounds;
    //        _belowcontentView=[[UIView alloc] init];
    //        _belowcontentView.backgroundColor = [UIColor clearColor];
    //        webcontentview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 50)];
    //        webcontentview.delegate=self;
    //        webcontentview.opaque = NO;
    //        webcontentview.scrollView.delegate=self;
    //        webcontentview.backgroundColor = [UIColor clearColor];
    //        [(UIScrollView *)[[webcontentview subviews] objectAtIndex:0] setBounces:NO];
    //        //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
    //        [webcontentview setScalesPageToFit:NO];
    //        [_belowcontentView addSubview:webcontentview];
    //        _belowcontentView.frame = CGRectMake(0, CGRectGetMaxY(headerFrame), rect.size.width, 60);
    //        [self addSubview:_belowcontentView];
    //    }
    //    float OriginY=0.0;
    //    NSMutableString *webcontent=[NSMutableString string];
    //    NSString * headHtml=@"<html>";
    //    NSString * tailHtml=@"</body></html>";
    //    NSString *header=@"\
    //    <head>\
    //    <meta charset=\"UTF-8\">\
    //    <title></title>\
    //    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
    //    <style>\
    //    img {\
    //    max-width: 100%;\
    //    height: auto;\
    //    }\
    //    </style>\
    //    </head><body>";
    //
    //    webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@%@",headHtml,header];
    //    for (int index=0; index<contents.count; index++) {
    //        content *acont=[contents objectAtIndex:index];
    //        //        if (!acont.msg.length) {
    //        //            continue;
    //        //        }
    //        if (acont.type.intValue==0) {//如果内容是网页文字
    //            acont.msg=[acont.msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //            NSString *message =[NSString stringWithFormat:@"<font size=\"%d\">%@</font>",self.fontsize,acont.msg];
    //            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",message];
    //        }
    //        else if (acont.type.intValue == 3)
    //        {
    //            acont.msg=[acont.msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //            NSString *message =[NSString stringWithFormat:@"<font size=\"%d\">%@</font>",self.fontsize,acont.msg];
    //            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",message];
    //        }
    //        else if (acont.type.intValue == 2) {//如果内容是表情
    //
    //            NSString *faceimg= [faceMap objectForKey:acont.msg];
    //            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"30\" height=\"30\" />",[NSString stringWithFormat:@"image.bundle/expressions/%@.png",faceimg]];
    //
    //        }
    //        else if (acont.type.intValue==1) {//如果内容是图片
    //            if ( ![BeeReachability isReachableViaWIFI] )//是否加载图片
    //            {
    //                if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_23G_NOTLOAD)
    //                {
    //                    break;
    //                }
    //            }
    //            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<p><img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"200\" height=\"50\" /></p>",acont.msg];
    //        }
    //        else if (acont.type.intValue == 5 ) {//如果无权限的图
    //            webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"<img alt=\"\" src=\"%@\" style=\"border: none;\" align=\"middle\" width=\"200\" height=\"50\" /></p>",[NSString stringWithFormat:@"tishihuamian@2x.png"]];
    //        }
    //    }
    //    webcontent = (NSMutableString *)[webcontent stringByAppendingFormat:@"%@",tailHtml];
    //    NSString *filepath = [[NSBundle mainBundle] bundlePath];
    //    NSURL *baseURL = [NSURL fileURLWithPath:filepath];
    //    CGRect mainrect = [UIScreen mainScreen].bounds;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [webcontentview loadHTMLString:webcontent baseURL:baseURL];
    //        _belowcontentView.size=CGSizeMake(mainrect.size.width, OriginY);
    //        _belowcontentView.frame=CGRectMake(0, CGRectGetMaxY(headerFrame), mainrect.size.width, OriginY);
    //        sendDelegate = send;
    //    });
}

#pragma mark - Events Management

- (void)imageViewTap:(UITapGestureRecognizer *)gesture
{
    BeeUIImageView *imgview = (BeeUIImageView *)gesture.view;
    if ([self.delegate respondsToSelector:@selector(B3_PostData:ShowBigImgview:imageView:)]) {
        if ([imgview.loadedURL rangeOfString:@"null"].location == NSNotFound) {
            NSString *imgurl= [NSString stringWithFormat:@"%@", imgview.loadedURL];
            [self.delegate B3_PostData:self ShowBigImgview:imgurl imageView:imgview];
        } else {
            [self.delegate B3_PostData:self ShowBigImgview:imgview.backupurl imageView:imgview];
        }
    }
}

#pragma mark - RTLabelDelegate

- (void)rtLabel:(RCLabel *)rtLabel didSelectLinkWithURL:(NSString *)url
{
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:rtLabel:didSelectLinkWithURL:)]) {
    //        [self.delegate B3_PostBaseTableViewCell:self rtLabel:rtLabel didSelectLinkWithURL:url];
    //    }
}

- (void)rtlabel:(RCLabel *)rtlabel LongPress:(UIGestureRecognizer *)recognizer
{
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(B3_PostBaseTableViewCell:rtlabel:LongPress:)]) {
    //        [self.delegate B3_PostBaseTableViewCell:self rtlabel:rtlabel LongPress:recognizer];
    //    }
}

- (void)dealloc
{
    
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
