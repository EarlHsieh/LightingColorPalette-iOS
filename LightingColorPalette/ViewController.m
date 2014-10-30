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
    colorBrightnessSlider = [[UISlider alloc] init];
    colorTempSlider = [[UISlider alloc] init];
    [self createColorWheelView];
    [self createColorTempImage];
    [self createColorBrightnessImage];
    [self createOtherComponent];
    isColorWheelTouched = false;
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
    CGFloat notificationBarHeight = [[UIScreen mainScreen] bounds].size.height -
                                    [[UIScreen mainScreen] applicationFrame].size.height;

    CGFloat startPointX = notificationBarHeight / 4.0;
    CGFloat startPointY = notificationBarHeight * 2.0;
    CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width - (notificationBarHeight / 2.0);
    CGFloat centerPointX = startPointX + (viewWidth / 2.0);
    CGFloat centerPointY = startPointY + (viewWidth / 2.0);
    CGRect imageFrame = CGRectMake(startPointX, startPointY, viewWidth, viewWidth);

    colorWheelView = [[UIImageView alloc]initWithImage:[colorPalette createColorWheelImageWithFrame:imageFrame]];
    colorWheelView.frame = imageFrame;
    colorWheelView.layer.masksToBounds = YES;
    colorWheelView.layer.cornerRadius = viewWidth / 2.0;
    
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
    CGFloat notificationBarHeight = [[UIScreen mainScreen] bounds].size.height -
                                    [[UIScreen mainScreen] applicationFrame].size.height;

    CGFloat startPointX = colorWheelView.frame.origin.x;
    CGFloat startPointY = colorWheelView.frame.origin.y +
                          colorWheelView.frame.size.height +
                          notificationBarHeight;
    CGFloat viewWidth = colorWheelView.frame.size.width;
    CGFloat viewHeight = colorTempSlider.frame.size.height;
    CGRect imageFrame = CGRectMake(startPointX, startPointY, viewWidth, viewHeight);
    
    colorTempView = [[UIImageView alloc]initWithImage:[colorPalette createColorTempImageWithFrame:imageFrame]];
    colorTempView.frame = imageFrame;

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
    CGFloat notificationBarHeight = [[UIScreen mainScreen] bounds].size.height -
                                    [[UIScreen mainScreen] applicationFrame].size.height;

    CGFloat startPointX = colorTempView.frame.origin.x;
    CGFloat startPointY = colorTempView.frame.origin.y +
                        colorTempView.frame.size.height +
                        notificationBarHeight;
    CGFloat viewWidth = colorTempView.frame.size.width;
    CGFloat viewHeight = colorBrightnessSlider.frame.size.height;
    CGRect imageFrame = CGRectMake(startPointX, startPointY, viewWidth, viewHeight);

    colorBrightnessView = [[UIImageView alloc]initWithImage:[colorPalette createColorBrightnessImageWithFrame:imageFrame]];
    colorBrightnessView.frame = imageFrame;

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
    CGFloat notificationBarHeight = [[UIScreen mainScreen] bounds].size.height -
                                    [[UIScreen mainScreen] applicationFrame].size.height;
    CGFloat startPointX = centerPointX - (notificationBarHeight / 2);
    CGFloat startPointY = centerPointY - (notificationBarHeight / 2);
    CGFloat viewWidth = notificationBarHeight;
    CGRect imageFrame = CGRectMake(startPointX, startPointY, viewWidth, viewWidth);

    colorIndicatorView = [[UIImageView alloc]initWithImage:[colorPalette createColorIndicateImageWithFrame:imageFrame]];
    colorIndicatorView.frame = imageFrame;
    
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
    CGFloat notificationBarHeight = [[UIScreen mainScreen] bounds].size.height -
                                    [[UIScreen mainScreen] applicationFrame].size.height;
    UIImage *clearTrack = [[UIImage alloc] init];

    colorTempSlider.frame = colorTempView.frame;
    colorTempSlider.minimumValue = 27;
    colorTempSlider.maximumValue = 65;
    colorTempSlider.value = 27;
    [colorTempSlider setMinimumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorTempSlider setMaximumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorTempSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorTempSlider];

    colorBrightnessSlider.frame = colorBrightnessView.frame;
    colorBrightnessSlider.minimumValue = 0.0;
    colorBrightnessSlider.maximumValue = 100.0;
    colorBrightnessSlider.value = 100.0;
    [colorBrightnessSlider setMinimumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorBrightnessSlider setMaximumTrackImage:clearTrack forState:UIControlStateNormal];
    [colorBrightnessSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorBrightnessSlider];
 
    powerStateSwitch = [[UISwitch alloc] init];
    CGFloat powerSwitchX = (colorBrightnessView.frame.origin.x +
                            (colorBrightnessView.frame.size.width / 2) -
                            (powerStateSwitch.frame.size.width / 2));
    CGFloat powerSwitchY = (colorBrightnessView.frame.origin.y +
                            colorBrightnessView.frame.size.height +
                            notificationBarHeight);
    powerStateSwitch.frame = CGRectMake(powerSwitchX, powerSwitchY, 0, 0);
    [powerStateSwitch setOn:true];
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
 *      isValidPointAtX:(float)x atY:(float)y
 *
 *  DESCRIPTION
 *      This function only action when color wheel is circle.
 *
 */
