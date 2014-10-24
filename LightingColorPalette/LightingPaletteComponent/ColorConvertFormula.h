//
//  ColorConvertFormula.h
//  EarlPalette
//
//  Created by Earl Hsieh on 2014/10/20.
//  Copyright (c) 2014年 Earl Hsieh. All rights reserved.
//

#ifndef EarlPalette_ColorConvertFormula_h
#define EarlPalette_ColorConvertFormula_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
} BitmapPixel;

typedef struct {
    CGFloat hue;
    CGFloat saturation;
    CGFloat value;
} BitMapHSV;

@interface ColorConvertFormula : NSObject
{
}

-(BitmapPixel)HSVToRGBByHue:(CGFloat)hue Saturation:(CGFloat)saturation Value:(CGFloat)value;

-(BitmapPixel)makeRGBADataByRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

-(BitmapPixel)convertColorTempToRGB:(int)colorTemp;

-(BitMapHSV)RGBToHSVByRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

@end

#endif
