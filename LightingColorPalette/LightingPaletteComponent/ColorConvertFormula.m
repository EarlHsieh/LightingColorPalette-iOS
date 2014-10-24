//
//  ColorConvertFormula.m
//  EarlPalette
//
//  Created by Earl Hsieh on 2014/10/20.
//  Copyright (c) 2014年 Earl Hsieh. All rights reserved.
//

#import "ColorConvertFormula.h"

@implementation ColorConvertFormula

/**
 *  NAME
 *      HSVToRGBByHue:(CGFloat)hue Saturation:(CGFloat)saturation Value:(CGFloat)value
 *
 *  DESCRIPTION
 *      Convert HSV data to RGBA data.
 *
 */
-(BitmapPixel)HSVToRGBByHue:(CGFloat)hue Saturation:(CGFloat)saturation Value:(CGFloat)value
{
    if (saturation == 0) {
        return [self makeRGBADataByRed:value Green:value Blue:value Alpha:1.0];
    }

    CGFloat var_hue = hue * 6.0;
    if (var_hue == 6.0) {
        var_hue = 0.0;
    }

    CGFloat var_i = floor(var_hue);
    CGFloat var_1 = value * (1.0 - saturation);
    CGFloat var_2 = value * (1.0 - (saturation * (var_hue - var_i)));
    CGFloat var_3 = value * (1.0 - (saturation * (1.0 - (var_hue - var_i))));
    
    if (var_i == 0) {
        return [self makeRGBADataByRed:value Green:var_3 Blue:var_1 Alpha:1.0];
    } else if (var_i == 1) {
        return [self makeRGBADataByRed:var_2 Green:value Blue:var_1 Alpha:1.0];
    } else if (var_i == 2) {
        return [self makeRGBADataByRed:var_1 Green:value Blue:var_3 Alpha:1.0];
    } else if (var_i == 3) {
        return [self makeRGBADataByRed:var_1 Green:var_2 Blue:value Alpha:1.0];
    } else if (var_i == 4) {
        return [self makeRGBADataByRed:var_3 Green:var_1 Blue:value Alpha:1.0];
    }

    return [self makeRGBADataByRed:value Green:var_1 Blue:var_2 Alpha:1.0];
}

/**
 *  NAME
 *      RGBToHSVByRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue
 *
 *  DESCRIPTION
 *      Convert HSV data to RGBA data.
 *
 */
-(BitMapHSV)RGBToHSVByRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue
{
    CGFloat hue, saturation, value;
    double colorMin, colorMax, delta;
    
    colorMin = MIN(red, MIN(green, blue));
    colorMax = MAX(red, MAX(green, blue));
    
    value = colorMax;
    delta = colorMax - colorMin;

    if (delta == 0.0) {
        saturation = 0.0;
        hue = 0.0;
        return [self makeHSVDataByHue:hue Saturation:saturation Value:value];
    } else {
        saturation = delta / colorMax;
    }

    if (red == colorMax) {
        hue = (green - blue) / delta;
    } else if (green == colorMax) {
        hue = 2.0 + ((blue - red) / delta);
    } else {
        hue = 4.0 + ((red - green) / delta);
    }

    hue *= 60;
    if (hue < 0.0) {
        hue += 360;
    }

    return [self makeHSVDataByHue:hue Saturation:saturation Value:value];
}

/**
 *  NAME
 *      convertColorTempToRGB:(int)colorTemp
 *
 *  DESCRIPTION
 *      Convert color temperatue to RGBA data, color temperature sholud be divide 100
 *      befor call this function.
 *
 */
-(BitmapPixel)convertColorTempToRGB:(int)colorTemp
{
    BitmapPixel colorTempRGBA;
    
    if (colorTemp <= 66) {
        colorTempRGBA.red = 255;
        
        colorTempRGBA.green = (99.4708025861 * log(colorTemp)) - 161.1195681661;
        if (colorTempRGBA.green < 0) {
            colorTempRGBA.green = 0;
        } else if (colorTempRGBA.green > 255) {
            colorTempRGBA.green = 255;
        }
        
        if (colorTemp <= 19) {
            colorTempRGBA.blue = 0;
        } else {
            colorTempRGBA.blue = (138.5177312231 * log((colorTemp - 10))) - 305.0447927307;
            if (colorTempRGBA.blue < 0) {
                colorTempRGBA.blue = 0;
            } else if (colorTempRGBA.blue > 255) {
                colorTempRGBA.blue = 255;
            }
        }
    } else {
        colorTempRGBA.red = 329.698727446 * pow((colorTemp - 60), -0.1332047592);
        if (colorTempRGBA.red < 0) {
            colorTempRGBA.red = 0;
        } else if (colorTempRGBA.red > 255) {
            colorTempRGBA.red = 255;
        }
        
        colorTempRGBA.green = 288.1221695283 * pow((colorTemp - 60), -0.0755148492);
        if (colorTempRGBA.green < 0) {
            colorTempRGBA.green = 0;
        } else if (colorTempRGBA.green > 255) {
            colorTempRGBA.green = 255;
        }
        
        colorTempRGBA.blue = 255;
    }
    
    colorTempRGBA.red /= 255;
    colorTempRGBA.green /= 255;
    colorTempRGBA.blue /= 255;
    return colorTempRGBA;
}

/**
 *  NAME
 *      makeRGBADataByRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)
 *
 *  DESCRIPTION
 *      Packing and return RGBA data.
 *
 */
-(BitmapPixel)makeRGBADataByRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha
{
    BitmapPixel pixel;
    
    pixel.red = red;
    pixel.green = green;
    pixel.blue = blue;
    pixel.alpha = alpha;
    
    return pixel;
}

/**
 *  NAME
 *      makeHSVDataByHue:(CGFloat)hue Saturation:(CGFloat)saturation Value:(CGFloat)value
 *
 *  DESCRIPTION
 *      Packing and return HSV data.
 *
 */
-(BitMapHSV)makeHSVDataByHue:(CGFloat)hue Saturation:(CGFloat)saturation Value:(CGFloat)value
{
    BitMapHSV hsv;

    hsv.hue = hue;
    hsv.saturation = saturation;
    hsv.value = value;

    return hsv;
}

@end
