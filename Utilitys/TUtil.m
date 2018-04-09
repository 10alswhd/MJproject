//
//  TUtil.m
//  
//
//  Created by 관수 이 on 11. 8. 4..
//  Copyright 2011 mnkc. All rights reserved.
//
#import "TUtil.h"

#import <netdb.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/ethernet.h>
#import <net/if_dl.h>
#import <net/if.h>
#import <mach/mach.h>
#import <netinet/in.h>

#include <sys/types.h>
#include <sys/sysctl.h>

#import <MobileCoreServices/MobileCoreServices.h>

#import "NSDate+Util.h"
#import "NSString+Additions.h"


@implementation TUtil

+ (CGFloat) getTextHeightWithLine:(NSString*)text line:(int)line spacing:(CGFloat)spacing fontsize:(CGFloat)fontsize
{
    __block CGFloat result = 0;
    
    if([NSThread isMainThread]) {
        if([TUtil hasText:text])
            result = floorf([text sizeWithFont1:[UIFont systemFontOfSize:fontsize]].height*spacing)*line;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if([TUtil hasText:text])
                result = floorf([text sizeWithFont1:[UIFont systemFontOfSize:fontsize]].height*spacing)*line;
        });
    }
    
	return result;
}

+ (uint) getTextLine:(NSString*)text width:(CGFloat)width fontsize:(CGFloat)fontsize
{
	uint result = 0;
    
    if([NSThread isMainThread]) {
        if([TUtil hasText:text]) {
            UIFont *font = [UIFont systemFontOfSize:fontsize];
            CGFloat lineHeight = [text sizeWithFont1:font].height;
            CGFloat textHeight = [TUtil getTextHeight:text width:width font:font];
            if(textHeight >= lineHeight)
                result = textHeight/lineHeight;
        }
    }
	
	return result;
}

+ (float) getTextHeight:(NSString*)text width:(float)width font:(UIFont*)font {
    CGSize suggestedSize = [text sizeWithFont1:font constrainedToSize:CGSizeMake(width, FLT_MAX)];
    return suggestedSize.height;
}

+ (float) getTextWidth:(NSString*)text height:(float)height font:(UIFont*)font {
    CGSize suggestedSize = [text sizeWithFont1:font constrainedToSize:CGSizeMake(FLT_MAX, height)];
    return suggestedSize.width;
}

