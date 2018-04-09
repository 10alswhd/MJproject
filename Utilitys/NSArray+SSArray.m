//
//  NSArray+SSArray.m
//  SnackFMC
//
//  Created by 관수 이 on 13. 4. 18..
//  Copyright (c) 2013년 DREAMKET. All rights reserved.
//

#import "NSArray+SSArray.h"

@implementation NSArray (SSArray)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

@end

@implementation NSMutableArray(SSArray)

- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx
{
    while ([self count] <= idx)
    {
        [self addObject:[NSMutableArray array]];
    }
    
    [[self objectAtIndex:idx] addObject:anObject];
}

@end
