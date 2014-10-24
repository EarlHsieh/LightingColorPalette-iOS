//
//  ColorPaletteCreator.m
//  EarlPalette
//
//  Created by Earl Hsieh on 2014/10/16.
//  Copyright (c) 2014年 Earl Hsieh. All rights reserved.
//

#import "LightingPaletteComponent.h"

#define COLOR_WHEEL_CIRCLE

@implementation LightingPaletteComponent

@synthesize colorWheelImage;
@synthesize colorTempImage;
@synthesize colorBrightnessImage;
@synthesize colorIndicatorImage;
@synthesize fullScreenWidth;
@synthesize fullScreenHeight;
@synthesize appScreenWidth;
@synthesize appScreenHeight;
@synthesize frameLength;
@synthesize frameReserved;
@synthesize currentColor;
@synthesize colorConvert;
@synthesize bitmapContext;
@synthesize bitmapData;
@synthesize bitmapImagRef;

/**
 *  NAME
 *      init
 *
 *  DESCRIPTION
 *      Initail UIImage and image based information.
 *
 */
-(id)init
{
    self = [super init];
    colorConvert = [[ColorConvertFormula alloc] init];
    colorWheelImage = [[UIImage alloc]init];
    colorTempImage = [[UIImage alloc]init];
    colorBrightnessImage = [[UIImage alloc]init];
    fullScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    fullScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    appScreenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    appScreenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    frameReserved = (fullScreenHeight - appScreenHeight);
    frameLength = (fullScreenWidth - frameReserved);

    return self;
}

/**
 *  NAME
 *      setColorTempByUser:(int)colorTemp
 *
 *  DESCRIPTION
 *      Update currentColor for UIImageView.
 *
 */
-(void)setColorTempByUser:(int)colorTemp
{
    currentColor = [colorConvert convertColorTempToRGB:colorTemp];
}

/**
 *  NAME
 *      setRGBDataByUserOnImage:(UIImage *)image atX:(float)pointX atY:(float)pointY
 *
 *  DESCRIPTION
 *      After user use color wheel image view to select color, update currentColor
 *      to let image view have correct color information.
 */
