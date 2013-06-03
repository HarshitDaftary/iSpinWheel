//
//  UIView+z.h
//  iWheel
//
//  Created by 锡安 冯 on 13-3-9.
//  Copyright (c) 2013年 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (z)

+(id) viewWithNib:(NSString*)nib owner:(id)owner;
- (void)clipToCircus;

@end
