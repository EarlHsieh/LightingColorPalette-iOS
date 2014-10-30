//
//  ViewController.h
//  EarlPalette
//
//  Created by Earl Hsieh on 2014/10/16.
//  Copyright (c) 2014年 Earl Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LightingPaletteComponent/LightingPaletteComponent.h"

@interface ViewController : UIViewController
{
    LightingPaletteComponent *colorPalette;
    UIImageView *colorWheelView;
    UIImageView *colorTempView;
    UIImageView *colorBrightnessView;
    UIImageView *colorIndicatorView;
    UISlider *colorTempSlider;
    UISlider *colorBrightnessSlider;
    UISwitch *powerStateSwitch;
    BOOL isColorWheelTouched;
}

@property (strong, nonatomic)LightingPaletteComponent *colorPalette;

@property (strong, nonatomic)UIImageView *colorWheelView;

@property (strong, nonatomic)UIImageView *colorTempView;

@property (strong, nonatomic)UIImageView *colorBrightnessView;

@property (strong, nonatomic)UIImageView *colorIndicatorView;

@property (strong, nonatomic)UISlider *colorTempSlider;

@property (strong, nonatomic)UISlider *colorBrightnessSlider;

@property (strong, nonatomic)UISwitch *powerStateSwitch;

@end

