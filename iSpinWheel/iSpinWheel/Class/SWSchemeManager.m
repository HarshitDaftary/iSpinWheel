//
//  SWSchemeManager.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWSchemeManager.h"

static SWSchemeManager* monoSchemeManager;
static SWSchemeManager* biSchemeManager;
static SWSchemeManager* triSchemeManager;

@interface SWSchemeManager ()
{
    SchemeGroupType _schemeGroupType;
}

@property (strong, nonatomic) NSMutableDictionary *schemeDictionary;
@property (strong, nonatomic) NSArray *schemeNameList_v;
@property (copy, nonatomic) NSString *schemeNameInUsing_v;
@end

@implementation SWSchemeManager
@synthesize schemeDictionary=_schemeDictionary;
@synthesize schemeNameList_v=_schemeNameList_v;
@synthesize schemeNameInUsing_v=_schemeNameInUsing_v;

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

- (NSString*)schemeNameInUsing
{
    if (nil!=self.schemeNameInUsing_v)
    {
        return self.schemeNameInUsing_v;
    }
    NSString *key=[[self schemeGroupNameOfType:_schemeGroupType] stringByAppendingString:@"_inUsing"];
    self.schemeNameInUsing_v=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nil==self.schemeNameInUsing_v)
    {
        self.SchemeNameInUsing_v=[[self schemeNameList] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:self.schemeNameInUsing_v forKey:key];
    }
    return self.schemeNameInUsing_v;
}

- (BOOL)setSchemeNameInUsing:(NSString*)schemeName
{
    if ([schemeName isEqualToString:self.schemeNameInUsing_v])
    {
        return NO;
    }
    NSString *key=[[self schemeGroupNameOfType:_schemeGroupType] stringByAppendingString:@"_inUsing"];
    if (nil==schemeName)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:schemeName forKey:key];
    }
    self.schemeNameInUsing_v=schemeName;
    return YES;
}

+ (SWSchemeManager*)shareInstanceOfSchemeType:(SchemeGroupType)type
{
    switch (type)
    {
        case SchemeGroupType_MonoWheel:
            if (nil==monoSchemeManager)
            {
                monoSchemeManager=[[SWSchemeManager alloc] initWithSchemeType:SchemeGroupType_MonoWheel];
            }
            return monoSchemeManager;
            break;
        case SchemeGroupType_BiWheel:
            if (nil==biSchemeManager)
            {
                biSchemeManager=[[SWSchemeManager alloc] initWithSchemeType:SchemeGroupType_BiWheel];
            }
            return biSchemeManager;
            break;
        case SchemeGroupType_TriWheel:
            if (nil==triSchemeManager)
            {
                triSchemeManager=[[SWSchemeManager alloc] initWithSchemeType:SchemeGroupType_TriWheel];
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
                        [[NSMutableArray alloc] initWithObjects:@"新选项",@"新选项 01", nil],
                        nil];
            break;
        case SchemeGroupType_BiWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithObjects:@"新选项",@"新选项 01", nil],
                        [[NSMutableArray alloc] initWithObjects:@"新选项",@"新选项 01", nil],
                        nil];
            break;
        case SchemeGroupType_TriWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithObjects:@"新选项",@"新选项 01", nil],
                        [[NSMutableArray alloc] initWithObjects:@"新选项",@"新选项 01", nil],
                        [[NSMutableArray alloc] initWithObjects:@"新选项",@"新选项 01", nil],
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
    if ([schemeName isEqualToString:[self schemeNameInUsing]])
    {
        [self setSchemeNameInUsing:nil];
    }
    [self loadSchemeNameList];
    return YES;
    
}

- (BOOL)schemeRenameFrom:(NSString*)schemeName to:(NSString*)newName
{
    if ([schemeName isEqualToString:newName])
    {
        return NO;
    }
    id obj=[self.schemeDictionary objectForKey:schemeName];
    
    if (nil==obj)
    {
        return NO;
    }
    [self.schemeDictionary setObject:obj forKey:newName];
    [self.schemeDictionary removeObjectForKey:schemeName];
    [self setSchemeNameInUsing:newName];
    [self loadSchemeNameList];
    return YES;

}

- (BOOL)wheelStringAdded:(NSString *)newStr forWheel:(NSInteger)wheelIndex ofScheme:(NSString *)schemeName
{
    NSInteger maxSegment=0;
    switch (_schemeGroupType) {
        case SchemeGroupType_MonoWheel:
            maxSegment=MonoWheelMaxSegment;
            break;
        case SchemeGroupType_BiWheel:
            if (0==wheelIndex)
            {
                maxSegment=BiSmallWheelMaxSegment;
            }
            else
            {
                maxSegment=BiBigWheelMaxSegment;
            }
            break;
        case SchemeGroupType_TriWheel:
            if (0==wheelIndex)
            {
                maxSegment=TriSmallWheelMaxSegment;
            }
            else if (1==wheelIndex)
            {
                maxSegment=TriMediumWheelMaxSegment;
            }
            else
            {
                maxSegment=TriBigWheelMaxSegment;
            }
            break;
            
        default:
            break;
    }
    NSMutableArray *strArray=[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex];
    if ([strArray count]>=maxSegment)
    {
        return NO;
    }
    [strArray addObject:newStr];
    return YES;
    
}

- (BOOL)wheelStringRenameTo:(NSString*)newName atIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    [[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex] setObject:newName atIndex:strIndex];
    return YES;
    
}

- (BOOL)wheelStringDeletedAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    NSMutableArray *strList=[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex];
    if (2>=[strList count])
    {
        return NO;
    }
    [strList removeObjectAtIndex:strIndex];
    return YES;
}

- (void)abandonChanging
{
    [self loadSchemeOfType:_schemeGroupType];
}

- (void)commitChanging
{
    [[NSUserDefaults standardUserDefaults] setObject:self.schemeDictionary forKey:[self schemeGroupNameOfType:_schemeGroupType]];
}

- (void)restoreToDefault
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self schemeGroupNameOfType:_schemeGroupType]];
    [self loadSchemeFromPlistFileOfType:_schemeGroupType];
    [self setSchemeNameInUsing:nil];
}

- (NSArray*)schemeNameList
{
    if (nil==self.schemeNameList_v)
    {
        [self loadSchemeNameList];
    }
    return self.schemeNameList_v;

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
    self.schemeNameList_v=[nameList sortedArrayUsingComparator:^(id obj1, id obj2) {
        return [(NSString*)obj1 caseInsensitiveCompare:(NSString*)obj2];
    }];
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
