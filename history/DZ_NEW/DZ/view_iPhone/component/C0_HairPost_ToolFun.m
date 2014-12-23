//
//  C0_HairPost_ToolFun.m
//  DZ
//
//  Created by nonato on 14-10-28.
//
//

#import "C0_HairPost_ToolFun.h"
#import "UIImage+Bundle.h"
#import "SETextView.h"
#import "ToolsFunc.h"
#import "FaceBoard.h"
#import "newTopic.h"
@implementation DratfStruct
@end

@implementation C0_HairPost_ToolFun
DEF_SINGLETON(C0_HairPost_ToolFun)


#pragma mark - 保存草稿
-(void)saveDrafts
{
    return;//先不保存草稿
//    DratfStruct *adraft=[[DratfStruct alloc] init];
//    adraft.title=self.titleTxt.text;
//    adraft.plates=self.selectforumbtn.titleLabel.text;
//    adraft.selectfid=self.selectfid;
//    [DratfStruct saveObject:adraft forKey:DRAFTSTRUCT];
//    
//    NSArray * array=[self spliteContentWithattAry:_fastTextView.attachments.allObjects atrributestr:_fastTextView.attributedText UploadedImageAry:self.UploadedImageAry];
//    
//    [[newTopicModel sharedInstance] savedraft:array];
}


-(BOOL)isFacialMark:(NSString *)mark seTextView:(SETextView *)textview
{
    if ([mark rangeOfString:@":"].location != NSNotFound) {
        NSString *facename=[FaceBoard faceFileName:mark];
        UIImage *stampImage = [UIImage bundleImageNamed:facename];
        if (stampImage) {
            textview.addobj_name=mark;
            textview.addobj_type=@"2";
            [textview insertObject:stampImage size:stampImage.size];
            return YES;
        }
    }
    return NO;
}


#pragma mark - 切分句子将文件和图片分开提取句子
-(NSMutableArray *)spliteContentWithattAry:(NSArray *)attAry atrributestr:(NSAttributedString *)AttributedString UploadedImageAry:(NSMutableArray *)UploadedImageAry
{
    NSMutableArray *contentTextAry=[[NSMutableArray alloc] init];
    NSMutableArray *array=[NSMutableArray arrayWithArray:attAry];
    if (attAry.count && !UploadedImageAry.count) {
        newtopicContent *acont1=[[newtopicContent alloc] init];
        acont1.msg=AttributedString.string;
        acont1.type=[NSNumber numberWithInt:TEXTTYPE];
        [contentTextAry addObject:acont1];
        [contentTextAry addObject:[C0_HairPost_ToolFun pushDeviceMark]];
        return contentTextAry;
    }
    NSSortDescriptor *goodscodeDesc = [NSSortDescriptor sortDescriptorWithKey:@"sortforRangLocation" ascending:YES];
    NSArray *descs = @[goodscodeDesc];
    array =[NSMutableArray arrayWithArray:[attAry sortedArrayUsingDescriptors:descs]];
    
    int imgIndex=0;
    for (int index=0;index<array.count;index++) {
        id object=[array objectAtIndex:index];
        if (![[object class] isSubclassOfClass:NSClassFromString(@"SETextAttachment")]) {
            continue;
        }
        SETextAttachment *achtment=(SETextAttachment *)object;
        if (index==0) {
            if (achtment.range.location) {
                NSAttributedString *substr=[AttributedString attributedSubstringFromRange:NSMakeRange(0, achtment.range.location)];
                newtopicContent *acont1=[[newtopicContent alloc] init];
                acont1.msg=substr.string;
                acont1.type=[NSNumber numberWithInt:TEXTTYPE];
                [contentTextAry addObject:acont1];
            }
            if ([achtment.type isEqual:@"1"]) {
                if (UploadedImageAry.count>imgIndex) {
                    newtopicContent *imgcont=[UploadedImageAry objectAtIndex:imgIndex];//加入图片
                    [contentTextAry addObject:imgcont];
                    imgIndex++;
                }
            }
            else if ([achtment.type isEqual:@"2"]) {
                newtopicContent *facecont=[[newtopicContent alloc] init];
                facecont.msg=achtment.name;
                facecont.type=[NSNumber numberWithInt:FACETYPE];
                [contentTextAry addObject:facecont];
            }
        }
        else
        {
            SETextAttachment *lastachtment=[array objectAtIndex:index-1];
            NSUInteger lastpostion=lastachtment.range.location+lastachtment.range.length;
            if (achtment.range.location >  lastpostion) {
                NSAttributedString *substr=[AttributedString attributedSubstringFromRange:NSMakeRange(lastpostion,(achtment.range.location-lastpostion))];
                newtopicContent *acont1=[[newtopicContent alloc] init];
                acont1.msg=substr.string;
                acont1.type=[NSNumber numberWithInt:TEXTTYPE];
                [contentTextAry addObject:acont1];
            }
            if ([achtment.type isEqual:@"1"]) {//图片
                if (UploadedImageAry.count>imgIndex) {
                    newtopicContent *imgcont=[UploadedImageAry objectAtIndex:imgIndex];//加入图片
                    [contentTextAry addObject:imgcont];
                    imgIndex++;
                }
            }
            else if ([achtment.type isEqual:@"2"]) {//表情
                newtopicContent *facecont=[[newtopicContent alloc] init];
                facecont.msg=achtment.name;
                facecont.type=[NSNumber numberWithInt:FACETYPE];
                [contentTextAry addObject:facecont];
            }
        }
    }
    SETextAttachment *achtment=[array lastObject];
    if ((achtment.range.location+achtment.range.length)<(AttributedString.length)) {
        NSUInteger length=AttributedString.length-(achtment.range.location+achtment.range.length);
        NSUInteger location=achtment.range.location+achtment.range.length ;
        NSAttributedString *substr=[AttributedString attributedSubstringFromRange:NSMakeRange(location,length)];
        newtopicContent *acont1=[[newtopicContent alloc] init];
        acont1.msg=substr.string;
        acont1.type=[NSNumber numberWithInt:TEXTTYPE];
        [contentTextAry addObject:acont1];
    }
    /*插入标签 发布于iOS客户端*/
    [contentTextAry addObject:[C0_HairPost_ToolFun pushDeviceMark]];
    return contentTextAry;
}


#pragma mark - 发布标签
+(newtopicContent *)pushDeviceMark
{
    newtopicContent *acont1=[[newtopicContent alloc] init];
    NSString * device = [ToolsFunc   deviceType];
    acont1.msg= TL_PUSTMAK(device) ;
    acont1.type=[NSNumber numberWithInt:TEXTTYPE];
    return acont1;
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(float)imageSizewithUrl:(NSString *)url
{
    UIImage * image = [[BeeImageCache sharedInstance] memoryImageForURL:url];
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    float filesize = [imageData length]/1024.0/1024.0;
    return filesize;
}


@end
