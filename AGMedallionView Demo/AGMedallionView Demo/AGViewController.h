//
//  AGViewController.h
//  AGMedallionView Demo
//
//  Created by Artur Grigor on 2/12/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGMedallionView.h"

@interface AGViewController : UIViewController
{
    AGMedallionView *medallionView;
}

@property (nonatomic, retain) IBOutlet AGMedallionView *medallionView;

@end
