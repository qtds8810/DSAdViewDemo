//
//  NSObject+DSExchangeMethods.h
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/21.
//  Copyright © 2018年 得胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DSExchangeMethods)

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

@end
