//
//  TimerViewController.m
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/19.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController () {
    NSInteger upNumber;
    NSInteger bottomNumber;
}

@property (weak, nonatomic) IBOutlet UILabel *upTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomTimeLabel;

@property (strong, nonatomic) NSTimer *upTimer;

@property (strong, nonatomic) NSTimer *bottomTimer;

@end

@implementation TimerViewController

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
    if (self.upTimer.isValid) {
        [self.upTimer invalidate];
    }
    
    if (self.bottomTimer.isValid) {
        [self.bottomTimer invalidate];
    }
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


#pragma mark - Actions

- (void)upTimeUpdate {
    NSLog(@"up--当前线程：%@",[NSThread currentThread]);
    NSLog(@"up---启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    dispatch_async(dispatch_get_main_queue(), ^{
        upNumber ++;
        self.upTimeLabel.text = [NSString stringWithFormat:@"FlyElephant:%ld",upNumber];
    });
}


- (void)bottomTimeUpdate {
    NSLog(@"bottom---当前线程：%@",[NSThread currentThread]);
    NSLog(@"bottom---启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    dispatch_async(dispatch_get_main_queue(), ^{
        bottomNumber ++;
        self.bottomTimeLabel.text = [NSString stringWithFormat:@"FlyElephant:%ld",bottomNumber];;
    });
}


#pragma mark - SetUp

- (void)setUp {
    
    self.upTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(upTimeUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.upTimer forMode:NSRunLoopCommonModes];
    [self.upTimer fire];
    
    self.bottomTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(bottomTimeUpdate) userInfo:nil repeats:YES];
    
}



@end
