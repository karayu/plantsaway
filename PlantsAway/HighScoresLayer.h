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

//returns the scene containing a highscores layer
+(CCScene *) scene;

//high score file name and max # of scores
extern NSString *HighScoreFileName;
extern int MaxHighScores;

//filename and highscores array
@property (strong) NSString *fullFilePath;
@property (strong) NSMutableData *receivedData;
@property (strong) NSMutableArray *highScores;

//functionality of high scores layer
-(void)goBack: (id)sender;


//score saving and loading
- (void)loadScores;
- (void)saveScores;
- (BOOL)addHighScore: (int)score;


@end