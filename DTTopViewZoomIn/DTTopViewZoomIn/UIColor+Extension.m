//
//  UIColor+Extension.m
//  DTTopViewZoomIn
//
//  Copyright © 2016年 dtlr. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (instancetype)dt_colorWithHex:(uint32_t)hex{
    uint8_t red = (hex & 0xFF0000) >> 16;
    uint8_t green = (hex & 0x00FF00) >> 8;
    uint8_t blue = hex & 0x0000FF;
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}
@end
