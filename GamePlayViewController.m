//
//  GamePlayViewController.m
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePlayViewController.h"

@interface GamePlayViewController (){
@private
CGPoint _velocity;
}

@property (nonatomic, readwrite, weak) IBOutlet UIImageView *oldLadyImage;
@property (nonatomic, readwrite, weak) IBOutlet UIImageView *plantImage;

@end

@implementation GamePlayViewController

@synthesize oldLadyImage = _oldLadyImage;
@synthesize plantImage = _plantImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
