//
//  TUtil.h
//  FamiLog
//
//  Created by 관수 이 on 11. 8. 4..
//  Copyright 2011 mnkc. All rights reserved.
//

#import <Foundation/Foundation.h>

struct sockaddr_in;

@interface TUtil : NSObject 

+ (CGFloat)     getTextHeightWithLine:(NSString*)textStr line:(int)line spacing:(CGFloat)spacing fontsize:(CGFloat)fontsize;
+ (uint)        getTextLine:(NSString*)textStr width:(CGFloat)width fontsize:(CGFloat)fontsize;

+ (float)       getTextWidth:(NSString*)textStr  height:(float)height font:(UIFont*)font;
+ (float)       getTextHeight:(NSString*)textStr width:(float)width font:(UIFont*)font;
+ (float)       getSingleLineTextWidth:(NSString*)textStr font:(UIFont*)font;
+ (float)       getSingleLineTextHeight:(NSString*)textStr font:(UIFont*)font;
+ (CGSize)      getSingleLineTextSize:(NSString*)textStr font:(UIFont*)font;
+ (float)       getLabelTextHeight:(UILabel*)myLabel;

+ (CGRect)      getLabelTextRect:(UILabel*)myLabel;

+ (UIColor*)    rgbFromHex:(NSString *)code;
+ (BOOL)        floatInRange:(CGFloat)value between:(CGFloat)minValue and:(CGFloat)maxValue;
+ (BOOL)        findstr:(NSString*)aString find:(NSString*)aFind;
+ (NSString*)	getValidInteger:(NSString*)aStr;
+ (BOOL)        isEmpty:(NSString*)aStr;
+ (BOOL)        hasText:(NSString*)aStr; 
+ (BOOL)        isEqualText:(NSString*)str1 str:(NSString*)str2;
+ (BOOL)        isEqualTextToIndex:(NSString*)str1 str:(NSString*)str2 to:(UInt16)to;

+ (NSString*)   substr:(NSString*)str index:(NSInteger)idx;
+ (NSString*)   substr:(NSString*)str startIndex:(NSUInteger)sidx endIndex:(NSUInteger)eidx;
+ (NSString*)   trim:(NSString*)str;
+ (NSString*)   substrToIndex:(NSString*)str find:(NSString*)find;
+ (NSString *)  substrFromIndex:(NSString*)str find:(NSString*)find;

+ (NSString*)   dateFormat:(NSString*)dateStr;
+ (NSString*)   dateFormatYYYYMMDD:(NSString*)inStr;
+ (NSString*)   dateFormatYYYYMMDDHHMM:(NSString*)inStr;
+ (NSString*)   moneyFormat:(SInt64)value;

+ (void)        setLabelVerticalAlignment:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText usingVerticalAlign:(int)vertAlign;

+ (BOOL)        checkFile:(NSString *)aFile; 
+ (BOOL)        createDir:(NSString *)aDir; 
+ (BOOL)        copyFile:(NSString *)aOrgFile destfile:(NSString *)aDstFile ;
+ (BOOL)        deleteFile:(NSString *)aFile;
+ (SInt64)      getFileSize:(NSString*)path;

+ (NSString*)   stringForKey:(NSDictionary *)dictionary keyStr:(NSString*)keyStr;
+ (SInt64)      intForKey:(NSDictionary *)dictionary keyStr:(NSString*)keyStr;

// 얼랏팝업 체크
+ (BOOL)        checkAlertExist:(NSInteger)tagIndex;
+ (BOOL)        checkAlertExist;

+ (NSString*)getValidString:(NSString*)aStr charSet:(NSString*)charSet;

// 전화번호 hyphen 추가.
+ (NSString*)   addHyphenToPhoneNumber:(NSString*)aStr;
+ (NSString*)   getValidNumber:(NSString*)phoneNumber;

// 파일저장 위치..
+ (NSString *)  documentDir;
+ (NSString *)  documentPath:(NSString*)fname;

+ (NSString *)  applicationDirectory;
+ (NSString *)  thumbDirectory;
+ (NSString *)  databaseDirectory;
//

+ (UIImage*)    readImageFromStorage:(NSString *)path;
+ (void)        saveImageToStorage:(NSString*)path image:(UIImage*)image;

+ (UIImage *)   scaleAndRotate:(UIImage *)image maxResolution:(int)maxResolution orientation:(UIImageOrientation)orientation;
+ (UIImage*)    imageByCropping:(UIImage *)imageToCrop;

+ (BOOL)        offsetRect:(UIView*)view offset:(CGPoint)offset;
+ (UIImage *)   resizeWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*)    resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;

+ (NSDate *)    addDate:(NSDate *)date value:(NSInteger)day;
+ (NSDate *)    addHour:(NSDate *)date value:(NSInteger)hour;


// UILabel 정렬
+ (void)setVerticalAlign:(UILabel *)label maxFrame:(CGRect)frame text:(NSString *)text align:(int)align;
+ (void)setRightAlign:(UILabel *)label pos:(CGFloat)pos text:(NSString *)text;

// 좌표옵셋
+ (void)setOffset:(UIView *)myView ofView:(UIView*)ofView posX:(SInt16)posX posY:(SInt16)posY;

+ (UILabel*)getTitleLabel:(NSString*)title;
+ (NSString *)addComma:(NSString *)str;

// 휴대전화 번호 체크.
+ (BOOL)checkNationalNumber:(NSString*)aStr;
+ (BOOL)checkMobileNumber:(NSString*)string;
+ (BOOL)checkCommonServiceNumber:(NSString*)aStr;
+ (BOOL)checkHomeNumber:(NSString*)aStr;
+ (BOOL)checkRepresentativeNumber:(NSString*)aStr;
+ (BOOL)checkSpecialNumber:(NSString*)aStr;

