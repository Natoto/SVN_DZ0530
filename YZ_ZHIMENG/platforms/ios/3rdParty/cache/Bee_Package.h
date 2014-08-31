//
//  Bee_Package.h
//  YZ_ZM
//
//  Created by Nonato on 14-8-28.
//
//

#pragma mark -

#undef	AS_NAMESPACE
#define AS_NAMESPACE( __name ) \
@class BeePackage; \
extern BeePackage *	__name; \
@interface __Namespace_##__name : BeePackage \
AS_SINGLETON( __Namespace_##__name ) \
@end

#undef	DEF_NAMESPACE
#define DEF_NAMESPACE( __name ) \
BeePackage * __name = nil; \
@implementation __Namespace_##__name \
DEF_SINGLETON( __Namespace_##__name ) \
+ (void)load \
{ \
__name = [__Namespace_##__name sharedInstance]; \
} \
@end

#undef	NAMESPACE
#define	NAMESPACE( __name ) \
__Namespace_##__name

#pragma mark -

#undef	AS_PACKAGE
#define AS_PACKAGE( __parentClass, __class, __propertyName ) \
@class __class; \
@interface __parentClass (AutoLoad_##__propertyName) \
@property (nonatomic, readonly) __class * __propertyName; \
@end

#undef	DEF_PACKAGE
#define DEF_PACKAGE( __parentClass, __class, __propertyName ) \
@implementation __parentClass (AutoLoad_##__propertyName) \
@dynamic __propertyName; \
- (__class *)__propertyName \
{ \
return [__class sharedInstance]; \
} \
@end

#undef	AS_PACKAGE_
#define AS_PACKAGE_( __parentClass, __class, __propertyName ) \
@class __class; \
@interface __parentClass (AutoLoad_##__propertyName) \
@property (nonatomic, readonly) __class * __propertyName; \
@end \
@interface __class : NSObject \
AS_SINGLETON( __class ); \
@end

#undef	DEF_PACKAGE_
#define DEF_PACKAGE_( __parentClass, __class, __propertyName ) \
@implementation __parentClass (AutoLoad_##__propertyName) \
@dynamic __propertyName; \
- (__class *)__propertyName \
{ \
return [__class sharedInstance]; \
} \
@end \
@implementation __class \
DEF_SINGLETON( __class ); \
@end

#pragma mark -