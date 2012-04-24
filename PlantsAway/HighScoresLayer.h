//
//  HighScoresLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

@interface HighScoresLayer : CCLayer
{
    CCLabelTTF *highScoresLabel;
}


@property (strong) NSString *deviceID;
@property (strong) NSMutableData *receivedData;
@property int score;
@property int time;

-(void)findDeviceID;


@end