-(void)setRGBDataByUserOnImage:(UIImage *)image atX:(float)pointX atY:(float)pointY
{
    CGImageRef imageRef = [image CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // Get image and put it to rawData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    // Clear and re-create CGContext
    CGContextClearRect(context, CGRectMake(0.0, 0.0, width, height));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    // Convert image point(x, y) to one-dimensional array
    int byteIndex = (bytesPerRow * floor(pointY)) + (bytesPerPixel * floor(pointX));

    currentColor = [colorConvert makeRGBADataByRed:((float) rawData[byteIndex] / 255)
                                                 Green:((float) rawData[byteIndex + 1] / 255)
                                                  Blue:((float) rawData[byteIndex + 2] / 255)
                                                 Alpha:1.0];
    free(rawData);
}

/**
 *  NAME
 *      newARGBBitmapContextWithSize:(CGSize)size
 *
 *  DESCRIPTION
 *      Create a null context for color wheel, it will set color pixel by pixel
 *
 */
-(CGContextRef)newARGBBitmapContextWithSize:(CGSize)size {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapDataTmp;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = round(size.width);
    size_t pixelsHigh = round(size.height);
    
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapDataTmp = malloc(bitmapByteCount);
    if (bitmapDataTmp == NULL) {
        NSLog(@"Malloc failed which is too bad.  I was hoping to use this memory.");
        CGColorSpaceRelease(colorSpace);
        // even though CGContextRef technically is not a pointer,
        // it's typedef probably is and it is a scalar anyway.
        return NULL;
    }
    
    // Create the bitmap context. We are
    // setting up the image as an ARGB (0-255 per component)
    // 4-byte per/pixel.
    context = CGBitmapContextCreate(bitmapDataTmp,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapDataTmp);
        NSLog(@"Failed to create bitmap!");
    }
    
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

/**
 *  NAME
 *      isValidPointAtX:(float)x atY:(float)y
 *
 *  DESCRIPTION
 *      This function only action when color wheel is circle.
 *
 */
-(BOOL)isValidPointAtX:(float)x atY:(float)y
{
    CGFloat radius = frameLength / 2;
    CGFloat pointX = x - radius;
    CGFloat pointY = radius - y;
    CGFloat r_distance = sqrtf(pow(pointX, 2) + pow(pointY, 2));
    
#ifdef COLOR_WHEEL_CIRCLE
    if (fabsf(r_distance) > radius) {
        return FALSE;
    }
#endif
    
    r_distance = fmin(r_distance, radius);
    CGFloat angle = atan2(pointY, pointX);
    if (angle < 0.0) {
        angle = (2.0 * M_PI) + angle;
    }
    CGFloat perc_angle = angle / (2.0 * M_PI);
    
    currentColor = [colorConvert HSVToRGBByHue:perc_angle Saturation:r_distance / radius Value:1.0];
    
    return TRUE;
}

/**
 *  NAME
 *      setRGBAToBitmapData:(BitmapPixel)pixel atPointX:(long)pointX atPointY:(long)pointY
 *
 *  DESCRIPTION
 *      Set bitmap data, for color wheel.
 *
 */
-(void)setRGBAToBitmapData:(BitmapPixel)pixel atPointX:(long)pointX atPointY:(long)pointY
{
    size_t length = frameLength;
    unsigned char *argbData = &bitmapData[((pointY * length) + pointX) * 4];
    
    argbData[1] = round(pixel.red   * 255.0); // red
    argbData[2] = round(pixel.green * 255.0); // green
    argbData[3] = round(pixel.blue  * 255.0); // blue
    argbData[0] = round(pixel.alpha * 255.0); // alpha
}

/**
 *  NAME
 *      genBitmapDataToColorWheel
 *
 *  DESCRIPTION
 *      Set color pixel to bitmap data at color wheel image view
 *
 */
-(void)genBitmapDataToColorWheel
{
    for (CGFloat x = 0; x < frameLength; ++x) {
        for (CGFloat y = 0; y < frameLength; ++y) {
            if ([self isValidPointAtX:x atY:y]) {
                [self setRGBAToBitmapData:currentColor atPointX:x atPointY:y];
            }
        }
    }
    currentColor = [colorConvert makeRGBADataByRed:1.0 Green:1.0 Blue:1.0 Alpha:1.0];
}

/**
 *  NAME
 *      createColorWheelImage
 *
 *  DESCRIPTION
 *      Create a image view for color wheel.
 *
 */
-(UIImage *)createColorWheelImage
{
    bitmapContext = [self newARGBBitmapContextWithSize:CGSizeMake(frameLength, frameLength)];
    bitmapData = CGBitmapContextGetData(bitmapContext);
    [self genBitmapDataToColorWheel];

    CGImageRelease(bitmapImagRef);
    bitmapImagRef = CGBitmapContextCreateImage(bitmapContext);
    colorWheelImage = [[UIImage alloc] initWithCGImage:bitmapImagRef];
    
    UIGraphicsEndImageContext();
    return colorWheelImage;
}

/**
 *  NAME
 *      makeColorTempArray
 *
 *  DESCRIPTION
 *      Convert color temperature to RGBA into 2700K to 6500K.
 *
 */
-(void)makeColorTempArray
{
    int colorTempMin = (COLOR_TEMP_MIN / 100);
    int colorTempMax = (COLOR_TEMP_MAX / 100);
    for (int currentColorTemp = colorTempMin; currentColorTemp < colorTempMax; ++currentColorTemp) {
        colorTempPixel[currentColorTemp - colorTempMin] =
        [colorConvert convertColorTempToRGB:currentColorTemp];
    }
}

/**
 *  NAME
 *      createColorTempImage
 *
 *  DESCRIPTION
 *      Create a image view for color temperature.
 *
 */
-(UIImage *)createColorTempImage
{
    [self makeColorTempArray];

    size_t colorCount = (COLOR_TEMP_MAX - COLOR_TEMP_MIN) / 100;
    CGFloat components[colorCount * 4];
    CGFloat locations[colorCount];
    CGColorSpaceRef colorTemp = CGColorSpaceCreateDeviceRGB();

    for (int i = 0; i < colorCount; ++i) {
        components[(i * 4) + 0] = colorTempPixel[i].red;
        components[(i * 4) + 1] = colorTempPixel[i].green;
        components[(i * 4) + 2] = colorTempPixel[i].blue;
        components[(i * 4) + 3] = 1.0;
        locations[i] = ((float) i) / colorCount;
    }
        
    CGSize imageSize = {frameLength, frameReserved * 2};

    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorTemp, components, locations, colorCount);
    CGColorSpaceRelease(colorTemp);

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef colorTempContext = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(colorTempContext, gradient, CGPointMake(0, 0), CGPointMake(frameLength, 0), 0);
    CGContextSaveGState(colorTempContext);
    
    colorTempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return colorTempImage;
}

