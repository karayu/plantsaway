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

@interface Sprite : CCSprite
{    
    CCTexture2D *hoodlumTexture1;
    CCTexture2D *hoodlumTexture2;
    
    CCTexture2D *momTexture1;
    CCTexture2D *momTexture2;
}


-(void)initializeSprite: (BOOL) type;
-(BOOL)prepareTarget;
-(void)calculateHit;
-(void)initializeSpeed;
-(void)leftOrRight;
-(void)setTexture;
-(void)move: (ccTime) time;
-(BOOL)offScreen;



@property (readwrite) BOOL collision;
@property int speed;
@property (nonatomic) int start;
@property int score;
@property BOOL good;

@end
