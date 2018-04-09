//
//  NSArray+SSArray.h
//  SnackFMC
//
//  Created by 관수 이 on 13. 4. 18..
//  Copyright (c) 2013년 DREAMKET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SSArray)
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface NSMutableArray (SSArray)
// If idx is beyond the bounds of the reciever, this method automatically extends the reciever to fit with empty subarrays.
- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx;
@end
