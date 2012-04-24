//
//  OldLady.h
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldLady : NSObject

//the properties that define OldLady's new location
@property int time;

//constants (speed)
extern int speed;

//returns time it takes for movement to new position
- (int)timeToPosition :(int)newPosition :(int)oldPosition;

@end
