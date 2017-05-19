//
//  ThreadViewController.m
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/18.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "ThreadViewController.h"
#import "FEThread.h"

@interface ThreadViewController ()

@property (strong, nonatomic) FEThread *taskThread;

@end

@implementation ThreadViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

#pragma mark - Public

#pragma mark - RequestData

- (void)requestData {
    
}

#pragma mark - Private

- (void)threadWork1 {
    NSLog(@"执行---threadWork1");
    NSLog(@"子线程RunLoop模式--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"FlyElephant---%@开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"FlyElephant---%@结束",[NSThread currentThread]);
}

- (void)threadWork2 {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        NSLog(@"启动RunLoop--%@",runLoop.currentMode);
        [runLoop run];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(taskThreadOpetion) onThread:self.taskThread withObject:nil waitUntilDone:NO];
}

- (void)taskThreadOpetion {
    NSLog(@"执行---threadWork2");
    NSLog(@"子线程RunLoop模式--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"FlyElephant---%@开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"FlyElephant---%@结束",[NSThread currentThread]);
}

#pragma mark - Actions

- (IBAction)task1Action:(UIButton *)sender {
    FEThread *thread1 = [[FEThread alloc] initWithTarget:self selector:@selector(threadWork1) object:nil];
    [thread1 setName:@"TaskThread1"];
    [thread1 start];
}


- (IBAction)task2Action:(UIButton *)sender {
    FEThread *thread2 = [[FEThread alloc] initWithTarget:self selector:@selector(threadWork2) object:nil];
    [thread2 setName:@"TaskThread2"];
    [thread2 start];
    self.taskThread = thread2;
}


#pragma mark - SetUp

- (void)setUp {
    
    CFRunLoopRef runloopRef = CFRunLoopGetMain();
    CFArrayRef modes = CFRunLoopCopyAllModes(runloopRef);
    
    NSLog(@"主线程Runloop的模式:%@",modes);
    NSLog(@"主线程Runllop对象:%@",runloopRef);
}

@end
