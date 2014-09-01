//
//  DZ_SystemSetting.m
//  DZ
//
//  Created by Nonato on 14-6-10.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

typedef enum : NSInteger {
    MSG_ZHANNEI = 1,
    MSG_FRIENDS = 2,
    MSG_SYSTEM = 3,
} MSG_TYPE_FILTE;


#import "ZM_SystemSetting.h"
#import "TouchXML.h"
#import <objc/runtime.h>
#import "Constants.h"
#import "NSObject+BeeUserDefaults.h"
#import "NSObject+BeeJSON.h"
#import "Constants.h"
#pragma mark - 程序外配置信息


#pragma  mark - 程序内配置信息
@implementation DZ_SYS_IGNORE
@end

#pragma mark - 是否保存密码
@implementation DZ_SYS_SAVESCR
@end


@implementation ZM_SystemSetting

- (instancetype)sharedInstance \
{ \
    return [[self class] sharedInstance]; \
} \
+ (instancetype)sharedInstance \
{ \
    static dispatch_once_t once; \
    static id __singleton__; \
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
    return __singleton__; \
}

-(id)init
{
    self=[super init];
    if (self) {
        NSString *folderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [folderPath stringByAppendingPathComponent:@"DefaultConfigure.xml"];
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:filePath])//文件存在 则加载该文件
        {
            filePath=[[NSBundle mainBundle] pathForResource:@"DefaultConfigure" ofType:@"xml"];
        }//文件不存在加载默认配置文件
        NSData *XMLData = [NSData dataWithContentsOfFile:filePath];
        //生成CXMLDocument对象
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                            options:0
                                                              error:nil];
        
        NSDictionary *diction= [self parseRoot:document];
        self.websiteurl = [[diction valueForKey:@"websiteurl"] valueForKey:@"text"];
        self.forumurl =  [[diction valueForKey:@"forumurl"] valueForKey:@"text"];
        self.downloadurl = [[diction valueForKey:@"downloadurl"] valueForKey:@"text"];
        self.appid =[[diction valueForKey:@"appid"] valueForKey:@"text"];
        self.appname =[[diction valueForKey:@"appname"] valueForKey:@"text"];
        self.appcolor =[NSString stringWithFormat:@"%@",[[diction valueForKey:@"appcolor"] valueForKey:@"text"]];
        self.appversion = [NSString stringWithFormat:@"%@",[[diction valueForKey:@"appversion"] valueForKey:@"text"]];
        self.apptemplate = [NSString stringWithFormat:@"%@",[[diction valueForKey:@"apptemplate"] valueForKey:@"text"]];
        self.clientVersion = [NSString stringWithFormat:@"%@",[[diction valueForKey:@"clientVersion"] valueForKey:@"text"]];
        
//        if (color) {
//            unsigned long red = strtoul([color UTF8String],0,16);
//            self.navigationbarcolor = KT_HEXCOLOR(red);
//        }
        
//        if (backcolor) {
//            unsigned long red = strtoul([backcolor UTF8String],0,16);
//            self.backgroundcolor = KT_HEXCOLOR(red);
//        }

    }
    return self;
}
 
