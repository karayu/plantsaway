//
//  HighScoresLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

@interface HighScoresLayer : CCLayer
{
    CCLabelTTF *highScoresLabel;
}

+(CCScene *) scene;

//high score file name
extern NSString *HighScoreFileName;


//variables for NSURL connection
@property (strong) NSString *deviceID;
@property (strong) NSString *fullFilePath;
@property (strong) NSMutableData *receivedData;
@property (strong) NSMutableArray *highScores;

//functionality of high scores layer
-(void)goBack: (id)sender;

@end