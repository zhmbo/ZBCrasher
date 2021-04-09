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

@implementation ZBCrasherModel

- (NSString *)bundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey: (NSString *) kCFBundleVersionKey];
}

- (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"];
}

- (NSDictionary *)toDictionary {
    return @{
        @"name"         : self.name             ?:@"" ,
        @"reason"       : self.reason           ?:@"" ,
        @"stacks"       : [NSString stringWithFormat:@"%@",self.stacks] ?:@"" ,
        @"bundleId"     : self.bundleId         ?:@"" ,
        @"bundleVersion": self.bundleVersion    ?:@"" ,
        @"appVersion"   : self.appVersion       ?:@""
    };
}

@end