-(BOOL)isValidPointByRadius:(CGFloat)radius atX:(CGFloat)x atY:(CGFloat)y
{
    CGFloat pointX = x - radius;
    CGFloat pointY = radius - y;
    CGFloat r_distance = sqrtf(pow(pointX, 2) + pow(pointY, 2));

    if (fabsf(r_distance) > radius) {
        return FALSE;
    }

    return TRUE;
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
    CGPoint touchPoint = [userTouch locationInView:self.view];
    CGPoint wheelCenterPoint = CGPointMake(colorWheelView.frame.origin.x +
                                           (colorWheelView.frame.size.width / 2),
                                           colorWheelView.frame.origin.y +
                                           (colorWheelView.frame.size.height / 2));
    
    CGFloat touchDistance = sqrt(pow((touchPoint.x - wheelCenterPoint.x), 2) +
                                 pow((touchPoint.y - wheelCenterPoint.y), 2));
    CGFloat radius = colorWheelView.frame.size.width / 2;

    if (isColorWheelTouched == TRUE) {
        if (touchDistance > radius) {

            CGFloat n = radius / (touchDistance - radius);
            CGFloat distanceX = (wheelCenterPoint.x + (touchPoint.x * n)) / (1 + n);
            CGFloat distanceY = (wheelCenterPoint.y + (touchPoint.y * n)) / (1 + n);
        
            [colorPalette getColorWheelBitmapDataByRadius:radius
                                                      atX:distanceX
                                                      atY:distanceY];
            [self updateIndicatorViewAtX:distanceX atY:distanceY];
            [self updateBrightnessView];
            return;
        }
    
        CGPoint point = [userTouch locationInView:colorWheelView];
        [colorPalette getColorWheelBitmapDataByRadius:radius
                                              atX:point.x
                                              atY:point.y];
        [self updateIndicatorViewAtX:touchPoint.x atY:touchPoint.y];
        [self updateBrightnessView];
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

    CGPoint touchPoint = [touch locationInView:self.view];
    if (touchPoint.x > colorWheelView.frame.origin.x &&
        touchPoint.x <= (colorWheelView.frame.origin.x + colorWheelView.frame.size.width) &&
        touchPoint.y > colorWheelView.frame.origin.y &&
        touchPoint.y <= (colorWheelView.frame.origin.y + colorWheelView.frame.size.height)) {
        CGPoint colorWheelPoint = [touch locationInView:colorWheelView];
        CGFloat radius = colorWheelView.frame.size.width / 2;

        if ([self isValidPointByRadius:radius
                                   atX:colorWheelPoint.x
                                   atY:colorWheelPoint.y]) {
            [colorPalette getColorWheelBitmapDataByRadius:radius
                                                      atX:colorWheelPoint.x
                                                      atY:colorWheelPoint.y];
            [self updateIndicatorViewAtX:touchPoint.x atY:touchPoint.y];
            [self updateBrightnessView];
            isColorWheelTouched = true  ;
        }
    }
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
    isColorWheelTouched = false;
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
