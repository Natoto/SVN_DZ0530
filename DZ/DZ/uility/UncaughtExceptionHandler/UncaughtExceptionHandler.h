//
//  UncaughtExceptionHandler.h
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
#ifndef __KT_UN_CAUGHT_EXCEPTION_HANDLER_H__
#define __KT_UN_CAUGHT_EXCEPTION_HANDLER_H__

#import <Foundation/Foundation.h>


@interface UncaughtExceptionHandler : NSObject
{
}
@end
void CustomSignalHandler(int signal);
void uncaughtExceptionHandlerNotForSignal(NSException *exception);
void installUncaughtExceptionHandler();
#endif