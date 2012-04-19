//
//  MovingTarget.h
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovingTarget : NSObject

//properties for the moving target
@property BOOL goodOrBadGuy;
@property int startingPoint;
@property int endingPoint;
@property int velocity;

//function for initializing moving target's properties
- (void)initProperties;
- (void)initVelocity;

//constants for starting and ending positions
extern int leftSidePosition;
extern int rightSidePosition;
extern int minVelocity;

@end
