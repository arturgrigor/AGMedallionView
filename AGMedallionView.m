//
//  AGMedallionView.m
//  Photojog
//
//  Created by Artur Grigor on 1/23/12.
//  Copyright (c) 2012 Universitatea "Babes-Bolyai". All rights reserved.
//

#import "AGMedallionView.h"

@interface AGMedallionView (Private)

- (void)touchUpInsideControl:(id)sender;

@end

@implementation AGMedallionView

#pragma mark - Properties

@synthesize image, delegate;

- (void)setImage:(UIImage *)aImage
{
    if (image != nil)
        [image release];
    
    image = [aImage retain];
    [self setNeedsDisplay];
}

#pragma mark - Private

- (void)touchUpInsideControl:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTouchMedallionView:)])
        [self.delegate didTouchMedallionView:self];
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [image release];
    [touchableControl release];
    
    // Release the alpha gradient
    CGGradientRelease(_alphaGradient);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _alphaGradient = NULL;
        
        self.backgroundColor = [UIColor clearColor];
        
        // Place a touchable control on top of everything
        touchableControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [touchableControl addTarget:self action:@selector(touchUpInsideControl:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:touchableControl];
    }
    return self;
}

#pragma mark - Drawing

- (CGGradientRef)alphaGradient
{
    if (NULL == _alphaGradient) {
        CGFloat colors[4] = {1.0f, 0.65f, 1.0f, 0.0f};
        CGFloat colorStops[2] = {1.0f, 0.35f};
        CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
        _alphaGradient = CGGradientCreateWithColorComponents(grayColorSpace, colors, colorStops, 2);
        CGColorSpaceRelease(grayColorSpace);
    }
    
    return _alphaGradient;
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageRect = CGRectMake(4, 4, rect.size.width - 8, rect.size.height - 8);
    
    CGColorSpaceRef maskColorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef maskContextRef = CGBitmapContextCreate(NULL, rect.size
                                                        .width, rect.size.height, 8, rect.size.width, maskColorSpaceRef, 0);
    CGColorSpaceRelease(maskColorSpaceRef);
    CGContextSetFillColorWithColor(maskContextRef, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContextRef, rect);
    CGContextSetFillColorWithColor(maskContextRef, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(maskContextRef, 0, 0);
    CGContextAddEllipseInRect(maskContextRef, imageRect);
    CGContextFillPath(maskContextRef);
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContextRef);
    CGContextRelease(maskContextRef);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    CGImageRef imageRef = CGImageCreateWithMask(self.image.CGImage, maskImageRef);
    CGImageRef semiCircleMaskImageRef = [UIImage imageNamed:@"medallionShineMask"].CGImage;
    
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGContextSetShadowWithColor(contextRef, CGSizeMake(0, 1), 1.0, [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.75f].CGColor);
    CGContextDrawImage(contextRef, rect, imageRef);
    CGContextSaveGState(contextRef);
//    CGContextMoveToPoint(contextRef, 0, self.bounds.size.height);
//    CGContextAddEllipseInRect(contextRef, CGRectMake(3, 3, rect.size.width - 6, rect.size.height - 6));
    CGContextClipToMask(contextRef, self.bounds, maskImageRef);
    CGContextClipToMask(contextRef, self.bounds, semiCircleMaskImageRef);
//    CGContextDrawRadialGradient(contextRef, [self alphaGradient], CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)), 50, CGPointMake(70.f, 70.f), 50, 0);
    CGContextDrawLinearGradient(contextRef, [self alphaGradient], CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);
    CGContextRestoreGState(contextRef);
    
    CGImageRelease(maskImageRef);
    
    CGContextSetLineWidth(contextRef, 2.0f);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddEllipseInRect(contextRef, CGRectMake(3, 3, rect.size.width - 6, rect.size.height - 6));
    
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
}

@end