/**
 *  NAME
 *      makeColorBrightnessArray
 *
 *  DESCRIPTION
 *      Create a 100 level array for make a color brightness view.
 *
 */
-(void)makeColorBrightnessArray
{
    BitMapHSV hsv = [colorConvert RGBToHSVByRed:currentColor.red Green:currentColor.green Blue:currentColor.blue];
    
    for (int i = 0; i < COLOR_BRIGHTNESS_MAX; ++i) {
        colorBrightnessPixel[i] = [colorConvert HSVToRGBByHue:(hsv.hue / 360) Saturation:hsv.saturation Value:((hsv.value * i) / COLOR_BRIGHTNESS_MAX)];
    }
}

/**
 *  NAME
 *      createColorBrightnessImage
 *
 *  Description
 *      Create a color UIImage for 100 level color brightness and return to UIImageView
 *      to show this image.
 *
 */
-(UIImage *)createColorBrightnessImage
{
    [self makeColorBrightnessArray];

    size_t colorCount = COLOR_BRIGHTNESS_MAX;
    CGColorSpaceRef brigtnessColor = CGColorSpaceCreateDeviceRGB();
    CGFloat components[colorCount * 4];
    CGFloat locations[colorCount];
    CGSize imageSize = {frameLength, frameReserved * 2};

    for (int i = 0; i < colorCount; ++i) {
        components[(i * 4)] = colorBrightnessPixel[i].red;
        components[(i * 4) + 1] = colorBrightnessPixel[i].green;
        components[(i * 4) + 2] = colorBrightnessPixel[i].blue;
        components[(i * 4) + 3] = 1.0;
        locations[i] = ((float) i) / colorCount;
    }
   
    CGGradientRef gradient = CGGradientCreateWithColorComponents(brigtnessColor, components, locations, colorCount);
    CGColorSpaceRelease(brigtnessColor);

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef brightnessContext = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(brightnessContext, gradient, CGPointMake(0, 0), CGPointMake(frameLength, 0), 0);
    CGContextSaveGState(brightnessContext);
    
    colorBrightnessImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorBrightnessImage;
}

/**
 *  NAME
 *      createColorIndicateImage
 *
 *  DESCRIPTION
 *      Make a color indicate Image on UIImage, and return this image to UIImageView
 *      to let user know what kind color is they picked.
 *
 */
-(UIImage *)createColorIndicateImage
{
    CGColorSpaceRef indicatorColor = CGColorSpaceCreateDeviceRGB();

    CGFloat components[] = {0.0, 0.0, 0.0, 1.0,
                            currentColor.red, currentColor.green, currentColor.blue, 1.0,
                            currentColor.red, currentColor.green, currentColor.blue, 1.0};

    CGFloat locations[] = {0.0, 0.2, 1.0};
    CGFloat colorCount = 3;
    
    CGSize imageSize = {frameReserved, frameReserved};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(indicatorColor, components, locations, colorCount);
    CGColorSpaceRelease(indicatorColor);
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef indicatorContext = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(indicatorContext, gradient, CGPointMake(frameReserved / 2, frameReserved / 2), (frameReserved / 2), CGPointMake(frameReserved / 2, frameReserved / 2), 0, 0);
    CGContextSaveGState(indicatorContext);
    
    colorIndicatorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return colorIndicatorImage;
}

@end