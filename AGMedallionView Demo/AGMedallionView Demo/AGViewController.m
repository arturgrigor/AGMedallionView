//
//  AGViewController.m
//  AGMedallionView Demo
//
//  Created by Artur Grigor on 2/12/12.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//

#import "AGViewController.h"

@interface AGViewController ()

- (void)medallionDidTap:(id)sender;

@end

@implementation AGViewController

#pragma mark - Properties

@synthesize medallionView;

#pragma mark - Object Lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [[AGMedallionView appearance] setBorderColor:[UIColor yellowColor]];
//    [[AGMedallionView appearance] setBorderWidth:4.f];
//    [[AGMedallionView appearance] setShadowColor:[UIColor redColor]];
//    [[AGMedallionView appearance] setShadowOffset:CGSizeMake(0, 0)];
//    [[AGMedallionView appearance] setShadowBlur:2.f];
    
    self.medallionView.image = [UIImage imageNamed:@"sample"];
//    self.medallionView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(medallionDidTap:)];
    [self.medallionView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Private

- (void)medallionDidTap:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tap" message:@"Medallion has been tapped." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
