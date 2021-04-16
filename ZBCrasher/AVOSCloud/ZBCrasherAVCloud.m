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

#import "ZBCrasherAVCloud.h"
#import "ZBCrasherUtils.h"
#import "ZBCrasherMacros.h"
#import "ZBCrasherModel.h"
#import "ZBCrasherConfig.h"

#if __has_include(<AVOSCloud/AVOSCloud.h>)
#import <AVOSCloud/AVOSCloud.h>
#else
#import "AVOSCloud.h"
#endif

@implementation ZBCrasherAVCloud

- (void) initAVCloudWithConfiguration:(ZBCrasherConfig *) configuration;
{
    ZBC_LOG(@"AVOSCloud Initializing...");
    if (!configuration.appId.isNonull && !configuration.appKey.isNonull) {
        ZBC_LOG(@"Error: Failed to initialize AVOSCloud, initialization parameter is empty!");
    }else {
        [AVOSCloud setApplicationId:configuration.appId clientKey:configuration.appKey serverURLString:configuration.serverURLString];
    }
}·

- (void)sendCrashReportsToAvocCloudWith:(ZBCrasherModel *)model {
    
    ZBC_LOG(@"Sending last crash log to AVOSCloud...");
    
    AVObject *avObj = [AVObject objectWithClassName:@"ZBCraher" dictionary:model.toDictionary];
    [avObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            ZBC_LOG(@"Succes: save crash log to avsocloud.");
        }else {
            ZBC_LOG(@"Error: save crash log to avsocloud.");
        }
    }];
    
}

@end
