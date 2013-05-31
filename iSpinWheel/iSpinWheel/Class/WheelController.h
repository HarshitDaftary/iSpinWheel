//
//  WheelController.h
//  iSpinWheel
//
//  Created by xunlei on 3/8/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNImageWheel.h"
#import "SWViewController.h"


@interface WheelController : SWViewController<SpinWheelDelegate,UIGestureRecognizerDelegate>
{
}
- (void)loadWheelUI;
    
@end
