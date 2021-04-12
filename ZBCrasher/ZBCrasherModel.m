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

#import "ZBCrasherModel.h"

static NSString *_bundleIdentifier  = @"";
static NSString *_bundleVersion     = @"";
static NSString *_appVersion        = @"";

static dispatch_once_t __t;

@implementation ZBCrasherModel

- (NSString *)timestamp {
    return [NSString stringWithFormat:@"%f", [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
}

- (NSString *)bundleId {
    dispatch_once(&__t, ^{
        
        _bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        /* Verify that the identifier is available */
        if (_bundleIdentifier == nil) {
            const char *progname = getprogname();
            if (progname == NULL) {
                _bundleIdentifier = @"NoneId!";
            }else {
                //  ZBC_LOG("Warning -- bundle identifier, using process name %s", progname);
                _bundleIdentifier = [NSString stringWithUTF8String: progname];
            }

        }
    });
    return _bundleIdentifier;
}

- (NSString *)bundleVersion {
    dispatch_once(&__t, ^{
        _bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey: (NSString *) kCFBundleVersionKey];
    });
    return _bundleVersion;
}

- (NSString *)appVersion {
    dispatch_once(&__t, ^{
        _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"];
    });
    return _appVersion;
}

- (NSDictionary *)toDictionary {
    return @{
        @"name"         : self.name             ?:@"" ,
        @"reason"       : self.reason           ?:@"" ,
        @"stacks"       : [NSString stringWithFormat:@"%@",self.stacks] ?:@"" ,
        @"timestamp"    : self.timestamp        ?:@"" ,
        
        @"bundleId"     : self.bundleId         ?:@"" ,
        @"bundleVersion": self.bundleVersion    ?:@"" ,
        @"appVersion"   : self.appVersion       ?:@""
    };
}

@end
