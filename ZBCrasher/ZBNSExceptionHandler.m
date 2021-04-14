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

#import "ZBNSExceptionHandler.h"
#import "ZBCrasherModel.h"
#import "ZBCrasherMacros.h"
#import "ZBCrasherManager.h"

void zb_uncaughtExceptionHandler(NSException * exception);

static NSUncaughtExceptionHandler *_ot_handler;

static ZBCrasherCallback __callback;

@implementation ZBNSExceptionHandler

// MARK: public

/**
 * register UncaughtExceptionHandler
 * In order to avoid covering other crash information, do something here
 * First, determine whether there is an `uncaughtexception handler`
 * Then save it temporarily, and then implement other `handles method` after our own crash information processing
 */
+ (void)zb_registerUncaughtExceptionHandler:(ZBCrasherCallback)callback {
    __callback = callback;
    _ot_handler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&zb_uncaughtExceptionHandler);
}

/**
 * Unsubscribe `uncaughtexceptionhandler`
 * postprocessing the information after crashing and breaking up.
 */
+ (void)zb_unRegisterUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(nil);
}

// MARK: private

void zb_uncaughtExceptionHandler(NSException *exception) {
    
    NSArray *stackSymbols = exception.callStackSymbols;
    NSString *reason = exception.reason;
    NSString *name = exception.name;
    
    // create crash model
    ZBCrasherModel *model = [ZBCrasherModel new];
    model.stacks = stackSymbols;
    model.name = name;
    model.reason = reason;
    
    // Send model to implementation proxy class
    if (__callback) {
        __callback(model);
    }
    
    // Implement other programs to deal with crash information
    if (_ot_handler) {
        _ot_handler(exception);
    }
}

@end
