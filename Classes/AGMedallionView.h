//
//  AGMedallionView.h
//  Photojog
//
//  Created by Artur Grigor on 1/23/12.
//  Copyright (c) 2012 Universitatea "Babes-Bolyai". All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGMedallionView;

@protocol AGMedallionViewDelegate<NSObject>

@optional
- (void)didTouchMedallionView:(AGMedallionView *)medallionView;

@end

@interface AGMedallionView : UIView
{
    UIImage *image;
    UIColor *borderColor;
    CGFloat borderWidth;
    UIColor *dropShadowColor;
    CGSize dropShadowOffset;
    CGFloat dropShadowBlur;
    
    id<AGMedallionViewDelegate> delegate;
    
    // Private
    UIControl *touchableControl;
    CGGradientRef alphaGradient;
}

@property (nonatomic, assign) id<AGMedallionViewDelegate> delegate;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, retain) UIColor *dropShadowColor;
@property (nonatomic, assign) CGSize dropShadowOffset;
@property (nonatomic, assign) CGFloat dropShadowBlur;

@end
