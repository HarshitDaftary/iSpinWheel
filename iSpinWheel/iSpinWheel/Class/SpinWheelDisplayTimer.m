//
//  SpinWheelDisplayTimer.m
//  iSpinWheel
//
//  Created by Zion on 5/31/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SpinWheelDisplayTimer.h"

@interface SpinWheelDisplayTimer()

@property (nonatomic, strong)   NSDate * lastTimerDate;
@property (nonatomic, strong)   CADisplayLink * displayTimer;
@property (nonatomic, strong)   NSArray *displayList;

@end

@implementation SpinWheelDisplayTimer
@synthesize lastTimerDate;
@synthesize displayTimer;
@synthesize displayList;

- (id)initWithDisplayList:(NSArray*)list
{
    if ([super init])
    {
        self.displayList=list;
        for (id d in list)
        {
            NSAssert([d conformsToProtocol:@protocol(DisplayTimerDelegate)]&&[d respondsToSelector:@selector(displayUpdate:)], @"error when init display timer.");
        }
        
    }
    return self;
}

- (void)startDisplayTimer
{
    if (self.displayTimer) return;
    self.lastTimerDate = nil;
    self.displayTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationTimer:)];
    [self.displayTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopDisplayTimer
{
    if (!self.displayTimer) return;
    [self.displayTimer invalidate];
    self.displayTimer = nil;
}

- (void)animationTimer:(id)sender
{
    NSDate * newDate = [NSDate date];
    if (!self.lastTimerDate) {
        self.lastTimerDate = newDate;
        return;
    }
    
    NSTimeInterval passed = [newDate timeIntervalSinceDate:self.lastTimerDate];
    for (id <DisplayTimerDelegate> d in self.displayList )
    {
        [d displayUpdate:passed];
    }
    
    self.lastTimerDate = newDate;
}

@end
