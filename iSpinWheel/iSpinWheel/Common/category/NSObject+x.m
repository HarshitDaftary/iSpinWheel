//
//  NSObject+x.m
//  iSpinWheel
//
//  Created by 锡安 冯 on 13-3-9.
//  Copyright (c) 2013年 Zion. All rights reserved.
//

#import "NSObject+x.h"

@implementation NSObject (x)
-(void)asyncTask:(dispatch_block_t)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

-(void)syncTask:(dispatch_block_t)block {
    dispatch_async(dispatch_get_current_queue(), block);
}

-(void) syncTask:(dispatch_block_t)block after:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC),
                   dispatch_get_current_queue(), block);
}

@end
