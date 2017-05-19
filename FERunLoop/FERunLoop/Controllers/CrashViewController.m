//
//  CrashViewController.m
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/19.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "CrashViewController.h"

@interface CrashViewController ()


@end

@implementation CrashViewController

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


#pragma mark - Private


#pragma mark - Actions

- (IBAction)crashAction:(UIButton *)sender {
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"FlyElephant",@"keso", nil];
    NSString *obj = arr[10];
}

#pragma mark - SetUp

- (void)setUp {
    
}

@end
