//
//  DZ_SystemSetting.h
//  DZ
//
//  Created by Nonato on 14-6-10.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
 

#define KEY_REMEMBERSECRET @"key.remembersecret"


@interface DZ_SYS_IGNORE : NSObject
@property(nonatomic,retain) NSNumber *ignore;
@end

@interface DZ_SYS_SAVESCR : NSObject
@property(nonatomic,retain) NSNumber *save;
@end


@interface ZM_SystemSetting : NSObject
- (instancetype)sharedInstance; \
+ (instancetype)sharedInstance; 

@property (nonatomic, strong) NSString * websiteurl;
@property (nonatomic, strong) NSString * appid;
@property (nonatomic, strong) NSString * appname;
@property (nonatomic, strong) NSString * appversion;
@property (nonatomic, strong) NSString * apptemplate;
@property (nonatomic, strong) NSString * appcolor;
@property (nonatomic, strong) NSString * clientVersion;

@property (nonatomic, strong) NSString * forumurl;
@property (nonatomic, strong) NSString * downloadurl;

//忽略消息

+(NSMutableArray *)classtoarray:(id)cls;
//保存密码
-(BOOL)saveUserSecret;
-(void)saveUserSecret:(BOOL)save;

+(BOOL)saveUserSecret;
+(void)saveUserSecret:(BOOL)save;
 
@end
