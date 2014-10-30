//
//  ColorPaletteCreator.h
//  EarlPalette
//
//  Created by Earl Hsieh on 2014/10/16.
//  Copyright (c) 2014年 Earl Hsieh. All rights reserved.
//

#ifndef EarlPalette_ColorPaletteCreator_h
#define EarlPalette_ColorPaletteCreator_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColorConvertFormula.h"

#define COLOR_TEMP_MIN          (2700)
#define COLOR_TEMP_MAX          (6500)
#define COLOR_TEMP_PER_STEP     (10)
#define COLOR_BRIGHTNESS_MAX    (100)

@interface LightingPaletteComponent : NSObject
{
    UIImage *colorWheelImage;
    UIImage *colorTempImage;
    UIImage *colorBrightnessImage;
    UIImage *colorIndicatorImage;
    CGImageRef bitmapImagRef;
    unsigned char *bitmapData;
    CGContextRef bitmapContext;
    ColorConvertFormula *colorConvert;
    BitmapPixel currentColor;
    BitmapPixel colorTempPixel[(COLOR_TEMP_MAX - COLOR_TEMP_MIN) / 100];
    BitmapPixel colorBrightnessPixel[COLOR_BRIGHTNESS_MAX];
}

@property (strong, nonatomic) UIImage *colorWheelImage;

@property (strong, nonatomic) UIImage *colorTempImage;

@property (strong, nonatomic) UIImage *colorBrightnessImage;

@property (strong, nonatomic) UIImage *colorIndicatorImage;

@property (nonatomic) ColorConvertFormula *colorConvert;

@property (nonatomic) BitmapPixel currentColor;

@property (nonatomic) CGImageRef bitmapImagRef;

@property (nonatomic) unsigned char *bitmapData;

@property (nonatomic) CGContextRef bitmapContext;

-(UIImage *)createColorWheelImageWithFrame:(CGRect)imageFrame;

-(UIImage *)createColorTempImageWithFrame:(CGRect)imageFrame;

-(UIImage *)createColorBrightnessImageWithFrame:(CGRect)imageFrame;

-(void)getColorWheelBitmapDataByRadius:(CGFloat)radius atX:(CGFloat)x atY:(CGFloat)y;

-(void)setRGBDataByUserOnImage:(UIImage *)image atX:(float)pointX atY:(float)pointY;

-(void)setColorTempByUser:(int)colorTemp;

-(UIImage *)createColorIndicateImageWithFrame:(CGRect)imageFrame;

@end

#endif
