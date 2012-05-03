//
//  HighScores.h
//  PlantsAway
//
//  Created by Kara Yu on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScores : NSObject


//high score file name and max # of scores
extern NSString *HighScoreFileName;
extern int MaxHighScores;

//filename and highscores array
@property (strong) NSString *fullFilePath;
@property (strong) NSMutableArray *scores;

//score saving and loading
- (void)loadScores;
- (void)saveScores;
- (BOOL)addHighScore:(int)score;


@end