+ (CGSize) getSingleLineTextSize:(NSString*)text font:(UIFont*)font {
    CGSize result = CGSizeZero;
    
    if([text respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSDictionary* attr = @{NSFontAttributeName:font};
        CGSize size = [text sizeWithAttributes:attr];
        
        result.height = ceilf(size.height);
        result.width  = ceilf(size.width);
    } else {
        result = [text sizeWithFont:font];
    }

    return result;
}

+ (float) getSingleLineTextWidth:(NSString*)textStr font:(UIFont*)font {
	    CGSize suggestedSize = [textStr sizeWithFont1:font];

    return suggestedSize.width;
}

+ (float) getLabelTextHeight:(UILabel*)myLabel {
    CGSize suggestedSize = [myLabel.text sizeWithFont1:myLabel.font
                                    constrainedToSize:CGSizeMake(myLabel.frame.size.width, FLT_MAX) 
                                        lineBreakMode:UILineBreakModeWordWrap];
    return suggestedSize.height;
}

+ (CGRect)getLabelTextRect:(UILabel*)myLabel {
    CGSize suggestedSize = [myLabel.text sizeWithFont1:myLabel.font];
    return CGRectMake(myLabel.frame.origin.x, myLabel.frame.origin.y, suggestedSize.width, suggestedSize.height);
}

+ (float) getSingleLineTextHeight:(NSString*)textStr font:(UIFont*)font {
    CGSize suggestedSize = [textStr sizeWithFont1:font];
    return suggestedSize.height;
}

+ (UIColor *) rgbFromHex:(NSString *)code {
    NSString *str = [[code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([str length] < 6)  // 일단 6자 이하면 말이 안되니까 검은색을 리턴해주자.
        return [UIColor blackColor];
    // 0x로 시작하면 0x를 지워준다.
    if ([str hasPrefix:@"0X"])
        str = [str substringFromIndex:2];
    // #으로 시작해도 #을 지워준다.
    if ([str hasPrefix:@"#"])
        str = [str substringFromIndex:1];
    if ([str length] != 6) //그랫는데도 6자 이하면 이것도 이상하니 그냥 검은색을 리턴해주자.
        return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rcolorString = [str substringWithRange:range];
    range.location = 2;
    NSString *gcolorString = [str substringWithRange:range];
    range.location = 4;
    NSString *bcolorString = [str substringWithRange:range];
    unsigned int red, green, blue;
    [[NSScanner scannerWithString: rcolorString] scanHexInt:&red];
    [[NSScanner scannerWithString: gcolorString] scanHexInt:&green];
    [[NSScanner scannerWithString: bcolorString] scanHexInt:&blue];
    
    return [UIColor colorWithRed:((float) red / 255.0f)
                           green:((float) green / 255.0f)
                            blue:((float) blue / 255.0f)
                           alpha:1.0f];
}

+ (BOOL)floatInRange:(CGFloat)value between:(CGFloat)minValue and:(CGFloat)maxValue {
    CGFloat min = minValue;
    CGFloat max = maxValue;
    
    if(min > max) {
        min = maxValue;
        max = minValue;
    }
    
    return (value >= min && value <= max);
}

+ (BOOL)findstr:(NSString*)aString find:(NSString*)aFind {
    if([aString rangeOfString:aFind].location == NSNotFound)
        return NO;

    return YES;
}

// substring
+ (NSString *) substr:(NSString*)str index:(NSInteger)idx {
	NSString *ret = nil;
	
	if (idx<0) {
		ret = [str substringFromIndex:[str length]+idx];
	} else {
		ret = [str substringToIndex:idx];
	}
	
	return ret;
}

// substring
+ (NSString *) substr:(NSString*)str startIndex:(NSUInteger)sidx endIndex:(NSUInteger)eidx {
	NSRange range = {sidx,eidx};
	NSString *ret = [str substringWithRange:range];
	
	return ret;
}

// trim
+ (NSString *) trim:(NSString*)str {
	NSString *ret = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	
	return ret;
}

+ (NSString *)substrToIndex:(NSString*)str find:(NSString*)find {
    NSRange range = [str rangeOfString:find];
    if (range.location == NSNotFound)
        return @"";

    return [str substringToIndex:range.location];
}

+ (NSString *)substrFromIndex:(NSString*)str find:(NSString*)find {
    NSRange range = [str rangeOfString:find];
    if (range.location == NSNotFound)
        return @"";
    
    return [str substringFromIndex:NSMaxRange(range)];
}

+ (NSString*)moneyFormat:(SInt64)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,###"];
    NSNumber *number = [NSNumber numberWithLongLong:value];
    
    //If you print next thing
    return [NSString stringWithFormat: @"%@", [formatter stringForObjectValue:number]];
}

// 2010년 03월10일 포맷으로
+ (NSString*)dateFormat:(NSString*)inStr
{
	NSString* ret = @"";
	if(inStr.length>0) {
		ret = [[NSString alloc] initWithFormat:@"%@년 %@월 %@일",
                [TUtil substr:inStr startIndex:0 endIndex:4], 
                [TUtil substr:inStr startIndex:4 endIndex:2], 
                [TUtil substr:inStr startIndex:6 endIndex:2]];
	} else {
		ret = @"";
	}
	
	return ret;
}

// 2012.01.04
+ (NSString*) dateFormatYYYYMMDD:(NSString*)inStr
{
	NSString* ret = @"";
	if(inStr.length>0)
	{
		ret = [[NSString alloc] initWithFormat:@"%@.%@.%@",
                [TUtil substr:inStr startIndex:0 endIndex:4], 
                [TUtil substr:inStr startIndex:4 endIndex:2], 
                [TUtil substr:inStr startIndex:6 endIndex:2]];
	} else {
		ret = @"";
	}
	
	return ret;
}

+ (NSString*) dateFormatYYYYMMDDHHMM:(NSString*)inStr {
	NSString* ret = @"";
	if(inStr.length>0) {
		ret = [[NSString alloc] initWithFormat:@"%@.%@.%@ %@:%@",
                [TUtil substr:inStr startIndex:0 endIndex:4], 
                [TUtil substr:inStr startIndex:4 endIndex:2], 
                [TUtil substr:inStr startIndex:6 endIndex:2],
                [TUtil substr:inStr startIndex:8 endIndex:2],
                [TUtil substr:inStr startIndex:10 endIndex:2]];
	} else {
		ret = @"";
	}
	
	return ret;
}


// 공백값인가
+ (BOOL) isEmpty:(NSString*)aStr {
    if(nil == aStr)
        return YES;
    if ([@"" isEqualToString:aStr]) 
        return YES;
	if([aStr isKindOfClass:[NSNull class]]) {
		return YES;
	}
    
    return NO;
}

// 문자가 있는지.
+ (BOOL) hasText:(NSString *)aStr {
    if(nil == aStr)
        return NO;
    if ([@"" isEqualToString:aStr]) 
        return NO;
	if([aStr isKindOfClass:[NSNull class]]) {
		return NO;
	}
	
    return YES;
}

+ (BOOL) isEqualText:(NSString*)str1 str:(NSString*)str2 {
    return [str1 isEqualToString:str2];
}

+ (BOOL) isEqualTextToIndex:(NSString*)str1 str:(NSString*)str2 to:(UInt16)to {
    NSString *string1 = [str1 substringToIndex:to];
    NSString *string2 = [str2 substringToIndex:to];
    
    return [string1 isEqualToString:string2];
}

+ (void)setLabelVerticalAlignment:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText usingVerticalAlign:(int)vertAlign
{
    CGSize stringSize = [theText sizeWithFont1:myLabel.font constrainedToSize:maxFrame.size lineBreakMode:myLabel.lineBreakMode];
    
    switch (vertAlign) {
        case 0: // vertical align = top
            myLabel.frame = CGRectMake(myLabel.frame.origin.x, 
                                       myLabel.frame.origin.y, 
                                       myLabel.frame.size.width, 
                                       stringSize.height
                                       );
            break;
            
        case 1: // vertical align = middle
            // don't do anything, lines will be placed in vertical middle by default
            break;
            
        case 2: // vertical align = bottom
            myLabel.frame = CGRectMake(myLabel.frame.origin.x, 
                                       (myLabel.frame.origin.y + myLabel.frame.size.height) - stringSize.height, 
                                       myLabel.frame.size.width, 
                                       stringSize.height
                                       );
            break;
    }
    
    myLabel.text = theText;
}

+ (BOOL)checkFile:(NSString *)aFile {
    BOOL result = NO;
    
    NSFileManager * fm = [[NSFileManager alloc] init];
    if(nil != fm) {
        result = [fm fileExistsAtPath:aFile];
    }
    return result;
}

+ (BOOL)createDir:(NSString *)aDir {
    NSFileManager * fm = [[NSFileManager alloc] init];
    if(fm) {
        [fm createDirectoryAtPath:aDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}

+ (BOOL)copyFile:(NSString *)aOrgFile destfile:(NSString *)aDstFile {
    BOOL result = NO;
    
    NSFileManager * fm = [[NSFileManager alloc] init];
    if(nil != fm) {
        result = [fm copyItemAtPath:aOrgFile toPath:aDstFile error:nil];
    }
    
    return result;
}

+ (BOOL)deleteFile:(NSString *)aFile {
    NSFileManager * fm = [[NSFileManager alloc] init];
    if(nil != fm) {
        [fm removeItemAtPath:aFile error:nil];
    }
    
    return YES;
}

+ (SInt64)getFileSize:(NSString*)path {
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
}

+ (NSString *) getDayOfTheWeek:(NSDate *)aDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSMonthCalendarUnit|NSDayCalendarUnit
                              |NSWeekdayCalendarUnit fromDate:aDay];
    switch ([comp weekday]) { // 1 = Sunday, 2 = Monday, etc.
        case 1:
            return @"일요일";
            break;
        case 2:
            return @"월요일";
            break;
        case 3:
            return @"화요일";
            break;
        case 4:
            return @"수요일";
            break;
        case 5:
            return @"목요일";
            break;
        case 6:
            return @"금요일";
            break;
        case 7:
            return @"토요일";
            break;
        default:
            break;
    }
    
    return @"";
}

// 서버사용
+ (NSString*)stringForKey:(NSDictionary *)dictionary keyStr:(NSString*)keyStr {
    NSString * result = @"";
    if(nil != dictionary) {
        NSString *valueString = [dictionary objectForKey:keyStr];
        if(nil != valueString)
            result = [NSString stringWithFormat:@"%@", valueString];
    }
    
    return result;
}

+ (SInt64)intForKey:(NSDictionary *)dictionary keyStr:(NSString*)keyStr {
    int result = 0;
    if(nil != dictionary)
    {
        NSNumber *valueNumber = [dictionary objectForKey:keyStr];
        if(valueNumber)
            result = [valueNumber intValue];
    }
    
    return result;
}

+ (BOOL)checkAlertExist:(NSInteger)tag {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        for(int i=0; i<subviews.count; i++) {
            UIView *view = [subviews objectAtIndex:i];
            if ([view isKindOfClass:[UIAlertView class]]) {
                if(tag == view.tag)
                    return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)checkAlertExist {
	for(UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0) {
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
                return YES;
        }
    }
    
    return NO;
}

+ (NSString*)addHyphenToPhoneNumber:(NSString*)aString {
    NSString * result = aString;
    NSString * Str = [aString stringByReplacingOccurrencesOfString:@"-" withString:@""];

	if([TUtil checkMobileNumber:aString]) {
		if([Str isEqualToString:@""] && Str.length <10)	{
		} else {
			if(Str.length == 10) {
				NSString* str1 = [Str substringWithRange:NSMakeRange(0, 3)];
				NSString* str2 = [Str substringWithRange:NSMakeRange(3, 3)];
				NSString* str3 = [Str substringWithRange:NSMakeRange(6, 4)];
				result = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
			} else if (Str.length > 10) {
				NSString* str1 = [Str substringWithRange:NSMakeRange(0, 3)];
				NSString* str2 = [Str substringWithRange:NSMakeRange(3, 4)];
				NSString* str3 = [Str substringWithRange:NSMakeRange(7, Str.length - 7)];   
				result = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
			}
		}
	}
	else if([TUtil checkHomeNumber:aString]) {
		if([Str isEqualToString:@""] && Str.length < 9)	{
		} else {
			BOOL isSeoul = NO;
			NSString *prefix = [TUtil substr:Str startIndex:0 endIndex:2];
			if([prefix isEqualToString:@"02"])
				isSeoul = YES;
			if(isSeoul)	{
				if(Str.length == 9)	{
					NSString* str1 = [Str substringWithRange:NSMakeRange(0, 2)];
					NSString* str2 = [Str substringWithRange:NSMakeRange(2, 3)];
					NSString* str3 = [Str substringWithRange:NSMakeRange(5, 4)];
					result = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
				} else if(Str.length > 9) {
					NSString* str1 = [Str substringWithRange:NSMakeRange(0, 2)];
					NSString* str2 = [Str substringWithRange:NSMakeRange(2, 4)];
					NSString* str3 = [Str substringWithRange:NSMakeRange(6, Str.length - 6)];
					result = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
				}
			} else {
				if(Str.length == 10) {
					NSString* str1 = [Str substringWithRange:NSMakeRange(0, 3)];
					NSString* str2 = [Str substringWithRange:NSMakeRange(3, 3)];
					NSString* str3 = [Str substringWithRange:NSMakeRange(6, 4)];
					result = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
				} else if (Str.length > 10) {
					NSString* str1 = [Str substringWithRange:NSMakeRange(0, 3)];
					NSString* str2 = [Str substringWithRange:NSMakeRange(3, 4)];
					NSString* str3 = [Str substringWithRange:NSMakeRange(7, Str.length - 7)];   
					result = [NSString stringWithFormat:@"%@-%@-%@", str1, str2, str3];
				}
			}
		}
	}
    
    return result;
}

+ (NSString*)getValidNumber:(NSString*)phoneNumber {
    NSString *result = phoneNumber;
    
    if([TUtil hasText:phoneNumber]) {
        result = [[phoneNumber componentsSeparatedByCharactersInSet:
                         [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789*#"]invertedSet]]
                        componentsJoinedByString:@""];
    }
    
    return result;
}

+ (NSString*)getValidString:(NSString*)aStr charSet:(NSString*)charSet {
	NSString *result = aStr;
	if([TUtil hasText:charSet] && [TUtil hasText:aStr])	{
		result = [[aStr componentsSeparatedByCharactersInSet:
						 [[NSCharacterSet characterSetWithCharactersInString:charSet]invertedSet]]
						componentsJoinedByString:@""];
	}
	return result;
}

+ (NSString*)getValidInteger:(NSString*)aStr {
    NSString *result = aStr;
    
    if([TUtil hasText:aStr]) {
        result = [[aStr componentsSeparatedByCharactersInSet:
                         [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet]]
                        componentsJoinedByString:@""];
    }
    
    return result;
}

+ (UIImage*)readImageFromStorage:(NSString *)path {
    UIImage  *image = nil;

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //그림이 있으면 읽음
        NSURL *pURL = [NSURL fileURLWithPath:path];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pURL]];
    } else {
        //그림이 없으면 기본이미지를 출력함
    }
    
    return image;
}

+ (void)saveImageToStorage:(NSString*)path image:(UIImage*)image {
    // Save the image 
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data writeToFile:path atomically:YES];
}

//이미지 리사이즈
+ (UIImage *)scaleAndRotate:(UIImage *)image maxResolution:(int)maxResolution orientation:(UIImageOrientation)orientation {
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > maxResolution || height > maxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = maxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = maxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    switch (orientation) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//이미지 크롭
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop {
    CGRect rect = CGRectMake(imageToCrop.size.width/2 - 110 , imageToCrop.size.height/2 - 110, 110, 110);
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

+ (BOOL) offsetRect:(UIView*)view offset:(CGPoint)offset {
    if(nil == view)
        return NO;
    
    CGRect rect = view.frame;
    rect.origin.x = rect.origin.x + offset.x;
    rect.origin.y = rect.origin.y + offset.y;
    view.frame = rect;

    return YES;
}

+ (UIImage*)resizedImage:(UIImage*)inImage  inRect:(CGRect)thumbRect {
    // Creates a bitmap-based graphics context and makes it the current context.
    UIGraphicsBeginImageContext(thumbRect.size);
    [inImage drawInRect:thumbRect];
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)resizeWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSDate *)addDate:(NSDate *)date value:(NSInteger)day {
    return [date dateByAddingTimeInterval:day*24*60*60];
}

+ (NSDate *)addHour:(NSDate *)date value:(NSInteger)hour {
    return [date dateByAddingTimeInterval:hour*60*60];
}

// UILabel 정렬
+ (void)setVerticalAlign:(UILabel *)label maxFrame:(CGRect)frame text:(NSString *)text align:(int)align {
    CGSize stringSize = [text sizeWithFont:label.font constrainedToSize:frame.size lineBreakMode:label.lineBreakMode];
    switch (align) {
        case 0: // vertical align = top
            label.frame = CGRectMake(label.frame.origin.x, 
                                     label.frame.origin.y, 
                                     label.frame.size.width, 
                                     stringSize.height);
            break;
            
        case 1: // vertical align = middle
            // don't do anything, lines will be placed in vertical middle by default
            break;
            
        case 2: // vertical align = bottom
            label.frame = CGRectMake(label.frame.origin.x, 
                                     (label.frame.origin.y + label.frame.size.height) - stringSize.height, 
                                     label.frame.size.width, 
                                     stringSize.height);
            break;
    }
    
    label.text = text;
}

// UILabel 오른쪽정렬
+ (void)setRightAlign:(UILabel *)label pos:(CGFloat)pos text:(NSString *)text {
    CGFloat stingWidth = [TUtil getSingleLineTextWidth:text font:label.font];
    label.frame = CGRectMake(pos-stingWidth, label.frame.origin.y, stingWidth, label.frame.size.height);
}

// 상대좌표 설정.
+ (void)setOffset:(UIView *)myView ofView:(UIView*)ofView posX:(SInt16)posX posY:(SInt16)posY {
    if(posX > 0) {
        myView.frame = CGRectMake(ofView.frame.origin.x + ofView.frame.size.width + posX, 
                                  myView.frame.origin.y, 
                                  myView.frame.size.width,
                                  myView.frame.size.height);
    } else if(posX < 0) {
        posX = abs(posX);
        myView.frame = CGRectMake(ofView.frame.origin.x - (myView.frame.size.width + posX), 
                                  myView.frame.origin.y, 
                                  myView.frame.size.width,
                                  myView.frame.size.height);
    }
    
    if(posY > 0) {
        myView.frame = CGRectMake(ofView.frame.origin.x, 
                                  myView.frame.origin.y + ofView.frame.size.height + posY, 
                                  myView.frame.size.width,
                                  myView.frame.size.height);
    } else if(posY < 0) {
        posY = abs(posY);
        myView.frame = CGRectMake(ofView.frame.origin.x, 
                                  myView.frame.origin.y - myView.frame.size.height - posY, 
                                  myView.frame.size.width,
                                  myView.frame.size.height);
    }
}

+ (UILabel*)getTitleLabel:(NSString*)title {
    UILabel *reaultLabel = [[UILabel alloc]init];
    reaultLabel.font = [UIFont fontWithName:@"Helvetica" size: 20.0];
    reaultLabel.shadowOffset = CGSizeMake(0, -1);
    reaultLabel.shadowColor = [UIColor colorWithRed:0 /255.0 green:0 /255.0 blue:0 /255.0 alpha:0.5];
    [reaultLabel setBackgroundColor:[UIColor clearColor]];
    [reaultLabel setTextColor:[UIColor whiteColor]];
    [reaultLabel setText:title];
    [reaultLabel sizeToFit];
    
    return reaultLabel;
}

+ (NSString *)addComma:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *num = [NSNumber numberWithLongLong:[str longLongValue]];   
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];   
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];   
    [numberFormatter setGroupingSeparator:@","];   
    NSString *commaString = [numberFormatter stringForObjectValue:num];   
	
    return commaString;
}

