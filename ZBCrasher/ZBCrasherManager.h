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

#if __has_include(<ZBCrasher/ZBCrasherConfig.h>)
#import <ZBCrasher/ZBCrasherConfig.h>
#import <ZBCrasher/ZBCrasherModel.h>
#else
#import "ZBCrasherConfig.h"
#import "ZBCrasherModel.h"
#endif

@class ZBCrasherFileManager,ZBCrasherAVCloud;

NS_ASSUME_NONNULL_BEGIN

/**
 * @ingroup functions
 *
 * Prototype of a callback function used to crash call back information as provided
 * @param crashModel crash info model.
 */
typedef void (^ZBCrasherCallback)(ZBCrasherModel *crashModel);

@interface ZBCrasherManager : NSObject {
@private
    /** Reporter configuration */
    __strong ZBCrasherConfig *_config;
    
    /** Reporter file manager */
    __strong ZBCrasherFileManager *_fileManager;
    
    /** Reporter avos cloud */
    __strong id _avcloud;
    
    /** YES if the crash reporter has been enabled */
    BOOL _enabled;
    
    /** Application identifier */
    __strong NSString *_applicationIdentifier;

    /** Application version */
    __strong NSString *_applicationVersion;
    
    /** Application marketing version */
    __strong NSString *_applicationMarketingVersion;
}

/* lib version */
+ (NSString *)version;

/* (Deprecated) Crash manager singleton. */
+ (ZBCrasherManager *) manager __attribute__((deprecated));

/**
 * Initialize a new ZBCrasher instance with the given configuration.
 *
 * @param configuration The configuration to be used by this reporter instance.
 */
- (instancetype) initWithConfiguration:(ZBCrasherConfig *) configuration;

/**
 * Returns YES if the application has previously crashed and
 * an pending crash report is available.
 */
- (BOOL) hasPendingCrashReport;

/**
 * If an application has a pending crash report, this method returns the crash
 * report data.
 *
 * You may use this to submit the report to your own HTTP server, over e-mail, or even parse and
 * introspect the report locally using the ZBCrasher API.
 *
 * @return Returns nil if the crash report data could not be loaded.
 */
- (NSData *) loadPendingCrashReportData;

/**
 * If an application has a pending crash report, this method returns the crash
 * report data.
 *
 * You may use this to submit the report to your own HTTP server, over e-mail, or even parse and
 * introspect the report locally using the ZBCrasher API.
 
 * @param outError A pointer to an NSError object variable. If an error occurs, this pointer
 * will contain an error object indicating why the pending crash report could not be
 * loaded. If no error occurs, this parameter will be left unmodified. You may specify
 * nil for this parameter, and no error information will be provided.
 *
 * @return Returns nil if the crash report data could not be loaded.
 */
- (NSData *) loadPendingCrashReportDataAndReturnError: (NSError **) outError;

/**
 * Purge a pending crash report.
 *
 * @return Returns YES on success, or NO on error.
 */
- (BOOL) purgePendingCrashReport;

/**
 * Purge a pending crash report.
 *
 * @return Returns YES on success, or NO on error.
 */
- (BOOL) purgePendingCrashReportAndReturnError: (NSError **) outError;

/**
 * Enable the crasher. Once called, all application crashes will
 * result in a crash report being written prior to application exit.
 *
 * @return Returns YES on success, or NO if the crash reporter could
 * not be enabled.
 *
 * @par Registering Multiple Reporters
 *
 * Only one ZBCrasher instance may be enabled in a process; attempting to enable an additional instance
 * will return NO, and the reporter will not be enabled. This restriction may be removed in a future release.
 */
- (BOOL) enableCrasher;

/**
 * Enable the crash reporter. Once called, all application crashes will
 * result in a crash report being written prior to application exit.
 *
 * This method must only be invoked once. Further invocations will throw
 * a ZBCrasherException.
 *
 * @param outError A pointer to an NSError object variable. If an error occurs, this pointer
 * will contain an error in the ZBCrasherErrorDomain indicating why the Crash Reporter
 * could not be enabled. If no error occurs, this parameter will be left unmodified. You may
 * specify nil for this parameter, and no error information will be provided.
 *
 * @return Returns YES on success, or NO if the crash reporter could
 * not be enabled.
 *
 * @par Registering Multiple Reporters
 *
 * Only one ZBCrasher instance may be enabled in a process; attempting to enable an additional instance
 * will return NO and a ZBCrasherErrorResourceBusy error, and the reporter will not be enabled.
 * This restriction may be removed in a future release.
 */
- (BOOL) enableCrasherAndReturnError: (NSError **) outError;

/**
 * Set the callbacks that will be executed by the receiver after a crash has occured and been recorded by ZBCrasherManager.
 *
 * @param callback A pointer to an initialized ZBCrasherCallbacks structure.
 *
 * @note This method must be called prior to ZBCrasherManager::enableCrasher or
 * ZBCrasherManager::enableCrasherAndReturnError:
 */
- (void) setCrasherCallBack:(ZBCrasherCallback) callback;

/**
 * Set the callback that will be executed by the receiver the next time the program starts after the crash has occurred and recorded by ZBCrasherManager。
 *
 * @param callback A pointer to an initialized ZBCrasherCallbacks structure.
 *
 * @note This method must be called prior to ZBCrasherManager::enableCrasher or
 * ZBCrasherManager::enableCrasherAndReturnError:
 */
- (void) setLastCrasherCallBack:(ZBCrasherCallback) callback;

@end

NS_ASSUME_NONNULL_END
