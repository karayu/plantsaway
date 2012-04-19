//
//  OldLady.h
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldLady : NSObject

//the properties that define OldLady's updated location
@property int velocity;
@property int position;

//the functions that return her new location
- (int) calculatePosition;
- (int) calculateVelocity;

@end