+ (BOOL)checkNationalNumber:(NSString*)aString {
	NSString *str = [NSString whitespaceAndNewline:aString];
	NSString *prefix = @"";

	if (YES == [TUtil isEmpty:str])
        return NO;
	
	if(5 < str.length) {
		prefix = [str substringWithRange:NSMakeRange(0, 3)];
		if(NO == [prefix isEqualToString:@"003"]
		   && NO == [prefix isEqualToString:@"007"] 
		   && NO == [prefix isEqualToString:@"009"]) {
		}
		else
			return YES;
	}
	if(3 < str.length) {
		prefix = [str substringWithRange:NSMakeRange(0, 3)];
		if(NO == [prefix isEqualToString:@"001"] 
		   && NO == [prefix isEqualToString:@"002"] 
		   && NO == [prefix isEqualToString:@"004"]
		   && NO == [prefix isEqualToString:@"005"] 
		   && NO == [prefix isEqualToString:@"006"] 
		   && NO == [prefix isEqualToString:@"008"])
			return NO;
		else
			return YES;
	}
	return NO;
}

+ (BOOL)checkMobileNumber:(NSString*)string {
    NSString *str = [NSString whitespaceAndNewline:string];
    if (YES == [TUtil isEmpty:str])
        return NO;
    
	if(3 < str.length) {
		NSString *prefix = [str substringWithRange:NSMakeRange(0, 2)];
		if (NO == [prefix isEqualToString:@"01"]) {
			return NO;
		}
	}
	else
		return NO;
    
    return YES;
}

