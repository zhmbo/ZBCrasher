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

#import <Foundation/Foundation.h>
#import "ZBCrasherHandlerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBNSExceptionHandler : NSObject {
@private
    NSUncaughtExceptionHandler *_ot_handler;
}

/**
 * Single
 */
+ (instancetype)handler;

/**
 * register UncaughtExceptionHandler
 * In order to avoid covering other crash information, do something here.
 * First, determine whether there is an `uncaughtexception handler`.
 * Then save it temporarily, and then implement other `handles method` after our own crash information processing.
 */
+ (void)zb_registerUncaughtExceptionHandler;

/**
 * Unsubscribe `uncaughtexceptionhandler`
 * postprocessing the information after crashing and breaking up.
 */
+ (void)zb_unRegisterUncaughtExceptionHandler;

/**
 * Send crash log through this Agreement.
 */
@property (nonatomic, weak) id<ZBCrasherHandlerDelegate> delegate;

/**
 * Temporarily store the `handler` of other implementations.
 */
@property (nonatomic, readonly) NSUncaughtExceptionHandler *ot_handler;

@end

NS_ASSUME_NONNULL_END
