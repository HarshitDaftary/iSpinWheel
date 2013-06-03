//
//  UIImage+z.h
//  FrogFarm
//
//  Created by 锡安 冯 on 13-3-9.
//  Copyright (c) 2013年 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (z)

+ (UIImage*)localPngNamed:(NSString*)nameWithoutSuffix;

+ (UIImage*)localImageNamed:(NSString*)nameWithSuffix;

//改变大小
- (UIImage*)transformToSize:(CGSize)newSize;

+ (UIImage *)resizeableImageNamed:(NSString *)name capLeft:(CGFloat)left capTop:(CGFloat)top;

+ (UIImage *) resizeableImageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets;

+ (UIImage *)resizeableImageNamed:(NSString *)name;

@end
