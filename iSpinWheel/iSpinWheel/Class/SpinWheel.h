//
//  SpinWheel.h
//  SpinWheel
//
//  Created by Alex Nichol on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinWheelDisplayTimer.h"

@interface SpinWheel : UIView<DisplayTimerDelegate>
{
@public
    double angle;
    double angularVelocity;
    double drag;
    
    CGPoint initialPoint;
    double initialAngle;
    CGPoint previousPoints[2];
    NSDate * previousDates[2];
}

@property (readwrite) double angle;
@property (readwrite) double angularVelocity;
@property (readwrite) double drag;

@end
