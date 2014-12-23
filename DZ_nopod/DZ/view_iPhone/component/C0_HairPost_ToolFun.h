//
//  C0_HairPost_ToolFun.h
//  DZ
//
//  Created by nonato on 14-10-28.
//
//

#import <Foundation/Foundation.h>
#import "bee.h" 
#import "postImage.h"
#import "SETextView.h"

#define DRAFTSTRUCT @"draftstruct"
#define DRAFTSTITLE  @"draftstitle"
#define DRAFTSPLATESNAME @"selectforumbtnText"
#define TEXTTYPE 0
#define IMGTYPE  1
#define FACETYPE 0
#define TITLTTAG 7031051
#define CONTENTTAG 7031052

@interface DratfStruct : NSObject
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * plates;
@property(nonatomic,strong)NSString * selectfid;
@end

@interface C0_HairPost_ToolFun : NSObject
AS_SINGLETON(C0_HairPost_ToolFun)

-(NSMutableArray *)spliteContentWithattAry:(NSArray *)attAry atrributestr:(NSAttributedString *)AttributedString UploadedImageAry:(NSMutableArray *)UploadedImageAry;

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
-(void)saveDrafts;
-(BOOL)isFacialMark:(NSString *)mark seTextView:(SETextView *)textview;
+(newtopicContent *)pushDeviceMark;

-(float)imageSizewithUrl:(NSString *)url;
@end
