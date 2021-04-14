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

#import "ZBCrasherFileManager.h"
#import "ZBCrasherModel.h"
#import "ZBCrasherUtils.h"
#import "ZBCrasherMacros.h"

/** @internal
 * Crasher cache directory name. */
static NSString *ZBCRASH_CACHE_DIR = @"com.itzhangbao.zbcrasher.data";

/** @internal
 * Crash Report file name. */
static NSString *ZBCRASH_LIVE_CRASHREPORT = @"live_report.zbcrasher";

/** @internal
 * Directory containing crash reports queued for sending. */
static NSString *ZBCRASH_QUEUED_DIR = @"queued_reports";

@implementation ZBCrasherFileManager

- (instancetype)init
{
    return [self initWithBasePath:@"" appId:@""];
}

- (instancetype)initWithBasePath:(NSString *)basePath appId:(NSString *)appId
{
    if ((self = [super init]) == nil)
        return nil;
    _crashReportDirectory = [[basePath stringByAppendingPathComponent: ZBCRASH_CACHE_DIR] stringByAppendingPathComponent: appId];
    return self;
}

/// Write a fatal crash report.
/// @param model crashed infomation model
- (BOOL) zb_crasherWriteReport:(ZBCrasherModel *)model {
    NSDictionary *crashDict = model.toDictionary;
    NSString *crashStr = crashDict.toString;
    NSError *error;
    [crashStr writeToFile:[self crasherDirectory] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        ZBC_LOG(@"Error -- write crash report fail!");
        return NO;
    }
    return YES;
}

/**
 * Validate (and create if necessary) the crash reporter directory structure.
 */
- (BOOL) populateCrasherDirectoryAndReturnError: (NSError **) outError {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    /* Set up reasonable directory attributes */
    NSDictionary *attributes = [NSDictionary dictionaryWithObject: [NSNumber numberWithUnsignedLong: 0755] forKey: NSFilePosixPermissions];
    
    /* Create the top-level path */
    if (![fm fileExistsAtPath: [self crasherDirectory]] &&
        ![fm createDirectoryAtPath: [self crasherDirectory] withIntermediateDirectories: YES attributes: attributes error: outError])
    {
        return NO;
    }

    /* Create the queued crash report directory */
    if (![fm fileExistsAtPath: [self queuedCrasherDirectory]] &&
        ![fm createDirectoryAtPath: [self queuedCrasherDirectory] withIntermediateDirectories: YES attributes: attributes error: outError])
    {
        return NO;
    }

    return YES;
}

/**
 * Return the path to the crash reporter data directory.
 */
- (NSString *) crasherDirectory {
    return _crashReportDirectory;
}

/**
 * Return the path to to-be-sent crash reports.
 */
- (NSString *) queuedCrasherDirectory {
    return [[self crasherDirectory] stringByAppendingPathComponent: ZBCRASH_QUEUED_DIR];
}

/**
 * Return the path to live crash report (which may not yet, or ever, exist).
 */
- (NSString *) crashReportPath {
    return [[self crasherDirectory] stringByAppendingPathComponent: ZBCRASH_LIVE_CRASHREPORT];
}

/**
 * Returns YES if the application has previously crashed and
 * an pending crash report is available.
 */
- (BOOL) hasPendingCrashReport {
    /* Check for a live crash report file */
    return [[NSFileManager defaultManager] fileExistsAtPath: [self crashReportPath]];
}

@end
