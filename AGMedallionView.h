//
//  AGMedallionView.h
//  Photojog
//
//  Created by Artur Grigor on 1/23/12.
//  Copyright (c) 2012 Universitatea "Babes-Bolyai". All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGMedallionView;

@protocol AGMedallionViewDelegate <NSObject>

- (void)didTouchMedallionView:(AGMedallionView *)medallionView;

@end

@interface AGMedallionView : UIView
{
    UIImage *image;
    UIControl *touchableControl;

    CGGradientRef _alphaGradient;
    
    id<AGMedallionViewDelegate> delegate;
}

@property (nonatomic, assign) id<AGMedallionViewDelegate> delegate;
@property (nonatomic, retain) UIImage *image;

@end
