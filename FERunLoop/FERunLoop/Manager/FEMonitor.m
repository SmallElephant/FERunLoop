//
//  FEMonitor.m
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/19.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "FEMonitor.h"

@interface FEMonitor()

// 监控线程
@property (strong, nonatomic) NSThread *monitorThread;

// 观察者
@property (assign, nonatomic) CFRunLoopObserverRef observer;

@property (assign, nonatomic) CFRunLoopTimerRef timer;

// 开始时间
@property (strong, nonatomic) NSDate *startDate;

// 执行状态
@property (assign, nonatomic) BOOL excuting;

// 时间间隔
@property (assign, nonatomic) NSTimeInterval timeInterval;

// 超时设置
@property (assign, nonatomic) NSTimeInterval threshold;

@end

static FEMonitor *sharedMointor;
static dispatch_once_t   onceToken;

@implementation FEMonitor

#pragma mark - LifeCycle

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        sharedMointor = [[self alloc] init];
        sharedMointor.monitorThread = [[NSThread alloc] initWithTarget:self selector:@selector(monitorThreadEntryPoint) object:nil];
        [sharedMointor.monitorThread setName:@"FEMonitorThread"];
        [sharedMointor.monitorThread start];
    });
    
    return sharedMointor;
}

#pragma mark - Public

- (void)startMonitor {
    [self startMonitor:1.0 threshold:2.0];
}

- (void)startMonitor:(NSTimeInterval)interval threshold:(NSTimeInterval)threshold {
    
    _timeInterval = interval;
    _threshold = threshold;
    
    if (_observer) {
        return;
    }
    
    // 1.创建observer
    CFRunLoopObserverContext context = {0,(__bridge void*)self, NULL, NULL, NULL};
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &runLoopObserverCallBack,
                                        &context);
    // 2.将observer添加到主线程的RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    // 3.创建一个timer，并添加到子线程的RunLoop中
    [self performSelector:@selector(addTimerToMonitorThread) onThread:self.monitorThread withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
}

- (void)stopMonitor {
    if (_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
        CFRelease(_observer);
        _observer = NULL;
    }
    
    [self performSelector:@selector(removeTimer) onThread:self.monitorThread withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
}

#pragma mark - Private

+ (void)monitorThreadEntryPoint {
    
    @autoreleasepool {
        NSRunLoop * runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
    
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    FEMonitor *monitor = (__bridge FEMonitor*)info;
    NSLog(@"MainRunLoop---%@",[NSThread currentThread]);
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"runloop---kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"runloop--kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"runloop--kCFRunLoopBeforeSources");
            monitor.startDate = [NSDate date];
            monitor.excuting = YES;
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"runloop--kCFRunLoopBeforeWaiting");
            monitor.excuting = NO;
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"runloop--kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"runloop--kCFRunLoopExit");
            break;
        default:
            break;
    }
}

- (void)addTimerToMonitorThread {
    if (_timer) {
        return;
    }
    // 创建timer
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    _timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, _timeInterval, 0, 0,
                                  &runLoopTimerCallBack, &context);
    // 添加到子线程的RunLoop中
    CFRunLoopAddTimer(currentRunLoop, _timer, kCFRunLoopCommonModes);
}

static void runLoopTimerCallBack(CFRunLoopTimerRef timer, void *info) {
    FEMonitor *monitor = (__bridge FEMonitor*)info;
    if (!monitor.excuting) {
        return;
    }
    
    // 如果主线程正在执行任务，并且这一次loop 执行到 现在还没执行完，那就需要计算时间差
    NSTimeInterval excuteTime = [[NSDate date] timeIntervalSinceDate:monitor.startDate];
    NSLog(@"定时器---%@",[NSThread currentThread]);
    NSLog(@"主线程执行了---%f秒",excuteTime);
    
    if (excuteTime >= monitor.threshold) {
        NSLog(@"线程卡顿了%f秒",excuteTime);
//        [monitor handleStackInfo];
    }
}

- (void)removeTimer {
    if (_timer) {
        CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
        CFRunLoopRemoveTimer(currentRunLoop, _timer, kCFRunLoopCommonModes);
        CFRelease(_timer);
        _timer = NULL;
    }
}


@end