+ (BOOL)checkCommonServiceNumber:(NSString*)aStr {
	NSString *str = [NSString whitespaceAndNewline:aStr];

	if (YES == [TUtil isEmpty:str])
        return NO;
	
	if(3 < str.length) {
		NSString *prefix = [str substringWithRange:NSMakeRange(0,2)];
		if(NO == [prefix isEqualToString:@"03"] 
		   && NO == [prefix isEqualToString:@"04"] 
		   && NO == [prefix isEqualToString:@"05"] 
		   && NO == [prefix isEqualToString:@"06"] 
		   && NO == [prefix isEqualToString:@"07"] 
		   && NO == [prefix isEqualToString:@"08"] 
		   && NO == [prefix isEqualToString:@"09"])
			return NO;
		else	{
			prefix = [str substringWithRange:NSMakeRange(2,1)];
			if(NO == [prefix isEqualToString:@"0"])	{
			}
			else
				return YES;
		}
	}
	return NO;

}

+ (BOOL)checkHomeNumber:(NSString*)aStr {
	NSString *str = [NSString whitespaceAndNewline:aStr];

	if (YES == [TUtil isEmpty:str])
        return NO;

	if(3 < str.length) {
		NSString *prefix = [str substringWithRange:NSMakeRange(0, 2)];
		if(NO == [prefix isEqualToString:@"03"] 
		   && NO == [prefix isEqualToString:@"04"] 
		   && NO == [prefix isEqualToString:@"05"] 
		   && NO == [prefix isEqualToString:@"06"])
			return NO;
		else {
			prefix = [str substringWithRange:NSMakeRange(2, 1)];
			if(NO == [prefix isEqualToString:@"0"])
				return  YES;
			return NO;
		}
	}

	if(2 < str.length) {
		NSString *prefix = [str substringWithRange:NSMakeRange(0, 2)];
		if(NO == [prefix isEqualToString:@"02"]) {
		} else {
			prefix = [str substringWithRange:NSMakeRange(2, 1)];
			if(NO == [prefix isEqualToString:@"0"])
				return  YES;
			return NO;
		}
	}

	return NO;
}

+ (BOOL)checkRepresentativeNumber:(NSString*)aStr {
	NSString *str = [NSString whitespaceAndNewline:aStr];
	
	if (YES == [TUtil isEmpty:str])
        return NO;
	if(4 < str.length) {
		NSString *prefix = [str substringWithRange:NSMakeRange(0, 2)];
		if(NO == [prefix isEqualToString:@"13"]
		   && NO == [prefix isEqualToString:@"14"]
		   && NO == [prefix isEqualToString:@"15"]
		   && NO == [prefix isEqualToString:@"16"]
		   && NO == [prefix isEqualToString:@"17"]
		   && NO == [prefix isEqualToString:@"18"]
		   && NO == [prefix isEqualToString:@"19"]) {
		}
		else
			return YES;
	}
	return NO;
}

+ (BOOL)checkSpecialNumber:(NSString*)aStr {
	NSString *str = [NSString whitespaceAndNewline:aStr];

	if (YES == [TUtil isEmpty:str])
        return NO;
	if(3 == str.length || 4 == str.length) {
		NSString *prefix = [str substringWithRange:NSMakeRange(0, 1)];
		if(NO == [prefix isEqualToString:@"1"])	{
		}
		else
			return YES;
	}
	return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)documentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)documentPath:(NSString*)fname {
    return [[TUtil documentDir] stringByAppendingPathComponent:fname];
}

+ (NSString *)applicationDirectory {
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dir = [appSupportDir stringByAppendingPathComponent:bundleID];
    
    if(NO == [TUtil checkFile:dir])
        [TUtil createDir:dir];
    
	return dir;
}

+ (NSString*)thumbDirectory {
    NSString *appDir = [TUtil applicationDirectory];
    NSString *dir = [appDir stringByAppendingPathComponent:@"thumb"];
    
    if(NO == [TUtil checkFile:dir])
        [TUtil createDir:dir];
    
    return dir;
}

+ (NSString *)databaseDirectory {
    NSString *appDir = [TUtil applicationDirectory];
    NSString *dir = [appDir stringByAppendingPathComponent:@"db"];
    
    if(NO == [TUtil checkFile:dir])
        [TUtil createDir:dir];
    
    return dir;
}

+ (NSInteger)daysBetweenDate:(NSDate*)date1 date:(NSDate*)date2 {
    NSDateComponents *components;
    NSInteger days;
    
    components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit 
                                                 fromDate: date1 toDate: date2 options: 0];
    days = [components day];
    return days;
}

+ (UIViewController *)pageByClassName:(UINavigationController*)naviController
                            classname:(NSString*)cls {
    UIViewController *result = nil;
    
    NSInteger index = -1;
    NSArray * array = [[NSArray alloc]initWithArray:naviController.viewControllers];
    if(nil != array) {
        for(int i=0 ; i<[array count] ; i++) {
            if(YES == [[array objectAtIndex:i]isKindOfClass:NSClassFromString(cls)])
                index = i;
        }
        
        if(-1 == index) {
        } else {
            result = (UIViewController *)[array objectAtIndex:index];
        }
    }
    
    return result;
}

+ (void)addMessage:(id)abserver selector:(SEL)aSel message:(NSString *)aMsg {
	[[NSNotificationCenter defaultCenter] addObserver:abserver selector:aSel name:aMsg object:nil];
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", param1, @"param1", nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", param1, @"param1", param2, @"param2", nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 param3:(id)param3 {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID",
                                param1, @"param1",
                                param2, @"param2",
                                param3, @"param3",
                                nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    }
}

+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    }
}

+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", param1, @"param1", nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    }
}

+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", param1, @"param1", param2, @"param2", nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    }
}

+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 param3:(id)param3 {
    NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID",
                                param1, @"param1",
                                param2, @"param2",
                                param3, @"param3",
                                nil];
    if(dictionary) {
        NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    }
}

+ (void)removeMessage:(id)abserver message:(NSString *)aMsg {
	[[NSNotificationCenter defaultCenter] removeObserver:abserver name:aMsg object:nil];
}

+ (NSString *)unescapedString:(NSString*)aStr {
    NSMutableString *string = [NSMutableString stringWithString:aStr];

    [string replaceOccurrencesOfString: @"\0" withString: @"\\0" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\a" withString: @"\\a" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\b" withString: @"\\b" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\t" withString: @"\\t" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\n" withString: @"\\n" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\f" withString: @"\\f" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\r" withString: @"\\r" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\e" withString: @"\\e" options: NSLiteralSearch range: NSMakeRange(0, [string length])];

    return [NSString stringWithString:string];
}

+ (NSString *)escapedString:(NSString*)aStr {
    NSMutableString *string = [NSMutableString stringWithString:aStr];
    
    [string replaceOccurrencesOfString: @"\\0" withString: @"\0" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\a" withString: @"\a" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\b" withString: @"\b" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\t" withString: @"\t" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\n" withString: @"\n" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\f" withString: @"\f" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\r" withString: @"\r" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString: @"\\e" withString: @"\e" options: NSLiteralSearch range: NSMakeRange(0, [string length])];
    
    return [NSString stringWithString:string];
}

+ (BOOL)isViewLoaded:(UINavigationController*)nvc classname:(NSString *)name {
    BOOL result = NO;
    
    UIViewController *page = [TUtil pageByClassName:nvc classname:name];
    if(page)
        result = [page isViewLoaded];
    
    return result;
}

+ (BOOL)isVisibled:(UINavigationController*)nvc classname:(NSString*)name1 {
    BOOL result = NO;
    
    NSString *name2 = @"";
    
    UIViewController *controller = nvc.visibleViewController;
    if(controller)
        name2 = NSStringFromClass(controller.class);
    
    if([TUtil hasText:name2]) {
        if([TUtil isEqualText:name1 str:name2]) {
            return YES;
        }
    }
    
    return result;
}

+ (BOOL)isValidIP:(NSString*)address {
    struct in_addr pin;
    int success = inet_aton([address UTF8String],&pin);
    if (success == 1)
        return YES;
    
    return NO;
}

+ (NSArray *)ipAddresses {
    NSMutableArray *addresses = [NSMutableArray array];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *currentAddress = NULL;
    
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        currentAddress = interfaces;
        while(currentAddress != NULL) {
            if(currentAddress->ifa_addr->sa_family == AF_INET) {
                NSString *address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)currentAddress->ifa_addr)->sin_addr)];
                if (![address isEqual:@"127.0.0.1"]) {
                    NSLog(@"%@ ip: %@", [NSString stringWithUTF8String:currentAddress->ifa_name], address);
                    [addresses addObject:address];
                }
            }
            currentAddress = currentAddress->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return addresses;
}

