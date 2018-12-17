//
//  UIButton+DSFontFit.m
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/21.
//  Copyright © 2018年 得胜. All rights reserved.
//

#import "UIButton+DSFontFit.h"
#import "NSObject+DSExchangeMethods.h"

@implementation UIButton (DSFontFit)

+ (void)load {
    [[self class] swizzleInstanceMethod:@selector(initWithCoder:) with:@selector(ds_initWithCoder:)];
}

- (id)ds_initWithCoder:(NSCoder*)aDecode {
    [self ds_initWithCoder:aDecode];
    
    CGFloat pt = self.titleLabel.font.pointSize;
    self.titleLabel.font = [UIFont systemFontOfSize:pt];//这个方法会进行字体转换
    
    return self;
}

@end
