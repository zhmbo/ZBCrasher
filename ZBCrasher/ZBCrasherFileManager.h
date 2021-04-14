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
@class ZBCrasherModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZBCrasherFileManager : NSObject {
    
    /** Path to the crash reporter internal data directory */
    __strong NSString *_crashReportDirectory;
}

- (instancetype)initWithBasePath:(NSString *)basePath appId:(NSString *)appId;

/// Write a fatal crash report.
/// @param model crashed infomation model
- (BOOL) zb_crasherWriteReport:(ZBCrasherModel *)model;

/**
 * Validate (and create if necessary) the crash reporter directory structure.
 */
- (BOOL) populateCrasherDirectoryAndReturnError: (NSError **) outError;

/**
 * Return the path to the crash reporter data directory.
 */
- (NSString *) crasherDirectory;

/**
 * Return the path to to-be-sent crash reports.
 */
- (NSString *) queuedCrasherDirectory;

/**
 * Return the path to live crash report (which may not yet, or ever, exist).
 */
- (NSString *) crashReportPath;

/**
 * Returns YES if the application has previously crashed and
 * an pending crash report is available.
 */
- (BOOL) hasPendingCrashReport;

@end

NS_ASSUME_NONNULL_END
