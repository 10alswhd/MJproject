//
//  Defines.h
//  BR_MPOS
//
//  Created by shinhyejung on 2017. 10. 11..
//  Copyright © 2017년 mjyoon@zin.co.kr. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define WIDTH(v)            v.frame.size.width
#define HEIGHT(v)           v.frame.size.height
#define LEFT(v)             v.frame.origin.x
#define TOP(v)              v.frame.origin.y
#define RIGHT(v)            LEFT(v) + WIDTH(v)
#define BOTTOM(v)           TOP(v) + HEIGHT(v)


