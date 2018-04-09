//
//  NSString+Additions.m
//  SnackFMC
//
//  Created by 관수 이 on 13. 11. 7..
//  Copyright (c) 2013년 DREAMKET. All rights reserved.
//

#import "NSString+Additions.h"

#import "Defines.h"

@implementation NSString (Additions)

- (CGSize)sizeWithFont1:(UIFont *)font
{
    CGSize result = CGSizeZero;

    if(self.length > 0) {
        if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
            result = CGSizeMake(ceil(size.width), ceil(size.height));
        } else {
            result = [self sizeWithFont:font]; //how to get rid warning here
        }
    }
    
    return result;
}

- (CGSize)sizeWithFont1:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self sizeWithFont1:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeWithFont1:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize result = CGSizeZero;

    if(self.length > 0) {
        if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGSize boundingSize = [self boundingRectWithSize:size
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil].size;
            result = CGSizeMake(ceil(boundingSize.width), ceil(boundingSize.height));
        } else {
            result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];  //how to get rid warning here
        }
    }
    
    return result;
}

+ (NSString *)uuid {
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}

+ (NSString *)stringWithFileSize:(UInt64)size {
    CGFloat fSize = size;
    
    if(size < 1023) {
        if(1 >= size)
            return ([NSString stringWithFormat:@"%1.fbyte", fSize]);
        else
            return ([NSString stringWithFormat:@"%1.fbytes", fSize]);
    }
    
    fSize = fSize /1024;
    if(fSize < 1023)
        return ([NSString stringWithFormat:@"%1.1fKB", fSize]);
    fSize = fSize /1024;
    if(fSize < 1023)
        return ([NSString stringWithFormat:@"%1.1fMB", fSize]);
    fSize = fSize /1024;
    return ([NSString stringWithFormat:@"%1.1fGB", fSize]);
}

+ (NSString*)whitespaceAndNewline:(NSString*)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)chosung {
    NSString *result = @"";
    NSArray  *arr = [NSArray arrayWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@" ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    
    for(int i=0;i<[self length];i++) {
        NSInteger code = [self characterAtIndex:i];
        
        // 한글영역에 대해서만 처리
        if(code >= 44032 && code <= 55203) {
            // 한글 시작영역을 제거
            NSInteger UniCode = code - 44032;
            
            // 초성
            NSInteger choIndex = UniCode/21/28;
            result = [NSString stringWithFormat:@"%@%@", result, [arr objectAtIndex:choIndex]];
        }
    }
    return result;
}

// int to string convert
+ (NSString*)intToString:(NSInteger)intValue {
	return [NSString stringWithFormat:@"%ld", (long)intValue];
}

+ (NSString*)floatToString:(float)floatValue {
    return [NSString stringWithFormat:@"%.2f", floatValue];
}

+ (NSString *)nilToString:(NSString *)str {
    if (!str)
        return @"";
    
    return str;
}

+ (BOOL)isValidEmail:(NSString *)email {
    NSString* pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([predicate evaluateWithObject:email])
        return YES;
    else
        return NO;
}

+ (BOOL)isValidDomain:(NSString*)domain {
    NSString* pattern = @"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([predicate evaluateWithObject:domain])
        return YES;
    else
        return NO;
}

+ (BOOL)isNumeric:(NSString *)str {
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];
    return [numberPredicate evaluateWithObject:str];
}

@end
