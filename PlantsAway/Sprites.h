//
//  Sprites.h
//  PlantsAway
//
//  Created by Brooke Griffin on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface Sprites : NSObject

-(void)initializeSprites;
-(BOOL)prepareGoodTarget;
-(BOOL)prepareBadTarget;
-(void)calculateHit;
-(int)initializeSpeed;
-(int)leftOrRight;

@property (readwrite) BOOL goodCollision;
@property (readwrite) BOOL badCollision;
@property int goodSpeed;
@property int badSpeed;
@property (nonatomic) int goodStart;
@property (nonatomic) int badStart;
@property int score;

@end
