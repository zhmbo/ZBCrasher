/*
 * Author: Jumbo <hi@itzhangbao.com>
 *
 * Copyright (c) 2012-2021 @itzhangbao.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ZBSignalHandler.h"
#import "ZBCrasherBacktrace.h"
#import <UIKit/UIKit.h>
#import "ZBCrasherModel.h"

#include <libkern/OSAtomic.h>

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
};
 
static const char* s_fatal_signal_names[] = {
    "SIGABRT",
    "SIGBUS",
    "SIGFPE",
    "SIGILL",
    "SIGSEGV",
    "SIGTRAP",
    "SIGTERM",
    "SIGKILL",
};

volatile int32_t zbUncaughtExceptionCount = 0;
const int32_t zbUncaughtExceptionMaximum = 10;

void zb_signalHandler(int signal);
int zb_signalIndex(int signal);

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

static ZBCrasherCallback __callback;

@implementation ZBSignalHandler

// MARK: public

/**
 * linux error signal capture
 */
+ (void)zb_registerSignalHandler:(ZBCrasherCallback)callback {
    __callback = callback;
    for (int i = 0; i < s_fatal_signal_num; ++i) {
        signal(s_fatal_signals[i], zb_signalHandler);
    }
}

/**
 * Unregister Linux error signal capture.
 */
+ (void)zb_unRegisterSignalHandler {
    for (int i = 0; i < s_fatal_signal_num; ++i) {
        signal(s_fatal_signals[i], SIG_DFL);
    }
}

// MARK: private

// signal processing method
void zb_signalHandler(int signal)
{
    /** Automatically add a 32-bit value */
    int32_t exceptionCount = OSAtomicIncrement32(&zbUncaughtExceptionCount);
    
    if (exceptionCount > zbUncaughtExceptionMaximum) return;
    
    NSArray *callStacks = [ZBCrasherBacktrace backtrace];
    
    NSString *name = @"SIGNAL";
    
    NSString *reason = [[NSString alloc] initWithUTF8String:s_fatal_signal_names[zb_signalIndex(signal)]];
    
    ZBCrasherModel *model = [ZBCrasherModel new];
    model.stacks = callStacks;
    model.name = name;
    model.reason = reason;
    
    // Send model to implementation proxy class
    if (__callback) {
        __callback(model);
    }
}

int zb_signalIndex(int signal)
{
    for (int i = 0; i < s_fatal_signal_num; i++) {
        if (s_fatal_signals[i] == signal) {
            return i;
        }
    }
    return 0;
}

@end