+ (NSArray *)ethernetAddresses {
    NSMutableArray *addresses = [NSMutableArray array];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *currentAddress = NULL;
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        currentAddress = interfaces;
        while(currentAddress != NULL) {
            if(currentAddress->ifa_addr->sa_family == AF_LINK) {
                NSString *address = [NSString stringWithUTF8String:ether_ntoa((const struct ether_addr *)LLADDR((struct sockaddr_dl *)currentAddress->ifa_addr))];
                
                // ether_ntoa doesn't format the ethernet address with padding.
                char paddedAddress[80];
                int a,b,c,d,e,f;
                sscanf([address UTF8String], "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
                sprintf(paddedAddress, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
                address = [NSString stringWithUTF8String:paddedAddress];
                
                if (![address isEqual:@"00:00:00:00:00:00"] && ![address isEqual:@"00:00:00:00:00:FF"]) {
                    NSLog(@"%@ mac: %@", [NSString stringWithUTF8String:currentAddress->ifa_name], address);
                    [addresses addObject:address];
                }
            }
            currentAddress = currentAddress->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return addresses;
}

+ (NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL; struct ifaddrs *temp_addr = NULL;
	int success = 0; // retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)  {
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)  {
			if(temp_addr->ifa_addr->sa_family == AF_INET)  {
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])  {
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	// Free memory
	freeifaddrs(interfaces);
	return address;
}

+ (NSString *)get3gIPAddress {
	BOOL			success;
	struct ifaddrs * addrs	= NULL;
	const struct	ifaddrs * cursor;
	NSString		*address	= @"";
	
	success = (getifaddrs(&addrs) == 0);
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
            // this second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"pdp_ip0"]) { // found the WiFi adapter
					address	= [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
					break;
				}
			}
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return address;
	
}

+ (NSString *)getWiFiIPAddress {
	BOOL			success;
	struct ifaddrs * addrs	= NULL;
	const struct	ifaddrs * cursor;
	NSString		*address	= @"";
	
	success = (getifaddrs(&addrs) == 0);
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
            // this second test keeps from picking up the loopback address            
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"]) { // found the WiFi adapter
					address	= [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
					break;
				}
			}
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return address;
	
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxResolution:(int)resolution {
    //    int kMaxResolution = 1280; //PUT YOUR DESIRED RESOLUTION HERE
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);  
    CGFloat height = CGImageGetHeight(imgRef);  
    CGAffineTransform transform = CGAffineTransformIdentity;  
    CGRect bounds = CGRectMake(0, 0, width, height);  
    
    if (width > resolution || height > resolution) {
        CGFloat ratio = width/height;  
        if (ratio > 1) {
            bounds.size.width = resolution;  
            bounds.size.height = bounds.size.width / ratio;  
        } else {
            bounds.size.height = resolution;  
            bounds.size.width = bounds.size.height * ratio;  
        }  
    }  
    
    CGFloat scaleRatio = bounds.size.width / width;  
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
    CGFloat boundHeight;  
    UIImageOrientation orient = image.imageOrientation; 
    switch(orient) {  
            
        case UIImageOrientationUp: //EXIF = 1  
            transform = CGAffineTransformIdentity;  
            break;  
            
        case UIImageOrientationUpMirrored: //EXIF = 2  
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            break;  
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
            transform = CGAffineTransformRotate(transform, M_PI);  
            break;  
            
        case UIImageOrientationDownMirrored: //EXIF = 4  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);  
            transform = CGAffineTransformScale(transform, 1.0, -1.0);  
            break;  
            
        case UIImageOrientationLeftMirrored: //EXIF = 5  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationLeft: //EXIF = 6  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRightMirrored: //EXIF = 7  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeScale(-1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRight: //EXIF = 8  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        default:  
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
            
    }  
    
    UIGraphicsBeginImageContext(bounds.size);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
        CGContextTranslateCTM(context, -height, 0);  
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
        CGContextTranslateCTM(context, 0, -height);  
    }  
    
    CGContextConcatCTM(context, transform);  
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    return imageCopy;  
}

+ (void)performSelectorOnce:(id)aObject selector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:aObject selector:aSelector object:anArgument];
    [aObject performSelector:aSelector withObject:anArgument afterDelay:delay];
}

+ (UIImage*)resizableImage:(UIImage*)inImage insets:(UIEdgeInsets)edgeInsets {
    UIImage *resultImage = nil;

    // iOS 5
    if([inImage respondsToSelector:@selector(resizableImageWithCapInsets:)])
        resultImage = [inImage resizableImageWithCapInsets:edgeInsets];
    else
        resultImage = [inImage stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top];
    
    return resultImage;
}

#if TARGET_OS_IPHONE
+ (BOOL)isMultitaskingSupported {
	BOOL multiTaskingSupported = NO;
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
		multiTaskingSupported = [(id)[UIDevice currentDevice] isMultitaskingSupported];
	}
	return multiTaskingSupported;
}
#endif

+ (id)readPlist:(NSString *)fileName {
    NSData *plistData;
    NSString *error;
    NSPropertyListFormat format;
    id plist;
    
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    plistData = [NSData dataWithContentsOfFile:localizedPath];
    
    plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if (!plist) {
        NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
    }
    
    return plist;
}

/*
 Platforms
 iPhone1,1 -> iPhone 1G
 iPhone1,2 -> iPhone 3G
 iPod1,1   -> iPod touch 1G
 iPod2,1   -> iPod touch 2G
 */
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 WiFi";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 GSM";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 CDMA";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 CDMAS";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini Wifi";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 Wifi";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return @"Unknown";
}

