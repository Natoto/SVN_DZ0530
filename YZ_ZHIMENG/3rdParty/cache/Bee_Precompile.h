//
//  Bee_Precompile.h
//  YZ_ZM
//
//  Created by Nonato on 14-8-28.
//
//

#pragma mark -

typedef enum
{
	BeeLogLevelNone		= 0,
	BeeLogLevelInfo		= 100,
	BeeLogLevelPerf		= 200,
	BeeLogLevelWarn		= 300,
	BeeLogLevelError	= 400
} BeeLogLevel;

#pragma mark -

#if __BEE_LOG__

#if __BEE_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[BeeLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:BeeLogLevelNone format:__VA_ARGS__];

#else	// #if __BEE_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[BeeLogger sharedInstance] level:BeeLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[BeeLogger sharedInstance] level:BeeLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[BeeLogger sharedInstance] level:BeeLogLevelNone format:__VA_ARGS__];

#endif	// #if __BEE_DEVELOPMENT__

#undef	VAR_DUMP
#define VAR_DUMP( __obj )	PRINT( [__obj description] );

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )	PRINT( [__obj objectToDictionary] );

#else	// #if __BEE_LOG__

#undef	CC
#define CC( ... )

#undef	INFO
#define INFO( ... )

#undef	PERF
#define PERF( ... )

#undef	WARN
#define WARN( ... )

#undef	ERROR
#define ERROR( ... )

#undef	PRINT
#define PRINT( ... )

#undef	VAR_DUMP
#define VAR_DUMP( __obj )

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )

#endif	// #if __BEE_LOG__

#undef	TODO
#define TODO( desc, ... )

#pragma mark -

#ifndef YZ_ZM_Bee_Precompile_h
#define YZ_ZM_Bee_Precompile_h

#import "Bee_Package.h"
#import "Bee_Singleton.h"
#endif
