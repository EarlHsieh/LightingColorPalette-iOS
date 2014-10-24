//
//  ViewController.m
//  EarlPalette
//
//  Created by Earl Hsieh on 2014/10/16.
//  Copyright (c) 2014年 Earl Hsieh. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize colorPalette;
@synthesize colorWheelView;
@synthesize colorTempView;
@synthesize colorBrightnessView;
@synthesize colorTempSlider;
@synthesize colorBrightnessSlider;
@synthesize colorIndicatorView;
@synthesize powerStateSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    colorPalette = [[LightingPaletteComponent alloc] init];
    [self createColorWheelView];
    [self createColorTempImage];
    [self createColorBrightnessImage];
    [self createOtherComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  NAME
 *      createColorWheelView
 *
 *  DESCRIPTION
 *      Create a color wheel image.
 *
 */
-(void)createColorWheelView
{
    float startPointX = colorPalette.frameReserved / 2;
    float startPointY = colorPalette.frameReserved * 2;
    float viewWidth = colorPalette.frameLength;
    float centerPointX = startPointX + (viewWidth / 2);
    float centerPointY = startPointY + (viewWidth / 2);
    
    colorWheelView = (id)[[UIImageView alloc]initWithImage:[colorPalette createColorWheelImage]];
    colorWheelView.frame = CGRectMake(startPointX, startPointY, viewWidth, viewWidth);

    [self.view addSubview:colorWheelView];
    [self createColorIndicateImageAtX:centerPointX atY:centerPointY];
}

/**
 *  NAME
 *      createColorTempImage
 *
 *  DESCRIPTION
 *      Create color temperature image.
 *
 */
-(void)createColorTempImage
{
    CGFloat startPointX = colorWheelView.frame.origin.x;
    CGFloat startPointY = colorWheelView.frame.origin.y + colorWheelView.frame.size.height +
                         colorPalette.frameReserved;
    CGFloat viewWidth = colorWheelView.frame.size.width;
    CGFloat viewHeight = colorPalette.frameReserved * 1.5;

    colorTempView = [[UIImageView alloc]initWithImage:[colorPalette createColorTempImage]];
    colorTempView.frame = CGRectMake(startPointX, startPointY, viewWidth, viewHeight);
    
    [self.view addSubview:colorTempView];
}

/**
 *  NAME
 *      createColorBrightnessImage
 *
 *  DESCRIPTION
 *      Create brightness image and re-add colorBrightnessSlider.
 *
 */
-(void)createColorBrightnessImage
{
    float startPointX = colorTempView.frame.origin.x;
    float startPointY = colorTempView.frame.origin.y + colorTempView.frame.size.height +
                         colorPalette.frameReserved;
    float viewWidth = colorTempView.frame.size.width;
    CGFloat viewHeight = colorPalette.frameReserved * 1.5;

    colorBrightnessView = [[UIImageView alloc]initWithImage:[colorPalette createColorBrightnessImage]];
    colorBrightnessView.frame = CGRectMake(startPointX, startPointY, viewWidth, viewHeight);


    [self.view addSubview:colorBrightnessView];
    [self.view addSubview:colorBrightnessSlider];
}

/**
 *  NAME
 *      createColorIndicateImageAtX:(float)centerPointX atY:(float)centerPointY
 *
 *  DESCRIPTION
 *      Create an indicate image at point x, y.
 *
 */
-(void)createColorIndicateImageAtX:(float)centerPointX atY:(float)centerPointY
{
    float startPointX = centerPointX - (colorPalette.frameReserved / 2);
    float startPointY = centerPointY - (colorPalette.frameReserved / 2);
    float viewWidth = colorPalette.frameReserved;

    colorIndicatorView = [[UIImageView alloc]initWithImage:[colorPalette createColorIndicateImage]];
    colorIndicatorView.frame = CGRectMake(startPointX, startPointY, viewWidth, viewWidth);
    
    [self.view addSubview:colorIndicatorView];
}

/**
 *  NAME
 *      createOtherComponent
 *
 *  DESCRIPTION
 *      Create colorTempSlider and colorBrightnessSlider.
 *
 */
-(void)createOtherComponent
{
    UIImage *clearTrack = [[UIImage alloc] init];

    colorTempSlider = [[UISlider alloc] initWithFrame:colorTempView.frame];
    colorTempSlider.minimumValue = 27;
    colorTempSlider.maximumValue = 65;
    colorTempSlider.value = 27;
    [colorTempSlider setMinimumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorTempSlider setMaximumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorTempSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorTempSlider];

    colorBrightnessSlider = [[UISlider alloc] initWithFrame:colorBrightnessView.frame];
    colorBrightnessSlider.minimumValue = 0.0;
    colorBrightnessSlider.maximumValue = 100.0;
    colorBrightnessSlider.value = 100.0;
    [colorBrightnessSlider setMinimumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorBrightnessSlider setMaximumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorBrightnessSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorBrightnessSlider];
 
    CGFloat powerSwitchX = (colorBrightnessView.frame.origin.x +
                            (colorBrightnessView.frame.size.width / 2) -
                            (powerStateSwitch.frame.size.width / 2));
    CGFloat powerSwitchY = (colorBrightnessView.frame.origin.y +
                            colorBrightnessView.frame.size.height +
                            colorPalette.frameReserved);
    powerStateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(powerSwitchX, powerSwitchY, 0,0 )];
    [powerStateSwitch setOn:false];
    [powerStateSwitch addTarget:self action:@selector(powerStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:powerStateSwitch];
}

/**
 *  NAME
 *      sliderValueChange:(id)sender
 *
 *  DESCRIPTION
 *      If UISlider value has chang, do some corresponding action.
 *
 */
-(void)sliderValueChange:(id)sender
{
    UISlider *sliderCtrl = (UISlider *)sender;
    
    if (sliderCtrl == colorTempSlider) {
        [colorPalette setColorTempByUser:sliderCtrl.value];
        [self updateBrightnessView];
    }
}


-(void)powerStateChange:(id)sender
{
    UISwitch *switchCtrl = (UISwitch *)sender;
    
    if (switchCtrl == powerStateSwitch) {
    }
}

/**
 *  NAME
 *      updateBrightnessView
 *
 *  DESCRIPTION
 *      Re-create brightness view.
 *
 */
-(void)updateBrightnessView
{
    [colorBrightnessView removeFromSuperview];
    [colorBrightnessSlider removeFromSuperview];
    [self createColorBrightnessImage];
}

/**
 *  NAME
 *      updateIndicatorViewAtX:(CGFloat)x atY:(float)y
 *
 *  DESCRIPTION
 *      Re-create indicator view by point x, y.
 *
 */
-(void)updateIndicatorViewAtX:(CGFloat)x atY:(float)y
{
    [colorIndicatorView removeFromSuperview];
    [self createColorIndicateImageAtX:x atY:y];
}

/**
 *  NAME
 *      updateViewWithTouchEventInTouch:(UITouch *)userTouch
 *
 *  DESCRIPTION
 *      Update brightness view and indicator view when user picker color by color wheel.
 *
 */
-(void)updateViewWithTouchEventInTouch:(UITouch *)userTouch
{
   
    CGFloat x = [userTouch locationInView:self.view].x;
    CGFloat y = [userTouch locationInView:self.view].y;

    if ((x >= colorWheelView.frame.origin.x) &&
        (x < (colorWheelView.frame.origin.x + colorWheelView.frame.size.width)) &&
        (y >= colorWheelView.frame.origin.y) &&
        (y < (colorWheelView.frame.origin.y + colorWheelView.frame.size.height))) {
        CGFloat imageViewX = [userTouch locationInView:colorWheelView].x;
        CGFloat imageViewY = [userTouch locationInView:colorWheelView].y;

        if ([colorPalette isValidPointAtX:imageViewX atY:imageViewY]) {
            [self updateIndicatorViewAtX:x atY:y];
            [self updateBrightnessView];
        }
    }
}

/**
 *  NAME
 *      touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 *
 *  DESCRIPTION
 *      User began touch device panel, update brightness image view and indicator image view.
 *
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self updateViewWithTouchEventInTouch:touch];
}

/**
 *  NAME
 *      touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 *
 *  DESCRIPTION
 *      During user touch device panel, update brightness image view and indicator image view.
 *
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self updateViewWithTouchEventInTouch:touch];
}

/**
 *  NAME
 *      touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 *
 *  DESCRIPTION
 *      After user touch device panel, update brightness image view and indicator image view.
 *
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self updateViewWithTouchEventInTouch:touch];
}

/**
 *  NAME
 *      shouldAutorotate
 *
 *  DESCRIPTION
 *      Do not rotate.
 *
 */
-(BOOL)shouldAutorotate
{
    return NO;
}

@end