+ (float)iosVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)applicationVersion {
	return (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)phoneNumber {
	NSString *phoneNumber = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
	return phoneNumber;
}

+ (NSDictionary *)globalPreferences {
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/.GlobalPreferences.plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	//CFShow(dict);
	return dict;
}

+ (NSURL *)applicationDocumentsDirectory {
    return ([[NSFileManager defaultManager] respondsToSelector:@selector(URLsForDirectory:inDomains:)] ?
            [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] :
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
}

+ (BOOL)multitaskingSupport {
    BOOL backgroundSupported = NO;
    if( [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] )
        backgroundSupported = [UIDevice currentDevice].multitaskingSupported;
    return backgroundSupported;
}

+ (double)availableMemory {
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if( kernReturn != KERN_SUCCESS )
		return LONG_MAX;
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

+ (void)enableDebugToFile:(NSString *)filename {
	// Create OS specific path
	const char *path = [[[[TUtil applicationDocumentsDirectory] absoluteString] stringByAppendingPathComponent:filename] UTF8String];
	// Specify stderr writes to a file (truncating contents first)
	freopen(path, "w", stderr);
	
	NSLog(@"Enabled debug to path: %@", [NSString stringWithUTF8String:path]);;
}

// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
//
// Because the definition of the kinfo_proc structure (in <sys/sysctl.h>) is
// conditionalized by __APPLE_API_UNSTABLE, you should restrict use of the
// code below to the debug build of your program.
+ (BOOL)debuggerAttached {
	int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
	
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
	
    info.kp_proc.p_flag = 0;
	
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
	
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
	
    // Call sysctl.
	
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
	
    // We're being debugged if the P_TRACED flag is set.
	
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

+ (void)telWithString:(NSString *)phoneNumber {
	NSLog(@"about to call %@", phoneNumber);
	NSString *url = [[@"tel://" stringByAppendingString:phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)smsWithString:(NSString *)phoneNumber {
	NSString *url = [[@"sms://" stringByAppendingString:phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (UIView *)retrieveKeyboardView {
    for( UIWindow *keyboardWindow in [[UIApplication sharedApplication] windows] ) {
        // Now iterating over each subview of the available windows
        for( UIView *keyboard in [keyboardWindow subviews] ) {
            // Check to see if the description of the view we have referenced is UIKeyboard.
            // If so then we found the keyboard view that we were looking for.
            if( [[keyboard description] hasPrefix:@"<UIKeyboard"] )
				return keyboard;
		}
	}
	
	return nil;
}

#pragma mark -
#pragma mark Graphics Utility
+ (CGSize)statusBarSize {
	return [[UIApplication sharedApplication] statusBarFrame].size;
}

+ (CGSize)screenSize {
	return [UIScreen mainScreen].bounds.size;
}

+ (CGSize)screenPercentage:(CGFloat)p {
	CGSize ss = [TUtil screenSize];
	ss.width = nearbyint(ss.width * p);
	ss.height = nearbyint(ss.height * p);
	return ss;
}

+ (CGFloat)fontPixelToPoint:(int)pixelSize {
    return pixelSize / 2.2639;
}

// angles in drawing are in radians, where pi radians = 180 degrees
#define DEGREES_TO_RADIANS(x) ( M_PI * (x) / 180.0 )

static BOOL optRoundedInit = NO;
static CGSize roundSize;
static CGFloat roundRadius, roundMinX, roundMinY, roundMaxX, roundMaxY;
static CGFloat angle0, angle90, angle180, angle270, angle360;
static CGRect roundDrawingRect, roundInteriorRect;
static CGMutablePathRef roundClippingPath;

+ (UIImage *)roundCornersOfImageOptimized:(UIImage *)image {
	// Single time optimization, bool comparison is the fastest thing a CPU can do,
	// no worries about perf here
	if( !optRoundedInit ) {
		roundSize = CGSizeMake(90.f, 90.f);
		roundRadius = MIN(12.f, .5f * MIN(roundSize.width, roundSize.height) );
		
		// it's not that the "interior rect" makes any sense by itself; it's just used
		// to determine the coordinates of the straight parts of the rounded rect
		//
		roundDrawingRect = CGRectMake( 0.0f, 0.0f, roundSize.width, roundSize.height );
		roundInteriorRect = CGRectInset( roundDrawingRect, roundRadius, roundRadius );
		
		roundMinX = CGRectGetMinX( roundInteriorRect );
		roundMinY = CGRectGetMinY( roundInteriorRect );
		roundMaxX = CGRectGetMaxX( roundInteriorRect );
		roundMaxY = CGRectGetMaxY( roundInteriorRect );
		
		angle0   = DEGREES_TO_RADIANS( 0.0 );
		angle90  = DEGREES_TO_RADIANS( 90.0 );
		angle180 = DEGREES_TO_RADIANS( 180.0 );
		angle270 = DEGREES_TO_RADIANS( 270.0 );
		angle360 = DEGREES_TO_RADIANS( 360.0 );
		
		// we're not using a transformation of the coordinate system
		const CGAffineTransform * noTransform = NULL;
		
		// drawing will be counterclockwise
		const bool counterclockwise = NO;  //NO means counterclockwise; YES means clockwise
		
		// if the button size and rounded-corner radius are going to be constant,
		// this block (and its setup) could conceivably be moved to -viewDidLoad,
		// with clippingPath being an instance variable.
		//
		roundClippingPath = CGPathCreateMutable();
		CGPathAddArc( roundClippingPath, noTransform, roundMaxX, roundMaxY, roundRadius, angle0,   angle90,  counterclockwise );
		CGPathAddArc( roundClippingPath, noTransform, roundMinX, roundMaxY, roundRadius, angle90,  angle180, counterclockwise );
		CGPathAddArc( roundClippingPath, noTransform, roundMinX, roundMinY, roundRadius, angle180, angle270, counterclockwise );
		CGPathAddArc( roundClippingPath, noTransform, roundMaxX, roundMinY, roundRadius, angle270, angle360, counterclockwise );
		
		// Warning! clippingPath is never dealloced!
		
		optRoundedInit = YES;
		
	}
	
	// all actual drawing takes place in a drawing context.
    // Since have haven't gone through -drawRect: at this stage, we have to create a context ourselves.
    UIGraphicsBeginImageContext( roundSize );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // all the setup is done; now define the clipping path
    CGContextBeginPath( context );
    CGContextAddPath( context, roundClippingPath );
    CGContextClosePath( context );
    CGContextClip( context );
    
    // ...and draw our image, clipping the corners
    [image drawInRect: roundDrawingRect];
    
    // get the result as an autoreleased image
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // we're done with our image context
    UIGraphicsEndImageContext();
    
    // and return the autoreleased image to the caller
    return resultImage;
    
}

+ (UIImage *)roundCornersOfImage:(UIImage *)image radius:(CGFloat)radius size:(CGSize)size {
    // account for a passed-in radius that is too large to work with the size
    radius = MIN(radius, .5 * MIN(size.width, size.height) );
    
    // it's not that the "interior rect" makes any sense by itself; it's just used
    // to determine the coordinates of the straight parts of the rounded rect
    //
    CGRect drawingRect = CGRectMake( 0.0f, 0.0f, size.width, size.height );
    CGRect interiorRect = CGRectInset( drawingRect, radius, radius );
    
    CGFloat minX = CGRectGetMinX( interiorRect );
    CGFloat minY = CGRectGetMinY( interiorRect );
    CGFloat maxX = CGRectGetMaxX( interiorRect );
    CGFloat maxY = CGRectGetMaxY( interiorRect );
    
    CGFloat angle0   = DEGREES_TO_RADIANS( 0.0 );
    CGFloat angle90  = DEGREES_TO_RADIANS( 90.0 );
    CGFloat angle180 = DEGREES_TO_RADIANS( 180.0 );
    CGFloat angle270 = DEGREES_TO_RADIANS( 270.0 );
    CGFloat angle360 = DEGREES_TO_RADIANS( 360.0 );
    
    // we're not using a transformation of the coordinate system
    const CGAffineTransform * noTransform = NULL;
    
    // drawing will be counterclockwise
    const bool counterclockwise = NO;  //NO means counterclockwise; YES means clockwise
    
    // if the button size and rounded-corner radius are going to be constant,
    // this block (and its setup) could conceivably be moved to -viewDidLoad,
    // with clippingPath being an instance variable.
    //
    CGMutablePathRef clippingPath = CGPathCreateMutable();
    CGPathAddArc( clippingPath, noTransform, maxX, maxY, radius, angle0,   angle90,  counterclockwise );
    CGPathAddArc( clippingPath, noTransform, minX, maxY, radius, angle90,  angle180, counterclockwise );
    CGPathAddArc( clippingPath, noTransform, minX, minY, radius, angle180, angle270, counterclockwise );
    CGPathAddArc( clippingPath, noTransform, maxX, minY, radius, angle270, angle360, counterclockwise );
    
    // all actual drawing takes place in a drawing context.
    // Since have haven't gone through -drawRect: at this stage, we have to create a context ourselves.
    UIGraphicsBeginImageContext( size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // all the setup is done; now define the clipping path
    CGContextBeginPath( context );
    CGContextAddPath( context, clippingPath );
    CGContextClosePath( context );
    CGContextClip( context );
    
    // ...and draw our image, clipping the corners
    [image drawInRect: drawingRect];
    
    // get the result as an autoreleased image
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // release the memory for our clipping path (but move to -dealloc if clippingPath
    // is changed to be an instance variable and its definition is moved to -viewDidLoad)
    CFRelease( clippingPath );
    
    // we're done with our image context
    UIGraphicsEndImageContext();
    
    // and return the autoreleased image to the caller
    return resultImage;
}

+ (UIImage *)resizeImagePercentage:(UIImage *)image percentage:(int)percentage {
	CGSize s = [image size];
	float p = (float)percentage / 100.f;
	s.width *= p;
	s.height *= p;
	
	return [TUtil resizeImage:image size:s mode:UIViewContentModeScaleToFill];
	
}

+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size mode:(UIViewContentMode)contentMode {
	if( contentMode == UIViewContentModeScaleToFill ) {
		// Do nothing
	} else if( contentMode == UIViewContentModeScaleAspectFit ) {
		CGFloat relationWidth = size.width / [image size].width;
		CGFloat relationHeight = size.height / [image size].height;
		CGFloat relation = ( relationWidth < relationHeight ) ? relationWidth : relationHeight;
		size = CGSizeMake([image size].width * relation, [image size].height * relation);
	} else {
		NSLog(@"resizeImage: UIViewContentMode not supported.");
	}
	
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = [UIImage imageWithCGImage:[UIGraphicsGetImageFromCurrentImageContext() CGImage]];	// Hope this is not the slowest thing in the world... :)
	//UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext(); // Autoreleased
	UIGraphicsEndImageContext();
	
	return scaledImage;
	
}

+ (UIImage *)imageToGrayScale:(UIImage *)image {
    uint8_t kBlue = 1, kGreen = 2, kRed = 3;
	
	CGSize size = image.size;
    int width = size.width;
    int height = size.height;
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	
    for( int y = 0; y < height; y++ ) {
        for( int x = 0; x < width; x++ ) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[kRed] + 0.59 * rgbaPixel[kGreen] + 0.11 * rgbaPixel[kBlue];
			
            // set the pixels to gray
            rgbaPixel[kRed] = gray;
            rgbaPixel[kGreen] = gray;
            rgbaPixel[kBlue] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
	
    // we're done with image now too
    CGImageRelease(imageRef);
	
    return resultUIImage;
	
}

+ (void)beginCurveAnimation:(float)duration {
	[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:duration];
}

+ (void)commitCurveAnimation {
	[UIView commitAnimations];
}

+ (NSString *)stringFromRect:(CGRect)r {
    return [NSString stringWithFormat:@"%f, %f, %f, %f", r.origin.x, r.origin.y, r.size.width, r.size.height];
}

+ (BOOL)isRetina {
    return [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && ([[UIScreen mainScreen] scale] > 1.f);
}

+ (UIImage *)rotateImageByDegrees:(UIImage *)image degrees:(CGFloat)degrees {
    // Create the bitmap context
    CGSize size = CGSizeMake(image.size.width *image.scale, image.size.height *image.scale);
    UIGraphicsBeginImageContext(size);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, size.width/2, size.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, [TUtil degreesToRadians:degrees]);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (double)degreesToRadians:(double)degrees {
    return degrees * M_PI / 180.0;
}

+ (double)radiansToDegrees:(double)radians {
    return radians * 180.0 / M_PI;
}

+ (UIImage *)rotateImageByRadians:(UIImage *)image radians:(CGFloat)radians {
    return [TUtil rotateImageByDegrees:image degrees:[TUtil radiansToDegrees:radians]];
}

#pragma mark
#pragma mark Orientation Utility

+ (BOOL)currentOrientationIsPortrait {
    if (UIDeviceOrientationIsValidInterfaceOrientation([[UIDevice currentDevice] orientation]))
        return UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
    else
        return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

+ (BOOL)currentOrientationIsLandscape {
    return ![TUtil currentOrientationIsPortrait];
}

+ (UIInterfaceOrientation)interfaceOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    UIInterfaceOrientation interfaceOrientation = 0;
    switch( deviceOrientation ) {
        case UIDeviceOrientationPortrait:           interfaceOrientation = UIInterfaceOrientationPortrait; break;
        case UIDeviceOrientationPortraitUpsideDown: interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown; break;
        case UIDeviceOrientationLandscapeLeft:      interfaceOrientation = UIInterfaceOrientationLandscapeRight; break;
        case UIDeviceOrientationLandscapeRight:     interfaceOrientation = UIInterfaceOrientationLandscapeLeft; break;
        default:
            interfaceOrientation = 0;
    }
    
    return interfaceOrientation;
}

+ (NSString *)interfaceOrientationToString:(UIInterfaceOrientation)interfaceOrientation {
    switch( interfaceOrientation ) {
        case UIInterfaceOrientationPortrait:            return @"UIInterfaceOrientationPortrait";
        case UIInterfaceOrientationPortraitUpsideDown:  return @"UIInterfaceOrientationPortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft:       return @"UIInterfaceOrientationLandscapeLeft";
        case UIInterfaceOrientationLandscapeRight:      return @"UIInterfaceOrientationLandscapeRight";
    }
}

#pragma mark -
#pragma mark UIView Utility

+ (CGPoint)centerPointForView:(UIView *)view
{
    UIView *tmpView = [[UIView alloc] initWithFrame:view.bounds];
    return tmpView.center;
}

#pragma mark -
#pragma mark String and Data Utility

+ (BOOL)stringHasUnicodeCharacters:(NSString *)string
{
    BOOL containsUnicode = NO;
    for( int i = 0; i < [string length] && !containsUnicode; i++ ) {
        unichar c = [string characterAtIndex:i];
        containsUnicode = (c > 0xff);
    }
    
    return containsUnicode;
}

+ (NSString *)valueInJsonForKey:(NSString *)json key:(NSString *)key {
    NSRange keyRange = [json rangeOfString:[NSString stringWithFormat:@"\"%@\"", key]];
    if (keyRange.location != NSNotFound) {
        NSInteger start = keyRange.location + keyRange.length;
        NSRange valueStart = [json rangeOfString:@":" options:0 range:NSMakeRange(start, [json length] - start)];
        if (valueStart.location != NSNotFound) {
            start = valueStart.location + 1;
            NSRange valueEnd = [json rangeOfString:@"," options:0 range:NSMakeRange(start, [json length] - start)];
            if (valueEnd.location != NSNotFound) {
                NSString *value = [json substringWithRange:NSMakeRange(start, valueEnd.location - start)];
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                while ([value hasPrefix:@"\""] && ![value hasSuffix:@"\""]) {
                    if (valueEnd.location == NSNotFound) {
                        break;
                    }
                    NSInteger newStart = valueEnd.location + 1;
                    valueEnd = [json rangeOfString:@"," options:0 range:NSMakeRange(newStart, [json length] - newStart)];
                    value = [json substringWithRange:NSMakeRange(start, valueEnd.location - start)];
                    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
                
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
                value = [value stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
                value = [value stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                value = [value stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
                value = [value stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                value = [value stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
                value = [value stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
                value = [value stringByReplacingOccurrencesOfString:@"\\f" withString:@"\f"];
                value = [value stringByReplacingOccurrencesOfString:@"\\b" withString:@"\f"];
                
                while (YES) {
                    NSRange unicode = [value rangeOfString:@"\\u"];
                    if (unicode.location == NSNotFound)
                    {
                        break;
                    }
                    
                    uint32_t c = 0;
                    NSString *hex = [value substringWithRange:NSMakeRange(unicode.location + 2, 4)];
                    NSScanner *scanner = [NSScanner scannerWithString:hex];
                    [scanner scanHexInt:&c];
                    
                    if (c <= 0xffff) {
                        value = [value stringByReplacingCharactersInRange:NSMakeRange(unicode.location, 6) withString:[NSString stringWithFormat:@"%C", (unichar)c]];
                    } else {
                        //convert character to surrogate pair
                        uint16_t x = (uint16_t)c;
                        uint16_t u = (c >> 16) & ((1 << 5) - 1);
                        uint16_t w = (uint16_t)u - 1;
                        unichar high = 0xd800 | (w << 6) | x >> 10;
                        unichar low = (uint16_t)(0xdc00 | (x & ((1 << 10) - 1)));
                        
                        value = [value stringByReplacingCharactersInRange:NSMakeRange(unicode.location, 6) withString:[NSString stringWithFormat:@"%C%C", high, low]];
                    }
                }
                return value;
            }
        }
    }
    return nil;
    
}

#pragma mark -
#pragma mark Network Utility

+ (void)openWeb:(NSString *)url {
	// Add URL prefix
	if( [url rangeOfString:@"http://"].location == NSNotFound )
		url = [@"http://" stringByAppendingString:url];
    
	// Percent escapes
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)sendEmail:(NSString *)to subject:(NSString *)subject body:(NSString *)body {
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
							[to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address {
	if( !IPAddress || ![IPAddress length] )
		return NO;
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if( conversionResult == 0 ) {
		NSLog(@"addressFromString: Failed to convert the IP address (%@) string into a sockaddr_in (%@).", IPAddress, address);
		return NO;
	}
	
	return YES;
}

+ (NSString *)ipAddressForHost:(NSString *)theHost {
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = @(inet_ntoa(*list[0]));
	
	return addressString;
}

+ (void)streamCreatePairWithUNIXSocketPair:(CFAllocatorRef)alloc read:(CFReadStreamRef *)readStream write:(CFWriteStreamRef *)writeStream {
    int sockpair[2];
    int success = socketpair(AF_UNIX, SOCK_STREAM, 0, sockpair);
    if (success < 0) {
        [NSException raise:@"HSK_CFUtilitiesErrorDomain" format:@"Unable to create socket pair, errno: %d", errno];
    }
    
    CFStreamCreatePairWithSocket(NULL, sockpair[0], readStream, NULL);
    CFReadStreamSetProperty(*readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFStreamCreatePairWithSocket(NULL, sockpair[1], NULL, writeStream);
    CFWriteStreamSetProperty(*writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
}

+ (CFIndex)writeStreamWriteFully:(CFWriteStreamRef)outputStream buffer:(const uint8_t*)buffer length:(CFIndex)length {
    CFIndex bufferOffset = 0;
    CFIndex bytesWritten;
	
    while( bufferOffset < length ) {
        if (CFWriteStreamCanAcceptBytes(outputStream)) {
            bytesWritten = CFWriteStreamWrite(outputStream, &(buffer[bufferOffset]), length - bufferOffset);
            if (bytesWritten < 0) {
                // Bail!
                return bytesWritten;
            }
            bufferOffset += bytesWritten;
        } else if (CFWriteStreamGetStatus(outputStream) == kCFStreamStatusError) {
            return -1;
        } else {
            // Pump the runloop
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.0, true);
        }
    }
    
    return bufferOffset;
	
}

+ (float)normB:(unsigned char)b {
	return (float)b / 255.0f;
}

/* if IOS Ver >= 5.0F, textField == Nil */
+ (void)showAlertViewWithTextField:(NSString*)title
                           message:(NSString*)message
                          delegate:(id)delegate
                               tag:(int)setTag
                      textFieldTag:(int)textFieldTag
			   textFieldTextString:(NSString*)textFieldTextString
				 textFieldFontSize:(float)fontSize
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSString *)otherButtonTitles,... {
	/* AlerView Create or Initailize */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:@""
													   delegate:delegate
											  cancelButtonTitle:cancelButtonTitle 
											  otherButtonTitles:otherButtonTitles, nil];
	/* Alert Create Success */
	if(alertView){
		alertView.tag = setTag;
		/* IOS Version >= 5.0F*/
		if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
			[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
			if([TUtil hasText:message])
				[alertView setMessage:message];
			[[alertView textFieldAtIndex:0] setFont:[UIFont systemFontOfSize:fontSize]];
			[[alertView textFieldAtIndex:0] setText:textFieldTextString];
			if([TUtil hasText:message]) {
				[alertView setFrame:CGRectMake(0,0, alertView.frame.size.width, alertView.frame.size.height-10)];
			}
		} else { /* IOS Version < 5.0F */
			/* TextField Create or Initialization */
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
			/* TextField Create Success */
			if(textField) {
				/* AlerView , Add TextField or Setting*/
				[textField setFont:[UIFont systemFontOfSize:fontSize]];
				[textField setBackgroundColor:[UIColor whiteColor]];
				textField.tag = textFieldTag;
				textField.text = textFieldTextString;
				[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
				if([TUtil hasText:message]) {
					int lines = 0;
					CGFloat lineHeight = [message sizeWithFont:[UIFont systemFontOfSize:fontSize]].height;
					CGFloat textHeight = [TUtil getTextHeight:message width:260 font:[UIFont systemFontOfSize:fontSize]];
					
					if(textHeight >= lineHeight)
						lines = (int)(textHeight/lineHeight);
					
					for(int i=0; i<lines; i++)
						message = [message stringByAppendingString:@"\n"];
					
					[alertView setMessage:message];
					[textField setFrame:CGRectMake(textField.frame.origin.x,
												   textField.frame.origin.y + lineHeight *lines + 10, 
												   textField.frame.size.width, 
												   textField.frame.size.height)];
				} else {
					[textField setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
					[alertView setMessage:@"\n"];
				}
				
				
				/* AlertView, Add TextField or Setting, TextFiled Release */
				[alertView addSubview:textField];
				[[alertView viewWithTag:textField.tag ] becomeFirstResponder];
				[alertView setTransform:CGAffineTransformMakeTranslation(0.0, 0.0)];
				
			} // if textfield
		} //~ else ios < 5.0
		/* AlerView Display and Memory De-Allocation */
		[alertView show];

	} // ~if alerView
	else
	{
		NSLog(@"TUTIL [ERR] func[showAlertViewWithTextField]; reason[UIAlertView Create Failure]");
	}
}

// 이머지 체크.
+ (BOOL)isEmoji:(NSString*)string {
	BOOL ret = NO ;
	
	if(string == nil || [string length] == 0) {
		return NO ;
	}
	
	for(int i=0;i<[string length];i++) {
		unichar code = [string characterAtIndex:i];
		if(0xE001 <= code && code <= 0xE05A) {
			ret = YES ;
			break ;
		}
		if(0xE101 <= code && code <= 0xE15A) {
			ret = YES ;
			break ;
		}
		if(0xE201 <= code && code <= 0xE253) {
			ret = YES ;
			break ;
		}
		if(0xE301 <= code && code <= 0xE34D) {
			ret = YES ;
			break ;
		}
		if(0xE401 <= code && code <= 0xE44C) {
			ret = YES ;
			break ;
		}
		if(0xE501 <= code && code <= 0xE537) {
			ret = YES ;
			break ;
		}
	}
    
	
	return ret ;
}

+ (NSString *) stringToHex:(NSString *)str {
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ ) {
        // [hexString [NSString stringWithFormat:@"%02x", chars[i]]]; /*previous input*/
        [hexString appendFormat:@"%02x", chars[i]]; /*EDITED PER COMMENT BELOW*/
    }
    free(chars);
    
    return hexString;
}

+ (NSString *)urlEncodeUTF8:(NSString *)str {
	NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																			(CFStringRef)str,
																			NULL,
																			CFSTR(":/?#[]@!$&’()*+,;="),
																			kCFStringEncodingUTF8));
	return result;
}

+ (NSString *)urlDecodeUTF8:(NSString *)str {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)str,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;
}

+ (int)intFromData:(NSData *)data {
    NSString *dataDescription = [data description];
    NSString *dataAsString = [dataDescription substringWithRange:NSMakeRange(1, [dataDescription length]-2)];
    
    unsigned intData = 0;
    NSScanner *scanner = [NSScanner scannerWithString:dataAsString];
    [scanner scanHexInt:&intData];
    
    return intData;
}

+ (BOOL)isAlphabet:(NSString*)str {
    BOOL result = NO;
    
    NSRegularExpression *regex = [[NSRegularExpression alloc]
                                   initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
    NSUInteger matches = [regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, 1)];
    if (matches > 0)
    {
        result = YES;
    }
    
    return result;
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if(rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

+ (UITableViewCell *)parentCellForView:(id)theView {
    id viewSuperView = [theView superview];
    while(viewSuperView) {
        if([viewSuperView isKindOfClass:[UITableViewCell class]])
            return (UITableViewCell *)viewSuperView;
        else
            viewSuperView = [viewSuperView superview];
    }
    
    return nil;
}

+ (NSString*)replaceString:(NSString*)aString target:(NSString*)taget replacement:(NSString*)replacement {
    NSMutableString *s = [aString mutableCopy];
    [s replaceOccurrencesOfString:taget withString:replacement options:0 range:NSMakeRange(0, [s length])];
    return s;
}

@end
