//
//  UIImage+UIImagex.h
//  FrogFarm
//
//  Created by 锡安 冯 on 13-3-9.
//  Copyright (c) 2013年 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (x)

+ (UIImage*)localPngNamed:(NSString*)nameWithoutSuffix;

+ (UIImage*)localImageNamed:(NSString*)nameWithSuffix;

//改变大小
- (UIImage*)transformToSize:(CGSize)newSize;

@end
