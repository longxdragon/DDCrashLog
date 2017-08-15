//
//  DDSignalHandle.m
//  DDCrashLog
//
//  Created by longxdragon on 2017/4/26.
//  Copyright © 2017年 longxdragon. All rights reserved.
//

#import "DDSignalHandle.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>

NSString* NSSTRING_NOT_NIL(NSString *str) {
    if (!str) {
        return @"";
    }
    return str;
}

@implementation DDSignalHandle

+ (void)initHandle {
    NSSetUncaughtExceptionHandler(&UncautchExceptionHandler);
    
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
}

void SignalExceptionHandler(int signal) {
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void *callstack[128];
    int i, frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }

    [[NSUserDefaults standardUserDefaults] setObject:mstr forKey:@"ss"];
}

void UncautchExceptionHandler(NSException *exception) {
    NSTimeInterval crashTime = [[NSDate date] timeIntervalSince1970] * 1000; //毫秒级
    NSString *name = [exception name]; //异常名称
    NSString *reason = [exception reason]; //异常原因
    NSString *callStackSymbols = [[exception callStackSymbols] componentsJoinedByString:@"\n"];
    if (callStackSymbols && callStackSymbols.length) {
        NSArray *callStack = [[exception userInfo] objectForKey:@""];
        if (callStack.count > 0) {
            callStackSymbols = [callStack componentsJoinedByString:@"\n"];
        }
    }
    int crashType = 1; //异常类型
    int netType = 1;//[[TNNetworkDoctor doctor] networkStatusType]; //网络类型
    int screenType = 1; //横竖屏
    NSString *memoryInfo = @"";//[TNDeviceUtils currentMemoryInfo]; //剩余内存
    NSString *pageName = @"";//[[TNAnalysisManager sharedManager] currentPagePath]; //当前页面路径
    
    NSMutableDictionary *crashDic = [NSMutableDictionary dictionary];
    [crashDic setObject:@(crashTime) forKey:@"time"];
    [crashDic setObject:NSSTRING_NOT_NIL(pageName) forKey:@"pageName"];
    [crashDic setObject:NSSTRING_NOT_NIL(name) forKey:@"name"];
    [crashDic setObject:NSSTRING_NOT_NIL(reason) forKey:@"reason"];
    [crashDic setObject:NSSTRING_NOT_NIL(callStackSymbols) forKey:@"stack"];
    [crashDic setObject:@(crashType) forKey:@"crashType"];
    [crashDic setObject:@(netType) forKey:@"netType"];
    [crashDic setObject:@(screenType) forKey:@"screenType"];
    [crashDic setObject:NSSTRING_NOT_NIL(memoryInfo) forKey:@"memoryInfo"];

    NSString *log = [NSString stringWithFormat:@"Stack:\n%@", callStackSymbols];
    [[NSUserDefaults standardUserDefaults] setObject:log forKey:@"bb"];
}

@end
