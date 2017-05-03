//
//  UIColor+ZKColor.h
//  BM51SEE
//
//  Created by mosaic on 2017/4/27.
//  Copyright © 2017年 com.Linhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZKColor)


+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
