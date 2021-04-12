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

NS_ASSUME_NONNULL_BEGIN

@interface ZBCrasherConfig : NSObject

/**
 * Return the default local configuration.
 */
+ (instancetype) defaultConfiguration;

/**
 * Initialize a new ZBCrasherConfig instance using the default configuration and custom crash data save path. The default configuration
 *
 * @param basePath The base path to save the crash data
 */
- (instancetype)initWithBasePath:(NSString *)basePath;

/**
 * Initialize a new ZBCrasherConfig instance.
 *
 * @param appId Initialize the id used by avcloud.
 * @param appKey Initialize the key used by avcloud.
 */
- (instancetype)initWithAppId:(NSString *)appId
                       appKey:(NSString *)appKey;

/**
 * Initialize a new ZBCrasherConfig instance.
 *
 * @param basePath The base path to save the crash data.
 * @param appId Initialize the id used by avcloud.
 * @param appKey Initialize the key used by avcloud.
 */
- (instancetype)initWithBasePath:(nullable NSString *)basePath
                           appId:(nullable NSString *)appId
                          appKey:(nullable NSString *)appKey;

/** Crash pop up in development environment */
@property (nonatomic, assign) BOOL debugAlert;

/** Output of ZBCrasher console in development environment */
@property (nonatomic, assign) BOOL debugNSlog;

/** The base path to save the crash data. */
@property(nonatomic, readonly) NSString *basePath;

/** The app id to init avcloud */
@property(nonatomic, readonly) NSString *appId;

/** The app key to init avcloud */
@property(nonatomic, readonly) NSString *appKey;

@end

NS_ASSUME_NONNULL_END
