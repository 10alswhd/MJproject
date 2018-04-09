//
//  NSDate+Util.h
//  SnackFMC
//
//  Created by 관수 이 on 13. 6. 20..
//  Copyright (c) 2013년 DREAMKET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString*)format;

- (NSDate *)tomorrow;
- (NSDate *)yesterday;
- (NSDate *)nextWeek;
- (NSDate *)lastWeek;
- (NSDate *)nextMonth;
- (NSDate *)lastMonth;
- (NSDate *)nextYear;
- (NSDate *)lastYear;

- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateBySubtractingDays:(NSInteger)days;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)datebySubtractingYears:(NSInteger)years;

- (NSInteger)dayOfWeek;
- (NSString*) stringAtDayOfWeekForKorea;
- (NSInteger)month;
- (NSInteger)year;

- (BOOL)isLaterThanDate:(NSDate *)date;
- (BOOL)isEarlierThanDate:(NSDate *)date;
- (BOOL)isSameAndLaterThanDate:(NSDate *)date;
- (BOOL)isSameAndEarlierThanDate:(NSDate*)date;

- (NSString *)stringWithFormat:(NSString *)format;

- (NSDate*)gmt;
- (NSDate*)localTime;

@end
