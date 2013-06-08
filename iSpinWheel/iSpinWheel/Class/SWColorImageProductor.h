//
//  SWColorImageProductor.h
//  iSpinWheel
//
//  Created by xunlei on 3/7/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWColorImageProductor : NSObject

+ (UIImage*)imageWithSize:(CGSize)size segmentNumber:(NSUInteger)seg;
//+ (UIImage*)imageWithSize:(CGSize)size segmentNumber:(NSUInteger)seg segmentColorArray:(NSArray *)array;
+ (UIImage*)defaultImage;

@end
