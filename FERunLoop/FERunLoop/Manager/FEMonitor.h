//
//  FEMonitor.h
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/19.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;

- (void)startMonitor:(NSTimeInterval)interval threshold:(NSTimeInterval)threshold;

- (void)stopMonitor;

@end
