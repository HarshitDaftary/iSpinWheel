//
//  SWMacro.h
//  MBThunder
//
//  Created by czh0766 on 12-9-6.
//  Copyright (c) 2012年 czh0766. All rights reserved.
//

#ifndef SWMacro_h
#define SWMacro_h

#define OBJ_EQUAL(a,b) (a == b || [a isEqual:b])

#define RANDOM_0_1 (arc4random() / (float)0x100000000)

#define STR_EMPTY(str) (str == nil || [str isEqual:@""])

#define MINUTE 60
#define HOUR (60 * 60)
#define DAY (60 * 60 * 24)

#define STATUS_BAR_HEIGHT 20

#define SOFT_KEYBOARD_HEIGHT 216

#define UIViewAutoresizingFlexibleSize \
        (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)

#define REG_NOTIFY(s, n) [[NSNotificationCenter defaultCenter] addObserver:self selector:s name:n object:nil];

#define NSGBKStringEncoding CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

#define M_PI_Double (6.283185307179586) //(2π)

//由于NSLog在Release版中不会被去掉，这会影响程序运行的性能，所以需要一个DEBUG宏开关来关闭它
//DEBUG设置方法：在Build Setting中查找 PreProcessor Macros 这个属性，对于 Debug 配置我们给他写上
//DEBUG=1,而在 Release 或者 Distribute 配置中把它留空
#ifdef DEBUG

#define SWLog( s, ... ) \
do{ \
NSLog( @"<%p %@ %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent],NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] );    \
}while(0);

#  define SWLogMethod NSLog(@"%s(%d)", __func__, __LINE__)

#  define SWLogMethod2 NSLog(@"%@/%@(%d)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__)

#else

#  define SWLog( s, ... )
#  define SWLogMethod( s, ... )
#  define SWLogMethod2( s, ... )

#endif//end DEBUG

#endif

