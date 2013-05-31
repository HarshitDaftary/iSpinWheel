//
//  UIColor+x.m
//  iSpinWheel
//
//  Created by xunlei on 3/7/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "UIColor+x.h"

@implementation UIColor (x)

+ (UIColor*)colorWithString:(NSString *)colorString
{
    colorString=[[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([colorString hasPrefix:@"0X"])
    {
        if ([colorString length]!=10)
        {
            return [UIColor whiteColor];
        }
        NSRange range;
        range.length=2;
        
        range.location=2;
        NSString* rString=[colorString substringWithRange:range];
        
        range.location=4;
        NSString* gString=[colorString substringWithRange:range];
        
        range.location=6;
        NSString* bString=[colorString substringWithRange:range];
        
        range.location=8;
        NSString* aString=[colorString substringWithRange:range];
        
        unsigned int r,g,b,a;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        
        return  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
    }
    else if ([colorString length]==11||[colorString length]==15)
    {
        NSArray* list=[colorString componentsSeparatedByString:@" "];
        
        int r,g,b,a;
        [[NSScanner scannerWithString:[list objectAtIndex:0]] scanInt:&r];
        [[NSScanner scannerWithString:[list objectAtIndex:1]] scanInt:&g];
        [[NSScanner scannerWithString:[list objectAtIndex:2]] scanInt:&b];
        if (4==[list count])
        {
            [[NSScanner scannerWithString:[list objectAtIndex:3]] scanInt:&a];
        }
        else
        {
            a=100.0f;
        }
        
        UIColor* color=[UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:(float)a/100.0];
        return color;
    }
    else
    {
        return [UIColor whiteColor];
    }
    
}
@end
