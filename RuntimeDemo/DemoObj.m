//
//  DemoObj.m
//  RuntimeDemo
//
//  Created by Company on 16/4/22.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "DemoObj.h"
#include <objc/runtime.h>
@implementation DemoObj


- (void)replaceMethod {
    
    class_replaceMethod([DemoObj class], @selector(eat), (IMP)run, NULL);
}

- (void)eat {
    NSLog(@"i am eat");
}

void run(id SELF, SEL _cmd) {

      NSLog(@"i am run");
}

@end