//获得一个类中的所有变量和函数名
//传递一个变量名称stringxing和类名称string型 得到其对应的值
- (NSString *)nameWithInstance:(id)instance target:(id)target
{
    unsigned int numIvars = 0;
    NSString *myvalue= [[NSString alloc] init];
    Ivar * ivars = class_copyIvarList([target class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        NSString *instance2 = [NSString stringWithFormat:@"_%@",instance];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ([key isEqualToString:instance] || [key isEqualToString:instance2]) {
            //　获取变量值
            id value = [target valueForKey:key];
            myvalue = value;
            break;
        } 
    }
    free(ivars);
    return myvalue;
    
}

+(NSMutableArray *)classtoarray:(id)cls
{
    unsigned int numIvars = 0;
//    NSString *myvalue= [[NSString alloc] init];
    NSMutableArray * array =[[NSMutableArray alloc] init];
    Ivar * ivars = class_copyIvarList([cls class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
//        if ([key isEqualToString:instance] || [key isEqualToString:instance2]) {
            //　获取变量值
        id value = [cls valueForKey:key];
        [array addObject:value];
//            myvalue = value;
//            break;
//        }
    }
    free(ivars);
    return array;
}

//-(NSString *)aboutus:(NSString *)para
//{
////    NSString *classstr=[NSString stringWithFormat:@"self.configration.aboutus.%@",para];
//    NSString *string = [self nameWithInstance:para target:self.configration.aboutus];//(NSString *) NSClassFromString(classstr);
//    return string;
//}
#pragma mark - 解析xml配置数据
- (NSDictionary *) parseRoot:(CXMLDocument *) document
{
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];
   
    NSMutableDictionary *nodeitem = [[NSMutableDictionary alloc] init];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
//                    if ([[element name] isEqualToString:@"navigationbar"])
//                    {
//                        [item setObject:[[element childAtIndex:i] stringValue] forKey:[[element childAtIndex:i] name]];
//                        NSLog(@"1--%@", [[element childAtIndex:i] stringValue] );
//                    }
                }
                    [item setObject:[[element childAtIndex:i] stringValue] forKey:[[element childAtIndex:i] name]];
                    NSLog(@"3--%@", [[element childAtIndex:i] stringValue] );
            }
            if (item) {
                [nodeitem setObject:item forKey:[element name]];
            }
        }
    }
    NSLog(@"%@", nodeitem);
    return nodeitem;
}


- (void) parseDire:(CXMLDocument *) document
{
    NSArray *books = NULL;
    books = [document nodesForXPath:@"//navigationbar" error:nil];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }
            //NSLog(@"%@", item);
        }
    }
    //
    books = [document nodesForXPath:@"//tabbar" error:nil];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }
            //NSLog(@"%@", item);
        }
    }
}


#pragma mark - 是否保存密码
-(BOOL)saveUserSecret
{
    NSString *key=KEY_REMEMBERSECRET;
    DZ_SYS_SAVESCR *ignore=[DZ_SYS_SAVESCR readObjectForKey:key];
    return ignore.save.boolValue;
    
}

-(void)saveUserSecret:(BOOL)save
{
    DZ_SYS_SAVESCR *ignore=[[DZ_SYS_SAVESCR alloc] init];
    ignore.save=[NSNumber numberWithBool:save];
    NSString *key=KEY_REMEMBERSECRET;
    [DZ_SYS_SAVESCR  saveObject:ignore forKey:key];
}

+(BOOL)saveUserSecret
{
    ZM_SystemSetting *setting=[ZM_SystemSetting sharedInstance];
    return [setting saveUserSecret];
}

+(void)saveUserSecret:(BOOL)save
{
     ZM_SystemSetting *setting=[ZM_SystemSetting sharedInstance];
    [setting saveUserSecret:save];
}

#pragma mark - 忽略系统消息

-(void)saveIgnoreSetting:(MSG_TYPE_FILTE) msg_type ignore:(BOOL)isignore
{
    DZ_SYS_IGNORE *ignore=[[DZ_SYS_IGNORE alloc] init];
    ignore.ignore=[NSNumber numberWithBool:isignore];
    
    NSString *key=[NSString stringWithFormat:@"DZ_SYS_IGNORE_%d",msg_type];
    [DZ_SYS_IGNORE  saveObject:ignore forKey:key];
}

-(BOOL)readIgnoreSetting:(MSG_TYPE_FILTE) msg_type
{
     NSString *key=[NSString stringWithFormat:@"DZ_SYS_IGNORE_%d",msg_type];
    DZ_SYS_IGNORE *ignore=[DZ_SYS_IGNORE readObjectForKey:key];
    return ignore.ignore.boolValue;
}

+(void)saveIgnoreSetting:(MSG_TYPE_FILTE)msg_type ignore:(BOOL)isignore
{
    ZM_SystemSetting *setting=[ZM_SystemSetting sharedInstance];
    [setting saveIgnoreSetting:msg_type ignore:isignore];
}

+(BOOL)readIgnoreSetting:(MSG_TYPE_FILTE) msg_type
{
    ZM_SystemSetting *setting=[ZM_SystemSetting sharedInstance];
    return [setting readIgnoreSetting:msg_type];
}
@end