+ (NSInteger)daysBetweenDate:(NSDate*)date1 date:(NSDate*)date2;

+ (UIViewController *)pageByClassName:(UINavigationController*)naviController
                            classname:(NSString*)cls;

// 노티피케이션 함수
+ (void)addMessage:(id)abserver selector:(SEL)aSel message:(NSString *)aMsg;
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID;
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID param1:(id)param1;
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2;
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 param3:(id)param3;

+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID;
+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1;
+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2;
+ (void)sendMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 param3:(id)param3;

+ (void)removeMessage:(id)abserver message:(NSString *)aMsg;

+ (BOOL)isViewLoaded:(UINavigationController*)nvc classname:(NSString*)name;
+ (BOOL)isVisibled:(UINavigationController*)nvc classname:(NSString*)name1;

+ (BOOL)isValidIP:(NSString*)address;

+ (NSArray *)ipAddresses;
+ (NSArray *)ethernetAddresses;
+ (NSString *)getIPAddress;

+ (NSString *)get3gIPAddress;
+ (NSString *)getWiFiIPAddress;

//
+ (UIImage*)scaleAndRotateImage:(UIImage *)image maxResolution:(int)resolution;

+ (void)performSelectorOnce:(id)aObject selector:(SEL)selector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;

+ (UIImage*)resizableImage:(UIImage*)inImage insets:(UIEdgeInsets)edgeInsets;

#if TARGET_OS_IPHONE
+ (BOOL)isMultitaskingSupported;
#endif

+ (id)readPlist:(NSString *)fileName;

+ (NSString *)platform;
+ (NSString *)platformString;

//////
+ (float)iosVersion;
+ (NSString *)applicationVersion;
+ (NSString *)phoneNumber;
+ (NSDictionary *)globalPreferences;
+ (NSURL *)applicationDocumentsDirectory;
+ (BOOL)multitaskingSupport;
+ (double)availableMemory;
+ (void)enableDebugToFile:(NSString *)filename;
+ (BOOL)debuggerAttached;
+ (void)telWithString:(NSString *)phoneNumber;
+ (void)smsWithString:(NSString *)phoneNumber;
+ (UIView *)retrieveKeyboardView;
+ (CGSize)statusBarSize;
+ (CGSize)screenSize;
+ (CGSize)screenPercentage:(CGFloat)p;
+ (CGFloat)fontPixelToPoint:(int)pixelSize;
+ (UIImage *)roundCornersOfImageOptimized:(UIImage *)image;
+ (UIImage *)roundCornersOfImage:(UIImage *)image radius:(CGFloat)radius size:(CGSize)size;
+ (UIImage *)resizeImagePercentage:(UIImage *)image percentage:(int)percentage;
+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size mode:(UIViewContentMode)contentMode;
+ (UIImage *)imageToGrayScale:(UIImage *)image;
+ (void)beginCurveAnimation:(float)duration;
+ (void)commitCurveAnimation;
+ (NSString *)stringFromRect:(CGRect)r;
+ (BOOL)isRetina;
+ (UIImage *)rotateImageByDegrees:(UIImage *)image degrees:(CGFloat)degrees;
+ (double)degreesToRadians:(double)degrees;
+ (double)radiansToDegrees:(double)radians;
+ (UIImage *)rotateImageByRadians:(UIImage *)image radians:(CGFloat)radians;
+ (BOOL)currentOrientationIsPortrait;
+ (BOOL)currentOrientationIsLandscape;
+ (UIInterfaceOrientation)interfaceOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
+ (NSString *)interfaceOrientationToString:(UIInterfaceOrientation)interfaceOrientation;
+ (CGPoint)centerPointForView:(UIView *)view;
+ (BOOL)stringHasUnicodeCharacters:(NSString *)string;
+ (NSString *)valueInJsonForKey:(NSString *)json key:(NSString *)key;
+ (void)openWeb:(NSString *)url;
+ (void)sendEmail:(NSString *)to subject:(NSString *)subject body:(NSString *)body;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSString *)ipAddressForHost:(NSString *)theHost;
+ (void)streamCreatePairWithUNIXSocketPair:(CFAllocatorRef)alloc read:(CFReadStreamRef *)readStream write:(CFWriteStreamRef *)writeStream;
+ (CFIndex)writeStreamWriteFully:(CFWriteStreamRef)outputStream buffer:(const uint8_t*)buffer length:(CFIndex)length;
+ (float)normB:(unsigned char)b;

+ (void)showAlertViewWithTextField:(NSString*)title
                           message:(NSString*)message
                          delegate:(id)delegate
                               tag:(int)setTag
                      textFieldTag:(int)textFieldTag
			   textFieldTextString:(NSString*)textFieldTextString
				 textFieldFontSize:(float)fontSize
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSString *)otherButtonTitles,...;

// 이모티콘체크
+ (BOOL)isEmoji:(NSString*)string;
+ (NSString *)stringToHex:(NSString *)str;

+ (NSString *)urlEncodeUTF8:(NSString *)str;
+ (NSString *)urlDecodeUTF8:(NSString *)str;

+ (int)intFromData:(NSData *)data;

+ (BOOL)isAlphabet:(NSString*)str;

+ (UIViewController *)topViewController:(UIViewController *)rootViewController;
+ (UITableViewCell *)parentCellForView:(id)theView;


+ (NSString *)unescapedString:(NSString*)aStr;
+ (NSString *)escapedString:(NSString*)aStr;

+ (NSString *)replaceString:(NSString*)aString target:(NSString*)taget replacement:(NSString*)replacement;


@end
