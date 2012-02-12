//
//  AGMedallionView.h
//  AGMedallionView
//
//  Created by Artur Grigor on 1/23/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
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
    UIColor *shadowColor;
    CGSize shadowOffset;
    CGFloat shadowBlur;
    
    id<AGMedallionViewDelegate> delegate;
    
    // Private
    UIControl *touchableControl;
    CGGradientRef alphaGradient;
}

@property (nonatomic, assign) id<AGMedallionViewDelegate> delegate;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;

@end
