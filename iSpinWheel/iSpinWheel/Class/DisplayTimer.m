//
//  DisplayTimer.m
//  iSpinWheel
//
//  Created by Zion on 5/31/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "DisplayTimer.h"

static DisplayTimer *defaultInstance;

@interface DisplayTimer()

@property (nonatomic, strong)   NSDate * lastTimerDate;
@property (nonatomic, strong)   CADisplayLink * displayTimer;
@property (nonatomic, strong)   NSMutableArray *displayList;

@end

@implementation DisplayTimer
@synthesize lastTimerDate;
@synthesize displayTimer;
@synthesize displayList;

- (id)init
{
    self=[super init];
    if (self)
    {
        self.displayList=[[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

+ (DisplayTimer*)defaultDisplayTimer
{
    if (nil==defaultInstance)
    {
        defaultInstance=[[DisplayTimer alloc] init];
    }
    return defaultInstance;
}

- (void)addDisplayObserver:(id<DisplayTimerDelegate>)obsr
{
    //should not modify the array when timer is running.
//    if (self.displayTimer)
//    {
//        return;
//    }
    [self.displayList addObject:obsr];
    [self startDisplayTimer];
}

- (void)removeDisplayObserver:(id<DisplayTimerDelegate>)obsr
{
    //should not modify the array when timer is running.
//    if (self.displayTimer)
//    {
//        return;
//    }
    [self.displayList removeObject:obsr];
}


- (void)startDisplayTimer
{
    if (self.displayTimer)
    {
        return;
    }
    self.lastTimerDate = nil;
    self.displayTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationTimer:)];
    [self.displayTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopDisplayTimer
{
    if (!self.displayTimer)
    {
        return;
    }
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
    if (0==[self.displayList count])
    {
        [self stopDisplayTimer];
        return;
    }
    for (id <DisplayTimerDelegate> d in self.displayList )
    {
        [d displayUpdate:passed];
    }
    
    self.lastTimerDate = newDate;
}

@end
