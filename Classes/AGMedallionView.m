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

@synthesize image, borderColor, borderWidth, dropShadowColor, dropShadowOffset, dropShadowBlur, delegate;

- (void)setImage:(UIImage *)aImage
{
    if (image != aImage) {
        [image release];
        image = [aImage retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setBorderColor:(UIColor *)aBorderColor
{
    if (borderColor != aBorderColor) {
        [borderColor release];
        borderColor = [aBorderColor retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setBorderWidth:(CGFloat)aBorderWidth
{
    if (borderWidth != aBorderWidth) {
        borderWidth = aBorderWidth;
        
        [self setNeedsDisplay];
    }
}

- (void)setDropShadowColor:(UIColor *)aDropShadowColor
{
    if (dropShadowColor != aDropShadowColor) {
        [dropShadowColor release];
        dropShadowColor = [aDropShadowColor retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setDropShadowOffset:(CGSize)aDropShadowOffset
{
    if (!CGSizeEqualToSize(dropShadowOffset, aDropShadowOffset)) {
        dropShadowOffset.width = aDropShadowOffset.width;
        dropShadowOffset.height = aDropShadowOffset.height;
        
        [self setNeedsDisplay];
    }
}

- (void)setDropShadowBlur:(CGFloat)aDropShadowBlur
{
    if (dropShadowBlur != aDropShadowBlur) {
        dropShadowBlur = aDropShadowBlur;
        
        [self setNeedsDisplay];
    }
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
    [borderColor release];
    [dropShadowColor release];
    [touchableControl release];
    
    // Release the alpha gradient
    CGGradientRelease(alphaGradient);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        alphaGradient = NULL;
        
        self.borderColor = [UIColor whiteColor];
        self.borderWidth = 4.f;
        self.dropShadowColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:.75f];
        self.dropShadowOffset = CGSizeMake(0, 1);
        self.dropShadowBlur = 1.f;
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
    if (NULL == alphaGradient) {
        CGFloat colors[6] = {1.f, 0.75f, 1.f, 0.f, 0.f, 0.f};
        CGFloat colorStops[3] = {1.f, 0.35f, 0.f};
        CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
        alphaGradient = CGGradientCreateWithColorComponents(grayColorSpace, colors, colorStops, 3);
        CGColorSpaceRelease(grayColorSpace);
    }
    
    return alphaGradient;
}

- (void)drawRect:(CGRect)rect
{
    // Image rect
    CGRect imageRect = CGRectMake(self.borderWidth, 
                                  self.borderWidth, 
                                  rect.size.width - (self.borderWidth * 2), 
                                  rect.size.height - (self.borderWidth * 2));
    
    // Start working with the mask
    CGColorSpaceRef maskColorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef mainMaskContextRef = CGBitmapContextCreate(NULL,
                                                        rect.size.width, 
                                                        rect.size.height, 
                                                        8, 
                                                        rect.size.width, 
                                                        maskColorSpaceRef, 
                                                        0);
    CGContextRef shineMaskContextRef = CGBitmapContextCreate(NULL,
                                                             rect.size.width, 
                                                             rect.size.height, 
                                                             8, 
                                                             rect.size.width, 
                                                             maskColorSpaceRef, 
                                                             0);
    CGColorSpaceRelease(maskColorSpaceRef);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor blackColor].CGColor);
    CGContextFillRect(mainMaskContextRef, rect);
    CGContextFillRect(shineMaskContextRef, rect);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor whiteColor].CGColor);
    
    // Create main mask shape
    CGContextMoveToPoint(mainMaskContextRef, 0, 0);
    CGContextAddEllipseInRect(mainMaskContextRef, imageRect);
    CGContextFillPath(mainMaskContextRef);
    // Create shine mask shape
    CGContextTranslateCTM(shineMaskContextRef, -(rect.size.width / 4), rect.size.height / 4 * 3);
    CGContextRotateCTM(shineMaskContextRef, -45.f);
    CGContextMoveToPoint(shineMaskContextRef, 0, 0);
    CGContextFillRect(shineMaskContextRef, CGRectMake(0, 
                                                      0, 
                                                      rect.size.width / 8 * 5, 
                                                      rect.size.height));
    
    CGImageRef mainMaskImageRef = CGBitmapContextCreateImage(mainMaskContextRef);
    CGImageRef shineMaskImageRef = CGBitmapContextCreateImage(shineMaskContextRef);
    CGContextRelease(mainMaskContextRef);
    CGContextRelease(shineMaskContextRef);
    // Done with mask context
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    CGImageRef imageRef = CGImageCreateWithMask(self.image.CGImage, mainMaskImageRef);
    
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    // Drop shadow
    CGContextSetShadowWithColor(contextRef, 
                                self.dropShadowOffset, 
                                self.dropShadowBlur, 
                                self.dropShadowColor.CGColor);
    // Draw image
    CGContextDrawImage(contextRef, rect, imageRef);
    CGContextSaveGState(contextRef);
    
    // Clip to shine's mask
    CGContextClipToMask(contextRef, self.bounds, mainMaskImageRef);
    CGContextClipToMask(contextRef, self.bounds, shineMaskImageRef);
//    CGContextSetBlendMode(contextRef, kCGBlendModeLighten);
    CGContextDrawLinearGradient(contextRef, [self alphaGradient], CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);
    CGContextRestoreGState(contextRef);
    
    CGImageRelease(mainMaskImageRef);
    CGImageRelease(shineMaskImageRef);
    // Done with image
    
    CGContextSetLineWidth(contextRef, self.borderWidth);
    CGContextSetStrokeColorWithColor(contextRef, self.borderColor.CGColor);
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddEllipseInRect(contextRef, CGRectMake(self.borderWidth / 2, 
                                                     self.borderWidth / 2, 
                                                     rect.size.width - self.borderWidth, 
                                                     rect.size.height - self.borderWidth));
    
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
}

@end
