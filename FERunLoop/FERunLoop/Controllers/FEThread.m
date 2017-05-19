//
//  FEThread.m
//  FERunLoop
//
//  Created by FlyElephant on 2017/5/18.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

#import "FEThread.h"

@implementation FEThread

- (void)dealloc {
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}


@end
