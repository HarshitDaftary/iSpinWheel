//
//  WheelSchemeManager.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "WheelSchemeManager.h"

static WheelSchemeManager* monoSchemeManager;
static WheelSchemeManager* biSchemeManager;
static WheelSchemeManager* triSchemeManager;

@interface WheelSchemeManager ()
{
    SchemeGroupType _schemeGroupType;
}

@property (strong, nonatomic) NSMutableDictionary *schemeDictionary;
@property (strong, nonatomic) NSMutableArray *schemeNameList;
@end

@implementation WheelSchemeManager
@synthesize schemeDictionary=_schemeDictionary;

#pragma mark - public -
- (id)initWithSchemeType:(SchemeGroupType)type
{
    self=[super init];
    if (self)
    {
        _schemeGroupType=type;
        [self loadSchemeOfType:type];
    }
    return self;
}

+ (WheelSchemeManager*)shareInstanceOfSchemeType:(SchemeGroupType)type
{
    switch (type)
    {
        case SchemeGroupType_MonoWheel:
            if (nil==monoSchemeManager)
            {
                monoSchemeManager=[[WheelSchemeManager alloc] initWithSchemeType:SchemeGroupType_MonoWheel];
            }
            return monoSchemeManager;
            break;
        case SchemeGroupType_BiWheel:
            if (nil==biSchemeManager)
            {
                biSchemeManager=[[WheelSchemeManager alloc] initWithSchemeType:SchemeGroupType_BiWheel];
            }
            return biSchemeManager;
            break;
        case SchemeGroupType_TriWheel:
            if (nil==triSchemeManager)
            {
                triSchemeManager=[[WheelSchemeManager alloc] initWithSchemeType:SchemeGroupType_TriWheel];
            }
            return triSchemeManager;
            break;
            
        default:
            break;
    }
    return nil;
}

- (BOOL)schemeAdded:(NSString *)schemeName
{
    if (nil!=[self.schemeDictionary objectForKey:schemeName])
    {
        return NO;
    }
    NSArray *wheelArray;
    switch (_schemeGroupType)
    {
        case SchemeGroupType_MonoWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithCapacity:3],
                        nil];
            break;
        case SchemeGroupType_BiWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithCapacity:3],
                        [[NSMutableArray alloc] initWithCapacity:3],
                        nil];
            break;
        case SchemeGroupType_TriWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithCapacity:3],
                        [[NSMutableArray alloc] initWithCapacity:3],
                        [[NSMutableArray alloc] initWithCapacity:3],
                        nil];
            break;
        default:
            break;
    }
    [self.schemeDictionary setObject:wheelArray forKey:schemeName];
    [self loadSchemeNameList];
    return YES;
    
}

- (BOOL)schemeDeleted:(NSString*)schemeName
{
    if (nil==[self.schemeDictionary objectForKey:schemeName])
    {
        return NO;
    }
    [self.schemeDictionary removeObjectForKey:schemeName];
    [self loadSchemeNameList];
    return YES;
    
}

- (BOOL)schemeRenameFrom:(NSString*)schemeName to:(NSString*)newName
{
    id obj=[self.schemeDictionary objectForKey:schemeName];
    
    if (nil==obj)
    {
        return NO;
    }
    [self.schemeDictionary setObject:obj forKey:newName];
    [self.schemeDictionary removeObjectForKey:schemeName];
    [self loadSchemeNameList];
    return YES;

}

- (BOOL)wheelStringAdded:(NSString *)newStr forWheel:(NSInteger)wheelIndex ofScheme:(NSString *)schemeName
{
    [[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex] addObject:newStr];
    return YES;
    
}

- (BOOL)wheelStringRenameTo:(NSString*)newName atIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    [[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex] setObject:newName atIndex:strIndex];
    return YES;
    
}

- (BOOL)wheelStringDeletedAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    [[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex] removeObjectAtIndex:strIndex];
    return YES;
}

- (void)abandonChanging
{
    [self loadSchemeOfType:_schemeGroupType];
}

- (void)saveChanging
{
    [[NSUserDefaults standardUserDefaults] setObject:self.schemeDictionary forKey:[self schemeGroupNameOfType:_schemeGroupType]];
}

- (NSArray*)schemeNameList
{
    if (nil==_schemeNameList)
    {
        [self loadSchemeNameList];
    }
    return _schemeNameList;

}

- (NSArray*)wheelArrayOfScheme:(NSString*)schemeName
{
    return [self.schemeDictionary objectForKey:schemeName];
}

- (NSString*)stringAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    return [[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex] objectAtIndex:strIndex];
}

#pragma mark - private -
- (void)loadSchemeNameList
{
    NSEnumerator *enumerator=[self.schemeDictionary keyEnumerator];
    NSMutableArray *nameList=[[NSMutableArray alloc] initWithCapacity:3];
    id key;
    while (key=[enumerator nextObject])
    {
        [nameList addObject:(NSString*)key];
    }
    self.schemeNameList=nameList;
}

- (void)loadSchemeFromPlistFileOfType:(SchemeGroupType)type
{
    NSDictionary *tempSchemeDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self schemeGroupNameOfType:type] ofType:@"plist"]];
    self.schemeDictionary=[[NSMutableDictionary alloc] initWithCapacity:[tempSchemeDic count]];
    
    [tempSchemeDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         NSArray *tempWheelArray=(NSArray*)obj;
         NSArray *wheelArray;
         
         switch (type)
         {
             case SchemeGroupType_MonoWheel:
                 wheelArray=[NSArray arrayWithObjects:
                             [[tempWheelArray objectAtIndex:0] mutableCopy],
                             nil];
                 break;
             case SchemeGroupType_BiWheel:
                 wheelArray=[NSArray arrayWithObjects:
                             [[tempWheelArray objectAtIndex:0] mutableCopy],
                             [[tempWheelArray objectAtIndex:1] mutableCopy],
                             nil];
                 break;
             case SchemeGroupType_TriWheel:
                 wheelArray=[NSArray arrayWithObjects:
                             [[tempWheelArray objectAtIndex:0] mutableCopy],
                             [[tempWheelArray objectAtIndex:1] mutableCopy],
                             [[tempWheelArray objectAtIndex:2] mutableCopy],
                             nil];
                 break;
             default:
                 break;
         }
         
         [self.schemeDictionary setObject:wheelArray forKey:(NSString*)key];
         
     }];
    
    [self loadSchemeNameList];
}

- (void)loadSchemeOfType:(SchemeGroupType)type
{
    NSDictionary *tempSchemeDic=[[NSUserDefaults standardUserDefaults] objectForKey:[self schemeGroupNameOfType:type]];
    if (nil!=tempSchemeDic)
    {
        self.schemeDictionary=[tempSchemeDic mutableCopy];
        [self loadSchemeNameList];
        return;
    }
    [self loadSchemeFromPlistFileOfType:type];

}

- (NSString*)schemeGroupNameOfType:(SchemeGroupType)type
{
    switch (type)
    {
        case SchemeGroupType_MonoWheel:
            return @"MonoWheelSchemeGroup";
            break;
        case SchemeGroupType_BiWheel:
            return @"BiWheelSchemeGroup";
            break;
        case SchemeGroupType_TriWheel:
            return @"TriWheelSchemeGroup";
            break;
        default:
            break;
    }
    return nil;
    
}

@end
