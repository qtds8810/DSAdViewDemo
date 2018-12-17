//
//  UIFont+DSFont.m
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/21.
//  Copyright © 2018年 得胜. All rights reserved.
//

#import "UIFont+DSFont.h"
#import "NSObject+DSExchangeMethods.h"

@implementation UIFont (DSFont)

/// UI图上设计的尺寸，可根据具体情况修改
static CGFloat const DS_UIScreen = 375;

+ (void)load {
    [self swizzleClassMethod:@selector((systemFontOfSize:)) with:@selector(ds_systemFontOfSize:)];
    [self swizzleClassMethod:@selector(boldSystemFontOfSize:) with:@selector(ds_boldSystemFontOfSize:)];
}

+ (UIFont *)ds_systemFontOfSize:(CGFloat)pxSize {
    /*
     ps和pt转换
     
     px:相对长度单位。像素（Pixel）。（PS字体）
     pt:绝对长度单位。点（Point）。（iOS字体）
     UI标记图上给我们字体的大小一般都是像素点，如图
     */
    return [UIFont ds_systemFontOfSize:pxSize*[UIScreen mainScreen].bounds.size.width/DS_UIScreen];
}

+ (UIFont*)ds_boldSystemFontOfSize:(CGFloat)pxSize {
    return [UIFont ds_boldSystemFontOfSize:pxSize*[UIScreen mainScreen].bounds.size.width/DS_UIScreen];
}

@end
