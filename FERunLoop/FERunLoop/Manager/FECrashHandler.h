//
//  FECrashHandler.h
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/19.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FECrashHandler : NSObject

@property (assign, nonatomic) BOOL ignore;

+ (instancetype)sharedInstance;

@end
