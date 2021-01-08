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

void zb_uncaughtExceptionHandler(NSException * exception);

static id _handler;
static dispatch_once_t t;

@implementation ZBNSExceptionHandler

@synthesize ot_handler = _ot_handler;

// MARK: public

/**
 * Single
 */
+ (instancetype)handler {
    dispatch_once(&t, ^{ _handler = [[ZBNSExceptionHandler alloc] init]; });
    return _handler;
}

/**
 * register UncaughtExceptionHandler
 * In order to avoid covering other crash information, do something here
 * First, determine whether there is an `uncaughtexception handler`
 * Then save it temporarily, and then implement other `handles method` after our own crash information processing
 */
+ (void)zb_registerUncaughtExceptionHandler {
    [[ZBNSExceptionHandler handler] zb_registerUncaughtExceptionHandler];
}

/**
 * Unsubscribe `uncaughtexceptionhandler`
 * postprocessing the information after crashing and breaking up.
 */
+ (void)zb_unRegisterUncaughtExceptionHandler {
    [[ZBNSExceptionHandler handler] zb_unRegisterUncaughtExceptionHandler];
}

// MARK: private

- (void)zb_registerUncaughtExceptionHandler {
    _ot_handler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&zb_uncaughtExceptionHandler);
}

- (void)zb_unRegisterUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(nil);
}

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
    ZBNSExceptionHandler *_handler = [ZBNSExceptionHandler handler];
    if (_handler.delegate && [_handler.delegate respondsToSelector:@selector(zb_crashHandlerModel:)]) {
        [_handler.delegate zb_crashHandlerModel:model];
    }
    
    // Implement other programs to deal with crash information
    if ([ZBNSExceptionHandler handler].ot_handler) {
        [ZBNSExceptionHandler handler].ot_handler(exception);
    }
}

@end
