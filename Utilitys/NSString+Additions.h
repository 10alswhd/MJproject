//
//  NSString+Additions.h
//  SnackFMC
//
//  Created by 관수 이 on 13. 11. 7..
//  Copyright (c) 2013년 DREAMKET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (CGSize)sizeWithFont1:(UIFont *)font;
- (CGSize)sizeWithFont1:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFont1:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

//- (NSString *)repr0;
//- (NSString *)repr1;
- (NSString *)chosung;

+ (NSString *)uuid;
+ (NSString *)stringWithFileSize:(UInt64)size;
+ (NSString *)whitespaceAndNewline:(NSString*)str;


// int to string convert
+ (NSString*)intToString:(NSInteger)intValue;
+ (NSString*)floatToString:(float)floatValue;

+ (NSString *)nilToString:(NSString *)str;

+ (BOOL)isValidEmail:(NSString*)email;
+ (BOOL)isValidDomain:(NSString*)domain;
+ (BOOL)isNumeric:(NSString *)str;

@end
