//
//  TBCircularSlider.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBCircularSlider.h"
#import "Commons.h"

/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

/** Parameters **/
#define TB_SAFEAREA_PADDING 60

#pragma mark - Private -

@interface TBCircularSlider(){
    UILabel *_textField;
    UILabel *_subtitle;
    int radius;
}
@end


#pragma mark - Implementation -

@implementation TBCircularSlider

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        
        //Define the circle radius taking into account the safe area
        radius = self.frame.size.width/2 - TB_SAFEAREA_PADDING;
        
        //Initialize the Angle at 0
        self.angle = 0;
		self.minValue = 2013;
		self.maxValue = 2019;
        
        //Define the Font
        UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
        UIFont *fontSubtitle = [UIFont fontWithName:TB_SUBFONTFAMILY size:TB_SUBFONTSIZE];
        //Calculate font size needed to display 3 numbers
        NSString *str = @"0000";
        CGSize fontSize = [str sizeWithFont:font];
        NSString *subStr = @"In the year";
        CGSize subFontSize = [subStr sizeWithFont:fontSubtitle];
        
        //Using a TextField area we can easily modify the control to get user input from this field
        _textField = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width  - fontSize.width) / 2,
																  (frame.size.height - fontSize.height) / 2,
                                                                  fontSize.width,
                                                                  fontSize.height)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = font;
        _textField.text = [NSString stringWithFormat:@"%d",self.value];
		_subtitle.numberOfLines = 1;
        [_textField setTextColor:[UIColor blackColor]];
        
        [self addSubview:_textField];

		_subtitle = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width  - subFontSize.width) / 2,
															 (frame.size.height - fontSize.height - subFontSize.height) / 2 - 30,
																subFontSize.width,
                                                                  subFontSize.height * 2)];
        _subtitle.backgroundColor = [UIColor clearColor];
        _subtitle.textColor = [UIColor colorWithWhite:0 alpha:0.2];
        _subtitle.textAlignment = NSTextAlignmentCenter;
        _subtitle.font = fontSubtitle;
        _subtitle.text = subStr;
        _subtitle.enabled = NO;
		_subtitle.numberOfLines = 1;
		
		[self addSubview:_subtitle];
		[self updateLabels];
    }
    
    return self;
}

- (int)value {
	int delta = self.maxValue - self.minValue;
	return (int)((self.angle > 360 ? self.angle - 360 : self.angle) / 360.0f * delta) + self.minValue;
}

- (NSString *)text {
	if (self.value == 2013) {
		return @"Already graduated";
	} else if (self.value >= 2018) {
		return @"I'll never graduate!";
	} else {
		return [NSString stringWithFormat:@"%d", self.value];
	}
}

- (void)setValue:(int)value {
	int delta = self.maxValue - self.minValue;
	self.angle = (int)(value * 360.0f / delta) + 1;
	_textField.text =  [NSString stringWithFormat:@"%d", self.value];
	[self setNeedsDisplay];
}

#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];

    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];

    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that   
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}


#pragma mark - Drawing Functions - 

//Use the draw rect to draw the Background, the Circle and the Handle 
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
/** Draw the Background **/
    
    //Create the path
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, M_PI *2, 0);
    
    //Set the stroke color to black
    [TB_LINE_COLOR setStroke];
    
    //Define line width and cap
    CGContextSetLineWidth(ctx, TB_BACKGROUND_WIDTH);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
   
//** Draw the circle (using a clipped gradient) **/
    
    
    /** Create THE MASK Image **/
    UIGraphicsBeginImageContext(CGSizeMake(TB_SLIDER_SIZE,TB_SLIDER_SIZE));
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(imageCtx, self.frame.size.width/2  , self.frame.size.height/2, radius, ToRad(90), ToRad(90 - (self.angle > 360 ? self.angle - 360 : self.angle)), 1);
    [[UIColor redColor]set];
    
    //Use shadow to create the Blur effect
    //CGContextSetShadowWithColor(imageCtx, CGSizeMake(0, 0), 5 + self.value / 2, TB_LINE_COLOR.CGColor);
    
    //define the path
    CGContextSetLineWidth(imageCtx, TB_LINE_WIDTH);
	CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    //save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    /** Clip Context to the mask **/
    CGContextSaveGState(ctx);
    
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    /** THE GRADIENT **/
	/*
    //list of components
    CGFloat components[8] = {
        0.6, 0.8, 1.0, 1.0,     // Start color - Blue
        0.6, 0.8, 1.0, 1.0 };   // End color - Violet
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    //Gradient direction
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    //Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    */
	[[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0] set];
	CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
    
    
/** Add some light reflection effects on the background circle**/
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //Draw the outside light
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius+TB_BACKGROUND_WIDTH/2, ToRad(90), ToRad(90-self.angle), 0);
    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //draw the inner light
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius-TB_BACKGROUND_WIDTH/2, ToRad(90), ToRad(90-self.angle), 0);
    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
/** Draw the handle **/
    [self drawTheHandle:ctx];
    
}

/** Draw a white knob over the circle **/
-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //I Love shadows
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, TB_LINE_COLOR.CGColor);
    
    //Get the handle position
    CGPoint handleCenter =  [self pointFromAngle: 90 - self.angle];
    
    //Draw It!
    [[UIColor colorWithWhite:1.0 alpha:0.7]set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, TB_LINE_WIDTH, TB_LINE_WIDTH));
    
    CGContextRestoreGState(ctx);
}


#pragma mark - Math -

/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);
    
    //Store the new angle
    self.angle = 90 + angleInt;
    [self updateLabels];
    
    //Redraw
    [self setNeedsDisplay];
}

-(void)updateLabels {
	CGRect frame = [self frame];
	
	//Update the textfield
	_textField.text = self.text;
	if (self.value == 2013 || self.value >= 2018) {
		UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:40];
		_textField.font = font;
		_textField.numberOfLines = 2;
		[_subtitle setHidden:YES];
	} else {
		UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
		NSString *str = @"0000";
        CGSize fontSize = [str sizeWithFont:font];
		_textField.font = font;
		[_textField setFrame:CGRectMake((frame.size.width  - fontSize.width) / 2,
										(frame.size.height - fontSize.height) / 2,
										fontSize.width,
										fontSize.height)];
		[_subtitle setHidden:NO];
	}
}

/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - TB_LINE_WIDTH/2, self.frame.size.height/2 - TB_LINE_WIDTH/2);
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    
    return result;
}

//Sourcecode from Apple example clockControl 
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}
@end


