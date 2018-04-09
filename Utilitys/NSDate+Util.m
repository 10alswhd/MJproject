//
//  NSDate+Util.m
//  SnackFMC
//
//  Created by 관수 이 on 13. 6. 20..
//  Copyright (c) 2013년 DREAMKET. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    
    [components release];
    [calendar release];
    
    return newDate;
}

static dispatch_queue_t _formatterQueue;
static dispatch_once_t  _onceToken;

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format
{
    __block NSDate *resultDate = nil;
    
    dispatch_once(&_onceToken, ^{
        _formatterQueue = dispatch_queue_create("formatter queue", NULL);
    });
    
    dispatch_sync(_formatterQueue, ^{
        
        NSDateFormatter *formatter = [NSDate currentDateFormatter:format];
        if(formatter)
            resultDate = [formatter dateFromString:dateString];
    });
    
    return resultDate;
}


//+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format
//{
//    NSDateFormatter *formatter = [NSDate currentDateFormatter:format];
//    return [formatter dateFromString:dateString];
//}

- (NSDate *)tomorrow
{
    return [self dateByAddingDays:1];
}

- (NSDate *)yesterday
{
    return [self dateBySubtractingDays:1];
}

- (NSDate *)nextWeek
{
    return [self dateByAddingDays:7];
}

- (NSDate *)lastWeek
{
    return [self dateBySubtractingDays:7];
}

- (NSDate *)nextMonth
{
    return [self dateByAddingMonths:1];
}

- (NSDate *)lastMonth
{
    return [self dateBySubtractingMonths:1];
}

- (NSDate *)nextYear
{
    return [self dateByAddingYears:1];
}

- (NSDate *)lastYear
{
    return [self datebySubtractingYears:1];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setDay:days];
    
    NSDate *newDate = [calendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    [_dateOffsetComponents release];
    [calendar release];
    
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)days
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setDay:-days];
    
    NSDate *newDate = [calendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    [_dateOffsetComponents release];
    [calendar release];
    
    return newDate;
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setMonth:months];
    
    NSDate *newDate = [calendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    [_dateOffsetComponents release];
    [calendar release];
    
    return newDate;
    
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)months
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *_dateOffsetComponents = [[NSDateComponents alloc] init];
    [_dateOffsetComponents setMonth:-months];
    
    NSDate *newDate = [calendar dateByAddingComponents:_dateOffsetComponents toDate:self options:0];
    
    [_dateOffsetComponents release];
    [calendar release];
    
    return newDate;
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:self options:0];
    
    [components release];
    [calendar release];
    
    return newDate;
}

- (NSDate *)datebySubtractingYears:(NSInteger)years
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:-years];
    
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:self options:0];
    
    [components release];
    [calendar release];
    
    return newDate;
}

- (NSInteger)dayOfWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    [calendar release];
    
    return components.weekday;
}

- (NSString*) stringAtDayOfWeekForKorea {
	NSString *result = @"";
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[calendar setLocale:[NSLocale currentLocale]];
	[calendar setFirstWeekday:1];

	NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	[calendar release];

	switch(components.weekday) {
		case 1:
			result = @"일";
			break;
		case 2:
			result = @"월";
			break;
		case 3:
			result = @"화";
			break;
		case 4:
			result = @"수";
			break;
		case 5:
			result = @"목";
			break;
		case 6:
			result = @"금";
			break;
		case 7:
			result = @"토";
			break;
		default:
			break;
	}

	return result;

}

- (NSInteger)month
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit fromDate:self];
    [calendar release];
    
    return components.month;
}

- (NSInteger)year
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:self];
    [calendar release];
    
    return components.year;
}

- (BOOL)isLaterThanDate:(NSDate *)date
{
    return ([self compare:date] == NSOrderedDescending);
}

- (BOOL)isSameAndLaterThanDate:(NSDate *)date
{
	return ([self compare:date] == NSOrderedDescending || [self compare:date] == NSOrderedSame);
}

- (BOOL)isSameAndEarlierThanDate:(NSDate*)date
{
	return ([self compare:date] == NSOrderedAscending || [self compare:date] == NSOrderedSame);
}


- (BOOL)isEarlierThanDate:(NSDate *)date
{
    return ([self compare:date] == NSOrderedAscending);
}

- (NSString *)stringWithFormat:(NSString *)format
{
    __block NSString *resultString = @"";
    
    dispatch_once(&_onceToken, ^{
        _formatterQueue = dispatch_queue_create("formatter queue", NULL);
    });
    
    dispatch_sync(_formatterQueue, ^{

        NSDateFormatter *formatter = [NSDate currentDateFormatter:format];
        if(formatter)
            resultString = [formatter stringFromDate:self];
        
        if([TUtil isEqualText:@"yyyyMMddHHmmssSSS" str:format])
        {
            if(format.length != resultString.length)
                NSLog(@"[APP]stringWithFormat %@, %@ : %@, %@", format, formatter.dateFormat, resultString, [formatter stringFromDate:self]);
        }
    });
    
    return resultString;
}

- (NSDate*)gmt
{
    NSTimeInterval offset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval:-offset]; // NOTE the "-" sign!
}

- (NSDate*)localTime
{
    NSTimeInterval offset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:self];
    if(32400 == offset)
    {
        
    }
    else
    {
    }
    
    return [self dateByAddingTimeInterval:offset];
}

static NSCache *NSDateFormatterReusableDatesCache;

+ (NSDateFormatter *)currentDateFormatter:(NSString*)format
{
    static dispatch_once_t cacheOnceToken;

    dispatch_once(&cacheOnceToken, ^{
        NSDateFormatterReusableDatesCache = [[NSCache alloc] init];
    });

    NSDateFormatter *dateFormatter = [NSDateFormatterReusableDatesCache objectForKey:format];
    if (!dateFormatter)
    {
        dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
        dateFormatter.dateFormat = format;

        [NSDateFormatterReusableDatesCache setObject:dateFormatter forKey:format];
    }

    return dateFormatter;
}

//static NSCache *NSDateFormatterReusableDatesCache;
//
//+ (NSDateFormatter *)currentDateFormatter:(NSString*)format
//{
//    static dispatch_once_t cacheOnceToken;
//    static dispatch_queue_t formatterQueue;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&cacheOnceToken, ^{
//        NSDateFormatterReusableDatesCache = [[NSCache alloc] init];
//    });
//
//    dispatch_once(&onceToken, ^{
//        formatterQueue = dispatch_queue_create("formatter queue", NULL);
//    });
//
//    __block NSDateFormatter *dateFormatter = nil;
//
//    dispatch_sync(formatterQueue, ^{
//
//        dateFormatter = [NSDateFormatterReusableDatesCache objectForKey:format];
//        if (!dateFormatter)
//        {
//            dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
//            dateFormatter.dateFormat = format;
//
//            [NSDateFormatterReusableDatesCache setObject:dateFormatter forKey:format];
//        }
//    });
//
//    return dateFormatter;
//}

@end
