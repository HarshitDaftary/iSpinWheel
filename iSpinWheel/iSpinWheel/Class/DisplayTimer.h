//
//  DisplayTimer.h
//  iSpinWheel
//
//  Created by Zion on 5/31/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DisplayTimerDelegate <NSObject>

@required
- (void)displayUpdate:(NSTimeInterval)passed;
    
@end

@interface DisplayTimer : NSObject

+ (DisplayTimer*)defaultDisplayTimer;

- (void)addDisplayObserver:(id<DisplayTimerDelegate>)obsr;
- (void)removeDisplayObserver:(id<DisplayTimerDelegate>)obsr;

@end
